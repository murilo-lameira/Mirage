"""
=============================================================================
PROJETO MIRAGE — CONFIGURAÇÃO GLOBAL E HIPERPARÂMETROS
=============================================================================
Constantes físicas, restrições orçamentárias (B = 1.8), limites de genes,
parâmetros de dificuldade e paletas de cores do ecossistema.
=============================================================================
"""

from dataclasses import dataclass
from typing import Dict, List, Tuple
import numpy as np

# ---------------------------------------------------------------------------
# 1. ORÇAMENTO GENÉTICO GLOBAL (INVARIANTE)
# ---------------------------------------------------------------------------
GLOBAL_BUDGET: float = 1.8  # Restrição energética: sum(u_i) <= 1.8
NUM_GENES: int = 4          # [HP, Attack, AttackSpeed, MovementSpeed]

# Limites fenotípicos de desnormalização: valor = min + (max - min) * u_i
GENE_BOUNDS: List[Tuple[float, float]] = [
    (10.0, 200.0),   # Gene 0: HP Máximo [pontos]
    (5.0, 50.0),     # Gene 1: Poder de Ataque [unidades de dano]
    (0.5, 5.0),      # Gene 2: Cadência de Disparo [Hz]
    (1.0, 8.0),      # Gene 3: Velocidade Máxima de Movimento [m/s]
]

GENE_NAMES: List[str] = [
    "HP Máximo",
    "Poder de Ataque",
    "Cadência de Disparo",
    "Velocidade de Movimento",
]

# ---------------------------------------------------------------------------
# 2. AMBIENTE FÍSICO E ARENA 2D
# ---------------------------------------------------------------------------
ARENA_BOUNDS: float = 18.0     # Fronteira da arena [-18, 18] metros
DT_PHYSICS: float = 0.05       # Passo temporal de integração (50 FPS / 20 Hz)
MAX_EPISODE_TIME: float = 30.0 # Duração máxima do episódio em segundos
NPC_RADIUS: float = 1.0        # Raio da hitbox do NPC
RADAR_RADIUS: float = 4.0      # Raio de detecção de proximidade (radar militar)
SAFETY_RADIUS_CPA: float = 2.5 # Distância crítica de evasão do CPA
CPA_TIME_HORIZON: float = 1.5  # Horizonte temporal de predição [s]
NPC_BULLET_SPEED: float = 16.0 # Velocidade do projétil do NPC [m/s]

# Pilares estáticos de cobertura física
PILLARS: np.ndarray = np.array([
    [-8.0, -8.0],
    [ 8.0, -8.0],
    [-8.0,  8.0],
    [ 8.0,  8.0]
], dtype=np.float64)
PILLAR_RADIUS: float = 1.3

# ---------------------------------------------------------------------------
# 3. HIPERPARÂMETROS DO ALGORITMO GENÉTICO POR DIFICULDADE
# ---------------------------------------------------------------------------
@dataclass
class DifficultyConfig:
    name: str
    pop_size: int
    max_generations: int
    crossover_rate: float
    mutation_rate: float
    elitism_count: int
    spawn_rate_init: float
    spawn_rate_final: float
    proj_speed: float
    noise_scale: float
    fitness_weights: Tuple[float, float, float, float, float]
    has_shotgun: bool = False
    has_spiral: bool = False

DIFFICULTY_SETTINGS: Dict[int, DifficultyConfig] = {
    1: DifficultyConfig(
        name="Fácil",
        pop_size=20,
        max_generations=50,
        crossover_rate=0.60,
        mutation_rate=0.15,
        elitism_count=0,
        spawn_rate_init=1.40,
        spawn_rate_final=0.70,
        proj_speed=9.0,
        noise_scale=0.25,
        fitness_weights=(10.0, 5.0, 10.0, 0.5, 0.2),
        has_shotgun=False,
        has_spiral=False
    ),
    2: DifficultyConfig(
        name="Médio",
        pop_size=50,
        max_generations=50,
        crossover_rate=0.75,
        mutation_rate=0.05,
        elitism_count=1,
        spawn_rate_init=0.70,
        spawn_rate_final=0.30,
        proj_speed=11.5,
        noise_scale=0.15,
        fitness_weights=(15.0, 8.0, 15.0, 0.8, 0.3),
        has_shotgun=True,
        has_spiral=False
    ),
    3: DifficultyConfig(
        name="Difícil",
        pop_size=100,
        max_generations=50,
        crossover_rate=0.90,
        mutation_rate=0.01,
        elitism_count=3,
        spawn_rate_init=0.30,
        spawn_rate_final=0.10,
        proj_speed=13.5,
        noise_scale=0.08,
        fitness_weights=(25.0, 12.0, 25.0, 1.2, 0.5),
        has_shotgun=True,
        has_spiral=True
    )
}

# Critérios de Parada de Estagnação
STAGNATION_WINDOW: int = 15      # K_stop gerações
STAGNATION_EPSILON: float = 0.01  # eps_stop = 1% de melhoria mínima

# ---------------------------------------------------------------------------
# 4. PALETA DE CORES CYBERPUNK & ACADÊMICA
# ---------------------------------------------------------------------------
COLOR_BG_SPACE = (12, 16, 26)        # Deep space navy #0c101a
COLOR_GRID = (24, 34, 52)            # Radar grid line
COLOR_NPC = (0, 210, 255)            # Cyan neon NPC chassis
COLOR_NPC_CORE = (255, 255, 255)     # Glowing core
COLOR_NPC_BULLET = (0, 245, 255)     # Cyan energy bolt
COLOR_ENEMY_BULLET = (255, 55, 80)   # Plasma red/orange
COLOR_PILLAR = (45, 55, 75)          # Metallic pillar
COLOR_PILLAR_GLOW = (0, 180, 220)    # Cyan energy shield
COLOR_RADAR_CIRCLE = (0, 200, 255)   # HUD holographic ring
COLOR_EVADE_VECTOR = (50, 255, 120)  # Reynolds steering arrow
COLOR_LEAD_RAY = (255, 215, 0)       # Amber lead reticle ray
COLOR_TEXT_HUD = (220, 235, 255)     # Crisp white-blue HUD font

