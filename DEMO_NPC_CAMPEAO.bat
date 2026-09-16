@echo off
chcp 65001 >nul
title MIRAGE - Arena 2D do NPC Campeao (Demonstracao)
cd /d "%~dp0"

echo =======================================================================
echo          MIRAGE: SIMULADOR TÁTICO COM ALGORITMOS GENÉTICOS
echo                 DEMONSTRAÇÃO DO NPC CAMPEÃO EVOLUÍDO
echo =======================================================================
echo.
echo Localizando GNU Octave no sistema...

call "scripts\detect_octave.bat"

if "%OCTAVE_FOUND%"=="0" goto :OCTAVE_NOT_FOUND

echo [OK] GNU Octave detectado: "%OCTAVE_BIN%"
echo.
echo Abrindo a Arena Gráfica 2D com o melhor cromossomo treinado...
echo (A janela gráfica abrirá em instantes. Divirta-se acompanhando o combate!)
echo.

"%OCTAVE_BIN%" --persist --eval "addpath('src'); assistir_simulacao;"
exit /b 0

:OCTAVE_NOT_FOUND
cls
echo =======================================================================
echo   ATENÇÃO: GNU OCTAVE NÃO FOI ENCONTRADO NO COMPUTADOR!
echo =======================================================================
echo.
echo O Mirage necessita do GNU Octave (software livre e gratuito) para
echo executar as simulações físicas, cinemática vetorial e renderização 2D.
echo.
echo OPÇÕES RÁPIDAS PARA INSTALAR:
echo.
echo [1] Instalação automática via Windows Terminal (Recomendado):
echo     Abra o Prompt de Comando ou PowerShell e digite:
echo     winget install GNU.Octave
echo.
echo [2] Download pelo instalador oficial:
echo     https://octave.org/download
echo.
echo =======================================================================
set /p opt="Deseja abrir a página de download do Octave agora? (S/N): "
if /i "%opt%"=="S" (
    start https://octave.org/download
)
echo.
echo Após instalar o Octave, basta clicar novamente neste arquivo.
pause
exit /b 1
