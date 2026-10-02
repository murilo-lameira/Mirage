"""
=============================================================================
PROJETO MIRAGE — GERAÇÃO DE GRÁFICOS CIENTÍFICOS DE ALTA RESOLUÇÃO (300 DPI)
=============================================================================
Pipeline visual para artigos científicos e relatórios técnicos.
Produz:
1. Boxplots com strip-jitter para métricas de desempenho.
2. Curvas de convergência evolutiva com faixas de confiança (± 1σ).
3. Heatmap 3x3 do catálogo MAP-Elites com anotações de nicho fenotípico.
4. Gráfico Radar/Spider para comparação morfológica dos cromossomos campeões.
=============================================================================
"""

import math
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

from mirage.core.map_elites import MAPElitesGrid, STRATEGIC_CATALOGUE


def set_academic_style():
    """Configura o estilo visual moderno, sóbrio e acadêmico."""
    sns.set_theme(style="whitegrid", font="sans-serif")
    plt.rcParams.update({
        "font.size": 11,
        "axes.labelsize": 12,
        "axes.titlesize": 13,
        "axes.titleweight": "bold",
        "xtick.labelsize": 10,
        "ytick.labelsize": 10,
        "legend.fontsize": 10,
        "figure.titlesize": 14,
        "figure.dpi": 300,
        "savefig.dpi": 300,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.08,
    })


def generate_boxplots(df: pd.DataFrame, output_dir: Path):
    """Gera boxplots científicos com sobreposição de dados pontuais (jitter)."""
    palette = {1: "#3b82f6", 2: "#10b981", 3: "#ef4444"}
    diff_labels = {1: "Fácil (D1)", 2: "Médio (D2)", 3: "Difícil (D3)"}
    df_plot = df.copy()
    df_plot["Dificuldade_Nome"] = df_plot["Dificuldade"].map(diff_labels)

    # 1. Boxplot de Fitness Máximo e Médio
    fig, axes = plt.subplots(1, 2, figsize=(12, 5))

    for ax, metric, title in zip(
        axes,
        ["Fitness_Max", "Fitness_Medio"],
        ["Fitness Máximo do Campeão", "Fitness Médio da População"]
    ):
        sns.boxplot(
            data=df_plot,
            x="Dificuldade_Nome",
            y=metric,
            hue="Dificuldade_Nome",
            legend=False,
            ax=ax,
            palette=["#93c5fd", "#6ee7b7", "#fca5a5"],
            boxprops=dict(alpha=0.75, edgecolor="#1e293b", linewidth=1.2),
            medianprops=dict(color="#0f172a", linewidth=2.0),
            whiskerprops=dict(color="#334155", linewidth=1.2),
            capprops=dict(color="#334155", linewidth=1.2),
            fliersize=0,
        )
        sns.stripplot(
            data=df_plot,
            x="Dificuldade_Nome",
            y=metric,
            hue="Dificuldade_Nome",
            legend=False,
            ax=ax,
            palette=["#1d4ed8", "#047857", "#b91c1c"],
            size=6,
            jitter=0.22,
            alpha=0.65,
            edgecolor="#ffffff",
            linewidth=0.5,
        )
        ax.set_title(title)
        ax.set_xlabel("Nível de Dificuldade")
        ax.set_ylabel("Aptidão (Fitness)")
        ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    fig.savefig(output_dir / "boxplot_fitness_comparativo.png")
    plt.close(fig)

    # 2. Boxplot de Gerações até Convergência / Parada
    fig, ax = plt.subplots(figsize=(7, 5))
    sns.boxplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Geracoes_Treinadas",
        hue="Dificuldade_Nome",
        legend=False,
        ax=ax,
        palette=["#cbd5e1", "#cbd5e1", "#cbd5e1"],
        boxprops=dict(alpha=0.7, edgecolor="#1e293b", linewidth=1.2),
        medianprops=dict(color="#dc2626", linewidth=2.2),
        fliersize=0,
    )
    sns.stripplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Geracoes_Treinadas",
        hue="Dificuldade_Nome",
        legend=False,
        ax=ax,
        palette=["#3b82f6", "#10b981", "#ef4444"],
        size=6,
        jitter=0.2,
        alpha=0.75,
    )
    ax.axhline(50, color="#94a3b8", linestyle=":", label="Limite Máximo (50 gen)")
    ax.set_title("Gerações Treinadas até Estagnação (Early Stopping)")
    ax.set_xlabel("Nível de Dificuldade")
    ax.set_ylabel("Número de Gerações")
    ax.legend(loc="lower right")
    ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    fig.savefig(output_dir / "boxplot_geracoes.png")
    plt.close(fig)

    # 3. Sobrevivência e Desvios
    fig, axes = plt.subplots(1, 2, figsize=(12, 5))
    sns.boxplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Elite_Sobrevivencia",
        hue="Dificuldade_Nome",
        legend=False,
        ax=axes[0],
        palette=["#93c5fd", "#6ee7b7", "#fca5a5"],
        boxprops=dict(alpha=0.7),
        fliersize=0,
    )
    sns.stripplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Elite_Sobrevivencia",
        color="#1e293b",
        size=5,
        jitter=0.2,
        alpha=0.5,
        ax=axes[0],
    )
    axes[0].set_title("Tempo de Sobrevivência (s)")
    axes[0].set_xlabel("Dificuldade")
    axes[0].set_ylabel("Segundos")

    sns.boxplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Elite_Desvios",
        hue="Dificuldade_Nome",
        legend=False,
        ax=axes[1],
        palette=["#93c5fd", "#6ee7b7", "#fca5a5"],
        boxprops=dict(alpha=0.7),
        fliersize=0,
    )
    sns.stripplot(
        data=df_plot,
        x="Dificuldade_Nome",
        y="Elite_Desvios",
        color="#1e293b",
        size=5,
        jitter=0.2,
        alpha=0.5,
        ax=axes[1],
    )
    axes[1].set_title("Número de Evasões Bem-Sucedidas (CPA)")
    axes[1].set_xlabel("Dificuldade")
    axes[1].set_ylabel("Contagem de Desvios")

    plt.tight_layout()
    fig.savefig(output_dir / "boxplot_sobrevivencia_desvios.png")
    plt.close(fig)


