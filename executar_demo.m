% =========================================================================
% 🎮 EXECUTAR_DEMO: ARENA 2D DO NPC CAMPEÃO (PROJETO MIRAGE)
% =========================================================================
% Compatível com MathWorks MATLAB e GNU Octave.
%
% COMO USAR NO MATLAB:
%   - Clique em 'Run' (F5) ou digite 'executar_demo' no Command Window.
% =========================================================================

clear; close all; clc;

% Configuração automática de caminhos do projeto
root_dir = fileparts(mfilename('fullpath'));
cd(root_dir);
addpath(fullfile(root_dir, 'src'));

fprintf('\n======================================================\n');
fprintf('>>> PROJETO MIRAGE: DEMONSTRAÇÃO DO NPC CAMPEÃO <<<\n');
fprintf('======================================================\n');
fprintf('Carregando Arena 2D com o melhor cromossomo treinado...\n\n');

% Executa a arena visual interativa
assistir_simulacao;
