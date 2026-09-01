% =========================================================================
% 🛡️ SCRIPT PRINCIPAL: Mirage COM ALGORITMO GENETICO (OCTAVE)
% =========================================================================
% Projeto: Engenharia de Controle e Automacao (UNISENAI)
% Tema: Inimigos virtuais que aprendem a desviar com Algoritmos Geneticos
% Autores: Leonardo Retori, Henry Matheus, Murilo Lameira, Murilo Romualdo
% Orientador: Me. Ricardo Martinez Vicentini
% =========================================================================

clc; clear; close all;
addpath(fileparts(mfilename('fullpath')));

fprintf('--- INICIANDO TREINAMENTO EVOLUTIVO ---\n');

% 1. ESCOLHA A DIFICULDADE E MODO DE EVOLUÇÃO
% Abre uma caixa de dialogo visual para selecionar o modo
fprintf('Aguardando selecao de dificuldade na interface...\n');
difficulty = menu('Escolha a Dificuldade do Treinamento:', ...
                  'Fácil (População 20, Alta Mutação)', ...
                  'Médio (Balanceado)', ...
                  'Difícil (População 100, Alto Cruzamento)');

% Se o usuario fechar a janela no "X" sem escolher, assumimos Medio por padrao
if difficulty == 0
    difficulty = 2;
end

switch difficulty
    case 1 % FACIL
        fprintf('>>> MODO FACIL ATIVADO (Comportamento Erratico) <<<\n');
        pop_size = 20;           % Populacao pequena
        max_generations = 30;    
        crossover_rate = 0.60;   % Recombinacao moderada
        mutation_rate = 0.15;    % Mutacao ALTISSIMA (15%) - perde estrategias faceis
        elitism_count = 0;       % Sem elitismo
        
    case 2 % MEDIO
        fprintf('>>> MODO MEDIO ATIVADO (Balanceado) <<<\n');
        pop_size = 50;           
        max_generations = 50;    
        crossover_rate = 0.75;   
        mutation_rate = 0.05;    
        elitism_count = 1;       
        
    case 3 % DIFICIL
        fprintf('>>> MODO DIFICIL ATIVADO (Convergencia Cirurgica) <<<\n');
        pop_size = 100;          % Populacao robusta
        max_generations = 60;    
        crossover_rate = 0.90;   % Cruzamento altissimo (90%)
        mutation_rate = 0.01;    % Mutacao ultra baixa (1%)
        elitism_count = 3;       % Preserva os 3 mestres absolutos
end

% 1.5. MODO DE MUTAÇÃO PURA (EDS - NLR)
if ~exist('pure_mutation_mode', 'var')
    pure_mutation_mode = false; % Defina como true externamente ou aqui para desativar crossover
end
if pure_mutation_mode
    fprintf('>>> MODO MUTAÇÃO PURA ATIVADO (EDS) <<<\n');
    crossover_rate = 0.0;
    mutation_rate = 0.30; % Alta mutação Box-Muller compensatória
end

% Arrays para o Grafico de Convergencia (Slides)
history_max_fitness = zeros(max_generations, 1);
history_mean_fitness = zeros(max_generations, 1);

% Parametros do Criterio de Parada de Bhandari
K_generations_stop = 15;
epsilon_stop = 0.01;

% Skilled Experience Catalogue (SEC) - Marcos Históricos
sec_milestones = [ceil(max_generations * 0.2), ceil(max_generations * 0.5), max_generations];

% MAP-Elites (Kirk & Scirea) - Grade 3x3 de Nichos [Mobilidade x Classe Física]
map_elites_fitness = -ones(3, 3);
map_elites_chromosomes = zeros(3, 3, 4);

% 2. INICIALIZACAO DA POPULACAO
population = init_population(pop_size);
best_overall_chromosome = [];
best_overall_fitness = -1;

tic; % Inicia cronometro

