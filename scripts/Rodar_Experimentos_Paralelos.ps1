# =========================================================================
# ?? EXECUTOR PARALELO DE EXPERIMENTOS (MIRAGE - ALGORITMOS GEN�TICOS)
# =========================================================================
# Executa 10 rodadas de treinamento para as 3 dificuldades simultaneamente
# utilizando m�ltiplos processos em segundo plano do GNU Octave.
# =========================================================================

$ErrorActionPreference = "Continue"

# Localizacao dinamica do Octave CLI
$octavePath = (Get-Command octave-cli.exe -ErrorAction SilentlyContinue).Source
if (-not $octavePath) {
    $octavePath = (Get-Command octave.exe -ErrorAction SilentlyContinue).Source
}
if (-not $octavePath) {
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
            $octavePath = $found.FullName
            break
        }
    }
}

if (-not $octavePath -or -not (Test-Path $octavePath)) {
    Write-Host "ERRO: GNU Octave nao encontrado automaticamente no sistema!" -ForegroundColor Red
    Write-Host "Por favor, instale o GNU Octave ou adicione-o ao PATH do Windows." -ForegroundColor Yellow
    Exit 1
}
$numRuns = 10

$logsDir = Join-Path (Split-Path $PSScriptRoot -Parent) "logs"
if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "     INICIANDO 30 EXPERIMENTOS EM PARALELO (10x CADA MODO)     " -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Processos Paralelos:" -ForegroundColor Gray
Write-Host "  -> Worker 1: Dificuldade F�cil (1)  - 10 Rodadas" -ForegroundColor Green
Write-Host "  -> Worker 2: Dificuldade M�dio (2)  - 10 Rodadas" -ForegroundColor Yellow
Write-Host "  -> Worker 3: Dificuldade Dif�cil (3) - 10 Rodadas" -ForegroundColor Red
Write-Host "----------------------------------------------------------------" -ForegroundColor Gray

$workers = @(
    @{ Diff = 1; Name = "F�cil (1)"; Log = (Join-Path $logsDir "worker_diff1.log"); ErrLog = (Join-Path $logsDir "worker_diff1_err.log") },
    @{ Diff = 2; Name = "M�dio (2)"; Log = (Join-Path $logsDir "worker_diff2.log"); ErrLog = (Join-Path $logsDir "worker_diff2_err.log") },
    @{ Diff = 3; Name = "Dif�cil (3)"; Log = (Join-Path $logsDir "worker_diff3.log"); ErrLog = (Join-Path $logsDir "worker_diff3_err.log") }
)

$processes = @()
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($w in $workers) {
    if (Test-Path $w.Log) { Remove-Item $w.Log -Force }
    if (Test-Path $w.ErrLog) { Remove-Item $w.ErrLog -Force }
    
    $cmd = "addpath('src'); run_batch_experiment($($w.Diff), $numRuns);"
    $proc = Start-Process -FilePath $octavePath -ArgumentList "--eval `"$cmd`"" -WorkingDirectory (Split-Path $PSScriptRoot -Parent) -RedirectStandardOutput $w.Log -RedirectStandardError $w.ErrLog -PassThru -NoNewWindow
    
    $w.Process = $proc
    $processes += $w
}


Write-Host "Todos os 3 processos foram iniciados com sucesso! Monitorando progresso..." -ForegroundColor Cyan
Write-Host ""

$completed = 0
while ($completed -lt 3) {
    Start-Sleep -Seconds 3
    $elapsed = [math]::Round($stopwatch.Elapsed.TotalSeconds, 1)
    
    Clear-Host
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "   PAINEL DE EXECU��O PARALELA (Tempo Decorrido: ${elapsed}s)   " -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Cyan
    
    $completed = 0
    foreach ($w in $processes) {
        $p = $w.Process
        $status = if ($p.HasExited) { 
            $completed++
            if ($p.ExitCode -eq 0) { "[ CONCLU�DO ]" } else { "[ ERRO ]" }
        } else { 
            "[ EM ANDAMENTO ]" 
        }
        
        $color = if ($p.HasExited) { "Green" } else { "Cyan" }
        Write-Host "$($w.Name) : $status" -ForegroundColor $color
        
        if (Test-Path $w.Log) {
            $lastLines = Get-Content $w.Log -Tail 2 -ErrorAction SilentlyContinue
            foreach ($line in $lastLines) {
                Write-Host "    $line" -ForegroundColor Gray
            }
        }
        Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
    }
}

$stopwatch.Stop()
$totalSec = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2)

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host "   TODOS OS 30 EXPERIMENTOS FORAM CONCLU�DOS EM ${totalSec}s!   " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host "Os dados foram registrados no arquivo data/resultados_experimentos.csv`n" -ForegroundColor White

Write-Host "Gerando gr�ficos comparativos..." -ForegroundColor Yellow
Start-Process -FilePath $octaveGuiPath -ArgumentList "--persist src/gerar_graficos_comparativos.m" -WorkingDirectory (Split-Path $PSScriptRoot -Parent)

