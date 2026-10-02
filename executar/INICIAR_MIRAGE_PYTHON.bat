@echo off
chcp 65001 >nul
title Mirage - Painel de Controle Principal
echo ===============================================================================
echo            PROJETO MIRAGE - PAINEL PRINCIPAL (PYTHON CLI)
echo ===============================================================================
cd /d "%~dp0\.."
python -m mirage.main
if errorlevel 1 (
    echo.
    echo [ERRO] Ocorreu uma falha ao executar o painel principal.
    pause
)