% 3. LOOP EVOLUTIVO
for gen = 1:max_generations
    fitnesses = zeros(pop_size, 1);
    
    % AVALIACAO (Headless Mode: visualize = false para nao travar a tela)
    for i = 1:pop_size
        [T_surv, N_dodge, N_coll, D_taken, D_inflict] = simulate_episode(population(i, :), false, difficulty);
        fit = fitness_function(T_surv, N_dodge, N_coll, D_taken, D_inflict, difficulty);
        fitnesses(i) = fit;
        
        % =================================================================
        % MAP-ELITES: Categorização em Nichos (Quality-Diversity)
        % =================================================================
        hp_val = population(i, 1);
        atk_val = population(i, 2);
        spd_val = population(i, 4);
        
        % Coluna (Classe Física): 1=Tank, 2=Balanceado, 3=Dano
        ratio = hp_val / max(atk_val, 1);
        if ratio > 3.0
            col = 1; % Tank
        elseif ratio < 1.0
            col = 3; % Dano (Glass Cannon)
        else
            col = 2; % Balanceado
        end
        
        % Linha (Mobilidade): 1=Lento, 2=Médio, 3=Rápido
        if spd_val < 4.5
            row = 1; % Lento
        elseif spd_val > 6.5
            row = 3; % Rápido
        else
            row = 2; % Médio
        end
        
        % Atualiza se for o novo elite deste nicho específico
        if fit > map_elites_fitness(row, col)
            map_elites_fitness(row, col) = fit;
            map_elites_chromosomes(row, col, :) = population(i, :);
        end
        % =================================================================
    end
    
    % Coleta de Dados Estatisticos Globais
    [current_max_fit, best_idx] = max(fitnesses);
    current_mean_fit = mean(fitnesses);
    
    history_max_fitness(gen) = current_max_fit;
    history_mean_fitness(gen) = current_mean_fit;
    
    % Salva o Supremo Global
    if current_max_fit > best_overall_fitness
        best_overall_fitness = current_max_fit;
        best_overall_chromosome = population(best_idx, :);
    end
    
    fprintf('Geracao %02d | Max Fitness: %7.2f | Media: %7.2f\n', gen, current_max_fit, current_mean_fit);
    
    % =================================================================
    % SKILLED EXPERIENCE CATALOGUE (SEC): Exporta Marcos de Conhecimento
    % =================================================================
    if ismember(gen, sec_milestones) || (gen == max_generations)
        if exist(fullfile('data', 'catalogo_sec.csv'), 'file') == 2
            sec_filename = fullfile('data', 'catalogo_sec.csv');
        else
            sec_filename = fullfile('data', 'catalogo_sec.csv');
        end
        
        sec_fid = fopen(sec_filename, 'a');
        if exist(sec_filename, 'file') ~= 2 || dir(sec_filename).bytes == 0
            fprintf(sec_fid, 'Data_Hora,Dificuldade,Geracao,Modo_EDS,Fitness,HP,Atk,AtkSpd,MovSpd\n');
        end
        
        timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
        fprintf(sec_fid, '%s,%d,%d,%d,%.2f,%d,%d,%.2f,%.2f\n', ...
            timestamp, difficulty, gen, pure_mutation_mode, current_max_fit, ...
            round(best_overall_chromosome(1)), round(best_overall_chromosome(2)), ...
            best_overall_chromosome(3), best_overall_chromosome(4));
        fclose(sec_fid);
    end
    % =================================================================
    
    % CRITERIO DE PARADA (Estagnacao - Bhandari)
    if gen > K_generations_stop
        past_fitness = history_max_fitness(gen - K_generations_stop);
        % Checa se melhorou em relacao a K geracoes atras
        improvement = (current_max_fit - past_fitness) / past_fitness;
        
        if improvement < epsilon_stop
            fprintf('\n>>> CRITERIO DE PARADA ATINGIDO <<<\n');
            fprintf('Estagnacao detectada (Melhora < 1%% nas ultimas %d geracoes).\n', K_generations_stop);
            max_generations = gen; % Corta o tamanho real do loop para o grafico
            break;
        end
    end
    
    % REPRODUCAO & NOVA GERACAO
    new_population = zeros(pop_size, 4);
    
    % A) Elitismo: Os mestres passam direto sem mutacao
    [~, sorted_indices] = sort(fitnesses, 'descend');
    for e = 1:elitism_count
        new_population(e, :) = population(sorted_indices(e), :);
    end
    
    % B) Selecao (Torneio)
    selected_parents_indices = selection(population, fitnesses);
    
    % C) Crossover e Mutacao
    for i = (elitism_count + 1):2:pop_size
        p1 = population(selected_parents_indices(i), :);
        
        % Garante que nao ultrapasse o vetor
        if (i+1) <= pop_size
            p2 = population(selected_parents_indices(i+1), :);
        else
            p2 = population(selected_parents_indices(i), :);
        end
        
        % Recombina (se pure_mutation_mode=true, c1 e c2 serão idênticos aos pais na lógica local ou crossover=0)
        [c1, c2] = crossover(p1, p2, crossover_rate);
        
        % Muta
        c1 = mutation(c1, mutation_rate);
        c2 = mutation(c2, mutation_rate);
        
        % Salva na nova geracao
        new_population(i, :) = c1;
        if (i+1) <= pop_size
            new_population(i+1, :) = c2;
        end
    end
    
    % Atualiza a matriz global
    population = new_population;