def generate_map_elites_heatmap(output_dir: Path):
    """Gera visualização de mapa de calor da grade 3x3 MAP-Elites."""
    grid = MAPElitesGrid()
    # Povoa a grade com os perfis SEC canônicos
    grid.seed_with_canonical_archetypes()
    summary = grid.get_archive_summary()
    fit_matrix = summary["fitness_matrix"].copy()

    # Mascara células vazias para NaN
    masked_matrix = np.where(fit_matrix < 0.0, np.nan, fit_matrix)

    fig, ax = plt.subplots(figsize=(8.5, 6.5))
    cmap = sns.color_palette("viridis", as_cmap=True)

    sns.heatmap(
        masked_matrix,
        annot=True,
        fmt=".1f",
        cmap=cmap,
        cbar_kws={"label": "Aptidão do Elite (Fitness)"},
        xticklabels=["Tanker (HP/Atk > 3)", "Balanceado", "Glass Cannon (HP/Atk < 1)"],
        yticklabels=["Lento (<4.5 m/s)", "Médio (4.5-6.5 m/s)", "Rápido (>6.5 m/s)"],
        linewidths=1.5,
        linecolor="#ffffff",
        ax=ax,
        annot_kws={"size": 12, "weight": "bold"},
    )

    # Adiciona anotações sutis de coordenadas
    for r in range(3):
        for c in range(3):
            elite = grid.get_elite(r, c)
            if elite is not None:
                ax.text(
                    c + 0.5,
                    r + 0.80,
                    f"Fit: {elite.fitness:.1f}",
                    ha="center",
                    va="center",
                    fontsize=8.5,
                    color="#ffffff",
                    weight="normal",
                )

    ax.set_title("Catálogo MAP-Elites 3×3 (Quality-Diversity Archive)")
    ax.set_xlabel("Dimensão Comportamental 1: Razão HP/Ataque (Classe de Combate)")
    ax.set_ylabel("Dimensão Comportamental 2: Mobilidade Cinemática (Velocidade)")

    plt.tight_layout()
    fig.savefig(output_dir / "heatmap_map_elites.png")
    plt.close(fig)


def generate_radar_archetypes(output_dir: Path):
    """Gera gráfico radar (spider plot) comparando os fenótipos canônicos."""
    categories = ["HP Máximo", "Poder de Ataque", "Cadência de Disparo", "Velocidade"]
    num_vars = len(categories)
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]

    # Arquétipos normalizados [0, 1] com restrição sum <= 1.8
    archetypes = {
        "Tank": [0.90, 0.20, 0.20, 0.50],
        "Glass Cannon": [0.15, 0.85, 0.65, 0.15],
        "Scout Ágil": [0.20, 0.30, 0.40, 0.90],
        "Balanceado": [0.45, 0.45, 0.45, 0.45],
    }
    colors = ["#3b82f6", "#ef4444", "#10b981", "#f59e0b"]

    fig, ax = plt.subplots(figsize=(7, 7), subplot_kw=dict(polar=True))
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
    ax.set_title("Comparação Morfológica dos Arquétipos do Catálogo SEC", pad=20)

    plt.tight_layout()
    fig.savefig(output_dir / "radar_fenotipos_campeoes.png")
    plt.close(fig)


