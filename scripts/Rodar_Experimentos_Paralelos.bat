@echo off
title Mirage - Executor Paralelo de Experimentos (30 Rodadas)
echo ================================================================
echo    INICIANDO SIMULADOR PARALELO (10x CADA DIFICULDADE)
echo ================================================================
powershell -ExecutionPolicy Bypass -File "%~dp0Rodar_Experimentos_Paralelos.ps1"
pause