end

% Avaliação de Desempenho em Combate do Campeão Global
[elite_surv, elite_dodges, elite_hits, elite_dmg_taken, elite_dmg_dealt] = simulate_episode(best_overall_chromosome, false, difficulty);

total_time = toc;
fprintf('\n======================================================\n');
fprintf('TREINAMENTO CONCLUIDO em %.2f segundos!\n', total_time);
fprintf('Total de Geracoes Executadas: %d\n', max_generations);
fprintf('Genoma do NPC Perfeito (Elite Global):\n');
fprintf('  HP Max: %d\n', round(best_overall_chromosome(1)));
fprintf('  Ataque: %d\n', round(best_overall_chromosome(2)));
fprintf('  Velocidade de Ataque: %.2f Hz\n', best_overall_chromosome(3));
fprintf('  Velocidade de Desvio: %.2f m/s\n', best_overall_chromosome(4));
fprintf('======================================================\n');

% =========================================================================
% MAP-ELITES: EXPORTAÇÃO DA DIVERSIDADE DE NICHOS
% =========================================================================
if exist(fullfile('data', 'map_elites.csv'), 'file') == 2
    map_filename = fullfile('data', 'map_elites.csv');
else
    map_filename = fullfile('data', 'map_elites.csv');
end
map_fid = fopen(map_filename, 'a');
if exist(map_filename, 'file') ~= 2 || dir(map_filename).bytes == 0
    fprintf(map_fid, 'Data_Hora,Dificuldade,Modo_EDS,Mobilidade,Classe,Fitness,HP,Atk,AtkSpd,MovSpd\n');
end

linhas_desc = {'Lento', 'Medio', 'Rapido'};
colunas_desc = {'Tank', 'Balanceado', 'Dano(GlassCannon)'};
timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');

fprintf('\n=== RESULTADO MAP-ELITES (Classes Descobertas) ===\n');
for r = 1:3
    for c = 1:3
        if map_elites_fitness(r, c) > 0
            chromo = reshape(map_elites_chromosomes(r, c, :), 1, 4);
            fprintf(' - Nicho [%s | %s]: Fit %.2f -> HP:%d Atk:%d Spd:%.2f\n', ...
                linhas_desc{r}, colunas_desc{c}, map_elites_fitness(r, c), ...
                round(chromo(1)), round(chromo(2)), chromo(4));
            
            fprintf(map_fid, '%s,%d,%d,%s,%s,%.2f,%d,%d,%.2f,%.2f\n', ...
                timestamp, difficulty, pure_mutation_mode, linhas_desc{r}, colunas_desc{c}, ...
                map_elites_fitness(r, c), round(chromo(1)), round(chromo(2)), chromo(3), chromo(4));
        end
    end
