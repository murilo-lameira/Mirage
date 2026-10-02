"""
=============================================================================
PROJETO MIRAGE — APLICAÇÃO INTERATIVA E MODOS DE JOGO (PYGAME-CE)
=============================================================================
Oferece dois modos de experiência visual e interativa:
1. Modo Espectador (IA Autônoma): Visualização da nave controlada pelo
   Algoritmo Genético, CPA e Reynolds Steering em tempo real.
2. Modo Humano (Você no Controle): Permite ao jogador pilotar a nave via
   WASD/Teclas direcionais e mouse/teclado, confrontando os mesmos
   padrões Danmaku / Bullet Hell da IA.
=============================================================================
"""

import math
import sys
import time
from typing import List, Optional
import numpy as np
import pygame

from mirage.config import (
    ARENA_BOUNDS,
    DIFFICULTY_SETTINGS,
    DT_PHYSICS,
    MAX_EPISODE_TIME,
    NPC_BULLET_SPEED,
    NPC_RADIUS,
    PILLAR_RADIUS,
    PILLARS,
    RADAR_RADIUS,
    DifficultyConfig,
)
from mirage.core.kinematics import resolve_pillar_collision
from mirage.core.simulation import (
    EpisodeResult,
    TelemetryFrame,
    denormalize_chromosome,
    simulate_episode,
)
from mirage.gui.arena_view import CyberArenaRenderer


def run_spectator_mode(
    chromosome: Optional[np.ndarray] = None,
    difficulty: int = 2,
    seed: Optional[int] = None,
):
    """
    Executa a arena em modo espectador, exibindo a IA autônoma em ação.
    """
    if chromosome is None:
        # Cromossomo Balanceado canônico que obedece ao orçamento global 1.8
        chromosome = np.array([0.45, 0.45, 0.45, 0.45], dtype=np.float64)

    cfg: DifficultyConfig = DIFFICULTY_SETTINGS.get(difficulty, DIFFICULTY_SETTINGS[2])
    renderer = CyberArenaRenderer(title=f"Mirage — Modo Espectador [IA Campeã | Dificuldade {cfg.name}]")

    running = True
    current_seed = seed or int(time.time() * 1000) % 100000

    while running:
        # Gera o episódio com telemetria síncrona gravada
        res, telemetry = simulate_episode(
            chromosome=chromosome,
            difficulty=difficulty,
            record_telemetry=True,
            seed=current_seed,
        )

        frame_idx = 0
        total_frames = len(telemetry)
        paused = False

        while frame_idx < total_frames and running:
            # Tratamento de Eventos de Entrada
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                    break
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
                        break
                    elif event.key == pygame.K_SPACE:
                        paused = not paused
                    elif event.key == pygame.K_r:
                        current_seed = (current_seed + 1) % 100000
                        frame_idx = total_frames  # Força reinício imediato

            if not running:
                break

            if paused:
                renderer.draw_background()
                renderer.draw_pillars()
                f = telemetry[min(frame_idx, total_frames - 1)]
                renderer.draw_projectiles(f.enemy_projectiles, f.npc_projectiles)
                renderer.draw_npc(f.npc_pos, f.npc_vel, f.npc_hp, f.npc_max_hp, f.evade_force, f.lead_target)
                renderer.draw_hud(
                    f.time,
                    MAX_EPISODE_TIME,
                    f.npc_hp,
                    f.npc_max_hp,
                    f.dodges,
                    f.collisions,
                    f.damage_inflicted,
                    cfg.name,
                    mode_label="ESPECTADOR (PAUSADO)",
                    fps=renderer.clock.get_fps(),
                )
                renderer.flip(50)
                continue

            frame: TelemetryFrame = telemetry[frame_idx]

            # Renderização de camadas
            renderer.draw_background()
            renderer.draw_pillars()
            renderer.draw_projectiles(frame.enemy_projectiles, frame.npc_projectiles)
            renderer.draw_npc(
                pos=frame.npc_pos,
                vel=frame.npc_vel,
                hp=frame.npc_hp,
                max_hp=frame.npc_max_hp,
                evade_force=frame.evade_force,
                lead_target=frame.lead_target,
            )
            renderer.draw_hud(
                time_curr=frame.time,
                time_max=MAX_EPISODE_TIME,
                hp=frame.npc_hp,
                max_hp=frame.npc_max_hp,
                dodges=frame.dodges,
                collisions=frame.collisions,
                damage_inflicted=frame.damage_inflicted,
                difficulty_name=cfg.name,
                mode_label="ESPECTADOR (IA)",
                fps=renderer.clock.get_fps(),
            )

            renderer.flip(50)
            frame_idx += 1

        # Pequena pausa ao fim do episódio antes de recomeçar
        if running:
            time.sleep(1.0)
            current_seed = (current_seed + 1) % 100000

    renderer.close()


