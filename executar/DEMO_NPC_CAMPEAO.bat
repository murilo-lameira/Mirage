@echo off
setlocal enabledelayedexpansion
title MIRAGE - Arena 2D do NPC Campeao (Demonstracao)
cd /d "%~dp0.."

echo =======================================================================
echo          MIRAGE: SIMULADOR TATICO COM ALGORITMOS GENETICOS
echo                 DEMONSTRACAO DO NPC CAMPEAO EVOLUIDO
echo =======================================================================
echo.
echo Localizando GNU Octave ou MATLAB no sistema...

call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" goto :RUNTIME_NOT_FOUND

echo [OK] Ambiente detectado: %RUNTIME_NAME%
echo      Binario: "%RUNTIME_BIN%"
echo.
echo Abrindo a Arena Grafica 2D com o melhor cromossomo treinado...
echo.

if "%RUNTIME%"=="MATLAB" (
    "%RUNTIME_BIN%" -nosplash -r "addpath('src'); assistir_simulacao;"
) else (
    "%RUNTIME_BIN%" --persist --eval "addpath('src'); assistir_simulacao;"
)
exit /b 0

:RUNTIME_NOT_FOUND
cls
echo =======================================================================
echo   ATENCAO: GNU OCTAVE OU MATLAB NAO FORAM ENCONTRADOS!
echo =======================================================================
echo.
echo O Mirage necessita do GNU Octave (gratuito) ou MathWorks MATLAB.
echo.
echo OPCOES RAPIDAS PARA INSTALAR:
echo.
echo [1] Instalacao automatica do GNU Octave via terminal (Recomendado):
echo     winget install GNU.Octave
echo.
echo [2] Download pelo instalador oficial gratuito do Octave:
echo     https://octave.org/download
echo.
echo Se voce utiliza MATLAB, adicione a pasta 'bin' do MATLAB ao PATH.
echo =======================================================================
set /p opt="Deseja abrir a pagina oficial de download do Octave agora? (S/N): "
if /i "%opt%"=="S" (
    start https://octave.org/download
)
echo.
pause
exit /b 1
