"""
=============================================================================
PROJETO MIRAGE — SIMULADOR FÍSICO CONTÍNUO DE COMBATE 2D
=============================================================================
Mecanismo de alta velocidade para episódios de combate cinemático.
Suporta execução headless em lote (ultrarrápida) e captura de telemetria
para visualização ao vivo em Pygame-CE.
=============================================================================
"""

import math
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple
import numpy as np

from mirage.config import (
    ARENA_BOUNDS,
    CPA_TIME_HORIZON,
    DIFFICULTY_SETTINGS,
    DT_PHYSICS,
    GENE_BOUNDS,
    MAX_EPISODE_TIME,
    NPC_BULLET_SPEED,
    NPC_RADIUS,
    PILLAR_RADIUS,
    PILLARS,
    RADAR_RADIUS,
    SAFETY_RADIUS_CPA,
    DifficultyConfig,
)
from mirage.core.kinematics import (
    calculate_cpa_evade_force,
    calculate_lead_aiming_direction,
    resolve_pillar_collision,
)


@dataclass
class EpisodeResult:
    survival_time: float
    dodges: int
    collisions: int
    damage_taken: float
    damage_inflicted: float
    fitness: float
    final_hp: float
    max_hp: float


@dataclass
class TelemetryFrame:
    time: float
    npc_pos: np.ndarray
    npc_vel: np.ndarray
    npc_hp: float
    npc_max_hp: float
    enemy_projectiles: np.ndarray  # [[x, y, vx, vy, active]]
    npc_projectiles: np.ndarray    # [[x, y, vx, vy, active]]
    evade_force: np.ndarray
    lead_target: Optional[np.ndarray]
    dodges: int
    collisions: int
    damage_inflicted: float


def denormalize_chromosome(chromosome: np.ndarray) -> Tuple[float, float, float, float]:
    """
    Desnormaliza o cromossomo contínuo [0, 1]^4 para valores físicos reais:
    (HP_max, Attack, AttackSpeed, MovementSpeed)
    """
    hp = GENE_BOUNDS[0][0] + (GENE_BOUNDS[0][1] - GENE_BOUNDS[0][0]) * chromosome[0]
    atk = GENE_BOUNDS[1][0] + (GENE_BOUNDS[1][1] - GENE_BOUNDS[1][0]) * chromosome[1]
    atk_spd = GENE_BOUNDS[2][0] + (GENE_BOUNDS[2][1] - GENE_BOUNDS[2][0]) * chromosome[2]
    mov_spd = GENE_BOUNDS[3][0] + (GENE_BOUNDS[3][1] - GENE_BOUNDS[3][0]) * chromosome[3]
    return float(hp), float(atk), float(atk_spd), float(mov_spd)


def calculate_fitness(
    t_surv: float,
    n_dodge: int,
    n_coll: int,
    d_taken: float,
    d_inflict: float,
    difficulty: int
) -> float:
    """Calcula a aptidão com base nos pesos canônicos da dificuldade."""
    cfg = DIFFICULTY_SETTINGS[difficulty]
    w = cfg.fitness_weights
    fit = w[0] * t_surv + w[1] * n_dodge - w[2] * n_coll + w[3] * d_inflict - w[4] * d_taken
    return float(max(1.0, fit))


