@echo off
setlocal enabledelayedexpansion
title MIRAGE - Painel Principal de Controle
cd /d "%~dp0.."

:CHECK_RUNTIME
call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" (
    cls
    echo =======================================================================
    echo   ATENCAO: GNU OCTAVE OU MATLAB NAO FORAM ENCONTRADOS NO SISTEMA!
    echo =======================================================================
    echo.
    echo O Mirage necessita do GNU Octave ou MathWorks MATLAB para rodar.
    echo.
    echo Como instalar o GNU Octave rapidamente:
    echo   1. Pelo terminal: winget install GNU.Octave
    echo   2. Pelo site oficial: https://octave.org/download
    echo =======================================================================
    set /p dl="Deseja abrir a pagina de download do Octave agora? (S/N): "
    if /i "%dl%"=="S" start https://octave.org/download
    echo.
    pause
    exit /b 1
)

:MENU
cls
echo =======================================================================
echo          MIRAGE: SIMULADOR TATICO COM ALGORITMOS GENETICOS
echo        Inimigos Virtuais que Aprendem a Desviar em Tempo Real
echo        UNISENAI - Engenharia de Controle e Automacao (Joinville)
echo =======================================================================
echo  Ambiente: %RUNTIME_NAME%
echo  Binario:  %RUNTIME_BIN%
echo  Status:   Pronto para Execucao Plug-and-Play
echo =======================================================================
echo.
echo  Selecione a opcao desejada:
echo.
echo   [1] Assistir NPC Campeao em Acao (Arena 2D Interativa)
echo   [2] Demonstracao Rapida no Modo Dificil (Bullet Hell Extremo)
echo   [3] Iniciar Treinamento do Algoritmo Genetico (Graficos em Tempo Real)
echo   [4] Gerar Todos os Graficos Cientificos e Testes Estatisticos
echo   [5] Gerar GIF Animado da Arena (data/graficos/demonstracao_npc.gif)
echo   [6] Executar Baterias de Teste em Paralelo (30x Headless)
echo   [7] Abrir Pasta de Graficos e Resultados Gerados
echo   [8] Abrir Pasta de Documentacao e Artigos Tecnicos
echo   [0] Sair
echo.
echo =======================================================================
set /p opt="Digite o numero da opcao (0-8) e pressione ENTER: "

if "%opt%"=="1" goto :ASSISTIR_INTERATIVO
if "%opt%"=="2" goto :ASSISTIR_DIFICIL
if "%opt%"=="3" goto :TREINAR_GA
if "%opt%"=="4" goto :GERAR_GRAFICOS
if "%opt%"=="5" goto :GERAR_GIF
if "%opt%"=="6" goto :PARALELO
if "%opt%"=="7" goto :ABRIR_GRAFICOS
if "%opt%"=="8" goto :ABRIR_DOCS
if "%opt%"=="0" exit /b 0

echo Opcao invalida!
timeout /t 2 >nul
goto :MENU

:ASSISTIR_INTERATIVO
echo.
echo Iniciando Arena 2D (Modo Interativo)...
if "%RUNTIME%"=="MATLAB" (
    "%RUNTIME_BIN%" -nosplash -r "addpath('src'); assistir_simulacao;"
) else (
    "%RUNTIME_BIN%" --persist --eval "addpath('src'); assistir_simulacao;"
)
goto :MENU

:ASSISTIR_DIFICIL
echo.
echo Iniciando Arena 2D com Campeao no Modo Dificil...
if "%RUNTIME%"=="MATLAB" (
    "%RUNTIME_BIN%" -nosplash -r "difficulty=3; addpath('src'); assistir_simulacao;"
) else (
    "%RUNTIME_BIN%" --persist --eval "difficulty=3; addpath('src'); assistir_simulacao;"
)
goto :MENU

:TREINAR_GA
echo.
echo Iniciando Treinamento Interativo do Algoritmo Genetico...
if "%RUNTIME%"=="MATLAB" (
    "%RUNTIME_BIN%" -nosplash -r "addpath('src'); npc_evasivo_ga;"
) else (
    "%RUNTIME_BIN%" --persist --eval "addpath('src'); npc_evasivo_ga;"
)
goto :MENU

:GERAR_GRAFICOS
echo.
echo Executando analises cientificas e testes de hipoteses...
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
