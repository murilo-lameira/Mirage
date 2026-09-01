% =========================================================================
% 📊 ANALISADOR DE EVOLUÇÃO MÉDIA DO ALGORITMO GENÉTICO (MIRAGE)
% =========================================================================
% Lê o histórico em 'historico_geracoes.csv' e plota a curva média de 
% aprendizado para cada nível de dificuldade.
% =========================================================================

clc; clear; close all;
warning('off', 'all');
try graphics_toolkit('qt'); catch; end;
addpath(fileparts(mfilename('fullpath')));

csv_filename = fullfile('data', 'historico_geracoes.csv');
if ~exist(csv_filename, 'file')
    error('Arquivo data/historico_geracoes.csv não encontrado. Rode novos treinamentos (lotes ou unicos) primeiro para gerar o arquivo!');
end

output_dir = fullfile('data', 'graficos');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

fprintf('Lendo dados de %s...\n', csv_filename);

fid = fopen(csv_filename, 'r');
header_line = fgetl(fid);

data_entries = [];
while ~feof(fid)
    line = fgetl(fid);
    if ischar(line) && ~isempty(strtrim(line))
        tokens = strsplit(line, ',');
        if length(tokens) >= 6
            diff_val = str2double(tokens{2});
            rodada = str2double(tokens{3}); 
            geracao = str2double(tokens{4});
            fit_max = str2double(tokens{5});
            
            % Guardar Timestamp (tokens{1}) como valor numérico para hash de rodada única
            hash_ts = sum(double(tokens{1}));
            
            data_entries = [data_entries; diff_val, hash_ts, rodada, geracao, fit_max];
        end
    end
end
fclose(fid);

if isempty(data_entries)
    error('Nenhum dado válido encontrado no histórico.');
end

diff_names = {'Fácil (1)', 'Médio (2)', 'Difícil (3)'};
colors = {'g', 'b', 'r'}; % Verde, Azul, Vermelho

fig = figure('Name', 'Curvas Médias de Aprendizado', 'Position', [150, 150, 800, 500]);
hold on; grid on;

for d = 1:3
    idx_diff = find(data_entries(:, 1) == d);
    if isempty(idx_diff)
        continue;
    end
    data_diff = data_entries(idx_diff, :);
    
    max_gen = max(data_diff(:, 4));
    
    % Identificar execuções únicas baseadas no par [hash_ts, rodada]
    runs = unique(data_diff(:, 2:3), 'rows');
    num_runs = size(runs, 1);
    
    fitness_matrix = zeros(num_runs, max_gen);
    
    for r = 1:num_runs
        idx_run = find(data_diff(:, 2) == runs(r, 1) & data_diff(:, 3) == runs(r, 2));
        run_data = data_diff(idx_run, :);
        
        run_gens = run_data(:, 4);
        run_fits = run_data(:, 5);
        
        % Preenchimento inteligente (forward-fill) para GAs que param cedo (critério de Bhandari)
        last_fit = run_fits(1);
        for g = 1:max_gen
            idx_g = find(run_gens == g, 1);
            if ~isempty(idx_g)
                last_fit = run_fits(idx_g);
            end
            fitness_matrix(r, g) = last_fit;
        end
    end
    
    avg_fit_max = mean(fitness_matrix, 1);
    
    % Plot da média principal
    plot(1:max_gen, avg_fit_max, 'LineWidth', 2.5, 'Color', colors{d}, 'DisplayName', [diff_names{d} ' (N=' num2str(num_runs) ')']);
end

title('Curva Média de Aprendizado Consolidado por Dificuldade');
xlabel('Gerações');
ylabel('Aptidão Máxima Média (Fitness)');
legend('Location', 'southeast');
set(gca, 'FontSize', 11);

fig_path = fullfile(output_dir, 'evolucao_media_por_dificuldade.png');
print(fig, fig_path, '-dpng');

fprintf('-> Gráfico consolidado salvo em: %s\n', fig_path);
fprintf('-> Análise de Evolução Média Concluída!\n');

