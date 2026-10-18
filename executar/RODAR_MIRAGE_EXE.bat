@echo off
setlocal
title Mirage - Executavel Standalone Windows (.exe)
echo ===============================================================================
echo            PROJETO MIRAGE - EXECUTAVEL STANDALONE (WINDOWS)
echo ===============================================================================
cd /d "%~dp0\.."
if not exist "dist\Mirage.exe" (
    echo [AVISO] O executavel Mirage.exe nao foi encontrado na pasta dist.
    echo Executando compilacao automatica...
    call "executar\COMPILAR_EXE.bat"
)
if exist "dist\Mirage.exe" (
    start "" "dist\Mirage.exe"
) else (
    echo [ERRO] Nao foi possivel iniciar o Mirage.exe.
    pause
)
