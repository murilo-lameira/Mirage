% =========================================================================
% 📊 GERADOR DE GRÁFICOS COMPARATIVOS DO ALGORITMO GENÉTICO (MIRAGE)
% =========================================================================
% Lê o histórico em 'resultados_experimentos.csv' e plota comparações visuais,
% salvando-as automaticamente na pasta 'data/graficos/' para relatórios e slides.
% =========================================================================

clc; clear; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

csv_filename = fullfile('data', 'resultados_experimentos.csv');
if ~exist(csv_filename, 'file')
    error('Arquivo data/resultados_experimentos.csv nao encontrado. Execute alguns treinamentos antes!');
end

% Garante que a pasta de gráficos existe
output_dir = fullfile('data', 'graficos');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

fprintf('Lendo dados de %s...\n', csv_filename);

% Abre e lê o arquivo CSV linha a linha
fid = fopen(csv_filename, 'r');
header_line = fgetl(fid);

data_entries = [];
while ~feof(fid)
    line = fgetl(fid);
    if ischar(line) && ~isempty(strtrim(line))
        tokens = strsplit(line, ',');
            if length(tokens) >= 11
                % Converte valores numéricos a partir da coluna 2 (Dificuldade)
                num_row = zeros(1, min(15, length(tokens) - 1));
                for k = 2:min(16, length(tokens))
                    num_row(k-1) = str2double(tokens{k});
                end
                if length(num_row) == 15
                    data_entries = [data_entries; num_row];
                end
            end
    end
end
fclose(fid);

if isempty(data_entries)
    error('Nenhum dado valido encontrado no CSV.');
end

fprintf('Total de experimentos carregados: %d\n', size(data_entries, 1));

% Agrupamento por Dificuldade (1: Facil, 2: Medio, 3: Dificil)
diffs = data_entries(:, 1);
unique_diffs = unique(diffs);

% 1. FIGURA 1: Perfil de Genes dos Elites por Dificuldade
fig1 = figure('Name', 'Comparativo de Genes por Dificuldade', 'Position', [100, 100, 900, 500]);

genes_mean = zeros(length(unique_diffs), 4);
diff_labels = {};

for d = 1:length(unique_diffs)
    dif_val = unique_diffs(d);
    idx = find(diffs == dif_val);
    % Genes: HP (col 6), Atk (col 7), AtkSpd (col 8), MovSpd (col 9)
    genes_mean(d, 1) = mean(data_entries(idx, 6)); % HP
    genes_mean(d, 2) = mean(data_entries(idx, 7)); % Atk
    genes_mean(d, 3) = mean(data_entries(idx, 8)); % AtkSpd
    genes_mean(d, 4) = mean(data_entries(idx, 9)); % MovSpd
    
    if dif_val == 1
        diff_labels{d} = 'Fácil (1)';
    elseif dif_val == 2
        diff_labels{d} = 'Médio (2)';
    else
        diff_labels{d} = 'Difícil (3)';
    end
end

subplot(2, 2, 1);
bar(genes_mean(:, 1), 'FaceColor', [0.2 0.7 0.3]);
set(gca, 'XTickLabel', diff_labels);
title('HP Máximo do Campeão');
ylabel('Pontos de Vida'); grid on;

subplot(2, 2, 2);
bar(genes_mean(:, 2), 'FaceColor', [0.85 0.3 0.2]);
set(gca, 'XTickLabel', diff_labels);
title('Poder de Ataque');
ylabel('Dano Base'); grid on;

subplot(2, 2, 3);
bar(genes_mean(:, 3), 'FaceColor', [0.9 0.6 0.1]);
set(gca, 'XTickLabel', diff_labels);
title('Velocidade de Ataque');
ylabel('Frequência (Hz)'); grid on;

subplot(2, 2, 4);
bar(genes_mean(:, 4), 'FaceColor', [0.2 0.5 0.9]);
set(gca, 'XTickLabel', diff_labels);
title('Velocidade de Movimento (Esquiva)');
ylabel('Velocidade (m/s)'); grid on;

% Salva Figura 1
fig1_path = fullfile(output_dir, 'comparativo_genes.png');
print(fig1, fig1_path, '-dpng');
fprintf('-> Gráfico de Genes salvo em: %s\n', fig1_path);

% 2. FIGURA 2: Fitness Máximo vs Médio por Dificuldade
fig2 = figure('Name', 'Comparativo de Fitness por Dificuldade', 'Position', [150, 150, 750, 450]);
fit_max_mean = zeros(length(unique_diffs), 1);
fit_pop_mean = zeros(length(unique_diffs), 1);

for d = 1:length(unique_diffs)
    dif_val = unique_diffs(d);
    idx = find(diffs == dif_val);
    fit_max_mean(d) = mean(data_entries(idx, 4)); % Fitness Max
    fit_pop_mean(d) = mean(data_entries(idx, 5)); % Fitness Medio
end

b = bar([fit_max_mean, fit_pop_mean]);
set(gca, 'XTickLabel', diff_labels);
title('Evolução do Fitness por Nível de Dificuldade');
ylabel('Pontuação de Fitness');
legend('Fitness Máximo (Campeão)', 'Fitness Médio da População', 'Location', 'northwest');
grid on;

% Salva Figura 2
fig2_path = fullfile(output_dir, 'comparativo_fitness.png');
print(fig2, fig2_path, '-dpng');
fprintf('-> Gráfico de Fitness salvo em: %s\n', fig2_path);

fprintf('\n>>> Todos os gráficos foram gerados e salvos em %s! <<<\n', output_dir);
