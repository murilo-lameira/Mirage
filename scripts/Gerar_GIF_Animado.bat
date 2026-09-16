@echo off
chcp 65001 >nul
echo ========================================================
echo GERADOR DE GIF ANIMADO - MIRAGE
echo ========================================================
echo.
cd /d "%~dp0.."
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave nao encontrado no sistema!
    pause
    exit /b 1
)

echo Gravando sequencia de combate do Campeao...
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); gerar_gif_animado;"

echo.
echo Concluido! Verifique o arquivo data/graficos/demonstracao_npc.gif
pause
