#!/usr/bin/env bash
# =========================================================================
# MIRAGE - DEMONSTRAÇÃO DO NPC CAMPEÃO (LINUX / MACOS)
# =========================================================================

cd "$(dirname "$0")"

echo "======================================================================="
echo "         MIRAGE: SIMULADOR TÁTICO COM ALGORITMOS GENÉTICOS"
echo "                 DEMONSTRAÇÃO DO NPC CAMPEÃO EVOLUÍDO"
echo "======================================================================="

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

echo "Executando Arena 2D com: $OCTAVE_CMD"
$OCTAVE_CMD --persist --eval "addpath('src'); assistir_simulacao;"
