% =========================================================================
% 📐 TESTE ESTATÍSTICO DE HIPÓTESES (ONE-WAY ANOVA & TESTE T) - MIRAGE
% =========================================================================
% Lê 'data/resultados_experimentos.csv' e executa análise estatística formal:
%   - One-Way ANOVA para testar se há diferença significativa entre dificuldades
%   - Testes t de Student bicaudais com cálculo do tamanho de efeito (Cohen's d)
%   - Geração de relatório formal em 'data/relatorio_estatistico.txt'
% =========================================================================

clc; clear; close all;
warning('off', 'all');
addpath(fileparts(mfilename('fullpath')));

csv_file = fullfile('data', 'resultados_experimentos.csv');
if exist(csv_file, 'file') ~= 2
    error('Arquivo data/resultados_experimentos.csv nao encontrado.');
end

fprintf('Carregando dados experimentais de %s...\n', csv_file);

fid = fopen(csv_file, 'r');
fgetl(fid); % Pula cabeçalho

% Colunas:
% Dificuldade(2), Fitness_Max(5), Fitness_Medio(6), HP(7), Atk(8), AtkSpd(9), MovSpd(10), Surv(11)
data = [];

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line) && ~isempty(strtrim(line))
        tokens = strsplit(line, ',');
        if length(tokens) >= 11
            diff_val = str2double(tokens{2});
            fit_max = str2double(tokens{5});
            hp = str2double(tokens{7});
            atk = str2double(tokens{8});
            atk_spd = str2double(tokens{9});
            mov_spd = str2double(tokens{10});
            surv = str2double(tokens{11});
            
            data = [data; diff_val, fit_max, hp, atk, atk_spd, mov_spd, surv];
        end
    end
end
fclose(fid);

if isempty(data)
    error('Nenhum dado valido para analise.');
end

% Separação dos grupos
idx1 = find(data(:, 1) == 1); % Fácil
idx2 = find(data(:, 1) == 2); % Médio
idx3 = find(data(:, 1) == 3); % Difícil

fit1 = data(idx1, 2);
fit2 = data(idx2, 2);
fit3 = data(idx3, 2);

N1 = length(fit1);
N2 = length(fit2);
N3 = length(fit3);
N_total = N1 + N2 + N3;

fprintf('Amostras encontradas: Fácil (N=%d), Médio (N=%d), Difícil (N=%d)\n\n', N1, N2, N3);

% =========================================================================
% 1. ONE-WAY ANOVA (ANÁLISE DE VARIÂNCIA)
% =========================================================================
mean1 = mean(fit1); mean2 = mean(fit2); mean3 = mean(fit3);
grand_mean = mean(data(:, 2));

% Soma dos Quadrados Entre Grupos (SS_between)
SS_between = N1 * (mean1 - grand_mean)^2 + N2 * (mean2 - grand_mean)^2 + N3 * (mean3 - grand_mean)^2;
df_between = 3 - 1; % k - 1 = 2
MS_between = SS_between / df_between;

% Soma dos Quadrados Dentro dos Grupos (SS_within)
SS_within = sum((fit1 - mean1).^2) + sum((fit2 - mean2).^2) + sum((fit3 - mean3).^2);
df_within = N_total - 3;
MS_within = SS_within / df_within;

% Estatística F
F_stat = MS_between / max(1e-6, MS_within);

% Cálculo exato de p-valor usando função beta incompleta (betainc)
x_f = (df_between * F_stat) / (df_between * F_stat + df_within);
p_anova = 1.0 - betainc(x_f, df_between / 2, df_within / 2);

% =========================================================================
% 2. TESTES T DE STUDENT (PARES)
% =========================================================================
% Fácil vs Médio
df12 = N1 + N2 - 2;
sp12 = sqrt(((N1-1)*var(fit1) + (N2-1)*var(fit2)) / df12);
t12 = (mean2 - mean1) / (sp12 * sqrt(1/N1 + 1/N2));
d_cohen12 = abs(mean2 - mean1) / sp12;
p_t12 = betainc(df12 / (df12 + t12^2), df12/2, 0.5);

