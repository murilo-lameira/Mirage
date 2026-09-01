@echo off
echo ========================================================
echo GERADOR DE GRAFICOS E ANALISES - MIRAGE
echo ========================================================
echo.
echo Executando Octave (CLI) para analises...

cd %~dp0..
octave-cli --eval "addpath('src'); gerar_graficos_comparativos;"
octave-cli --eval "addpath('src'); analise_evolucao_media;"

echo.
echo Processo concluido! Verifique a pasta data/graficos/
pause

