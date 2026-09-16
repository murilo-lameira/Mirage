@echo off
chcp 65001 >nul
cd /d "%~dp0.."
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave nao encontrado no sistema!
    pause
    exit /b 1
)

echo Iniciando o Octave com o Treinamento do Algoritmo Genético...
"%OCTAVE_BIN%" --persist --eval "addpath('src'); npc_evasivo_ga;"
