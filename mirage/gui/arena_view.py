"""
=============================================================================
PROJETO MIRAGE — RENDERIZADOR CYBERPUNK DA ARENA 2D (PYGAME-CE)
=============================================================================
Apresentação visual com shaders estéticos em 2D:
- Grade cibernética holográfica e radar de escaneamento militar.
- Pilares de força com anéis de campo de energia.
- Vetores de direção de Steering (Reynolds) e mira balística Lead-Aiming.
- Projéteis com efeitos de rastro (glow).
- Painel HUD translúcido com telemetria em tempo real.
=============================================================================
"""

import math
from typing import List, Optional, Tuple
import numpy as np
import pygame

from mirage.config import (
    ARENA_BOUNDS,
    COLOR_BG_SPACE,
    COLOR_ENEMY_BULLET,
    COLOR_EVADE_VECTOR,
    COLOR_GRID,
    COLOR_LEAD_RAY,
    COLOR_NPC,
    COLOR_NPC_BULLET,
    COLOR_NPC_CORE,
    COLOR_PILLAR,
    COLOR_PILLAR_GLOW,
    COLOR_RADAR_CIRCLE,
    COLOR_TEXT_HUD,
    NPC_RADIUS,
    PILLAR_RADIUS,
    PILLARS,
    RADAR_RADIUS,
)


