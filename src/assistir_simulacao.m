% =========================================================================
% 🎮 ASSISTIR SIMULAÇÃO VISUAL: CAMPEÃO DO ALGORITMO GENÉTICO (MIRAGE)
% =========================================================================
% Carrega o melhor NPC treinado de 'resultados_experimentos.csv' (ou usa um
% genoma padrão evoluído) e executa a arena gráfica interativa em tempo real.
% =========================================================================

clc; clear; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

fprintf('======================================================\n');
fprintf('>>> SIMULADOR VISUAL DO NPC EVASIVO (MIRAGE) <<<\n');
fprintf('======================================================\n');

% 1. Escolha a Dificuldade para o Teste Visual
difficulty = menu('Escolha a Dificuldade da Arena para Assistir:', ...
                  'Fácil (Tiros Lentos e Esparsos)', ...
                  'Médio (Balanceado)', ...
                  'Difícil (Bullet Hell Intenso)');

if difficulty == 0
    difficulty = 2; % Padrão: Médio
end

csv_filename = fullfile('data', 'resultados_experimentos.csv');
melhor_cromossomo = [100, 15, 1.5, 6.0]; % Padrão caso não haja CSV

if exist(csv_filename, 'file') == 2
    fid = fopen(csv_filename, 'r');
    fgetl(fid); % Pula cabeçalho
    
    maior_fit = -1;
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && ~isempty(strtrim(line))
            tokens = strsplit(line, ',');
            if length(tokens) >= 10
                dif_csv = str2double(tokens{2});
                fit_csv = str2double(tokens{5});
                % Prioriza o campeão da dificuldade escolhida ou o melhor absoluto
                if dif_csv == difficulty && fit_csv > maior_fit
                    maior_fit = fit_csv;
                    hp = str2double(tokens{7});
                    atk = str2double(tokens{8});
                    atk_spd = str2double(tokens{9});
                    mov_spd = str2double(tokens{10});
                    melhor_cromossomo = [hp, atk, atk_spd, mov_spd];
                end
            end
        end
    end
    fclose(fid);
end

fprintf('\nExecutando Simulação com o NPC Campeão:\n');
fprintf('  HP Máximo: %d\n', round(melhor_cromossomo(1)));
fprintf('  Poder de Ataque: %d\n', round(melhor_cromossomo(2)));
fprintf('  Velocidade de Ataque: %.2f Hz\n', melhor_cromossomo(3));
fprintf('  Velocidade de Desvio: %.2f m/s\n', melhor_cromossomo(4));
fprintf('======================================================\n');
fprintf('A janela de animação abrirá agora! Acompanhe o combate...\n\n');

% Roda a simulação visual
simulate_episode(melhor_cromossomo, true, difficulty);

fprintf('\nSimulação finalizada com sucesso!\n');

