@echo off
chcp 65001 >nul
title MIRAGE - Treinamento do Algoritmo Genético
cd /d "%~dp0"

echo =======================================================================
echo          MIRAGE: TREINAMENTO DO ALGORITMO GENÉTICO
echo =======================================================================
echo Localizando GNU Octave...

call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave não encontrado!
    pause
    exit /b 1
)

echo [OK] Octave: %OCTAVE_BIN%
echo Iniciando evolução das gerações com visualização em tempo real...
"%OCTAVE_BIN%" --persist --eval "addpath('src'); npc_evasivo_ga;"
