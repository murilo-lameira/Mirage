@echo off
setlocal enabledelayedexpansion
title MIRAGE - Gerador de Graficos e Estatisticas
cd /d "%~dp0.."

echo =======================================================================
echo     MIRAGE: GERACAO DE GRAFICOS CIENTIFICOS E TESTES ESTATISTICOS
echo =======================================================================
call "scripts\Gerar_Todos_Graficos.bat"