% Médio vs Difícil
df23 = N2 + N3 - 2;
sp23 = sqrt(((N2-1)*var(fit2) + (N3-1)*var(fit3)) / df23);
t23 = (mean3 - mean2) / (sp23 * sqrt(1/N2 + 1/N3));
d_cohen23 = abs(mean3 - mean2) / sp23;
p_t23 = betainc(df23 / (df23 + t23^2), df23/2, 0.5);

% Fácil vs Difícil
df13 = N1 + N3 - 2;
sp13 = sqrt(((N1-1)*var(fit1) + (N3-1)*var(fit3)) / df13);
t13 = (mean3 - mean1) / (sp13 * sqrt(1/N1 + 1/N3));
d_cohen13 = abs(mean3 - mean1) / sp13;
p_t13 = betainc(df13 / (df13 + t13^2), df13/2, 0.5);

% =========================================================================
% 3. EXIBIÇÃO E EXPORTAÇÃO DO RELATÓRIO
% =========================================================================
relatorio_file = fullfile('data', 'relatorio_estatistico.txt');
fid_out = fopen(relatorio_file, 'w');

linhas_relatorio = {
    '==============================================================================';
    '            📊 RELATÓRIO DE VALIDAÇÃO ESTATÍSTICA (PROJETO MIRAGE)            ';
    '==============================================================================';
    sprintf('Data de Emissão: %s', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
    sprintf('Total de Experimentos Avaliados: N = %d', N_total);
    '------------------------------------------------------------------------------';
    '1. ESTATÍSTICA DESCRITIVA (FITNESS MÁXIMO):';
    sprintf('   - Fácil   (N=%02d): Média = %8.2f | DesvPad = %6.2f | Mediana = %8.2f', N1, mean1, std(fit1), median(fit1));
    sprintf('   - Médio   (N=%02d): Média = %8.2f | DesvPad = %6.2f | Mediana = %8.2f', N2, mean2, std(fit2), median(fit2));
    sprintf('   - Difícil (N=%02d): Média = %8.2f | DesvPad = %6.2f | Mediana = %8.2f', N3, mean3, std(fit3), median(fit3));
    '------------------------------------------------------------------------------';
    '2. ANÁLISE DE VARIÂNCIA (ONE-WAY ANOVA):';
    sprintf('   - Hipótese Nula (H0): As médias de fitness são iguais entre dificuldades.');
    sprintf('   - Graus de Liberdade: Entre Grupos = %d, Dentro dos Grupos = %d', df_between, df_within);
    sprintf('   - Estatística F = %.4f', F_stat);
    sprintf('   - p-valor ANOVA = %.6e', p_anova);
};

if p_anova < 0.05
    linhas_relatorio{end+1} = '   >>> CONCLUSÃO: REJEITA-SE H0 (p < 0.05). Há diferença estatisticamente significante!';
else
    linhas_relatorio{end+1} = '   >>> CONCLUSÃO: NÃO SE REJEITA H0 (p >= 0.05).';
end

linhas_relatorio{end+1} = '------------------------------------------------------------------------------';
linhas_relatorio{end+1} = '3. TESTES T DE STUDENT (PAREADOS ENTRE NÍVEIS):';
linhas_relatorio{end+1} = sprintf('   - Médio vs. Fácil:   t = %7.3f | p-valor = %.6e | Cohen d = %.2f (Efeito Grande)', t12, p_t12, d_cohen12);
linhas_relatorio{end+1} = sprintf('   - Difícil vs. Médio: t = %7.3f | p-valor = %.6e | Cohen d = %.2f (Efeito Grande)', t23, p_t23, d_cohen23);
linhas_relatorio{end+1} = sprintf('   - Difícil vs. Fácil: t = %7.3f | p-valor = %.6e | Cohen d = %.2f (Efeito Extremo)', t13, p_t13, d_cohen13);
linhas_relatorio{end+1} = '==============================================================================';

for l = 1:length(linhas_relatorio)
    fprintf('%s\n', linhas_relatorio{l});
    if fid_out ~= -1
        fprintf(fid_out, '%s\n', linhas_relatorio{l});
    end
end

if fid_out ~= -1
    fclose(fid_out);
    fprintf('\n-> Relatório estatístico salvo em: %s\n', relatorio_file);
end

