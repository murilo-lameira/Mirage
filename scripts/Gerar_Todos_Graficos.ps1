Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "GERADOR DE GRAFICOS E ANALISES - MIRAGE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Executando Octave (CLI) para analises..."

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path "$ScriptDir\.."

octave-cli --eval "addpath('src'); gerar_graficos_comparativos;"
octave-cli --eval "addpath('src'); analise_evolucao_media;"
octave-cli --eval "addpath('src'); gerar_heatmap_map_elites;"
octave-cli --eval "addpath('src'); gerar_boxplots;"
octave-cli --eval "addpath('src'); teste_estatistico_hipoteses;"

Write-Host ""
Write-Host "Processo concluido! Verifique a pasta data/graficos/" -ForegroundColor Green
Pause

