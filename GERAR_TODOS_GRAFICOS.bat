@echo off
chcp 65001 >nul
title MIRAGE - Gerador de Gráficos e Estatísticas
cd /d "%~dp0"

echo =======================================================================
echo     MIRAGE: GERAÇÃO DE GRÁFICOS CIENTÍFICOS E TESTES ESTATÍSTICOS
echo =======================================================================
call "scripts\Gerar_Todos_Graficos.bat"
