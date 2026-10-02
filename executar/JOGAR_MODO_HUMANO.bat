@echo off
chcp 65001 >nul
title Mirage - Arena Jogavel (Modo Humano)
echo ===============================================================================
echo            PROJETO MIRAGE - ARENA JOGAVEL (MODO HUMANO)
echo ===============================================================================
echo Controles:
echo   - Movimento: [W, A, S, D] ou [Setas direcionais]
echo   - Mira e Tiro: Posicione o [Mouse] na direcao desejada
echo   - Pausa: [ESPACO] ^| Reiniciar: [R] ^| Sair: [ESC]
echo ===============================================================================
cd /d "%~dp0\.."
python -m mirage.main --play --diff 2
if errorlevel 1 (
    echo.
    echo [ERRO] Ocorreu uma falha ao executar a arena jogavel.
    pause
)
