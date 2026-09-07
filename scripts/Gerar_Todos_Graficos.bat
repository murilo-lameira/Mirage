@echo off
echo ========================================================
echo GERADOR DE GRAFICOS E ANALISES - MIRAGE
echo ========================================================
echo.
echo Executando Octave (CLI) para analises...

cd %~dp0..
octave-cli --eval "addpath('src'); gerar_graficos_comparativos;"
octave-cli --eval "addpath('src'); analise_evolucao_media;"
octave-cli --eval "addpath('src'); gerar_heatmap_map_elites;"
octave-cli --eval "addpath('src'); gerar_boxplots;"
octave-cli --eval "addpath('src'); teste_estatistico_hipoteses;"

echo.
echo Processo concluido! Verifique a pasta data/graficos/
pause

