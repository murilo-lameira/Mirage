@echo off
cd %~dp0..
echo Abrindo Simulador Visual do NPC Campeao...
"F:\Faculdade\Octave\Octave-11.3.0\mingw64\bin\octave.exe" --persist --eval "addpath('src'); assistir_simulacao;"

