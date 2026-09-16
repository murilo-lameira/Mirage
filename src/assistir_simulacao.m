% =========================================================================
% 🎮 ASSISTIR SIMULAÇÃO VISUAL: CAMPEÃO DO ALGORITMO GENÉTICO (MIRAGE)
% =========================================================================
% Carrega o melhor NPC treinado de 'resultados_experimentos.csv' (ou usa um
% genoma padrão evoluído) e executa a arena gráfica interativa em tempo real.
% =========================================================================

if exist('difficulty', 'var')
    preset_difficulty = difficulty;
end

clc; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

if exist('preset_difficulty', 'var')
    difficulty = preset_difficulty;
end

fprintf('======================================================\n');
fprintf('>>> SIMULADOR VISUAL DO NPC EVASIVO (MIRAGE) <<<\n');
fprintf('======================================================\n');

% 1. Escolha a Dificuldade para o Teste Visual (se não pré-definida)
if ~exist('difficulty', 'var') || isempty(difficulty)
    try
        difficulty = menu('Escolha a Dificuldade da Arena para Assistir:', ...
                          'Fácil (Tiros Lentos e Esparsos)', ...
                          'Médio (Balanceado)', ...
                          'Difícil (Bullet Hell Intenso)');
    catch
        difficulty = 2;
    end
    if isempty(difficulty) || difficulty == 0
        difficulty = 2; % Padrão: Médio
    end
end

diff_names = {'Fácil', 'Médio', 'Difícil'};
fprintf('Dificuldade Selecionada: %s (%d)\n', diff_names{difficulty}, difficulty);

% Resolução robusta de caminho para o CSV de resultados
script_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(script_dir);
csv_filename = fullfile(project_root, 'data', 'resultados_experimentos.csv');
if exist(csv_filename, 'file') ~= 2
    csv_filename = fullfile('data', 'resultados_experimentos.csv');
end

melhor_cromossomo = [100, 15, 1.5, 6.0]; % Genoma base padrão
origem_campeao = 'Genoma Padrão de Fábrica';
maior_fit = -1;

if exist(csv_filename, 'file') == 2
    fid = fopen(csv_filename, 'r');
    fgetl(fid); % Pula cabeçalho
    
    todos_dados = {};
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && ~isempty(strtrim(line))
            tokens = strsplit(line, ',');
            if length(tokens) >= 10
                todos_dados{end+1} = tokens;
                dif_csv = str2double(tokens{2});
                fit_csv = str2double(tokens{5});
                % Prioriza o campeão da dificuldade escolhida
                if dif_csv == difficulty && fit_csv > maior_fit
                    maior_fit = fit_csv;
                    hp = str2double(tokens{7});
                    atk = str2double(tokens{8});
                    atk_spd = str2double(tokens{9});
                    mov_spd = str2double(tokens{10});
                    melhor_cromossomo = [hp, atk, atk_spd, mov_spd];
                    origem_campeao = sprintf('Campeão da Dificuldade %d (Fitness: %.1f)', difficulty, maior_fit);
                end
            end
        end
    end
    fclose(fid);
    
    % Se não encontrou campeão exato para esta dificuldade, busca o melhor absoluto de qualquer dificuldade
    if maior_fit == -1 && ~isempty(todos_dados)
        for k = 1:length(todos_dados)
            tok = todos_dados{k};
            fit_csv = str2double(tok{5});
            if fit_csv > maior_fit
                maior_fit = fit_csv;
                hp = str2double(tok{7});
                atk = str2double(tok{8});
                atk_spd = str2double(tok{9});
                mov_spd = str2double(tok{10});
                melhor_cromossomo = [hp, atk, atk_spd, mov_spd];
                origem_campeao = sprintf('Campeão Global da Dificuldade %s (Fitness: %.1f)', tok{2}, maior_fit);
            end
        end
    end
end

fprintf('\nExecutando Simulação com o NPC Campeão:\n');
fprintf('  Origem: %s\n', origem_campeao);
fprintf('  HP Máximo: %d\n', round(melhor_cromossomo(1)));
fprintf('  Poder de Ataque: %d\n', round(melhor_cromossomo(2)));
fprintf('  Velocidade de Ataque: %.2f Hz\n', melhor_cromossomo(3));
fprintf('  Velocidade de Desvio: %.2f m/s\n', melhor_cromossomo(4));
fprintf('======================================================\n');
fprintf('A janela de animação abrirá agora! Acompanhe o combate...\n\n');

% Roda a simulação visual
simulate_episode(melhor_cromossomo, true, difficulty);

fprintf('\nSimulação finalizada com sucesso!\n');