def simulate_episode(
    chromosome: np.ndarray,
    difficulty: int = 2,
    record_telemetry: bool = False,
    seed: Optional[int] = None
) -> Tuple[EpisodeResult, List[TelemetryFrame]]:
    """
    Executa a simulação física completa de um episódio de combate.
    """
    if seed is not None:
        np.random.seed(seed)

    cfg: DifficultyConfig = DIFFICULTY_SETTINGS[difficulty]
    hp_max, attack, attack_speed, max_speed = denormalize_chromosome(chromosome)

    hp = hp_max
    npc_pos = np.array([0.0, 0.0], dtype=np.float64)
    npc_vel = np.array([0.0, 0.0], dtype=np.float64)

    # Listas dinâmicas de projéteis:
    # enemy: [x, y, vx, vy, active(1/0), radar_state(0=out, 1=in, 2=dodged)]
    enemy_proj_list: List[List[float]] = []
    # npc: [x, y, vx, vy, active(1/0)]
    npc_proj_list: List[List[float]] = []

    n_dodge = 0
    n_collision = 0
    d_taken = 0.0
    d_inflicted = 0.0
    survival_time = 0.0

    telemetry: List[TelemetryFrame] = []
    num_steps = int(MAX_EPISODE_TIME / DT_PHYSICS)

    last_shot_time = -1.0
    shot_interval = 1.0 / max(0.1, attack_speed)

    for step in range(num_steps):
        t = step * DT_PHYSICS
        survival_time = t

        if hp <= 0.0:
            break

        # ---------------------------------------------------------------------
        # 1. Geração de Projéteis Inimigos (Bullet Hell Dinâmico)
        # ---------------------------------------------------------------------
        t_progress = t / MAX_EPISODE_TIME
        current_spawn_rate = max(
            cfg.spawn_rate_final,
            cfg.spawn_rate_init - t_progress * (cfg.spawn_rate_init - cfg.spawn_rate_final)
        )

        if (t % current_spawn_rate) < DT_PHYSICS:
            angle = np.random.uniform(0, 2 * math.pi)
            spawn_pos = np.array([18.0 * math.cos(angle), 18.0 * math.sin(angle)], dtype=np.float64)
            aim_dir = npc_pos - spawn_pos
            aim_dist = np.linalg.norm(aim_dir)
            if aim_dist > 1e-4:
                aim_dir /= aim_dist

            noise = (np.random.rand(2) - 0.5) * cfg.noise_scale
            vel = (aim_dir + noise) * cfg.proj_speed
            enemy_proj_list.append([spawn_pos[0], spawn_pos[1], vel[0], vel[1], 1.0, 0.0])

        # Padrão Cone Shotgun (Médio e Difícil)
        if cfg.has_shotgun and t > 1.0 and (t % 2.8) < DT_PHYSICS:
            sg_angle = np.random.uniform(0, 2 * math.pi)
            sg_spawn = np.array([18.0 * math.cos(sg_angle), 18.0 * math.sin(sg_angle)], dtype=np.float64)
            sg_aim = npc_pos - sg_spawn
            sg_dist = np.linalg.norm(sg_aim)
            if sg_dist > 1e-4:
                sg_aim /= sg_dist
            for spread in (-0.22, 0.0, 0.22):
                cs, ss = math.cos(spread), math.sin(spread)
                rot_v = np.array([sg_aim[0] * cs - sg_aim[1] * ss, sg_aim[0] * ss + sg_aim[1] * cs])
                sg_vel = rot_v * (cfg.proj_speed * 1.05)
                enemy_proj_list.append([sg_spawn[0], sg_spawn[1], sg_vel[0], sg_vel[1], 1.0, 0.0])

        # Padrão Vórtice Espiral Danmaku (Difícil)
        if cfg.has_spiral and t > 2.0 and (t % 0.75) < DT_PHYSICS:
            ang_spiral = 4.5 * t
            dir_spiral = np.array([math.cos(ang_spiral), math.sin(ang_spiral)]) * 9.5
            enemy_proj_list.append([0.0, 0.0, dir_spiral[0], dir_spiral[1], 1.0, 0.0])

        # ---------------------------------------------------------------------
        # 2. Varredura CPA e Evasão Vetorial de Reynolds
        # ---------------------------------------------------------------------
        total_evade_force = np.zeros(2, dtype=np.float64)
        active_threats: List[int] = []

        for idx, p in enumerate(enemy_proj_list):
            if p[4] > 0.5:  # Ativo
                p_pos = np.array([p[0], p[1]], dtype=np.float64)
                p_vel = np.array([p[2], p[3]], dtype=np.float64)
                f_ev = calculate_cpa_evade_force(
                    npc_pos, npc_vel, p_pos, p_vel, max_speed,
                    SAFETY_RADIUS_CPA, CPA_TIME_HORIZON
                )
                total_evade_force += f_ev
                active_threats.append(idx)

        # Atualização Cinemática do NPC (Euler Semi-Implícito)
        npc_vel += total_evade_force * DT_PHYSICS
        spd = np.linalg.norm(npc_vel)
        if spd > max_speed:
            npc_vel = (npc_vel / spd) * max_speed

        if np.linalg.norm(total_evade_force) < 1e-3:
            npc_vel *= 0.85  # Atrito de frenagem suave

        npc_pos += npc_vel * DT_PHYSICS

        # Colisão com Pilares e Bordas
        npc_pos, npc_vel = resolve_pillar_collision(npc_pos, npc_vel, PILLARS, NPC_RADIUS, PILLAR_RADIUS)
        npc_pos[0] = max(min(npc_pos[0], ARENA_BOUNDS), -ARENA_BOUNDS)
        npc_pos[1] = max(min(npc_pos[1], ARENA_BOUNDS), -ARENA_BOUNDS)

        # ---------------------------------------------------------------------
        # 3. Disparo Preditivo Inverso (Lead-Aiming Counter-Attack)
        # ---------------------------------------------------------------------
        lead_target_pos: Optional[np.ndarray] = None
        if (t - last_shot_time) >= shot_interval:
            last_shot_time = t
            current_spd = np.linalg.norm(npc_vel)
            accuracy = max(0.5, 1.0 - (current_spd / max_speed) * 0.3)
            d_inflicted += attack * accuracy * 1.15  # Bônus de contra-ataque

            # Interceptação balística prioritária da ameaça mais próxima
            if active_threats:
                best_threat = -1
                min_threat_dist = 1e9
                for th_idx in active_threats:
                    th_p = enemy_proj_list[th_idx]
                    d_th = math.hypot(th_p[0] - npc_pos[0], th_p[1] - npc_pos[1])
                    if d_th < min_threat_dist:
                        min_threat_dist = d_th
                        best_threat = th_idx

                if best_threat >= 0:
                    th = enemy_proj_list[best_threat]
                    t_pos = np.array([th[0], th[1]], dtype=np.float64)
                    t_vel = np.array([th[2], th[3]], dtype=np.float64)
                    aim_dir, lead_target_pos = calculate_lead_aiming_direction(
                        npc_pos, t_pos, t_vel, NPC_BULLET_SPEED
                    )
                    shot_v = aim_dir * NPC_BULLET_SPEED
                    npc_proj_list.append([npc_pos[0], npc_pos[1], shot_v[0], shot_v[1], 1.0])
            else:
                # Disparo radial livre
                rnd_ang = np.random.uniform(0, 2 * math.pi)
                shot_v = np.array([math.cos(rnd_ang), math.sin(rnd_ang)]) * NPC_BULLET_SPEED
                npc_proj_list.append([npc_pos[0], npc_pos[1], shot_v[0], shot_v[1], 1.0])

        # ---------------------------------------------------------------------
        # 4. Atualização e Interceptação Ar-Ar de Projéteis do NPC
        # ---------------------------------------------------------------------
        for nb in npc_proj_list:
            if nb[4] > 0.5:
                nb[0] += nb[2] * DT_PHYSICS
                nb[1] += nb[3] * DT_PHYSICS

                # Absorção por Pilares
                for pil in PILLARS:
                    if math.hypot(nb[0] - pil[0], nb[1] - pil[1]) < (PILLAR_RADIUS + 0.3):
                        nb[4] = 0.0
                        break

                # Fora dos limites
                if abs(nb[0]) > 20.0 or abs(nb[1]) > 20.0:
                    nb[4] = 0.0
                    continue

                # Interceptação Ar-Ar (Projétil do NPC destrói Projétil Inimigo)
                if nb[4] > 0.5:
                    for ep in enemy_proj_list:
                        if ep[4] > 0.5:
                            if math.hypot(nb[0] - ep[0], nb[1] - ep[1]) < 0.8:
                                nb[4] = 0.0
                                ep[4] = 0.0
                                n_dodge += 1
                                break

        # ---------------------------------------------------------------------
        # 5. Atualização e Colisão dos Projéteis Inimigos
        # ---------------------------------------------------------------------
        for p in enemy_proj_list:
            if p[4] > 0.5:
                p[0] += p[2] * DT_PHYSICS
                p[1] += p[3] * DT_PHYSICS

                # Absorção por Pilares
                coll_pillar = False
                for pil in PILLARS:
                    if math.hypot(p[0] - pil[0], p[1] - pil[1]) < (PILLAR_RADIUS + 0.3):
                        p[4] = 0.0
                        coll_pillar = True
                        break
                if coll_pillar:
                    continue

                dist_npc = math.hypot(p[0] - npc_pos[0], p[1] - npc_pos[1])

                # 1) Colisão Direta
                if dist_npc < (NPC_RADIUS + 0.3):
                    p[4] = 0.0
                    n_collision += 1
                    damage = 25.0
                    hp -= damage
                    d_taken += damage

                # 2) Detecção no Radar de Perigo
                elif dist_npc < RADAR_RADIUS and p[5] == 0.0:
                    p[5] = 1.0

                # 3) Evasão com Sucesso (Saiu do Radar sem colidir)
                elif dist_npc >= RADAR_RADIUS and p[5] == 1.0:
                    p[5] = 2.0
                    n_dodge += 1

                # Fora dos limites
                if abs(p[0]) > 20.0 or abs(p[1]) > 20.0:
                    p[4] = 0.0

        # Gravação de Telemetria se solicitada
        if record_telemetry:
            en_snap = np.array([p[:5] for p in enemy_proj_list if p[4] > 0.5], dtype=np.float64)
            if en_snap.shape[0] == 0:
                en_snap = np.empty((0, 5), dtype=np.float64)

            npc_snap = np.array([b[:5] for b in npc_proj_list if b[4] > 0.5], dtype=np.float64)
            if npc_snap.shape[0] == 0:
                npc_snap = np.empty((0, 5), dtype=np.float64)

            frame = TelemetryFrame(
                time=t,
                npc_pos=npc_pos.copy(),
                npc_vel=npc_vel.copy(),
                npc_hp=max(0.0, hp),
                npc_max_hp=hp_max,
                enemy_projectiles=en_snap,
                npc_projectiles=npc_snap,
                evade_force=total_evade_force.copy(),
                lead_target=lead_target_pos.copy() if lead_target_pos is not None else None,
                dodges=n_dodge,
                collisions=n_collision,
                damage_inflicted=d_inflicted
            )
            telemetry.append(frame)

        if step % 200 == 0:
            enemy_proj_list = [p for p in enemy_proj_list if p[4] > 0.5]
            npc_proj_list = [b for b in npc_proj_list if b[4] > 0.5]

    fit = calculate_fitness(survival_time, n_dodge, n_collision, d_taken, d_inflicted, difficulty)
    res = EpisodeResult(
        survival_time=survival_time,
        dodges=n_dodge,
        collisions=n_collision,
        damage_taken=d_taken,
        damage_inflicted=d_inflicted,
        fitness=fit,
        final_hp=max(0.0, hp),
        max_hp=hp_max
    )
    return res, telemetry

