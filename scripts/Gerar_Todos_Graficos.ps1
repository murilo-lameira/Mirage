Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "GERADOR DE GRAFICOS E ANALISES - MIRAGE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Executando Octave (CLI) para analises..."

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path "$ScriptDir\.."

octave-cli --eval "addpath('src'); gerar_graficos_comparativos;"
octave-cli --eval "addpath('src'); analise_evolucao_media;"

Write-Host ""
Write-Host "Processo concluido! Verifique a pasta data/graficos/" -ForegroundColor Green
Pause

