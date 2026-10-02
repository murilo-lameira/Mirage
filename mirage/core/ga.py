"""
=============================================================================
PROJETO MIRAGE — ALGORITMO GENÉTICO CONTÍNUO COM ORÇAMENTO INVARIANTE (B=1.8)
=============================================================================
Operadores genéticos contínuos:
- Projeção no Simplex: sum(u_i) <= 1.8 (Previne Reward Hacking de NPCs invencíveis)
- Crossover Blend (BLX-alpha) com preservação de diversidade
- Mutação Gaussiana com perturbação estocástica
- Critérios de parada precoce por estagnação fenotípica (K_stop = 15, eps = 1%)
=============================================================================
"""

import time
from dataclasses import dataclass, field
from typing import Callable, List, Optional, Tuple
import numpy as np

from mirage.config import (
    DIFFICULTY_SETTINGS,
    GLOBAL_BUDGET,
    NUM_GENES,
    STAGNATION_EPSILON,
    STAGNATION_WINDOW,
    DifficultyConfig,
)
from mirage.core.simulation import EpisodeResult, simulate_episode


def project_to_budget(chromosome: np.ndarray, budget: float = GLOBAL_BUDGET) -> np.ndarray:
    """
    Garante a restrição energética estrita sum(u_i) <= budget e u_i in [0, 1].
    Se a soma ultrapassar o orçamento, reescala proporcionalmente.
    """
    clipped = np.clip(chromosome, 0.0, 1.0)
    total = np.sum(clipped)
    if total > budget:
        clipped = clipped * (budget / total)
    return np.clip(clipped, 0.0, 1.0)


def init_population(pop_size: int, budget: float = GLOBAL_BUDGET) -> np.ndarray:
    """
    Inicializa a população com cromossomos aleatórios contínuos [0, 1]^4
    projetados dentro do orçamento energético.
    """
    pop = np.random.rand(pop_size, NUM_GENES)
    for i in range(pop_size):
        pop[i] = project_to_budget(pop[i], budget)
    return pop


def tournament_selection(
    population: np.ndarray,
    fitnesses: np.ndarray,
    tournament_size: int = 3
) -> np.ndarray:
    """Seleção por torneio estocástico."""
    pop_size = len(population)
    selected_indices = np.zeros(pop_size, dtype=np.int64)

    for i in range(pop_size):
        candidates = np.random.choice(pop_size, size=tournament_size, replace=False)
        best_candidate = candidates[np.argmax(fitnesses[candidates])]
        selected_indices[i] = best_candidate

    return selected_indices


def blx_alpha_crossover(
    parent1: np.ndarray,
    parent2: np.ndarray,
    crossover_rate: float,
    alpha: float = 0.15
) -> Tuple[np.ndarray, np.ndarray]:
    """Crossover Blend (BLX-alpha) para cromossomos contínuos."""
    if np.random.rand() > crossover_rate:
        return parent1.copy(), parent2.copy()

    c1 = np.zeros(NUM_GENES, dtype=np.float64)
    c2 = np.zeros(NUM_GENES, dtype=np.float64)

    for g in range(NUM_GENES):
        d = abs(parent1[g] - parent2[g])
        low = min(parent1[g], parent2[g]) - alpha * d
        high = max(parent1[g], parent2[g]) + alpha * d
        c1[g] = np.random.uniform(low, high)
        c2[g] = np.random.uniform(low, high)

    return project_to_budget(c1), project_to_budget(c2)


def gaussian_mutation(
    chromosome: np.ndarray,
    mutation_rate: float,
    sigma: float = 0.10
) -> np.ndarray:
    """Mutação Gaussiana com perturbação estocástica e projeção no orçamento."""
    mutated = chromosome.copy()
    for g in range(NUM_GENES):
        if np.random.rand() < mutation_rate:
            noise = np.random.normal(0.0, sigma)
            mutated[g] += noise
    return project_to_budget(mutated)


@dataclass
class GenerationSnapshot:
    generation: int
    best_fitness: float
    mean_fitness: float
    best_chromosome: np.ndarray
    best_result: EpisodeResult


@dataclass
class TrainingRunResult:
    difficulty: int
    generations_trained: int
    best_fitness: float
    mean_pop_fitness: float
    best_chromosome: np.ndarray
    best_result: EpisodeResult
    history_best: List[float] = field(default_factory=list)
    history_mean: List[float] = field(default_factory=list)
    snapshots: List[GenerationSnapshot] = field(default_factory=list)
    converged_early: bool = False
    duration_seconds: float = 0.0


