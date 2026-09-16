@echo off
:: ============================================================================
:: MIRAGE - DETECTOR AUTOMATICO DO GNU OCTAVE (UNIVERSAL)
:: ============================================================================
:: Este script localiza o executavel do GNU Octave no sistema operacional.
:: Ordem de busca:
::   1. Variavel de ambiente %OCTAVE_HOME% (caso definida)
::   2. Variavel de ambiente PATH (where octave.exe / octave-cli.exe / octave.bat)
::   3. Diretorios padroes de instalacao em C:, D:, E:, F: (incluindo Program Files)
::   4. Fallback inteligente via PowerShell para varrer unidades de disco
:: ============================================================================

set "OCTAVE_FOUND=0"
set "OCTAVE_BIN="
set "OCTAVE_CLI_BIN="

:: 1. Verifica variavel de ambiente OCTAVE_HOME, se existir
if defined OCTAVE_HOME (
    if exist "%OCTAVE_HOME%\mingw64\bin\octave.exe" (
        set "OCTAVE_BIN=%OCTAVE_HOME%\mingw64\bin\octave.exe"
        set "OCTAVE_CLI_BIN=%OCTAVE_HOME%\mingw64\bin\octave-cli.exe"
    ) else if exist "%OCTAVE_HOME%\octave.bat" (
        set "OCTAVE_BIN=%OCTAVE_HOME%\octave.bat"
        set "OCTAVE_CLI_BIN=%OCTAVE_HOME%\octave.bat"
    )
)

:: 2. Verifica no PATH do sistema
if not defined OCTAVE_BIN (
    for /f "delims=" %%i in ('where octave.exe 2^>nul') do (
        if not defined OCTAVE_BIN set "OCTAVE_BIN=%%i"
    )
)
if not defined OCTAVE_CLI_BIN (
    for /f "delims=" %%i in ('where octave-cli.exe 2^>nul') do (
        if not defined OCTAVE_CLI_BIN set "OCTAVE_CLI_BIN=%%i"
    )
)
if not defined OCTAVE_BIN (
    for /f "delims=" %%i in ('where octave.bat 2^>nul') do (
        if not defined OCTAVE_BIN set "OCTAVE_BIN=%%i"
    )
)

:: 3. Varre pastas padroes de instalacao nos drives mais comuns
if not defined OCTAVE_BIN (
    for %%D in (
        "%ProgramFiles%\GNU Octave"
        "%ProgramFiles(x86)%\GNU Octave"
        "C:\Program Files\GNU Octave"
        "C:\Octave"
        "D:\Octave"
        "E:\Octave"
        "F:\Octave"
        "F:\Faculdade\Octave"
        "%LOCALAPPDATA%\Programs\GNU Octave"
    ) do (
        if not defined OCTAVE_BIN (
            if exist "%%~D" (
                for /f "delims=" %%V in ('dir /b /ad "%%~D" 2^>nul') do (
                    if not defined OCTAVE_BIN (
                        if exist "%%~D\%%V\mingw64\bin\octave.exe" (
                            set "OCTAVE_BIN=%%~D\%%V\mingw64\bin\octave.exe"
                            set "OCTAVE_CLI_BIN=%%~D\%%V\mingw64\bin\octave-cli.exe"
                        ) else if exist "%%~D\%%V\octave.bat" (
                            set "OCTAVE_BIN=%%~D\%%V\octave.bat"
                            set "OCTAVE_CLI_BIN=%%~D\%%V\octave.bat"
                        )
                    )
                )
            )
        )
    )
)

:: 4. Fallback via PowerShell caso ainda nao tenha localizado
if not defined OCTAVE_BIN (
    for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-Item ('C:','D:','E:','F:','G:' | ForEach-Object { \"$_\\*Octave*\\mingw64\\bin\\octave.exe\" }) -ErrorAction SilentlyContinue | Select-Object -First 1).FullName" 2^>nul') do (
        if not defined OCTAVE_BIN (
            set "OCTAVE_BIN=%%i"
            set "OCTAVE_CLI_BIN=%%~dpi\octave-cli.exe"
        )
    )
)

:: 5. Se encontrou GUI mas nao CLI, reutiliza GUI
if defined OCTAVE_BIN (
    set "OCTAVE_FOUND=1"
    if not defined OCTAVE_CLI_BIN set "OCTAVE_CLI_BIN=%OCTAVE_BIN%"
    exit /b 0
)

:: Caso nao tenha encontrado nenhum binario
set "OCTAVE_FOUND=0"
exit /b 1
