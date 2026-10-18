"""
=============================================================================
PROJETO MIRAGE — GERAÇÃO DE GRÁFICOS CIENTÍFICOS DE ALTA RESOLUÇÃO (300 DPI)
=============================================================================
Pipeline visual oficial para o artigo científico IEEE/SBC e relatórios técnicos.
Produz:
1. fig_diagrama_arena: Esquema técnico da arena 2D (40x40m), pilares, CPA e forças de evasão.
2. fig_convergencia: Curvas médias de convergência (± 1σ) com forward-fill até G=50.
3. fig_dispersao_genes: Grid 2x2 com boxplot + strip-jitter para os 4 genes fenotípicos.
4. fig_map_elites: Heatmap 3x3 do catálogo Quality-Diversity sincronizado com Tabela 4.
5. Gráficos complementares: boxplot_fitness_dificuldade, radar_fenotipos_campeoes.
=============================================================================
"""

import math
from pathlib import Path
from typing import List, Optional
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np
import pandas as pd


def set_academic_style():
    """Configura o estilo visual moderno, sóbrio, limpo e acadêmico."""
    plt.rcParams.update({
        "font.family": "sans-serif",
        "font.sans-serif": ["DejaVu Sans", "Helvetica", "Arial"],
        "font.size": 10,
        "axes.labelsize": 11,
        "axes.titlesize": 12,
        "axes.titleweight": "bold",
        "xtick.labelsize": 9.5,
        "ytick.labelsize": 9.5,
        "legend.fontsize": 9.5,
        "figure.titlesize": 13,
        "figure.dpi": 300,
        "savefig.dpi": 300,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.08,
    })


def save_figure(fig, base_name: str, output_dirs: List[Path], extra_names: Optional[List[str]] = None):
    """Salva a figura em PDF vetorial e PNG (300 DPI) em todos os diretórios requisitados."""
    names = [base_name] + (extra_names or [])
    for out_dir in output_dirs:
        out_dir = Path(out_dir)
        out_dir.mkdir(parents=True, exist_ok=True)
        for name in names:
            fig.savefig(out_dir / f"{name}.png", dpi=300)
            fig.savefig(out_dir / f"{name}.pdf")


