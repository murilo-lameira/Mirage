@echo off
REM ===========================================================================
REM MIRAGE - DETECTOR UNIVERSAL DE AMBIENTE NUMERICO (OCTAVE E MATLAB)
REM ===========================================================================

set "OCTAVE_FOUND=0"
set "RUNTIME=NONE"
set "RUNTIME_NAME="
set "RUNTIME_BIN="
set "OCTAVE_BIN="
set "OCTAVE_CLI_BIN="

REM 1. Verifica variavel de ambiente OCTAVE_HOME
if defined OCTAVE_HOME (
    if exist "%OCTAVE_HOME%\mingw64\bin\octave.exe" (
        set "OCTAVE_BIN=%OCTAVE_HOME%\mingw64\bin\octave.exe"
        set "OCTAVE_CLI_BIN=%OCTAVE_HOME%\mingw64\bin\octave-cli.exe"
    ) else if exist "%OCTAVE_HOME%\octave.bat" (
        set "OCTAVE_BIN=%OCTAVE_HOME%\octave.bat"
        set "OCTAVE_CLI_BIN=%OCTAVE_HOME%\octave.bat"
    )
)

REM 2. Verifica no PATH do sistema
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

REM 3. Varre pastas padroes de instalacao do GNU Octave
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

REM 4. Fallback via PowerShell para varrer unidades de disco
if not defined OCTAVE_BIN (
    for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-Item ('C:','D:','E:','F:','G:' | ForEach-Object { \"$_\\*Octave*\\mingw64\\bin\\octave.exe\" }) -ErrorAction SilentlyContinue | Select-Object -First 1).FullName" 2^>nul') do (
        if not defined OCTAVE_BIN (
            set "OCTAVE_BIN=%%i"
            set "OCTAVE_CLI_BIN=%%~dpi\octave-cli.exe"
        )
    )
)

REM 5. Se encontrou Octave com sucesso
if defined OCTAVE_BIN (
    set "OCTAVE_FOUND=1"
    set "RUNTIME=OCTAVE"
    set "RUNTIME_NAME=GNU Octave"
    set "RUNTIME_BIN=%OCTAVE_BIN%"
    if not defined OCTAVE_CLI_BIN set "OCTAVE_CLI_BIN=%OCTAVE_BIN%"
    exit /b 0
)

REM ===========================================================================
REM FASE 2: PROCURAR MATHWORKS MATLAB (SE OCTAVE NAO FOI ENCONTRADO)
REM ===========================================================================

set "MATLAB_BIN="

REM 2.1 Verifica PATH
for /f "delims=" %%i in ('where matlab.exe 2^>nul') do (
    if not defined MATLAB_BIN set "MATLAB_BIN=%%i"
)

REM 2.2 Verifica %MATLAB_HOME%
if not defined MATLAB_BIN (
    if defined MATLAB_HOME (
        if exist "%MATLAB_HOME%\bin\matlab.exe" set "MATLAB_BIN=%MATLAB_HOME%\bin\matlab.exe"
    )
)

REM 2.3 Varre pastas padroes do MATLAB
if not defined MATLAB_BIN (
    for %%D in (
        "%ProgramFiles%\MATLAB"
        "%ProgramFiles(x86)%\MATLAB"
        "C:\Program Files\MATLAB"
        "D:\MATLAB"
        "E:\MATLAB"
    ) do (
        if not defined MATLAB_BIN (
            if exist "%%~D" (
                for /f "delims=" %%V in ('dir /b /ad "%%~D" 2^>nul') do (
                    if not defined MATLAB_BIN (
                        if exist "%%~D\%%V\bin\matlab.exe" (
                            set "MATLAB_BIN=%%~D\%%V\bin\matlab.exe"
                        )
                    )
                )
            )
        )
    )
)

if defined MATLAB_BIN (
    set "OCTAVE_FOUND=1"
    set "RUNTIME=MATLAB"
    set "RUNTIME_NAME=MathWorks MATLAB"
    set "RUNTIME_BIN=%MATLAB_BIN%"
    set "OCTAVE_BIN=%MATLAB_BIN%"
    set "OCTAVE_CLI_BIN=%MATLAB_BIN%"
    exit /b 0
)

REM ===========================================================================
REM FASE 3: NENHUM ENCONTRADO
REM ===========================================================================
set "OCTAVE_FOUND=0"
set "RUNTIME=NONE"
exit /b 1