class CyberArenaRenderer:
    """Renderizador gráfico de alta fidelidade para combate 2D em Pygame-CE."""

    def __init__(self, width: int = 900, height: int = 900, title: str = "Mirage — Cyber Arena"):
        self.width = width
        self.height = height
        self.title = title
        self.center_x = width // 2
        self.center_y = height // 2
        # Escala: mapeia [-19, 19] metros para o espaço de pixels
        self.scale = (min(width, height) - 80) / (2.0 * 19.0)

        pygame.init()
        pygame.display.set_caption(self.title)
        self.screen = pygame.display.set_mode((self.width, self.height))
        self.clock = pygame.time.Clock()

        # Fontes de interface
        self.font_large = pygame.font.SysFont("consolas", 20, bold=True)
        self.font_medium = pygame.font.SysFont("consolas", 14, bold=True)
        self.font_small = pygame.font.SysFont("consolas", 12)

        # Superfícies pré-calculadas para blending aditivo e rastro
        self.radar_surface = pygame.Surface((self.width, self.height), pygame.SRCALPHA)
        self.scan_angle = 0.0

    def world_to_screen(self, pos: np.ndarray) -> Tuple[int, int]:
        """Converte coordenadas físicas do mundo (m) para coordenadas de tela (pixels)."""
        sx = int(self.center_x + pos[0] * self.scale)
        sy = int(self.center_y - pos[1] * self.scale)  # Y invertido
        return sx, sy

    def draw_background(self):
        """Renderiza a arena com estética cibernética, grade e radar holográfico."""
        self.screen.fill(COLOR_BG_SPACE)

        # Grade cibernética sutil
        grid_spacing_meters = 2.0
        grid_step = int(grid_spacing_meters * self.scale)

        for x in range(self.center_x % grid_step, self.width, grid_step):
            pygame.draw.line(self.screen, COLOR_GRID, (x, 0), (x, self.height), 1)
        for y in range(self.center_y % grid_step, self.height, grid_step):
            pygame.draw.line(self.screen, COLOR_GRID, (0, y), (self.width, y), 1)

        # Fronteira física da arena (limite -18m a 18m)
        top_left = self.world_to_screen(np.array([-ARENA_BOUNDS, ARENA_BOUNDS]))
        box_size = int(2.0 * ARENA_BOUNDS * self.scale)
        pygame.draw.rect(
            self.screen,
            (35, 55, 85),
            (top_left[0], top_left[1], box_size, box_size),
            width=2,
            border_radius=8,
        )

        # Cruz central
        pygame.draw.line(
            self.screen,
            (40, 60, 95),
            (self.center_x - 15, self.center_y),
            (self.center_x + 15, self.center_y),
            1,
        )
        pygame.draw.line(
            self.screen,
            (40, 60, 95),
            (self.center_x, self.center_y - 15),
            (self.center_x, self.center_y + 15),
            1,
        )

        # Anel de radar militar em rotação suave
        self.radar_surface.fill((0, 0, 0, 0))
        self.scan_angle = (self.scan_angle + 0.03) % (2.0 * math.pi)
        radar_len = int(ARENA_BOUNDS * self.scale)
        sweep_end = (
            int(self.center_x + radar_len * math.cos(self.scan_angle)),
            int(self.center_y - radar_len * math.sin(self.scan_angle)),
        )
        pygame.draw.line(self.radar_surface, (0, 180, 255, 35), (self.center_x, self.center_y), sweep_end, 2)
        pygame.draw.circle(
            self.radar_surface,
            (0, 160, 240, 25),
            (self.center_x, self.center_y),
            int(ARENA_BOUNDS * self.scale),
            1,
        )
        self.screen.blit(self.radar_surface, (0, 0))

    def draw_pillars(self):
        """Renderiza os 4 pilares físicos com anéis de campo de força."""
        for p in PILLARS:
            px, py = self.world_to_screen(p)
            r_px = int(PILLAR_RADIUS * self.scale)

            # Anel externo de escudo de força
            pygame.draw.circle(self.screen, (0, 150, 220), (px, py), r_px + 4, width=1)
            # Corpo sólido do pilar
            pygame.draw.circle(self.screen, COLOR_PILLAR, (px, py), r_px)
            # Núcleo metálico
            pygame.draw.circle(self.screen, (70, 85, 115), (px, py), max(2, r_px - 4))

    def draw_npc(
        self,
        pos: np.ndarray,
        vel: np.ndarray,
        hp: float,
        max_hp: float,
        evade_force: Optional[np.ndarray] = None,
        lead_target: Optional[np.ndarray] = None,
        is_player: bool = False,
    ):
        """Renderiza o NPC/Jogador com radar holográfico, vetores e barra de vida."""
        sx, sy = self.world_to_screen(pos)
        r_px = int(NPC_RADIUS * self.scale)
        radar_px = int(RADAR_RADIUS * self.scale)

        # 1. Anel de Radar de Proximidade (CPA)
        pygame.draw.circle(self.screen, (0, 220, 255, 40), (sx, sy), radar_px, width=1)

        # 2. Vetor de Evasão de Reynolds (Seta Verde Neon)
        if evade_force is not None and np.linalg.norm(evade_force) > 0.01:
            ev_norm = evade_force / np.linalg.norm(evade_force)
            end_world = pos + ev_norm * 2.2
            ex, ey = self.world_to_screen(end_world)
            pygame.draw.line(self.screen, COLOR_EVADE_VECTOR, (sx, sy), (ex, ey), 3)
            pygame.draw.circle(self.screen, COLOR_EVADE_VECTOR, (ex, ey), 4)

        # 3. Raio de Mira Balística Lead-Aiming (Raio Âmbar/Dourado)
        if lead_target is not None:
            lx, ly = self.world_to_screen(lead_target)
            pygame.draw.line(self.screen, COLOR_LEAD_RAY, (sx, sy), (lx, ly), 1)
            pygame.draw.circle(self.screen, COLOR_LEAD_RAY, (lx, ly), 5, width=1)

        # 4. Chassi do NPC/Player (Triângulo Direcional Dinâmico)
        speed = float(np.linalg.norm(vel))
        if speed > 0.1:
            heading = math.atan2(vel[1], vel[0])
        else:
            heading = 0.0

        p1 = (int(sx + (r_px + 5) * math.cos(heading)), int(sy - (r_px + 5) * math.sin(heading)))
        p2 = (
            int(sx + r_px * math.cos(heading + 2.5)),
            int(sy - r_px * math.sin(heading + 2.5)),
        )
        p3 = (
            int(sx + r_px * math.cos(heading - 2.5)),
            int(sy - r_px * math.sin(heading - 2.5)),
        )

        main_color = (0, 255, 170) if is_player else COLOR_NPC
        pygame.draw.polygon(self.screen, main_color, [p1, p2, p3])
        pygame.draw.polygon(self.screen, (255, 255, 255), [p1, p2, p3], width=2)
        pygame.draw.circle(self.screen, COLOR_NPC_CORE, (sx, sy), max(2, r_px // 3))

        # 5. Barra de HP flutuante sobre a nave
        bar_w = 40
        bar_h = 5
        bar_x = sx - bar_w // 2
        bar_y = sy - r_px - 14
        pct = max(0.0, min(1.0, hp / max(1.0, max_hp)))

        pygame.draw.rect(self.screen, (40, 40, 50), (bar_x, bar_y, bar_w, bar_h))
        hp_color = (0, 255, 120) if pct > 0.5 else ((255, 200, 0) if pct > 0.25 else (255, 50, 50))
        pygame.draw.rect(self.screen, hp_color, (bar_x, bar_y, int(bar_w * pct), bar_h))
        pygame.draw.rect(self.screen, (150, 160, 180), (bar_x, bar_y, bar_w, bar_h), 1)

    def draw_projectiles(self, enemy_projs: np.ndarray, npc_projs: np.ndarray):
        """Renderiza projéteis de ambas as facções com núcleos brilhantes."""
        # Projéteis Inimigos (Plasma Vermelho/Laranja Danmaku)
        for p in enemy_projs:
            if len(p) >= 5 and p[4] > 0.5:
                px, py = self.world_to_screen(np.array([p[0], p[1]]))
                pygame.draw.circle(self.screen, (255, 80, 40), (px, py), 4)
                pygame.draw.circle(self.screen, (255, 230, 150), (px, py), 2)

        # Projéteis do NPC / Jogador (Energia Ciano / Raio Laser)
        for b in npc_projs:
            if len(b) >= 5 and b[4] > 0.5:
                bx, by = self.world_to_screen(np.array([b[0], b[1]]))
                pygame.draw.circle(self.screen, COLOR_NPC_BULLET, (bx, by), 5)
                pygame.draw.circle(self.screen, (255, 255, 255), (bx, by), 2)

    def draw_hud(
        self,
        time_curr: float,
        time_max: float,
        hp: float,
        max_hp: float,
        dodges: int,
        collisions: int,
        damage_inflicted: float,
        difficulty_name: str,
        mode_label: str = "MODO ESPECTADOR (IA)",
        fps: float = 50.0,
    ):
        """Renderiza painel translúcido de telemetria científica no topo/cantos."""
        # Painel Superior Translúcido
        hud_surface = pygame.Surface((self.width - 40, 56), pygame.SRCALPHA)
        hud_surface.fill((10, 18, 30, 210))
        pygame.draw.rect(hud_surface, (0, 180, 240, 120), hud_surface.get_rect(), width=1, border_radius=6)
        self.screen.blit(hud_surface, (20, 14))

        # Texto do Modo e Dificuldade
        title_text = self.font_large.render(f"MIRAGE :: {mode_label}", True, (0, 220, 255))
        diff_text = self.font_medium.render(f"Dificuldade: {difficulty_name}", True, (255, 200, 50))
        self.screen.blit(title_text, (35, 20))
        self.screen.blit(diff_text, (35, 42))

        # Métricas em tempo real
        time_str = f"Tempo: {time_curr:>4.1f}s / {time_max:.0f}s"
        dodges_str = f"Evasões CPA: {dodges:>2d}"
        coll_str = f"Colisões: {collisions:>2d}"
        hp_str = f"HP: {hp:>5.1f} / {max_hp:.1f}"

        txt_time = self.font_medium.render(time_str, True, COLOR_TEXT_HUD)
        txt_dodges = self.font_medium.render(dodges_str, True, (80, 255, 160))
        txt_coll = self.font_medium.render(coll_str, True, (255, 100, 100))
        txt_hp = self.font_medium.render(hp_str, True, (0, 230, 255))

        self.screen.blit(txt_time, (340, 22))
        self.screen.blit(txt_hp, (340, 42))
        self.screen.blit(txt_dodges, (560, 22))
        self.screen.blit(txt_coll, (560, 42))

        # FPS
        txt_fps = self.font_small.render(f"FPS: {fps:.0f}", True, (120, 150, 180))
        self.screen.blit(txt_fps, (self.width - 100, 22))

        # Rodapé com Comandos
        cmd_text = self.font_small.render(
            "[ESPAÇO] Pausar/Continuar | [R] Reiniciar | [ESC] Voltar ao Menu",
            True,
            (140, 165, 195),
        )
        self.screen.blit(cmd_text, (25, self.height - 25))

    def flip(self, target_fps: int = 50):
        """Atualiza a tela e sincroniza a taxa de quadros."""
        pygame.display.flip()
        self.clock.tick(target_fps)

    def close(self):
        """Encerra a instância do Pygame."""
        pygame.quit()

