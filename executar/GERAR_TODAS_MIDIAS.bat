@echo off
chcp 65001 >nul
title Mirage - Gerar Midias Visuais (GIFs e Video MP4)
echo ===============================================================================
echo        PROJETO MIRAGE - GERADOR DE MIDIAS VISUAIS (GIFs E VIDEO MP4)
echo ===============================================================================
echo Gerando animacoes e video demonstrativo dos NPCs campeoes em offscreen...
echo.
cd /d "%~dp0\.."
python -m mirage.main --media
if errorlevel 1 (
    echo.
    echo [ERRO] Ocorreu uma falha ao gerar as midias visuais.
    pause
) else (
    echo.
    echo [SUCESSO] Todas as midias foram salvas em data/graficos/ e data/arena_demo.gif!
    pause
)