def train_single_run(
    difficulty: int = 2,
    max_gens: Optional[int] = None,
    pop_size_override: Optional[int] = None,
    on_generation_callback: Optional[Callable[[GenerationSnapshot], None]] = None
) -> TrainingRunResult:
    """
    Executa uma rodada completa de treinamento evolutivo.
    """
    start_time = time.time()

    cfg: DifficultyConfig = DIFFICULTY_SETTINGS[difficulty]
    pop_size = pop_size_override if pop_size_override is not None else cfg.pop_size
    max_generations = max_gens if max_gens is not None else cfg.max_generations

    population = init_population(pop_size)
    best_overall_fitness = -1.0
    best_overall_chromosome = population[0].copy()
    best_overall_result: Optional[EpisodeResult] = None

    history_best: List[float] = []
    history_mean: List[float] = []
    snapshots: List[GenerationSnapshot] = []
    converged_early = False
    real_gens = max_generations

    for gen in range(1, max_generations + 1):
        fitnesses = np.zeros(pop_size, dtype=np.float64)
        results: List[EpisodeResult] = []

        for i in range(pop_size):
            res, _ = simulate_episode(population[i], difficulty=difficulty)
            fitnesses[i] = res.fitness
            results.append(res)

        gen_max_fit = float(np.max(fitnesses))
        gen_mean_fit = float(np.mean(fitnesses))
        gen_best_idx = int(np.argmax(fitnesses))

        if gen_max_fit > best_overall_fitness:
            best_overall_fitness = gen_max_fit
            best_overall_chromosome = population[gen_best_idx].copy()
            best_overall_result = results[gen_best_idx]

        history_best.append(best_overall_fitness)
        history_mean.append(gen_mean_fit)

        snap = GenerationSnapshot(
            generation=gen,
            best_fitness=best_overall_fitness,
            mean_fitness=gen_mean_fit,
            best_chromosome=best_overall_chromosome.copy(),
            best_result=best_overall_result if best_overall_result else results[gen_best_idx]
        )
        snapshots.append(snap)

        if on_generation_callback:
            on_generation_callback(snap)

        # Critério de Parada por Estagnação
        if gen > STAGNATION_WINDOW:
            past_fitness = history_best[gen - 1 - STAGNATION_WINDOW]
            if past_fitness > 1e-4:
                improvement = (best_overall_fitness - past_fitness) / past_fitness
                if improvement < STAGNATION_EPSILON:
                    converged_early = True
                    real_gens = gen
                    break

        # Reprodução e Elitismo
        new_pop = np.zeros_like(population)
        sorted_indices = np.argsort(fitnesses)[::-1]

        for e in range(cfg.elitism_count):
            new_pop[e] = population[sorted_indices[e]].copy()

        parents_idx = tournament_selection(population, fitnesses)

        curr = cfg.elitism_count
        while curr < pop_size:
            p1 = population[parents_idx[curr]]
            p2 = population[parents_idx[min(curr + 1, pop_size - 1)]]

            c1, c2 = blx_alpha_crossover(p1, p2, cfg.crossover_rate)
            c1 = gaussian_mutation(c1, cfg.mutation_rate)
            c2 = gaussian_mutation(c2, cfg.mutation_rate)

            new_pop[curr] = c1
            if curr + 1 < pop_size:
                new_pop[curr + 1] = c2
            curr += 2

        population = new_pop

    duration = time.time() - start_time
    return TrainingRunResult(
        difficulty=difficulty,
        generations_trained=real_gens,
        best_fitness=best_overall_fitness,
        mean_pop_fitness=float(np.mean(history_mean)),
        best_chromosome=best_overall_chromosome,
        best_result=best_overall_result,
        history_best=history_best,
        history_mean=history_mean,
        snapshots=snapshots,
        converged_early=converged_early,
        duration_seconds=duration
    )


def train_genetic_algorithm(
    difficulty: int = 2,
    max_gens: Optional[int] = None,
    pop_size_override: Optional[int] = None,
    verbose: bool = False,
    on_generation_callback: Optional[Callable[[GenerationSnapshot], None]] = None
) -> TrainingRunResult:
    """
    Função canônica para treinar o Algoritmo Genético, com suporte a feedback verbal no terminal.
    """
    def cb(snap: GenerationSnapshot):
        if verbose and (snap.generation % 5 == 0 or snap.generation == 1):
            print(
                f"  Gen {snap.generation:>2d} | Max Fit: {snap.best_fitness:>7.2f} "
                f"| Mean Fit: {snap.mean_fitness:>7.2f} | Sobrevivência: {snap.best_result.survival_time:>4.1f}s "
                f"| Desvios: {snap.best_result.dodges:>2d}"
            )
        if on_generation_callback:
            on_generation_callback(snap)

    res = train_single_run(
        difficulty=difficulty,
        max_gens=max_gens,
        pop_size_override=pop_size_override,
        on_generation_callback=cb if (verbose or on_generation_callback) else None
    )
    if verbose:
        status = "Convergência Precoce (Estagnação)" if res.converged_early else "Critério de Gerações Máximas"
        print(f"\n[Fim do Treino] {status} após {res.generations_trained} gerações ({res.duration_seconds:.2f}s).")
    return res

