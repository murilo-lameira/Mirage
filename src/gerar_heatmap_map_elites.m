% =========================================================================
% 🗺️ HEATMAP DE QUALIDADE E DIVERSIDADE (MAP-ELITES) - MIRAGE
% =========================================================================
% Lê 'data/map_elites.csv' e renderiza um mapa de calor 2D (3x3)
% representando os nichos de classes de combate e mobilidade descobertos.
% =========================================================================

clc; clear; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

csv_file = fullfile('data', 'map_elites.csv');
if exist(csv_file, 'file') ~= 2
    error('Arquivo data/map_elites.csv nao encontrado. Execute alguns treinamentos primeiro!');
end

output_dir = fullfile('data', 'graficos');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

fprintf('Processando nichos do MAP-Elites de %s...\n', csv_file);

% Matriz 3x3: Linhas = [Lento, Medio, Rapido], Colunas = [Tank, Balanceado, Dano]
grid_fit = zeros(3, 3);
grid_hp = zeros(3, 3);
grid_atk = zeros(3, 3);
grid_spd = zeros(3, 3);
grid_count = zeros(3, 3);

fid = fopen(csv_file, 'r');
fgetl(fid); % Pula cabeçalho

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line) && ~isempty(strtrim(line))
        tokens = strsplit(line, ',');
        if length(tokens) >= 10
            mob_str = strtrim(tokens{4});
            cls_str = strtrim(tokens{5});
            fit_val = str2double(tokens{6});
            hp_val = str2double(tokens{7});
            atk_val = str2double(tokens{8});
            spd_val = str2double(tokens{10});
            
            % Mapeia Linha (Mobilidade)
            if strcmpi(mob_str, 'Lento')
                r = 1;
            elseif strcmpi(mob_str, 'Medio')
                r = 2;
            else
                r = 3;
            end
            
            % Mapeia Coluna (Classe)
            if strcmpi(cls_str, 'Tank')
                c = 1;
            elseif strcmpi(cls_str, 'Balanceado')
                c = 2;
            else
                c = 3;
            end
            
            if fit_val > grid_fit(r, c)
                grid_fit(r, c) = fit_val;
                grid_hp(r, c) = hp_val;
                grid_atk(r, c) = atk_val;
                grid_spd(r, c) = spd_val;
            end
            grid_count(r, c) = grid_count(r, c) + 1;
        end
    end
end
fclose(fid);

% Criação da Figura
fig = figure('Name', 'Heatmap MAP-Elites (Quality-Diversity)', 'Position', [150, 150, 850, 600]);

imagesc(grid_fit);
colormap('summer');
cb = colorbar();
ylabel(cb, 'Aptidão Máxima (Fitness)', 'FontSize', 11, 'FontWeight', 'bold');

row_names = {'Lento (< 4.5 m/s)', 'Médio (4.5 a 6.5 m/s)', 'Rápido (> 6.5 m/s)'};
col_names = {'Tank (HP/Atk > 3)', 'Balanceado', 'Glass Cannon (HP/Atk < 1)'};

set(gca, 'XTick', 1:3, 'XTickLabel', col_names, 'FontSize', 10, 'FontWeight', 'bold');
set(gca, 'YTick', 1:3, 'YTickLabel', row_names, 'FontSize', 10, 'FontWeight', 'bold');
title('Grade MAP-Elites: Nichos Fenotípicos & Fitness dos Elites', 'FontSize', 13, 'FontWeight', 'bold');

% Adiciona anotações textuais informativas em cada célula
for r = 1:3
    for c = 1:3
        if grid_fit(r, c) > 0
            txt = sprintf('Fit: %.1f\nHP: %d | Atk: %d\nSpd: %.2f m/s\n(%d registros)', ...
                grid_fit(r, c), round(grid_hp(r, c)), round(grid_atk(r, c)), grid_spd(r, c), grid_count(r, c));
            text(c, r, txt, 'HorizontalAlignment', 'center', 'Color', 'k', ...
                'FontSize', 10, 'FontWeight', 'bold');
        else
            text(c, r, 'Não Descoberto', 'HorizontalAlignment', 'center', ...
                'Color', [0.4 0.4 0.4], 'FontSize', 10, 'FontAngle', 'italic');
        end
    end
end

grid on;
set(gca, 'GridColor', 'w', 'GridAlpha', 0.6);

output_png = fullfile(output_dir, 'map_elites_heatmap.png');
print(fig, output_png, '-dpng');
close(fig);

fprintf('-> Heatmap do MAP-Elites gerado com sucesso em: %s\n', output_png);

