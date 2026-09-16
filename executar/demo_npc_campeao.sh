#!/usr/bin/env bash
# =========================================================================
# MIRAGE - DEMONSTRAÇÃO DO NPC CAMPEÃO (LINUX / MACOS)
# Suporta GNU Octave e MathWorks MATLAB
# =========================================================================

cd "$(dirname "$0")/.."

if command -v octave &>/dev/null; then
    echo "Executando via GNU Octave..."
    octave --persist --eval "addpath('src'); assistir_simulacao;"
elif command -v matlab &>/dev/null; then
    echo "Executando via MATLAB..."
    matlab -nosplash -r "addpath('src'); assistir_simulacao;"
elif command -v octave-cli &>/dev/null; then
    echo "Executando via GNU Octave CLI..."
    octave-cli --persist --eval "addpath('src'); assistir_simulacao;"
else
    echo "ERRO: GNU Octave ou MATLAB não foram encontrados no sistema!"
    echo "Instale via terminal:"
    echo "  - Ubuntu/Debian: sudo apt-get install octave"
    echo "  - macOS (brew):  brew install octave"
    exit 1
fi