def generate_gene_distribution_plots(df: pd.DataFrame, output_dir: Path):
    """Gera visualização comparativa 2x2 da distribuição dos 4 genes evoluídos."""
    diff_labels = {1: "Fácil (D1)", 2: "Médio (D2)", 3: "Difícil (D3)"}
    df_plot = df.copy()
    df_plot["Dificuldade_Nome"] = df_plot["Dificuldade"].map(diff_labels)

    genes = [
        ("Elite_HP", "HP Máximo (Pontos de Vida)", [10, 200]),
        ("Elite_Atk", "Poder de Ataque (Dano/Tiro)", [5, 50]),
        ("Elite_AtkSpd", "Cadência de Disparo (Hz)", [0.5, 5.0]),
        ("Elite_MovSpd", "Velocidade de Movimento (m/s)", [1.0, 8.0]),
    ]

    fig, axes = plt.subplots(2, 2, figsize=(13, 10))
    axes = axes.flatten()

    for idx, (col_name, title, (ymin, ymax)) in enumerate(genes):
        ax = axes[idx]
        sns.boxplot(
            data=df_plot,
            x="Dificuldade_Nome",
            y=col_name,
            hue="Dificuldade_Nome",
            legend=False,
            ax=ax,
            palette=["#93c5fd", "#6ee7b7", "#fca5a5"],
            boxprops=dict(alpha=0.75, edgecolor="#1e293b", linewidth=1.2),
            medianprops=dict(color="#0f172a", linewidth=2.0),
            fliersize=0,
        )
        sns.stripplot(
            data=df_plot,
            x="Dificuldade_Nome",
            y=col_name,
            hue="Dificuldade_Nome",
            legend=False,
            ax=ax,
            palette=["#1d4ed8", "#047857", "#b91c1c"],
            size=6,
            jitter=0.22,
            alpha=0.65,
        )
        ax.set_title(title, weight="bold")
        ax.set_xlabel("Nível de Dificuldade")
        ax.set_ylabel("Valor Fenotípico Real")
        ax.set_ylim(ymin * 0.9, ymax * 1.08)
        ax.grid(True, linestyle="--", alpha=0.5)

    plt.suptitle("Distribuição Morfológica dos Genes dos NPCs Campeões (N=90)", y=0.99, weight="bold", size=14)
    plt.tight_layout()
    fig.savefig(output_dir / "boxplot_distribuicao_genes.png")
    fig.savefig(output_dir / "comparativo_genes.png")
    plt.close(fig)


def generate_convergence_learning_curves(history_csv: Path, output_dir: Path):
    """Gera curvas de convergência evolutiva média com faixas de confiança (± 1σ)."""
    if not history_csv.exists():
        return

    df_hist = pd.read_csv(history_csv)
    df_hist.columns = [c.strip() for c in df_hist.columns]

    fig, ax = plt.subplots(figsize=(10, 6))
    diff_styles = {
        1: ("Fácil (D1)", "#2563eb", "--"),
        2: ("Médio (D2)", "#059669", "-"),
        3: ("Difícil (D3)", "#dc2626", "-."),
    }

    for diff, (label, color, ls) in diff_styles.items():
        subset = df_hist[df_hist["Dificuldade"] == diff]
        if subset.empty:
            continue

        grouped = subset.groupby("Geracao")["Fitness_Maximo_Global"]
        gens = grouped.mean().index.to_numpy()
        mean_fit = grouped.mean().to_numpy()
        std_fit = grouped.std().fillna(0.0).to_numpy()

        ax.plot(gens, mean_fit, label=f"Média {label}", color=color, linestyle=ls, linewidth=2.2)
        ax.fill_between(
            gens,
            np.maximum(0, mean_fit - std_fit),
            mean_fit + std_fit,
            color=color,
            alpha=0.18,
            label=f"±1σ {label}",
        )

    ax.set_title("Curvas de Aprendizado e Convergência Evolutiva (Média ± 1σ sobre 30 Repetições)")
    ax.set_xlabel("Geração do Algoritmo Genético")
    ax.set_ylabel("Aptidão Máxima Acumulada (Fitness)")
    ax.legend(loc="lower right", framealpha=0.9)
    ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    fig.savefig(output_dir / "evolucao_media_por_dificuldade.png")
    fig.savefig(output_dir / "comparativo_fitness.png")
    plt.close(fig)


def generate_all_academic_plots(
    csv_path: str = "data/resultados_experimentos.csv",
    history_path: str = "data/historico_geracoes.csv",
    output_dir: str = "data/graficos"
):
    """Executa a geração completa de todas as figuras acadêmicas a 300 DPI."""
    out = Path(output_dir)
    out.mkdir(parents=True, exist_ok=True)
    set_academic_style()

    p_csv = Path(csv_path)
    if p_csv.exists():
        df = pd.read_csv(p_csv)
        df.columns = [c.strip() for c in df.columns]
        generate_boxplots(df, out)
        generate_gene_distribution_plots(df, out)
    else:
        print(f"[Aviso] Arquivo {csv_path} não encontrado para geração de boxplots.")

    p_hist = Path(history_path)
    generate_convergence_learning_curves(p_hist, out)
    generate_map_elites_heatmap(out)
    generate_radar_archetypes(out)
    print(f"[Sucesso] Todos os gráficos científicos foram gerados em: {out.resolve()}")

