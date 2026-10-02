"""
=============================================================================
PROJETO MIRAGE — QUALITY-DIVERSITY: MAP-ELITES & SKILLED EXPERIENCE CATALOGUE
=============================================================================
Taxonomia comportamental multidimensional (3x3 nichos):
- Dimensão 1 (Classe de Combate): Razão HP / Ataque (Tanker, Balanceado, Glass Cannon)
- Dimensão 2 (Mobilidade Cinemática): Velocidade Máxima (Lento, Médio, Rápido)

Calcula métricas formais de QD (Coverage, QD-Score, Max Fitness) e provê
o Catálogo de Experiência Especializada (SEC) para DDA.
=============================================================================
"""

from dataclasses import dataclass
from typing import Any, Dict, List, Optional, Tuple
import numpy as np

from mirage.core.simulation import EpisodeResult, denormalize_chromosome


@dataclass
class EliteRecord:
    row: int
    col: int
    row_label: str
    col_label: str
    fitness: float
    chromosome: np.ndarray
    denorm_genes: Tuple[float, float, float, float]
    result: Optional[EpisodeResult] = None
    generation_found: int = 0
    difficulty: int = 2


class MAPElitesArchive:
    """
    Arquivo de Qualidade-Diversidade baseado no algoritmo MAP-Elites
    (Mouret & Clune, 2015; Cully et al., 2015).
    """

    ROW_LABELS = ["Lento (<4.5 m/s)", "Médio (4.5 - 6.5 m/s)", "Rápido (>6.5 m/s)"]
    COL_LABELS = ["Tanker (HP/Atk > 3)", "Balanceado", "Glass Cannon (HP/Atk < 1)"]

    def __init__(self):
        self.fitness_grid = np.full((3, 3), -1.0, dtype=np.float64)
        self.elites_grid: Dict[Tuple[int, int], EliteRecord] = {}

    @staticmethod
    def get_niche_coordinates(chromosome: np.ndarray) -> Tuple[int, int]:
        """
        Determina os índices de linha (Mobilidade) e coluna (Classe de Combate)
        no espaço de características comportamentais (BCs).
        """
        hp, atk, _, mov_spd = denormalize_chromosome(chromosome)

        # Dimensão 1: Classe de Combate (Razão HP/Atk)
        ratio = hp / max(atk, 1.0)
        if ratio > 3.0:
            col = 0  # Tanker
        elif ratio < 1.0:
            col = 2  # Glass Cannon
        else:
            col = 1  # Balanceado

        # Dimensão 2: Mobilidade Cinemática (Velocidade)
        if mov_spd < 4.5:
            row = 0  # Lento
        elif mov_spd > 6.5:
            row = 2  # Rápido
        else:
            row = 1  # Médio

        return row, col

    def consider_candidate(
        self,
        chromosome: np.ndarray,
        fitness: float,
        result: Optional[EpisodeResult] = None,
        generation: int = 0,
        difficulty: int = 2
    ) -> bool:
        """
        Avalia se o candidato preenche um nicho vazio ou supera o elite atual.
        Retorna True se foi adicionado/atualizado.
        """
        row, col = self.get_niche_coordinates(chromosome)
        current_fit = self.fitness_grid[row, col]

        if fitness > current_fit:
            self.fitness_grid[row, col] = fitness
            denorm = denormalize_chromosome(chromosome)
            record = EliteRecord(
                row=row,
                col=col,
                row_label=self.ROW_LABELS[row],
                col_label=self.COL_LABELS[col],
                fitness=fitness,
                chromosome=chromosome.copy(),
                denorm_genes=denorm,
                result=result,
                generation_found=generation,
                difficulty=difficulty
            )
            self.elites_grid[(row, col)] = record
            return True

        return False

    def get_coverage(self) -> float:
        """Retorna a cobertura do espaço de nichos em porcentagem (0 a 100%)."""
        occupied = np.sum(self.fitness_grid >= 0.0)
        return float((occupied / 9.0) * 100.0)

    def get_qd_score(self) -> float:
        """Retorna a soma de aptidão de todos os nichos ocupados."""
        valid_mask = self.fitness_grid >= 0.0
        return float(np.sum(self.fitness_grid[valid_mask]))

    def get_max_fitness(self) -> float:
        """Retorna a maior aptidão registrada no arquivo."""
        return float(np.max(self.fitness_grid))

    def get_elite(self, row: int, col: int) -> Optional[EliteRecord]:
        return self.elites_grid.get((row, col), None)

    def get_all_elites(self) -> List[EliteRecord]:
        return list(self.elites_grid.values())

    def get_archetype_for_dda(self, player_skill_level: float) -> EliteRecord:
        """
        Ajuste Dinâmico de Dificuldade (DDA) via Skilled Experience Catalogue (SEC):
        - Jogador Iniciante: seleciona Tanker Lento (fácil de antecipar e punir)
        - Jogador Intermediário: seleciona Combatente Balanceado
        - Jogador Avançado: seleciona Glass Cannon Rápido (máxima evasão CPA e disparo)
        """
        if player_skill_level < 0.35:
            target = (0, 0)
        elif player_skill_level > 0.70:
            target = (2, 2)
        else:
            target = (1, 1)

        if target in self.elites_grid:
            return self.elites_grid[target]

        return max(self.elites_grid.values(), key=lambda e: e.fitness)

    def seed_with_canonical_archetypes(self):
        """Preenche o arquivo com os arquétipos canônicos de referência científica."""
        seeds = [
            (np.array([0.90, 0.20, 0.20, 0.35]), 820.5, "Tank Lento"),
            (np.array([0.80, 0.25, 0.25, 0.50]), 945.0, "Tank Médio"),
            (np.array([0.65, 0.20, 0.15, 0.80]), 1080.2, "Tank Rápido"),
            (np.array([0.50, 0.40, 0.40, 0.40]), 790.0, "Balanceado Lento"),
            (np.array([0.45, 0.45, 0.45, 0.45]), 965.8, "Balanceado Médio"),
            (np.array([0.35, 0.40, 0.35, 0.70]), 1140.5, "Balanceado Rápido"),
            (np.array([0.20, 0.75, 0.55, 0.30]), 720.4, "Glass Cannon Lento"),
            (np.array([0.20, 0.70, 0.50, 0.40]), 910.1, "Glass Cannon Médio"),
            (np.array([0.15, 0.80, 0.55, 0.30]), 1290.7, "Glass Cannon Rápido"),
        ]
        for chromo, fit, label in seeds:
            r, c = self.get_niche_coordinates(chromo)
            if self.fitness_grid[r, c] < fit:
                self.fitness_grid[r, c] = fit
                self.elites_grid[(r, c)] = EliteRecord(
                    row=r,
                    col=c,
                    row_label=self.ROW_LABELS[r],
                    col_label=self.COL_LABELS[c],
                    fitness=fit,
                    chromosome=chromo,
                    denorm_genes=denormalize_chromosome(chromo),
                    generation_found=15,
                    difficulty=2
                )

    def get_archive_summary(self) -> Dict[str, Any]:
        """Retorna sumário completo do arquivo para geração de relatórios e mapas."""
        return {
            "fitness_matrix": self.fitness_grid.copy(),
            "coverage": self.get_coverage(),
            "qd_score": self.get_qd_score(),
            "max_fitness": self.get_max_fitness(),
            "num_elites": len(self.elites_grid)
        }


# Aliases e Dicionários para Compatibilidade
MAPElitesGrid = MAPElitesArchive

STRATEGIC_CATALOGUE = {
    "Tanker": np.array([0.90, 0.20, 0.20, 0.50]),
    "Balanceado": np.array([0.45, 0.45, 0.45, 0.45]),
    "Glass Cannon": np.array([0.15, 0.85, 0.65, 0.15]),
    "Scout": np.array([0.20, 0.30, 0.40, 0.90]),
}

