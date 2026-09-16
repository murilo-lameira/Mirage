#!/usr/bin/env bash
# =========================================================================
# MIRAGE - MENU INTERATIVO PRINCIPAL (LINUX / MACOS)
# =========================================================================

cd "$(dirname "$0")"

if command -v octave &>/dev/null; then
    OCTAVE_CMD="octave"
elif command -v octave-cli &>/dev/null; then
    OCTAVE_CMD="octave-cli"
else
    echo "ERRO: GNU Octave não encontrado no sistema!"
    echo "Instale via terminal:"
    echo "  - Ubuntu/Debian: sudo apt-get install octave"
    echo "  - Fedora:        sudo dnf install octave"
    echo "  - macOS (brew):  brew install octave"
    exit 1
fi

while true; do
    clear
    echo "======================================================================="
    echo "         MIRAGE: SIMULADOR TÁTICO COM ALGORITMOS GENÉTICOS"
    echo "       Inimigos Virtuais que Aprendem a Desviar em Tempo Real"
    echo "======================================================================="
    echo " Octave detectado: $(which $OCTAVE_CMD)"
    echo "======================================================================="
    echo ""
    echo "  [1] Assistir NPC Campeão em Ação (Arena 2D Interativa)"
    echo "  [2] Demonstração Rápida no Bullet Hell Difícil (Modo Extremo)"
    echo "  [3] Iniciar Treinamento do Algoritmo Genético (Gráficos em Tempo Real)"
    echo "  [4] Gerar Todos os Gráficos e Relatório Estatístico"
    echo "  [5] Gerar GIF Animado da Arena"
    echo "  [0] Sair"
    echo ""
    read -p "Digite a opção desejada [0-5]: " opt
    case "$opt" in
        1)
            $OCTAVE_CMD --persist --eval "addpath('src'); assistir_simulacao;"
            ;;
        2)
            $OCTAVE_CMD --persist --eval "difficulty=3; addpath('src'); assistir_simulacao;"
            ;;
        3)
            $OCTAVE_CMD --persist --eval "addpath('src'); npc_evasivo_ga;"
            ;;
        4)
            echo "Gerando gráficos e análises..."
            $OCTAVE_CMD --no-gui --eval "addpath('src'); gerar_graficos_comparativos; analise_evolucao_media; gerar_heatmap_map_elites; gerar_boxplots; teste_estatistico_hipoteses;"
            read -p "Concluído! Pressione ENTER para voltar ao menu..."
            ;;
        5)
            echo "Gerando GIF animado..."
            $OCTAVE_CMD --no-gui --eval "addpath('src'); gerar_gif_animado;"
            read -p "Concluído! Pressione ENTER para voltar ao menu..."
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            sleep 1
            ;;
    esac
done
