% =========================================================================
% 📦 GERADOR DE BOXPLOTS E DISTRIBUIÇÃO ESTATÍSTICA - MIRAGE
% =========================================================================
% Lê 'data/resultados_experimentos.csv' e renderiza boxplots estatísticos:
%   1. 'boxplot_fitness_dificuldade.png': Dispersão de Fitness por nível
%   2. 'boxplot_distribuicao_genes.png': Dispersão dos 4 genes (HP, Atk, Cadência, Velocidade)
% =========================================================================

function gerar_boxplots()
    clc; clear; close all;
    warning('off', 'all');
    try graphics_toolkit('qt'); catch; end;
    addpath(fileparts(mfilename('fullpath')));

csv_file = fullfile('data', 'resultados_experimentos.csv');
if exist(csv_file, 'file') ~= 2
    error('Arquivo data/resultados_experimentos.csv nao encontrado.');
end

output_dir = fullfile('data', 'graficos');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

fprintf('Processando distribuições para Boxplots a partir de %s...\n', csv_file);

fid = fopen(csv_file, 'r');
fgetl(fid); % Pula cabeçalho

% Colunas: Dificuldade(1), Fitness(2), HP(3), Atk(4), AtkSpd(5), MovSpd(6)
dados = [];

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line) && ~isempty(strtrim(line))
        tokens = strsplit(line, ',');
        if length(tokens) >= 11
            d_val = str2double(tokens{2});
            f_val = str2double(tokens{5});
            hp_val = str2double(tokens{7});
            atk_val = str2double(tokens{8});
            aspd_val = str2double(tokens{9});
            mspd_val = str2double(tokens{10});
            dados = [dados; d_val, f_val, hp_val, atk_val, aspd_val, mspd_val];
        end
    end
end
fclose(fid);

diff_labels = {'Fácil (1)', 'Médio (2)', 'Difícil (3)'};
diff_colors = {[0.2, 0.75, 0.3], [0.2, 0.5, 0.9], [0.9, 0.25, 0.2]};

% =========================================================================
% 1. BOXPLOT DE FITNESS MÁXIMO POR DIFICULDADE
% =========================================================================
fig1 = figure('Name', 'Dispersao de Fitness por Dificuldade', 'Position', [150, 150, 750, 500]);
hold on; grid on;

for d = 1:3
    idx = find(dados(:, 1) == d);
    vals = dados(idx, 2);
    desenhar_caixa_boxplot(d, vals, diff_colors{d});
end

set(gca, 'XTick', 1:3, 'XTickLabel', diff_labels, 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Aptidão Máxima (Fitness)', 'FontSize', 12, 'FontWeight', 'bold');
title('Dispersão Estatística do Fitness Máximo por Dificuldade (Boxplot)', 'FontSize', 13, 'FontWeight', 'bold');
xlim([0.4, 3.6]);

box1_path = fullfile(output_dir, 'boxplot_fitness_dificuldade.png');
print(fig1, box1_path, '-dpng');
close(fig1);
fprintf('-> Boxplot de Fitness salvo em: %s\n', box1_path);

% =========================================================================
% 2. BOXPLOTS DOS 4 GENES POR DIFICULDADE
% =========================================================================
fig2 = figure('Name', 'Dispersao dos Genes por Dificuldade', 'Position', [100, 100, 950, 650]);

gene_cols = [3, 4, 5, 6];
gene_titles = {'HP Máximo', 'Poder de Ataque', 'Velocidade de Ataque (Hz)', 'Velocidade de Desvio (m/s)'};
gene_ylabels = {'Pontos de Vida', 'Dano Base', 'Frequência (Hz)', 'Velocidade (m/s)'};

for g = 1:4
    subplot(2, 2, g);
    hold on; grid on;
    
    col_idx = gene_cols(g);
    for d = 1:3
        idx = find(dados(:, 1) == d);
        vals = dados(idx, col_idx);
        desenhar_caixa_boxplot(d, vals, diff_colors{d});
    end
    
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Fácil', 'Médio', 'Difícil'}, 'FontSize', 10, 'FontWeight', 'bold');
    ylabel(gene_ylabels{g}, 'FontSize', 10, 'FontWeight', 'bold');
    title(gene_titles{g}, 'FontSize', 11, 'FontWeight', 'bold');
    xlim([0.4, 3.6]);
end

box2_path = fullfile(output_dir, 'boxplot_distribuicao_genes.png');
print(fig2, box2_path, '-dpng');
close(fig2);
fprintf('-> Boxplot de Genes salvo em: %s\n', box2_path);
end

% =========================================================================
% FUNÇÃO AUXILIAR PARA RENDERIZAR UM BOXPLOT ROBUSTO E ELEGANTE
% =========================================================================
function desenhar_caixa_boxplot(x_pos, vals, cor)
    if isempty(vals)
        return;
    end
    
    q = quantile(vals, [0.25, 0.50, 0.75]);
    q1 = q(1);
    med = q(2);
    q3 = q(3);
    iqr_val = q3 - q1;
    
    w_low = max(min(vals), q1 - 1.5 * iqr_val);
    w_high = min(max(vals), q3 + 1.5 * iqr_val);
    
    box_w = 0.45;
    
    % Caixa Q1 a Q3
    rectangle('Position', [x_pos - box_w/2, q1, box_w, max(1e-4, q3 - q1)], ...
              'FaceColor', [cor * 0.4 + [0.6 0.6 0.6] * 0.6], 'EdgeColor', cor * 0.7, 'LineWidth', 1.8);
              
    % Linha da Mediana
    line([x_pos - box_w/2, x_pos + box_w/2], [med, med], 'Color', [0.1 0.1 0.1], 'LineWidth', 2.5);
    
    % Haste Inferior (Whisker)
    line([x_pos, x_pos], [q1, w_low], 'Color', [0.2 0.2 0.2], 'LineStyle', '--', 'LineWidth', 1.3);
    line([x_pos - box_w/4, x_pos + box_w/4], [w_low, w_low], 'Color', [0.2 0.2 0.2], 'LineWidth', 1.3);
    
    % Haste Superior (Whisker)
    line([x_pos, x_pos], [q3, w_high], 'Color', [0.2 0.2 0.2], 'LineStyle', '--', 'LineWidth', 1.3);
    line([x_pos - box_w/4, x_pos + box_w/4], [w_high, w_high], 'Color', [0.2 0.2 0.2], 'LineWidth', 1.3);
    
    % Diamante da Média
    m_val = mean(vals);
    plot(x_pos, m_val, 'd', 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k', 'MarkerSize', 8);
    
    % Pontos de dados reais com jitter horizontal suave
    jitter = (rand(size(vals)) - 0.5) * 0.18;
    plot(x_pos + jitter, vals, 'o', 'MarkerFaceColor', cor, 'MarkerEdgeColor', 'k', 'MarkerSize', 5);
end
