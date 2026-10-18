@echo off
setlocal enabledelayedexpansion
title Mirage - Compilador Standalone Executavel Windows
echo ===============================================================================
echo            PROJETO MIRAGE - GERADOR DE EXECUTAVEL STANDALONE
echo ===============================================================================
echo.

cd /d "%~dp0\.."

echo [1/3] Verificando ambiente Python e PyInstaller...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao foi localizado no PATH do sistema.
    pause
    exit /b 1
)

pyinstaller --version >nul 2>&1
if errorlevel 1 (
    echo [AVISO] PyInstaller nao encontrado diretamente no PATH. Tentando via python -m PyInstaller...
    set PYINSTALLER_CMD=python -m PyInstaller
) else (
    set PYINSTALLER_CMD=pyinstaller
)

echo [2/3] Compilando Mirage.exe via PyInstaller com Mirage.spec...
echo       Aguarde alguns instantes enquanto os modulos cientificos sao empacotados...
echo.

%PYINSTALLER_CMD% --clean Mirage.spec
if errorlevel 1 (
    echo.
    echo [ERRO] Falha durante o processo de compilacao do PyInstaller.
    pause
    exit /b 1
)

echo.
echo [3/3] Sincronizando pasta de dados (data) com a pasta de distribuicao (dist)...
if not exist "dist\data" (
    mkdir "dist\data"
)
xcopy /E /I /Y /Q "data" "dist\data" >nul 2>&1

echo.
echo ===============================================================================
echo [SUCESSO] Executavel compilado com exito!
echo Localizacao: %CD%\dist\Mirage.exe
echo ===============================================================================
echo.
pause
