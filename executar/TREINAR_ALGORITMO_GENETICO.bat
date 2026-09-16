@echo off
setlocal enabledelayedexpansion
title MIRAGE - Treinamento do Algoritmo Genetico
cd /d "%~dp0.."

echo =======================================================================
echo          MIRAGE: TREINAMENTO DO ALGORITMO GENETICO
echo =======================================================================
echo Localizando GNU Octave ou MATLAB...

call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave ou MATLAB nao foram encontrados!
    pause
    exit /b 1
)

echo [OK] Ambiente detectado: %RUNTIME_NAME% (%RUNTIME_BIN%)
echo Iniciando evolucao das geracoes com visualizacao em tempo real...
if "%RUNTIME%"=="MATLAB" (
    "%RUNTIME_BIN%" -nosplash -r "addpath('src'); npc_evasivo_ga;"
) else (
    "%RUNTIME_BIN%" --persist --eval "addpath('src'); npc_evasivo_ga;"
)
