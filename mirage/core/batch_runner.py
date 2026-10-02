"""
=============================================================================
PROJETO MIRAGE — EXECUTOR PARALELO DE EXPERIMENTOS EM LOTE (MULTIPROCESSING)
=============================================================================
Executa N rodadas experimentais simultâneas utilizando todos os núcleos da CPU,
registrando automaticamente telemetria, histórico de gerações e arquivo MAP-Elites
em formato CSV com tratamento de concorrência.
=============================================================================
"""

import csv
import datetime
import os
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from typing import Dict, List, Optional, Tuple
import numpy as np

from mirage.config import DIFFICULTY_SETTINGS
from mirage.core.ga import TrainingRunResult, train_single_run
from mirage.core.map_elites import MAPElitesArchive
from mirage.core.simulation import denormalize_chromosome


def _worker_run(args) -> TrainingRunResult:
    """Função executada por cada worker em processo isolado."""
    diff, max_gens, seed = args
    if seed is not None:
        np.random.seed(seed)
    return train_single_run(difficulty=diff, max_gens=max_gens)


class BatchExperimentRunner:
    def __init__(
        self,
        results_csv: str = "data/resultados_experimentos.csv",
        history_csv: str = "data/historico_geracoes.csv",
        map_elites_csv: str = "data/map_elites.csv"
    ):
        self.results_csv = results_csv
        self.history_csv = history_csv
        self.map_elites_csv = map_elites_csv
        self.archive = MAPElitesArchive()
        self._init_csv_files()

    def _init_csv_files(self):
        """Garante que os arquivos CSV possuam cabeçalhos padronizados."""
        os.makedirs("data", exist_ok=True)
        if not os.path.exists(self.results_csv) or os.path.getsize(self.results_csv) == 0:
            with open(self.results_csv, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow([
                    "Data_Hora", "Dificuldade", "Populacao", "Geracoes_Treinadas",
                    "Fitness_Max", "Fitness_Medio", "Elite_HP", "Elite_Atk",
                    "Elite_AtkSpd", "Elite_MovSpd", "Elite_Sobrevivencia",
                    "Elite_Desvios", "Elite_Colisoes", "Elite_DanoCausado",
                    "Elite_DanoTomado", "Tempo_Treino_Seg", "Modo_EDS"
                ])

        if not os.path.exists(self.history_csv) or os.path.getsize(self.history_csv) == 0:
            with open(self.history_csv, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow([
                    "Data_Hora", "Dificuldade", "Rodada", "Geracao",
                    "Fitness_Maximo_Global", "Fitness_Medio_Pop"
                ])

        if not os.path.exists(self.map_elites_csv) or os.path.getsize(self.map_elites_csv) == 0:
            with open(self.map_elites_csv, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow([
                    "Data_Hora", "Dificuldade", "Modo_EDS", "Mobilidade",
                    "Classe", "Fitness", "HP", "Atk", "AtkSpd", "MovSpd"
                ])

    def append_run_result(self, res: TrainingRunResult, run_number: int):
        """Registra o resultado final da rodada no CSV de experimentos."""
        now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        hp, atk, atk_spd, mov_spd = denormalize_chromosome(res.best_chromosome)

        best_res = res.best_result
        surv = best_res.survival_time if best_res else 30.0
        dodges = best_res.dodges if best_res else 0
        colls = best_res.collisions if best_res else 0
        dmg_inf = best_res.damage_inflicted if best_res else 0.0
        dmg_tak = best_res.damage_taken if best_res else 0.0

        pop_size = DIFFICULTY_SETTINGS.get(res.difficulty, DIFFICULTY_SETTINGS[2]).pop_size

        with open(self.results_csv, "a", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow([
                now_str, res.difficulty, pop_size, res.generations_trained,
                f"{res.best_fitness:.2f}", f"{res.mean_pop_fitness:.2f}",
                int(round(hp)), int(round(atk)), f"{atk_spd:.2f}", f"{mov_spd:.2f}",
                f"{surv:.2f}", dodges, colls, f"{dmg_inf:.2f}", f"{dmg_tak:.2f}",
                f"{res.duration_seconds:.2f}", 0
            ])

        with open(self.history_csv, "a", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            for g_idx, (b_fit, m_fit) in enumerate(zip(res.history_best, res.history_mean), start=1):
                writer.writerow([
                    now_str, res.difficulty, run_number, g_idx,
                    f"{b_fit:.4f}", f"{m_fit:.4f}"
                ])

        row, col = MAPElitesArchive.get_niche_coordinates(res.best_chromosome)
        mob_label = ["Lento", "Medio", "Rapido"][row]
        cls_label = ["Tank", "Balanceado", "Dano(GlassCannon)"][col]

        with open(self.map_elites_csv, "a", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow([
                now_str, res.difficulty, 0, mob_label, cls_label,
                f"{res.best_fitness:.2f}", int(round(hp)), int(round(atk)),
                f"{atk_spd:.2f}", f"{mov_spd:.2f}"
            ])

    def run_battery(
        self,
        runs_per_difficulty: int = 10,
        difficulties: Tuple[int, ...] = (1, 2, 3),
        max_workers: Optional[int] = None
    ) -> List[TrainingRunResult]:
        """
        Executa a bateria completa de experimentos em paralelo nativo na CPU.
        """
        tasks = []
        task_info = []
        seed_base = int(time.time())

        for diff in difficulties:
            for r in range(1, runs_per_difficulty + 1):
                seed = seed_base + diff * 1000 + r
                tasks.append((diff, None, seed))
                task_info.append((diff, r))

        total_runs = len(tasks)
        print(f"\n{'='*70}", flush=True)
        print(f" >>> INICIANDO BATERIA PARALELA: {total_runs} EXPERIMENTOS NO TOTAL", flush=True)
        print(f" >>> DIFICULDADES: {difficulties} | RODADAS POR MODO: {runs_per_difficulty}", flush=True)
        print(f"{'='*70}\n", flush=True)

        results = []
        t0 = time.time()
        completed = 0

        with ProcessPoolExecutor(max_workers=max_workers) as executor:
            future_to_info = {
                executor.submit(_worker_run, task): task_info[i]
                for i, task in enumerate(tasks)
            }

            for future in as_completed(future_to_info):
                diff, r_num = future_to_info[future]
                try:
                    res = future.result()
                    completed += 1
                    self.append_run_result(res, completed)
                    results.append(res)
                    hp, atk, atk_s, mov_s = denormalize_chromosome(res.best_chromosome)
                    print(
                        f"[{completed:02d}/{total_runs:02d}] Dificuldade {diff} (Rodada {r_num:02d}) -> "
                        f"FitMax: {res.best_fitness:7.2f} | Gens: {res.generations_trained:02d} | "
                        f"Genes: HP={int(hp):03d} Atk={int(atk):02d} Cad={atk_s:.2f} Vel={mov_s:.2f} | "
                        f"Tempo: {res.duration_seconds:5.2f}s",
                        flush=True
                    )
                except Exception as e:
                    print(f"[ERRO] Falha na rodada {r_num} (Dif {diff}): {e}", flush=True)

        total_time = time.time() - t0
        print(f"\n{'='*70}", flush=True)
        print(f" >>> BATERIA DE {total_runs} EXPERIMENTOS CONCLUÍDA EM {total_time:.2f}s!", flush=True)
        print(f" >>> Velocidade Média: {total_time/total_runs:.2f}s por treinamento evolutivo completo.", flush=True)
        print(f"{'='*70}\n", flush=True)
        return results

    # Compatibilidade de métodos
    run_parallel_experiments = run_battery


def run_batch_experiments(
    num_runs_per_diff: int = 10,
    difficulties: Tuple[int, ...] = (1, 2, 3),
    max_workers: Optional[int] = None
) -> List[TrainingRunResult]:
    """Função utilitária canônica para invocar a bateria paralela de experimentos."""
    runner = BatchExperimentRunner()
    fn = getattr(runner, "run_battery", getattr(runner, "run_parallel_experiments", None))
    return fn(
        runs_per_difficulty=num_runs_per_diff,
        difficulties=difficulties,
        max_workers=max_workers
    )

