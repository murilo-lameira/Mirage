"""
Test script to validate plotting functions and arena schematic generation.
"""
import math
from pathlib import Path
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
import pandas as pd
from scipy import stats

def create_arena_schematic(output_dirs):
    plt.rcParams.update({
        "font.family": "sans-serif",
        "font.size": 10,
        "axes.titlesize": 12,
        "axes.labelsize": 10,
        "figure.dpi": 300
    })
    fig, ax = plt.subplots(figsize=(7.5, 7.5), dpi=300)

    # 1. Arena Boundaries [-20, 20] x [-20, 20]
    arena_rect = patches.Rectangle(
        (-20, -20), 40, 40,
        fill=True, facecolor="#f8fafc", edgecolor="#1e293b", linewidth=2.0, linestyle="-"
    )
    ax.add_patch(arena_rect)

    # 2. Coordinate axes / gridlines subtis
    ax.axhline(0, color="#cbd5e1", linestyle="--", linewidth=0.8, alpha=0.7)
    ax.axvline(0, color="#cbd5e1", linestyle="--", linewidth=0.8, alpha=0.7)

    # 3. Círculo perimetral de disparo inimigo (r = 18 m)
    perimeter = patches.Circle(
        (0, 0), 18.0,
        fill=False, edgecolor="#e11d48", linewidth=1.8, linestyle="--", alpha=0.85,
        label=r"Perímetro Inimigo ($r = 18\,\text{m}$)"
    )
    ax.add_patch(perimeter)

    # 4. Pilares cilíndricos (R_pillar = 1.3 m) em (±8, ±8) m
    pillars = [(-8.0, -8.0), (8.0, -8.0), (-8.0, 8.0), (8.0, 8.0)]
    for i, (px, py) in enumerate(pillars):
        pil = patches.Circle(
            (px, py), 1.3,
            facecolor="#64748b", edgecolor="#0f172a", linewidth=1.5,
            label=r"Pilares ($R_{\text{pillar}} = 1{,}3\,\text{m}$)" if i == 0 else ""
        )
        ax.add_patch(pil)
        # Rótulo de coordenada de um pilar
        if i == 3: # (8, 8)
            ax.text(px + 1.6, py + 0.2, r"$(+8, +8)\,\text{m}$", fontsize=8.5, color="#334155", weight="bold")

    # 5. NPC no interior da arena
    # Posicionado estrategicamente em (1.5, -1.0)
    npc_x, npc_y = 1.5, -1.0

    # Raio de detecção periférica (R_radar = 4.0 m)
    radar_circle = patches.Circle(
        (npc_x, npc_y), 4.0,
        fill=True, facecolor="#3b82f6", edgecolor="#1d4ed8",
        linewidth=1.5, linestyle=":", alpha=0.12,
        label=r"Radar Periférico ($R_{\text{radar}} = 4{,}0\,\text{m}$)"
    )
    radar_edge = patches.Circle(
        (npc_x, npc_y), 4.0,
        fill=False, edgecolor="#2563eb", linewidth=1.5, linestyle=":", alpha=0.85
    )
    ax.add_patch(radar_circle)
    ax.add_patch(radar_edge)

    # Hitbox do NPC (r_hit = 1.0 m)
    npc_hitbox = patches.Circle(
        (npc_x, npc_y), 1.0,
        facecolor="#2563eb", edgecolor="#1e3a8a", linewidth=2.0, alpha=0.9,
        label=r"NPC ($r_{\text{hit}} = 1{,}0\,\text{m}$)"
    )
    ax.add_patch(npc_hitbox)

    # Marcador central do NPC
    ax.plot(npc_x, npc_y, "o", color="#ffffff", markersize=4)

    # 6. Projétil Ameaçador e Balística
    # Ponto de disparo no perímetro (spawn em r=18m, angulo ~ 50 deg: (11.57, 13.79))
    proj_spawn = (11.57, 13.79)
    # Posição atual do projétil dentro do radar do NPC
    proj_curr = (4.8, 3.5)
    # Direção de movimento do projétil ameaçando o NPC
    # Trajetória projetada passa próximo ao NPC: CPA em (2.6, 0.4)
    cpa_x, cpa_y = 2.6, 0.4

    # Trajetória do projétil (reta passando por spawn, proj_curr, CPA)
    # vetor diretor unitário: (cpa - proj_curr) normalizado
    dx = cpa_x - proj_curr[0]
    dy = cpa_y - proj_curr[1]
    dist = math.hypot(dx, dy)
    ux, uy = dx / dist, dy / dist

    # Linha tracejada da trajetória projetada
    t_line_start = proj_spawn
    t_line_end = (cpa_x + ux * 4.5, cpa_y + uy * 4.5)
    ax.plot(
        [t_line_start[0], t_line_end[0]], [t_line_start[1], t_line_end[1]],
        color="#dc2626", linestyle="--", linewidth=1.5, alpha=0.7,
        label=r"Trajetória Projetada do Projétil"
    )

    # Projétil atual
    proj_marker = patches.Circle(
        proj_curr, 0.4,
        facecolor="#ef4444", edgecolor="#991b1b", linewidth=1.5,
        label=r"Projétil Inimigo ($\mathbf{v}_p$)"
    )
    ax.add_patch(proj_marker)

    # Vetor velocidade do projétil v_p
    ax.annotate(
        "", xy=(proj_curr[0] + ux * 2.2, proj_curr[1] + uy * 2.2),
        xytext=proj_curr,
        arrowprops=dict(arrowstyle="->", color="#b91c1c", lw=2.2, mutation_scale=15)
    )
    ax.text(proj_curr[0] + 0.5, proj_curr[1] + 0.6, r"$\mathbf{v}_p$", fontsize=11, color="#b91c1c", weight="bold")

    # Ponto de Maior Aproximação (CPA)
    ax.plot(cpa_x, cpa_y, "x", color="#7f1d1d", markersize=10, markeredgewidth=2.5, label=r"CPA ($\mathbf{p}_{\text{cpa}}$)")
    ax.text(cpa_x + 0.5, cpa_y + 0.4, r"$\text{CPA}$", fontsize=10.5, color="#7f1d1d", weight="bold")

    # Linha de distância d_cpa entre NPC e CPA
    ax.plot([npc_x, cpa_x], [npc_y, cpa_y], color="#475569", linestyle=":", linewidth=1.5)
    ax.text((npc_x + cpa_x)/2 - 0.9, (npc_y + cpa_y)/2 + 0.3, r"$d_{\text{cpa}}$", fontsize=9.5, color="#334155", weight="bold")

    # 7. Vetor de Força de Evasão F_ev resultante
    # Direção de repulsão perpendicular à trajetória e apontando para longe do CPA
    # Vetor de evasão: de (cpa -> npc) empurrando o NPC
    ev_dx = npc_x - cpa_x
    ev_dy = npc_y - cpa_y
    ev_dist = math.hypot(ev_dx, ev_dy)
    ev_ux, ev_uy = ev_dx / ev_dist, ev_dy / ev_dist

    ev_len = 3.5
    ax.annotate(
        "", xy=(npc_x + ev_ux * ev_len, npc_y + ev_uy * ev_len),
        xytext=(npc_x, npc_y),
        arrowprops=dict(arrowstyle="->", color="#059669", lw=2.8, mutation_scale=18)
    )
    ax.text(npc_x + ev_ux * ev_len - 1.6, npc_y + ev_uy * ev_len - 0.8, r"$\mathbf{F}_{\text{ev}}$", fontsize=12, color="#047857", weight="bold")

    # 8. Linha de Visada Preditiva (Lead-Aiming)
    # NPC disparando de volta predizendo a posição futura de um alvo perimetral em (-12, 13.4)
    target_lead = (-10.5, 12.0)
    ax.annotate(
        "", xy=target_lead, xytext=(npc_x, npc_y),
        arrowprops=dict(arrowstyle="->", color="#d97706", lw=1.8, linestyle="--", mutation_scale=14)
    )
    ax.text((npc_x + target_lead[0])/2 - 3.2, (npc_y + target_lead[1])/2 + 0.8, r"$\text{Lead-Aiming}$", fontsize=10, color="#b45309", weight="bold", rotation=38)

    # 9. Configurações de eixos, títulos e limites
    ax.set_xlim(-22.5, 22.5)
    ax.set_ylim(-22.5, 22.5)
    ax.set_aspect("equal")
    ax.set_xlabel("Eixo X (metros)", fontsize=11, weight="bold")
    ax.set_ylabel("Eixo Y (metros)", fontsize=11, weight="bold")
    ax.set_title("Diagrama Esquemático da Arena 2D de Combate e Evasão Cinemática", fontsize=12.5, weight="bold", pad=12)

    # Legenda fora da área crítica
    ax.legend(loc="lower left", framealpha=0.92, edgecolor="#cbd5e1", fontsize=8.5, ncol=2)

    plt.tight_layout()

    for out_dir in output_dirs:
        p = Path(out_dir)
        p.mkdir(parents=True, exist_ok=True)
        fig.savefig(p / "fig_diagrama_arena.png", dpi=300)
        fig.savefig(p / "fig_diagrama_arena.pdf")

    plt.close(fig)
    print("Arena schematic successfully generated in all output dirs.")

create_arena_schematic(["paper/figuras", "data/graficos"])
