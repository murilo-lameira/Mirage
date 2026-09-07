@echo off
echo ========================================================
echo GERADOR DE GIF ANIMADO - MIRAGE
echo ========================================================
echo.
echo Gravando sequencia de combate do Campeao...

cd %~dp0..
octave-cli --eval "addpath('src'); gerar_gif_animado;"

echo.
echo Concluido! Verifique o arquivo data/graficos/demonstracao_npc.gif
pause

