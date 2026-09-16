@echo off
chcp 65001 >nul
title MIRAGE - Menu Principal Interativo
cd /d "%~dp0"

:CHECK_OCTAVE
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    cls
    echo =======================================================================
    echo   ATENÇÃO: GNU OCTAVE NÃO FOI ENCONTRADO NO SISTEMA!
    echo =======================================================================
    echo.
    echo O Mirage necessita do GNU Octave instalado para rodar os algoritmos
    echo genéticos, simulações físicas vetoriais e gráficos científicos.
    echo.
    echo Como instalar facilmente:
    echo.
    echo   1. Pelo terminal (Windows Package Manager):
    echo      winget install GNU.Octave
    echo.
    echo   2. Pelo instalador oficial para Windows:
    echo      https://octave.org/download
    echo.
    echo =======================================================================
    set /p dl="Deseja abrir a página de download do Octave agora? (S/N): "
    if /i "%dl%"=="S" start https://octave.org/download
    echo.
    pause
    exit /b 1
)

:MENU
cls
echo =======================================================================
echo          MIRAGE: SIMULADOR TÁTICO COM ALGORITMOS GENÉTICOS
echo        Inimigos Virtuais que Aprendem a Desviar em Tempo Real
echo        UNISENAI - Engenharia de Controle e Automação (Joinville)
echo =======================================================================
echo  Octave detectado: %OCTAVE_BIN%
echo  Status: Pronto para Execucao Plug-and-Play
echo =======================================================================
echo.
echo  Selecione a ação desejada:
echo.
echo   [1] Assistir NPC Campeão em Ação (Arena 2D Interativa)
echo   [2] Demonstração Rápida no Modo Difícil (Bullet Hell Extremo)
echo   [3] Iniciar Treinamento do Algoritmo Genético (Gráficos em Tempo Real)
echo   [4] Gerar Todos os Gráficos Científicos e Testes Estatísticos
echo   [5] Gerar GIF Animado da Arena (data/graficos/demonstracao_npc.gif)
echo   [6] Executar Baterias de Teste em Paralelo (30x Headless)
echo   [7] Abrir Pasta de Gráficos e Resultados Gerados
echo   [8] Abrir Pasta de Documentação e Artigos Técnicos
echo   [0] Sair
echo.
echo =======================================================================
set /p opt="Digite o número da opção (0-8) e pressione ENTER: "

if "%opt%"=="1" goto :ASSISTIR_INTERATIVO
if "%opt%"=="2" goto :ASSISTIR_DIFICIL
if "%opt%"=="3" goto :TREINAR_GA
if "%opt%"=="4" goto :GERAR_GRAFICOS
if "%opt%"=="5" goto :GERAR_GIF
if "%opt%"=="6" goto :PARALELO
if "%opt%"=="7" goto :ABRIR_GRAFICOS
if "%opt%"=="8" goto :ABRIR_DOCS
if "%opt%"=="0" exit /b 0

echo Opção inválida!
timeout /t 2 >nul
goto :MENU

:ASSISTIR_INTERATIVO
echo.
echo Iniciando Arena 2D (Modo Interativo)...
"%OCTAVE_BIN%" --persist --eval "addpath('src'); assistir_simulacao;"
goto :MENU

:ASSISTIR_DIFICIL
echo.
echo Iniciando Arena 2D com Campeão no Modo Difícil...
"%OCTAVE_BIN%" --persist --eval "difficulty=3; addpath('src'); assistir_simulacao;"
goto :MENU

:TREINAR_GA
echo.
echo Iniciando Treinamento Interativo do Algoritmo Genético...
"%OCTAVE_BIN%" --persist --eval "addpath('src'); npc_evasivo_ga;"
goto :MENU

:GERAR_GRAFICOS
echo.
echo Executando análises científicas e testes de hipóteses...
call "scripts\Gerar_Todos_Graficos.bat"
goto :MENU

:GERAR_GIF
echo.
echo Gerando GIF animado do combate...
call "scripts\Gerar_GIF_Animado.bat"
goto :MENU

:PARALELO
echo.
echo Disparando 30 experimentos em segundo plano...
powershell -ExecutionPolicy Bypass -File "scripts\Rodar_Experimentos_Paralelos.ps1"
pause
goto :MENU

:ABRIR_GRAFICOS
if exist "data\graficos" explorer "data\graficos"
goto :MENU

:ABRIR_DOCS
if exist "docs" explorer "docs"
goto :MENU