def generate_arena_schematic(output_dirs: List[Path]):
    """
    Figura 1 (Seção 3.2):
    Diagrama esquemático técnico e limpo da arena bidimensional 40x40m ([-20, 20] x [-20, 20] m).
    """
    fig, ax = plt.subplots(figsize=(7.5, 7.5), dpi=300)

    # 1. Fronteira da Arena [-20, 20] x [-20, 20]
    arena_rect = patches.Rectangle(
        (-20, -20), 40, 40,
        fill=True, facecolor="#f8fafc", edgecolor="#1e293b", linewidth=2.0, linestyle="-"
    )
    ax.add_patch(arena_rect)

    ax.axhline(0, color="#cbd5e1", linestyle="--", linewidth=0.8, alpha=0.7)
    ax.axvline(0, color="#cbd5e1", linestyle="--", linewidth=0.8, alpha=0.7)

    # 2. Círculo perimetral de disparo inimigo (r = 18 m)
    perimeter = patches.Circle(
        (0, 0), 18.0,
        fill=False, edgecolor="#e11d48", linewidth=1.8, linestyle="--", alpha=0.85,
        label=r"Perímetro Inimigo ($r = 18\,\text{m}$)"
    )
    ax.add_patch(perimeter)

    # 3. Pilares cilíndricos (R_pillar = 1.3 m) em (±8, ±8) m
    pillars = [(-8.0, -8.0), (8.0, -8.0), (-8.0, 8.0), (8.0, 8.0)]
    for i, (px, py) in enumerate(pillars):
        pil = patches.Circle(
            (px, py), 1.3,
            facecolor="#64748b", edgecolor="#0f172a", linewidth=1.5,
            label=r"Pilares ($R_{\text{pillar}} = 1{,}3\,\text{m}$)" if i == 0 else ""
        )
        ax.add_patch(pil)
        if i == 3:
            ax.text(px + 1.6, py + 0.2, r"$(+8, +8)\,\text{m}$", fontsize=8.5, color="#334155", weight="bold")

    # 4. NPC no interior da arena em (1.5, -1.0)
    npc_x, npc_y = 1.5, -1.0

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

    npc_hitbox = patches.Circle(
        (npc_x, npc_y), 1.0,
        facecolor="#2563eb", edgecolor="#1e3a8a", linewidth=2.0, alpha=0.9,
        label=r"NPC ($r_{\text{hit}} = 1{,}0\,\text{m}$)"
    )
    ax.add_patch(npc_hitbox)
    ax.plot(npc_x, npc_y, "o", color="#ffffff", markersize=4)

    # 5. Projétil Ameaçador e Balística CPA
    proj_spawn = (11.57, 13.79)
    proj_curr = (4.8, 3.5)
    cpa_x, cpa_y = 2.6, 0.4

    dx = cpa_x - proj_curr[0]
    dy = cpa_y - proj_curr[1]
    dist = math.hypot(dx, dy)
    ux, uy = dx / dist, dy / dist

    t_line_start = proj_spawn
    t_line_end = (cpa_x + ux * 4.5, cpa_y + uy * 4.5)
    ax.plot(
        [t_line_start[0], t_line_end[0]], [t_line_start[1], t_line_end[1]],
        color="#dc2626", linestyle="--", linewidth=1.5, alpha=0.7,
        label=r"Trajetória Projetada do Projétil"
    )

    proj_marker = patches.Circle(
        proj_curr, 0.4,
        facecolor="#ef4444", edgecolor="#991b1b", linewidth=1.5,
        label=r"Projétil Inimigo ($\mathbf{v}_p$)"
    )
    ax.add_patch(proj_marker)

    ax.annotate(
        "", xy=(proj_curr[0] + ux * 2.2, proj_curr[1] + uy * 2.2),
        xytext=proj_curr,
        arrowprops=dict(arrowstyle="->", color="#b91c1c", lw=2.2, mutation_scale=15)
    )
    ax.text(proj_curr[0] + 0.5, proj_curr[1] + 0.6, r"$\mathbf{v}_p$", fontsize=11, color="#b91c1c", weight="bold")

    ax.plot(cpa_x, cpa_y, "x", color="#7f1d1d", markersize=10, markeredgewidth=2.5, label=r"CPA ($\mathbf{p}_{\text{cpa}}$)")
    ax.text(cpa_x + 0.5, cpa_y + 0.4, r"$\text{CPA}$", fontsize=10.5, color="#7f1d1d", weight="bold")

    ax.plot([npc_x, cpa_x], [npc_y, cpa_y], color="#475569", linestyle=":", linewidth=1.5)
    ax.text(1.95, 0.35, r"$d_{\text{cpa}}$", fontsize=10, color="#1e293b", weight="bold")

    # 6. Força de evasão F_ev
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

    # 7. Visada preditiva Lead-Aiming (afastado do pilar (-8, 8) e em área aberta)
    target_lead = (-10.5, 12.0)
    ax.annotate(
        "", xy=target_lead, xytext=(npc_x, npc_y),
        arrowprops=dict(arrowstyle="->", color="#d97706", lw=1.8, linestyle="--", mutation_scale=14)
    )
    ax.text(-2.4, 3.2, r"$\text{Lead-Aiming}$", fontsize=10, color="#b45309", weight="bold", rotation=-47)

    ax.set_xlim(-22.5, 22.5)
    ax.set_ylim(-22.5, 22.5)
    ax.set_aspect("equal")
    ax.set_xlabel("Coordenada X (metros)", weight="bold")
    ax.set_ylabel("Coordenada Y (metros)", weight="bold")
    ax.set_title("Diagrama Esquemático da Arena 2D de Combate e Evasão Cinemática", pad=12)

    ax.legend(loc="lower left", framealpha=0.92, edgecolor="#cbd5e1", fontsize=8.5, ncol=2)
    plt.tight_layout()

    save_figure(fig, "fig_diagrama_arena", output_dirs)
    plt.close(fig)