end
fclose(map_fid);
fprintf('>> Diversidade MAP-Elites salva em: %s\n', map_filename);
% =========================================================================

% --- INICIO DO BANCO DE DADOS (CSV PRINCIPAL) ---
if exist(fullfile('data', 'resultados_experimentos.csv'), 'file') == 2
    csv_filename = fullfile('data', 'resultados_experimentos.csv');
else
    csv_filename = fullfile('data', 'resultados_experimentos.csv');
end
file_exists = exist(csv_filename, 'file') == 2;
fid = fopen(csv_filename, 'a');

if ~file_exists
    fprintf(fid, 'Data_Hora,Dificuldade,Populacao,Geracoes_Treinadas,Fitness_Max,Fitness_Medio,Elite_HP,Elite_Atk,Elite_AtkSpd,Elite_MovSpd,Elite_Sobrevivencia,Elite_Desvios,Elite_Colisoes,Elite_DanoCausado,Elite_DanoTomado,Tempo_Treino_Seg,Modo_EDS\n');
end

fprintf(fid, '%s,%d,%d,%d,%.2f,%.2f,%d,%d,%.2f,%.2f,%.2f,%d,%d,%.2f,%.2f,%.2f,%d\n', ...
    timestamp, difficulty, pop_size, max_generations, ...
    current_max_fit, current_mean_fit, ...
    round(best_overall_chromosome(1)), round(best_overall_chromosome(2)), ...
    best_overall_chromosome(3), best_overall_chromosome(4), ...
    elite_surv, elite_dodges, elite_hits, elite_dmg_dealt, elite_dmg_taken, total_time, pure_mutation_mode);
fclose(fid);
fprintf('>> Resultados principais salvos em: %s\n', csv_filename);
% --- FIM DO BANCO DE DADOS ---

% 4. GERAR GRAFICO DE CONVERGENCIA
if ~exist('disable_plotting', 'var') || disable_plotting == false
    history_max_fitness = history_max_fitness(1:max_generations);
    history_mean_fitness = history_mean_fitness(1:max_generations);
    generations_x = 1:max_generations;

    figure('Name', 'Curva de Convergencia do Algoritmo Genetico', 'Position', [200, 200, 700, 500]);
    plot(generations_x, history_max_fitness, 'g-o', 'LineWidth', 2, 'MarkerFaceColor', 'g');
    hold on; grid on;
    plot(generations_x, history_mean_fitness, 'c-s', 'LineWidth', 2, 'MarkerFaceColor', 'c');

    title(sprintf('Evolucao Tatica: Convergencia de Fitness (Dificuldade %d)', difficulty));
    xlabel('Geracoes');
    ylabel('Valor de Aptidao (Fitness)');
    legend('Fitness Maximo (Elites)', 'Fitness Medio (Populacao)', 'Location', 'southeast');
    drawnow;

    try
        rodadas_dir = fullfile('data', 'graficos', 'rodadas');
        if ~exist(rodadas_dir, 'dir')
            mkdir(rodadas_dir);
        end
        ts_file = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
        run_img_name = fullfile(rodadas_dir, sprintf('evolucao_dif%d_manual_%s.png', difficulty, ts_file));
        print(gcf, run_img_name, '-dpng');
        fprintf('>> Gráfico de evolução da rodada salvo em: %s\n', run_img_name);
    catch
    end

    % 5. TESTE VISUAL
    fprintf('\nPreparando exibicao visual do combate com o genoma perfeito...\n');
    fprintf('(Va ate a janela de graficos para assistir)\n');
    pause(2); 

    simulate_episode(best_overall_chromosome, true, difficulty);
end
