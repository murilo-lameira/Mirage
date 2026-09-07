% =========================================================================
% 🎞️ GERADOR DE GIF ANIMADO DE COMBATE (DEMONSTRAÇÃO DO NPC) - MIRAGE
% =========================================================================
% Simula uma sequência de ação com o melhor NPC treinado e salva um arquivo
% GIF animado em 'data/graficos/demonstracao_npc.gif' para uso no README e slides.
% =========================================================================

clc; clear; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

fprintf('======================================================\n');
fprintf('>>> GERADOR DE GIF ANIMADO: DEMONSTRACAO TÁTICA <<<\n');
fprintf('======================================================\n');

output_dir = fullfile('data', 'graficos');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

gif_path = fullfile(output_dir, 'demonstracao_npc.gif');
csv_filename = fullfile('data', 'resultados_experimentos.csv');

% Genoma padrão de alta performance caso não haja CSV
champion = [80, 30, 2.0, 4.5];
highest_fit = -1;
best_diff = 2;

if exist(csv_filename, 'file') == 2
    fid = fopen(csv_filename, 'r');
    fgetl(fid);
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && ~isempty(strtrim(line))
            tokens = strsplit(line, ',');
            if length(tokens) >= 10
                fit_val = str2double(tokens{5});
                if fit_val > highest_fit
                    highest_fit = fit_val;
                    best_diff = str2double(tokens{2});
                    hp = str2double(tokens{7});
                    atk = str2double(tokens{8});
                    atk_spd = str2double(tokens{9});
                    mov_spd = str2double(tokens{10});
                    champion = [hp, atk, atk_spd, mov_spd];
                end
            end
        end
    end
    fclose(fid);
end

fprintf('Campeão Selecionado (Dificuldade %d, Fitness: %.1f):\n', best_diff, highest_fit);
fprintf('  HP: %d | Ataque: %d | Cadência: %.2f Hz | Esquiva: %.2f m/s\n', ...
    round(champion(1)), round(champion(2)), champion(3), champion(4));
fprintf('Gravando 8 segundos de combate em 15 FPS para o GIF...\n');

% Executa simulação gravando o GIF
simulate_episode(champion, true, best_diff, gif_path);

if exist(gif_path, 'file') == 2
    s = dir(gif_path);
    fprintf('\n-> GIF animado gerado com sucesso!\n');
    fprintf('   Arquivo: %s (Tamanho: %.2f KB)\n', gif_path, s.bytes / 1024);
else
    fprintf('\nAviso: Verifique a gravação do arquivo GIF.\n');
end