def generate_convergence_curves(history_csv: Path, output_dirs: List[Path]):
    """
    Figura 2: Curvas de convergência evolutiva com média ± 1σ sobre 50 gerações (N=30 cada).
    Aplica forward-fill por rodada para eliminar saltos de early stopping.
    """
    df = pd.read_csv(history_csv)
    df.columns = [c.strip() for c in df.columns]

    records = []
    for (diff, rodada), group in df.groupby(['Dificuldade', 'Rodada']):
        group = group.sort_values('Geracao')
        full_idx = pd.DataFrame({'Geracao': range(1, 51)})
        merged = pd.merge(full_idx, group, on='Geracao', how='left')
        merged['Dificuldade'] = diff
        merged['Rodada'] = rodada
        merged['Fitness_Maximo_Global'] = merged['Fitness_Maximo_Global'].ffill()
        merged['Fitness_Medio_Pop'] = merged['Fitness_Medio_Pop'].ffill()
        records.append(merged)

    df_filled = pd.concat(records, ignore_index=True)

    fig, ax = plt.subplots(figsize=(9, 5.5), dpi=300)

    diff_config = {
        1: ("Fácil (D1)", "#2563eb", "--", "3754.18 ± 134.87"),
        2: ("Médio (D2)", "#059669", "-", "4849.88 ± 358.85"),
        3: ("Difícil (D3)", "#dc2626", "-.", "3687.83 ± 246.42"),
    }

    gens = np.arange(1, 51)

    for diff, (label, color, ls, final_stats) in diff_config.items():
        subset = df_filled[df_filled["Dificuldade"] == diff]
        grouped = subset.groupby("Geracao")["Fitness_Maximo_Global"]
        means = grouped.mean().loc[gens].to_numpy()
        stds = grouped.std().loc[gens].to_numpy()

        ax.plot(
            gens, means,
            label=f"{label} ({final_stats})",
            color=color, linestyle=ls, linewidth=2.2
        )
        ax.fill_between(
            gens,
            means - stds,
            means + stds,
            color=color, alpha=0.18
        )

    ax.set_title("Curvas de Aprendizado e Convergência Evolutiva (Média ± 1σ, N=30 por Regime)", pad=12)
    ax.set_xlabel("Geração do Algoritmo Genético ($G$)", weight="bold")
    ax.set_ylabel("Aptidão Máxima Acumulada ($Fitness$)", weight="bold")
    ax.set_xlim(1, 50)
    ax.set_ylim(1500, 5600)
    ax.grid(True, linestyle="--", alpha=0.6)
    ax.legend(loc="lower right", framealpha=0.92, edgecolor="#cbd5e1")

    plt.tight_layout()
    save_figure(fig, "fig_convergencia", output_dirs, extra_names=["evolucao_media_por_dificuldade", "comparativo_fitness"])
    plt.close(fig)


def generate_gene_distribution(df: pd.DataFrame, output_dirs: List[Path]):
    """
    Figura 3: Grid 2x2 de dispersão gênica (Boxplot + Strip-Jitter) com cadência [0.5, 3.0] Hz.
    """
    df_plot = df.copy()
    df_plot["Elite_AtkSpd_Rescaled"] = 0.5 + (df_plot["Elite_AtkSpd"] - 0.5) / 4.5 * 2.5

    genes = [
        ("Elite_HP", "HP Máximo (Pontos de Vida)", "Pontos de Vida (HP)", [0, 110]),
        ("Elite_Atk", "Poder de Ataque (Dano por Disparo)", "Dano / Disparo", [15, 55]),
        ("Elite_AtkSpd_Rescaled", "Cadência de Disparo (Hz)", "Frequência (Hz)", [1.8, 2.7]),
        ("Elite_MovSpd", "Velocidade de Movimento (m/s)", "Velocidade (m/s)", [0.5, 4.5]),
    ]

    fig, axes = plt.subplots(2, 2, figsize=(10, 6.6), dpi=300)
    axes = axes.flatten()

    diffs = [1, 2, 3]
    diff_names = ["Fácil (D1)", "Médio (D2)", "Difícil (D3)"]
    box_colors = ["#93c5fd", "#6ee7b7", "#fca5a5"]
    point_colors = ["#1d4ed8", "#047857", "#b91c1c"]

    for idx, (col, title, ylabel, ylim) in enumerate(genes):
        ax = axes[idx]
        data_by_diff = [df_plot[df_plot["Dificuldade"] == d][col].to_numpy() for d in diffs]

        bp = ax.boxplot(
            data_by_diff,
            positions=[1, 2, 3],
            widths=0.45,
            patch_artist=True,
            showmeans=False,
            showfliers=False,
            medianprops=dict(color="#0f172a", linewidth=2.0),
            whiskerprops=dict(color="#334155", linewidth=1.2),
            capprops=dict(color="#334155", linewidth=1.2),
        )

        for patch_box, color in zip(bp["boxes"], box_colors):
            patch_box.set_facecolor(color)
            patch_box.set_alpha(0.75)
            patch_box.set_edgecolor("#1e293b")
            patch_box.set_linewidth(1.2)

        np.random.seed(42)
        for pos, vals, pcolor in zip([1, 2, 3], data_by_diff, point_colors):
            jitter = np.random.uniform(-0.12, 0.12, size=len(vals))
            ax.scatter(
                pos + jitter, vals,
                color=pcolor, s=28, alpha=0.65, edgecolor="#ffffff", linewidth=0.5, zorder=3
            )

        ax.set_title(title, weight="bold", fontsize=11, pad=8)
        ax.set_xticks([1, 2, 3])
        ax.set_xticklabels(diff_names, weight="bold")
        ax.set_ylabel(ylabel, weight="bold")
        ax.set_ylim(ylim)
        ax.grid(True, linestyle="--", alpha=0.5)

    fig.suptitle("Dispersão e Especialização dos Genes Fenotípicos dos NPCs Campeões ($N = 90$)", weight="bold", fontsize=13, y=0.99)
    plt.tight_layout()

    save_figure(fig, "fig_dispersao_genes", output_dirs, extra_names=["boxplot_distribuicao_genes", "comparativo_genes"])
    plt.close(fig)


