@echo off
chcp 65001 >nul
cd /d "%~dp0.."
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave nao encontrado no sistema!
    pause
    exit /b 1
)

echo Abrindo Simulador Visual do NPC Campeão...
"%OCTAVE_BIN%" --persist --eval "addpath('src'); assistir_simulacao;"
