"""
=============================================================================
PROJETO MIRAGE — CINEMÁTICA PREDITIVA (CPA, REYNOLDS STEERING & LEAD-AIMING)
=============================================================================
Implementação compilada em código de máquina via Numba JIT para velocidade
extrema em simulações contínuas de 50 FPS.
=============================================================================
"""

import math
from typing import Tuple
import numpy as np
from numba import njit


@njit(fastmath=True)
def calculate_cpa_evade_force(
    npc_pos: np.ndarray,
    npc_vel: np.ndarray,
    proj_pos: np.ndarray,
    proj_vel: np.ndarray,
    max_speed: float,
    safety_radius: float = 2.5,
    time_horizon: float = 1.5
) -> np.ndarray:
    """
    Calcula a força de esquiva baseada no Ponto de Maior Aproximação (CPA)
    e na mecânica de Steering Behaviors de Craig Reynolds.
    
    Ref: Lee et al. (2014) - Collision Avoidance via CPA.
    """
    pr = proj_pos - npc_pos
    vr = proj_vel - npc_vel
    speed_sq = vr[0] * vr[0] + vr[1] * vr[1]

    if speed_sq < 1e-6:
        return np.zeros(2, dtype=np.float64)

    t_cpa = -(pr[0] * vr[0] + pr[1] * vr[1]) / speed_sq

    # Só reage a projéteis convergentes dentro da janela temporal
    if 0.0 < t_cpa < time_horizon:
        npc_future = npc_pos + npc_vel * t_cpa
        proj_future = proj_pos + proj_vel * t_cpa

        diff = npc_future - proj_future
        dist_cpa = math.sqrt(diff[0] * diff[0] + diff[1] * diff[1])

        if dist_cpa < safety_radius:
            if dist_cpa < 1e-6:
                # Caso de colisão frontal perfeita: desvia na perpendicular
                evade_dir = np.array([-proj_vel[1], proj_vel[0]], dtype=np.float64)
            else:
                evade_dir = diff / dist_cpa

            # Reynolds Steering: Força = Velocidade Desejada - Velocidade Atual
            desired_vel = evade_dir * max_speed
            return desired_vel - npc_vel

    return np.zeros(2, dtype=np.float64)


@njit(fastmath=True)
def calculate_lead_aiming_direction(
    npc_pos: np.ndarray,
    target_pos: np.ndarray,
    target_vel: np.ndarray,
    shot_speed: float = 16.0
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Computa a solução analítica de 1ª ordem para interceptação balística
    (Lead-Aiming), prevendo a posição futura do projétil/alvo inimigo.
    
    Retorna: (vetor_unitario_mira, posicao_predita_alvo)
    """
    dx = target_pos[0] - npc_pos[0]
    dy = target_pos[1] - npc_pos[1]
    dist = math.sqrt(dx * dx + dy * dy)
    
    t_speed = math.sqrt(target_vel[0] * target_vel[0] + target_vel[1] * target_vel[1])
    t_intercept = dist / (shot_speed + t_speed + 1e-4)

    predicted_pos = target_pos + target_vel * t_intercept
    aim_vec = predicted_pos - npc_pos
    aim_dist = math.sqrt(aim_vec[0] * aim_vec[0] + aim_vec[1] * aim_vec[1])

    if aim_dist > 1e-5:
        aim_dir = aim_vec / aim_dist
    else:
        aim_dir = np.array([1.0, 0.0], dtype=np.float64)

    return aim_dir, predicted_pos


@njit(fastmath=True)
def resolve_pillar_collision(
    npc_pos: np.ndarray,
    npc_vel: np.ndarray,
    pillars: np.ndarray,
    npc_radius: float,
    pillar_radius: float
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Impede que o NPC atravesse pilares rígidos, calculando a força de contato
    e permitindo deslize tangencial suave na superfície do obstáculo.
    """
    min_dist = npc_radius + pillar_radius
    num_pillars = pillars.shape[0]

    for p in range(num_pillars):
        dx = npc_pos[0] - pillars[p, 0]
        dy = npc_pos[1] - pillars[p, 1]
        dist = math.sqrt(dx * dx + dy * dy)

        if dist < min_dist:
            if dist > 1e-4:
                nx = dx / dist
                ny = dy / dist
                npc_pos = np.array([pillars[p, 0] + nx * min_dist, pillars[p, 1] + ny * min_dist], dtype=np.float64)
                
                # Projeta a velocidade na normal: remove componente penetrante
                v_dot_n = npc_vel[0] * nx + npc_vel[1] * ny
                if v_dot_n < 0.0:
                    npc_vel = npc_vel - np.array([nx, ny], dtype=np.float64) * v_dot_n
            else:
                npc_pos = npc_pos + np.array([0.1, 0.1], dtype=np.float64)

    return npc_pos, npc_vel