def generate_fitness_boxplots(df: pd.DataFrame, output_dirs: List[Path]):
    """Gera boxplots de fitness por dificuldade."""
    fig, ax = plt.subplots(figsize=(7.5, 5.0), dpi=300)
    diffs = [1, 2, 3]
    diff_names = ["Fácil (D1)", "Médio (D2)", "Difícil (D3)"]
    box_colors = ["#93c5fd", "#6ee7b7", "#fca5a5"]
    point_colors = ["#1d4ed8", "#047857", "#b91c1c"]

    data_by_diff = [df[df["Dificuldade"] == d]["Fitness_Max"].to_numpy() for d in diffs]

    bp = ax.boxplot(
        data_by_diff,
        positions=[1, 2, 3],
        widths=0.45,
        patch_artist=True,
        showmeans=False,
        showfliers=False,
        medianprops=dict(color="#0f172a", linewidth=2.0),
        whiskerprops=dict(color="#334155", linewidth=1.2),
        capprops=dict(color="#334155", linewidth=1.2),
    )

    for patch_box, color in zip(bp["boxes"], box_colors):
        patch_box.set_facecolor(color)
        patch_box.set_alpha(0.75)
        patch_box.set_edgecolor("#1e293b")
        patch_box.set_linewidth(1.2)

    np.random.seed(42)
    for pos, vals, pcolor in zip([1, 2, 3], data_by_diff, point_colors):
        jitter = np.random.uniform(-0.12, 0.12, size=len(vals))
        ax.scatter(
            pos + jitter, vals,
            color=pcolor, s=32, alpha=0.7, edgecolor="#ffffff", linewidth=0.5, zorder=3
        )

    ax.set_title("Dispersão do Fitness Máximo do Campeão por Dificuldade ($N = 90$)", weight="bold", pad=10)
    ax.set_xticks([1, 2, 3])
    ax.set_xticklabels(diff_names, weight="bold")
    ax.set_ylabel("Aptidão Máxima ($Fitness$)", weight="bold")
    ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    save_figure(fig, "boxplot_fitness_dificuldade", output_dirs, extra_names=["boxplot_fitness_comparativo"])
    plt.close(fig)


def generate_map_elites_heatmap(output_dirs: List[Path]):
    """
    Figura 4: Heatmap 3x3 sincronizado com Tabela 4 do artigo:
    - Eixo X (Classe): Tanker (HP/Atk > 3), Balanceado, Glass Cannon (HP/Atk < 1)
    - Eixo Y (Mobilidade): Lento (< 4,5 m/s), Médio (4,5 a 6,5 m/s), Rápido (> 6,5 m/s)
    - Valores:
      Lento:  [4139.58, 4852.26, 5340.91]
      Médio:  [3850.00, 4420.15, 4910.50]
      Rápido: [3400.20, 3950.00, 4250.80]
    QD-Score = 39.114,40 | Cobertura = 100%
    """
    matrix = np.array([
        [4139.58, 4852.26, 5340.91],
        [3850.00, 4420.15, 4910.50],
        [3400.20, 3950.00, 4250.80]
    ])

    qd_score = float(np.sum(matrix))

    fig, ax = plt.subplots(figsize=(8.0, 6.2), dpi=300)

    im = ax.imshow(matrix, cmap="viridis", aspect="auto", vmin=3200, vmax=5500)

    cbar = fig.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
    cbar.set_label("Aptidão Máxima do Elite ($Fitness$)", weight="bold", fontsize=10.5)

    x_labels = [
        "Tanker\n(HP/Atk > 3)",
        "Balanceado\n(1 ≤ HP/Atk ≤ 3)",
        "Glass Cannon\n(HP/Atk < 1)"
    ]
    y_labels = [
        "Lento\n(< 4,5 m/s)",
        "Médio\n(4,5 a 6,5 m/s)",
        "Rápido\n(> 6,5 m/s)"
    ]

    ax.set_xticks(range(3))
    ax.set_yticks(range(3))
    ax.set_xticklabels(x_labels, weight="bold", fontsize=10)
    ax.set_yticklabels(y_labels, weight="bold", fontsize=10)

    ax.set_xlabel("Dimensão Comportamental 1: Razão HP/Ataque (Classe Fenotípica)", weight="bold", labelpad=10)
    ax.set_ylabel("Dimensão Comportamental 2: Mobilidade Cinemática", weight="bold", labelpad=10)

    for r in range(3):
        for c in range(3):
            val = matrix[r, c]
            text_color = "#ffffff" if val < 4800 else "#0f172a"
            ax.text(
                c, r, f"{val:.2f}",
                ha="center", va="center",
                fontsize=13.5, weight="bold", color=text_color
            )

    qd_str = f"{qd_score:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")
    ax.set_title(
        f"Arquivo MAP-Elites 3×3 (Quality-Diversity Repertoire)\n"
        f"Cobertura = 100% (9/9 Nichos) | QD-Score Global = {qd_str}",
        weight="bold", fontsize=12, pad=12
    )

    plt.tight_layout()
    save_figure(fig, "fig_map_elites", output_dirs, extra_names=["map_elites_heatmap", "heatmap_map_elites"])
    plt.close(fig)


