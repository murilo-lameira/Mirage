#!/usr/bin/env bash
# =========================================================================
# MIRAGE - MENU INTERATIVO PRINCIPAL (LINUX / MACOS)
# Suporta GNU Octave e MathWorks MATLAB
# =========================================================================

cd "$(dirname "$0")/.."

if command -v octave &>/dev/null; then
    RUNTIME_CMD="octave"
    RUNTIME_TYPE="OCTAVE"
elif command -v matlab &>/dev/null; then
    RUNTIME_CMD="matlab"
    RUNTIME_TYPE="MATLAB"
elif command -v octave-cli &>/dev/null; then
    RUNTIME_CMD="octave-cli"
    RUNTIME_TYPE="OCTAVE"
else
    echo "ERRO: GNU Octave ou MATLAB não foram encontrados no sistema!"
    echo "Instale o GNU Octave via terminal:"
    echo "  - Ubuntu/Debian: sudo apt-get install octave"
    echo "  - macOS (brew):  brew install octave"
    exit 1
fi

while true; do
    clear
    echo "======================================================================="
    echo "         MIRAGE: SIMULADOR TÁTICO COM ALGORITMOS GENÉTICOS"
    echo "       Inimigos Virtuais que Aprendem a Desviar em Tempo Real"
    echo "======================================================================="
    echo " Ambiente detectado: $RUNTIME_CMD ($RUNTIME_TYPE)"
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
            if [ "$RUNTIME_TYPE" = "MATLAB" ]; then
                matlab -nosplash -r "addpath('src'); assistir_simulacao;"
            else
                $RUNTIME_CMD --persist --eval "addpath('src'); assistir_simulacao;"
            fi
            ;;
        2)
            if [ "$RUNTIME_TYPE" = "MATLAB" ]; then
                matlab -nosplash -r "difficulty=3; addpath('src'); assistir_simulacao;"
            else
                $RUNTIME_CMD --persist --eval "difficulty=3; addpath('src'); assistir_simulacao;"
            fi
            ;;
        3)
            if [ "$RUNTIME_TYPE" = "MATLAB" ]; then
                matlab -nosplash -r "addpath('src'); npc_evasivo_ga;"
            else
                $RUNTIME_CMD --persist --eval "addpath('src'); npc_evasivo_ga;"
            fi
            ;;
        4)
            echo "Gerando gráficos e análises..."
            if [ "$RUNTIME_TYPE" = "MATLAB" ]; then
                matlab -batch "addpath('src'); gerar_graficos_comparativos; analise_evolucao_media; gerar_heatmap_map_elites; gerar_boxplots; teste_estatistico_hipoteses; exit;"
            else
                $RUNTIME_CMD --no-gui --eval "addpath('src'); gerar_graficos_comparativos; analise_evolucao_media; gerar_heatmap_map_elites; gerar_boxplots; teste_estatistico_hipoteses;"
            fi
            read -p "Concluído! Pressione ENTER para voltar ao menu..."
            ;;
        5)
            echo "Gerando GIF animado..."
            if [ "$RUNTIME_TYPE" = "MATLAB" ]; then
                matlab -batch "addpath('src'); gerar_gif_animado; exit;"
            else
                $RUNTIME_CMD --no-gui --eval "addpath('src'); gerar_gif_animado;"
            fi
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
