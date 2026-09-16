Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "GERADOR DE GRAFICOS E ANALISES - MIRAGE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path "$ScriptDir\.."

# Localizacao dinamica do Octave CLI
$octaveCli = (Get-Command octave-cli.exe -ErrorAction SilentlyContinue).Source
if (-not $octaveCli) {
    $candidates = @(
        "$env:ProgramFiles\GNU Octave\Octave-*\mingw64\bin\octave-cli.exe",
        "${env:ProgramFiles(x86)}\GNU Octave\Octave-*\mingw64\bin\octave-cli.exe",
        "C:\Octave\Octave-*\mingw64\bin\octave-cli.exe",
        "D:\Octave\Octave-*\mingw64\bin\octave-cli.exe",
        "F:\Faculdade\Octave\Octave-*\mingw64\bin\octave-cli.exe"
    )
    foreach ($c in $candidates) {
        $found = Get-Item $c -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $octaveCli = $found.FullName
            break
        }
    }
}
if (-not $octaveCli) {
    $octaveCli = "octave-cli"
}

Write-Host "Executando Octave CLI ($octaveCli) para analises..." -ForegroundColor Gray

& $octaveCli --eval "addpath('src'); gerar_graficos_comparativos;"
& $octaveCli --eval "addpath('src'); analise_evolucao_media;"
& $octaveCli --eval "addpath('src'); gerar_heatmap_map_elites;"
& $octaveCli --eval "addpath('src'); gerar_boxplots;"
& $octaveCli --eval "addpath('src'); teste_estatistico_hipoteses;"

Write-Host ""
Write-Host "Processo concluido! Verifique a pasta data/graficos/" -ForegroundColor Green
Pause
