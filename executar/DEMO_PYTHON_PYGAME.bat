@echo off
chcp 65001 >nul
title Mirage - Demonstracao da IA Campea (Pygame)
echo ===============================================================================
echo            PROJETO MIRAGE - DEMONSTRACAO DA IA AUTONOMA (PYGAME)
echo ===============================================================================
echo Iniciando Arena Cyberpunk com a IA Campea (Dificuldade Medio)...
echo Comandos: [ESPACO] Pausar/Continuar ^| [R] Reiniciar ^| [ESC] Sair
echo ===============================================================================
cd /d "%~dp0\.."
python -m mirage.main --demo --diff 2
if errorlevel 1 (
    echo.
    echo [ERRO] Ocorreu uma falha ao executar a simulacao.
    pause
)
