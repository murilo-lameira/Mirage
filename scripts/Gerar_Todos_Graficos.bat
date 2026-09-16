@echo off
chcp 65001 >nul
echo ========================================================
echo GERADOR DE GRAFICOS E ANALISES - MIRAGE
echo ========================================================
echo.
cd /d "%~dp0.."
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    echo [ERRO] GNU Octave nao encontrado no sistema!
    pause
    exit /b 1
)

echo Executando Octave CLI para analises...
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); gerar_graficos_comparativos;"
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); analise_evolucao_media;"
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); gerar_heatmap_map_elites;"
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); gerar_boxplots;"
"%OCTAVE_CLI_BIN%" --eval "addpath('src'); teste_estatistico_hipoteses;"

echo.
echo Processo concluido! Verifique a pasta data/graficos/
pause