def run_playable_human_mode(
    difficulty: int = 2,
    chromosome: Optional[np.ndarray] = None,
):
    """
    Executa a arena em modo interativo jogável com controle humano (WASD / Mouse).
    """
    if chromosome is None:
        chromosome = np.array([0.5, 0.4, 0.4, 0.5], dtype=np.float64)

    cfg: DifficultyConfig = DIFFICULTY_SETTINGS.get(difficulty, DIFFICULTY_SETTINGS[2])
    hp_max, attack, attack_speed, max_speed = denormalize_chromosome(chromosome)

    renderer = CyberArenaRenderer(title=f"Mirage — Modo Humano [Você no Controle | Dificuldade {cfg.name}]")

    running = True

    while running:
        hp = hp_max
        pos = np.array([0.0, 0.0], dtype=np.float64)
        vel = np.array([0.0, 0.0], dtype=np.float64)
        enemy_projs: List[List[float]] = []
        player_projs: List[List[float]] = []

        dodges = 0
        collisions = 0
        damage_inflicted = 0.0
        survival_time = 0.0
        last_shot_time = -1.0
        shot_interval = 1.0 / max(0.1, attack_speed)

        t_sim = 0.0
        paused = False
        game_over = False

        while t_sim < MAX_EPISODE_TIME and running:
            # 1. Trata Eventos de Teclado e Mouse
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                    break
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
                        break
                    elif event.key == pygame.K_SPACE and not game_over:
                        paused = not paused
                    elif event.key == pygame.K_r:
                        # Reinicia partida
                        t_sim = MAX_EPISODE_TIME + 1.0

            if not running:
                break

            if paused:
                renderer.draw_background()
                renderer.draw_pillars()
                renderer.draw_projectiles(
                    np.array(enemy_projs) if len(enemy_projs) > 0 else np.empty((0, 5)),
                    np.array(player_projs) if len(player_projs) > 0 else np.empty((0, 5)),
                )
                renderer.draw_npc(pos, vel, hp, hp_max, is_player=True)
                renderer.draw_hud(
                    t_sim,
                    MAX_EPISODE_TIME,
                    hp,
                    hp_max,
                    dodges,
                    collisions,
                    damage_inflicted,
                    cfg.name,
                    mode_label="HUMANO (PAUSADO)",
                    fps=renderer.clock.get_fps(),
                )
                renderer.flip(50)
                continue

            if hp <= 0.0:
                game_over = True

            # 2. Leitura Contínua das Teclas (WASD / Setas)
            if not game_over:
                keys = pygame.key.get_pressed()
                input_dir = np.array([0.0, 0.0], dtype=np.float64)
                if keys[pygame.K_w] or keys[pygame.K_UP]:
                    input_dir[1] += 1.0
                if keys[pygame.K_s] or keys[pygame.K_DOWN]:
                    input_dir[1] -= 1.0
                if keys[pygame.K_a] or keys[pygame.K_LEFT]:
                    input_dir[0] -= 1.0
                if keys[pygame.K_d] or keys[pygame.K_RIGHT]:
                    input_dir[0] += 1.0

                norm_in = np.linalg.norm(input_dir)
                if norm_in > 1e-4:
                    vel = (input_dir / norm_in) * max_speed
                else:
                    vel = vel * 0.85  # Atrito

                # Atualiza posição e resolve pilares
                pos += vel * DT_PHYSICS
                pos = resolve_pillar_collision(pos, NPC_RADIUS, PILLARS, PILLAR_RADIUS)
                pos[0] = np.clip(pos[0], -ARENA_BOUNDS, ARENA_BOUNDS)
                pos[1] = np.clip(pos[1], -ARENA_BOUNDS, ARENA_BOUNDS)

                # Disparo Contínuo do Jogador em direção ao mouse
                if (t_sim - last_shot_time) >= shot_interval:
                    mx, my = pygame.mouse.get_pos()
                    # Converte mouse para mundo
                    target_world = np.array([
                        (mx - renderer.center_x) / renderer.scale,
                        -(my - renderer.center_y) / renderer.scale,
                    ])
                    shoot_dir = target_world - pos
                    s_dist = np.linalg.norm(shoot_dir)
                    if s_dist > 1e-4:
                        shoot_dir /= s_dist
                        s_vel = shoot_dir * NPC_BULLET_SPEED
                        player_projs.append([pos[0], pos[1], s_vel[0], s_vel[1], 1.0])
                        last_shot_time = t_sim

            # 3. Geração de Projéteis Inimigos (Bullet Hell)
            t_progress = t_sim / MAX_EPISODE_TIME
            current_spawn_rate = max(
                cfg.spawn_rate_final,
                cfg.spawn_rate_init - t_progress * (cfg.spawn_rate_init - cfg.spawn_rate_final),
            )

            if (t_sim % current_spawn_rate) < DT_PHYSICS and not game_over:
                angle = np.random.uniform(0, 2 * math.pi)
                spawn_pos = np.array([18.0 * math.cos(angle), 18.0 * math.sin(angle)], dtype=np.float64)
                aim_dir = pos - spawn_pos
                aim_dist = np.linalg.norm(aim_dir)
                if aim_dist > 1e-4:
                    aim_dir /= aim_dist
                noise = (np.random.rand(2) - 0.5) * cfg.noise_scale
                p_vel = (aim_dir + noise) * cfg.proj_speed
                enemy_projs.append([spawn_pos[0], spawn_pos[1], p_vel[0], p_vel[1], 1.0, 0.0])

            # Padrão Cone Shotgun
            if cfg.has_shotgun and t_sim > 1.0 and (t_sim % 2.8) < DT_PHYSICS and not game_over:
                sg_angle = np.random.uniform(0, 2 * math.pi)
                sg_spawn = np.array([18.0 * math.cos(sg_angle), 18.0 * math.sin(sg_angle)], dtype=np.float64)
                sg_aim = pos - sg_spawn
                sg_dist = np.linalg.norm(sg_aim)
                if sg_dist > 1e-4:
                    sg_aim /= sg_dist
                for spread in (-0.22, 0.0, 0.22):
                    cs, ss = math.cos(spread), math.sin(spread)
                    rot_v = np.array([sg_aim[0] * cs - sg_aim[1] * ss, sg_aim[0] * ss + sg_aim[1] * cs])
                    sg_vel = rot_v * (cfg.proj_speed * 1.05)
                    enemy_projs.append([sg_spawn[0], sg_spawn[1], sg_vel[0], sg_vel[1], 1.0, 0.0])

            # 4. Atualização e Intercepção Física de Projéteis
            for b in player_projs:
                if b[4] > 0.5:
                    b[0] += b[2] * DT_PHYSICS
                    b[1] += b[3] * DT_PHYSICS
                    if abs(b[0]) > 20.0 or abs(b[1]) > 20.0:
                        b[4] = 0.0

            for p in enemy_projs:
                if p[4] > 0.5:
                    p[0] += p[2] * DT_PHYSICS
                    p[1] += p[3] * DT_PHYSICS
                    dist_p = np.linalg.norm(np.array([p[0], p[1]]) - pos)

                    # Colisão com Jogador
                    if dist_p < NPC_RADIUS and not game_over:
                        p[4] = 0.0
                        collisions += 1
                        hp -= 25.0
                    elif dist_p < RADAR_RADIUS and p[5] == 0.0:
                        p[5] = 1.0
                    elif dist_p >= RADAR_RADIUS and p[5] == 1.0:
                        p[5] = 2.0
                        dodges += 1

                    if abs(p[0]) > 20.0 or abs(p[1]) > 20.0:
                        p[4] = 0.0

            # 5. Renderização dos Elementos
            renderer.draw_background()
            renderer.draw_pillars()
            renderer.draw_projectiles(
                np.array([p[:5] for p in enemy_projs if p[4] > 0.5])
                if len(enemy_projs) > 0
                else np.empty((0, 5)),
                np.array([b[:5] for b in player_projs if b[4] > 0.5])
                if len(player_projs) > 0
                else np.empty((0, 5)),
            )
            renderer.draw_npc(pos, vel, hp, hp_max, is_player=True)

            mode_txt = "VOCÊ VENCEU!" if (t_sim >= MAX_EPISODE_TIME and hp > 0) else (
                "DESTRUÍDO!" if game_over else "VOCÊ NO CONTROLE (WASD)"
            )
            renderer.draw_hud(
                t_sim,
                MAX_EPISODE_TIME,
                max(0.0, hp),
                hp_max,
                dodges,
                collisions,
                damage_inflicted,
                cfg.name,
                mode_label=mode_txt,
                fps=renderer.clock.get_fps(),
            )

            renderer.flip(50)
            t_sim += DT_PHYSICS

            if game_over:
                # Mantém tela visível um pouco
                time.sleep(1.5)
                break

    renderer.close()