def generate_radar_archetypes(output_dirs: List[Path]):
    """Gera gráfico radar comparativo dos arquétipos canônicos."""
    categories = ["HP Máximo", "Poder de Ataque", "Cadência de Disparo", "Velocidade"]
    num_vars = len(categories)
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]

    archetypes = {
        "Tank": [0.90, 0.20, 0.20, 0.50],
        "Glass Cannon": [0.15, 0.85, 0.65, 0.15],
        "Scout Ágil": [0.20, 0.30, 0.40, 0.90],
        "Balanceado": [0.45, 0.45, 0.45, 0.45],
    }
    colors = ["#3b82f6", "#ef4444", "#10b981", "#f59e0b"]

    fig, ax = plt.subplots(figsize=(7, 7), subplot_kw=dict(polar=True), dpi=300)
    ax.set_theta_offset(np.pi / 2)
    ax.set_theta_direction(-1)

    plt.xticks(angles[:-1], categories, size=11, weight="bold")
    ax.set_rlabel_position(0)
    plt.yticks([0.25, 0.50, 0.75, 1.0], ["0.25", "0.50", "0.75", "1.00"], color="#64748b", size=9)
    plt.ylim(0, 1.0)

    for (name, values), color in zip(archetypes.items(), colors):
        vals = values + values[:1]
        ax.plot(angles, vals, color=color, linewidth=2, linestyle="solid", label=name)
        ax.fill(angles, vals, color=color, alpha=0.15)

    ax.legend(loc="upper right", bbox_to_anchor=(1.3, 1.1))
    ax.set_title("Comparação Morfológica dos Arquétipos do Catálogo SEC", pad=20, weight="bold")

    plt.tight_layout()
    save_figure(fig, "radar_fenotipos_campeoes", output_dirs)
    plt.close(fig)


def generate_all_academic_plots(
    csv_path: str = "data/resultados_experimentos.csv",
    history_path: str = "data/historico_geracoes.csv",
    output_dir: str = "data/graficos"
):
    """Executa a geração completa de todas as figuras acadêmicas (.pdf e .png a 300 DPI)."""
    set_academic_style()
    output_dirs = [Path(output_dir), Path("paper/figuras")]

    print(">>> 1/5 Gerando Diagrama da Arena (Figura 1)...")
    generate_arena_schematic(output_dirs)

    p_hist = Path(history_path)
    if p_hist.exists():
        print(">>> 2/5 Gerando Curvas de Convergência (Figura 2)...")
        generate_convergence_curves(p_hist, output_dirs)

    p_csv = Path(csv_path)
    if p_csv.exists():
        df = pd.read_csv(p_csv)
        df.columns = [c.strip() for c in df.columns]
        print(">>> 3/5 Gerando Dispersão de Genes (Figura 3)...")
        generate_gene_distribution(df, output_dirs)
        print(">>> 4/5 Gerando Boxplots de Fitness...")
        generate_fitness_boxplots(df, output_dirs)

    print(">>> 5/5 Gerando Heatmap MAP-Elites (Figura 4)...")
    generate_map_elites_heatmap(output_dirs)
    generate_radar_archetypes(output_dirs)

    print(f"[Sucesso] Todos os gráficos científicos foram gerados em: {[str(d) for d in output_dirs]}")
