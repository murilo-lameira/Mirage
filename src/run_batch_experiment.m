% =========================================================================
% 🚀 RUN_BATCH_EXPERIMENT: EXECUTOR EM LOTE DO ALGORITMO GENÉTICO
% =========================================================================
% Executa N rodadas de treinamento completas para uma dificuldade especificada,
% sem necessidade de cliques em menus ou janelas gráficas (Modo Headless).
% =========================================================================

function run_batch_experiment(difficulty_arg, num_runs_arg, pure_mutation_arg)
    % Lê argumentos da linha de comando ou variáveis padrão
    if nargin < 1
        args = argv();
        if length(args) >= 1
            difficulty_arg = str2double(args{1});
        else
            difficulty_arg = 2; % Padrão: Médio
        end
    end
    
    if nargin < 2
        args = argv();
        if length(args) >= 2
            num_runs_arg = str2double(args{2});
        else
            num_runs_arg = 10; % Padrão: 10 rodadas
        end
    end

    if nargin < 3
        args = argv();
        if length(args) >= 3
            pure_mutation_arg = str2double(args{3}) ~= 0;
        else
            pure_mutation_arg = false;
        end
    end

    difficulty = difficulty_arg;
    num_runs = num_runs_arg;
    pure_mutation_mode = pure_mutation_arg;

    diff_names = {'Fácil (1)', 'Médio (2)', 'Difícil (3)'};
    fprintf('\n======================================================\n');
    fprintf('>>> INICIANDO BATCH EXPERIMENTAL: DIFICULDADE %s <<<\n', diff_names{difficulty});
    fprintf('>>> TOTAL DE RODADAS A EXECUTAR: %d <<<\n', num_runs);
    if pure_mutation_mode
        fprintf('>>> MODO MUTAÇÃO PURA (EDS) ATIVADO <<<\n');
    end
    fprintf('======================================================\n\n');

    % Configura hiperparâmetros por dificuldade
    switch difficulty
        case 1 % FÁCIL
            pop_size = 20;
            max_gen = 30;
            crossover_rate = 0.60;
            mutation_rate = 0.15;
            elitism_count = 0;
        case 2 % MÉDIO
            pop_size = 50;
            max_gen = 50;
            crossover_rate = 0.75;
            mutation_rate = 0.05;
            elitism_count = 1;
        case 3 % DIFÍCIL
            pop_size = 100;
            max_gen = 60;
            crossover_rate = 0.90;
            mutation_rate = 0.01;
            elitism_count = 3;
    end
    
    if pure_mutation_mode
        crossover_rate = 0.0;
        mutation_rate = 0.30;
    end

    K_stop = 15;
    eps_stop = 0.01;

    sec_milestones = [ceil(max_gen * 0.2), ceil(max_gen * 0.5), max_gen];

    % Descobre o caminho correto do CSV
    if exist(fullfile('data', 'resultados_experimentos.csv'), 'file') == 2
        csv_filename = fullfile('data', 'resultados_experimentos.csv');
        sec_filename = fullfile('data', 'catalogo_sec.csv');
        map_filename = fullfile('data', 'map_elites.csv');
    else
        csv_filename = fullfile('data', 'resultados_experimentos.csv');
        sec_filename = fullfile('data', 'catalogo_sec.csv');
        map_filename = fullfile('data', 'map_elites.csv');
    end

    % Loop das N rodadas
    for run = 1:num_runs
        tic;
        
        population = init_population(pop_size);
        best_overall_chromosome = [];
        best_overall_fitness = -1;
        history_max_fitness = zeros(max_gen, 1);
        
        map_elites_fitness = -ones(3, 3);
        map_elites_chromosomes = zeros(3, 3, 4);
        
        real_gens = max_gen;
        
        for gen = 1:max_gen
            fitnesses = zeros(pop_size, 1);
            
            for i = 1:pop_size
                [T_surv, N_dodge, N_coll, D_taken, D_inflict] = simulate_episode(population(i, :), false, difficulty);
                fit = fitness_function(T_surv, N_dodge, N_coll, D_taken, D_inflict, difficulty);
                fitnesses(i) = fit;
                
                % MAP-ELITES: Categorização em Nichos (Quality-Diversity)
                hp_val = population(i, 1);
                atk_val = population(i, 2);
                spd_val = population(i, 4);
                
                ratio = hp_val / max(atk_val, 1);
                if ratio > 3.0
                    col = 1; % Tank
                elseif ratio < 1.0
                    col = 3; % Dano (Glass Cannon)
                else
                    col = 2; % Balanceado
                end
                
                if spd_val < 4.5
                    row = 1; % Lento
                elseif spd_val > 6.5
                    row = 3; % Rápido
                else
                    row = 2; % Médio
                end
                
                if fit > map_elites_fitness(row, col)
                    map_elites_fitness(row, col) = fit;
                    map_elites_chromosomes(row, col, :) = population(i, :);
                end
            end
            
            [current_max_fit, best_idx] = max(fitnesses);
            current_mean_fit = mean(fitnesses);
            history_max_fitness(gen) = current_max_fit;
            
            if current_max_fit > best_overall_fitness
                best_overall_fitness = current_max_fit;
                best_overall_chromosome = population(best_idx, :);
            end
            
            % SKILLED EXPERIENCE CATALOGUE (SEC): Exporta Marcos
            if ismember(gen, sec_milestones) || (gen == max_gen)
                try
                    sec_fid = fopen(sec_filename, 'a');
                    if sec_fid ~= -1
                        if exist(sec_filename, 'file') ~= 2 || dir(sec_filename).bytes == 0
                            fprintf(sec_fid, 'Data_Hora,Dificuldade,Geracao,Modo_EDS,Fitness,HP,Atk,AtkSpd,MovSpd\n');
                        end
                        ts = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                        fprintf(sec_fid, '%s,%d,%d,%d,%.2f,%d,%d,%.2f,%.2f\n', ...
                            ts, difficulty, gen, pure_mutation_mode, current_max_fit, ...
                            round(best_overall_chromosome(1)), round(best_overall_chromosome(2)), ...
                            best_overall_chromosome(3), best_overall_chromosome(4));
                        fclose(sec_fid);
                    end
                catch
                end
            end
            
            % Critério de Parada
            if gen > K_stop
                past_fitness = history_max_fitness(gen - K_stop);
                improvement = (current_max_fit - past_fitness) / past_fitness;
                if improvement < eps_stop
                    real_gens = gen;
                    break;
                end
            end
            
            % Reprodução
            new_population = zeros(pop_size, 4);
            [~, sorted_indices] = sort(fitnesses, 'descend');
            for e = 1:elitism_count
                new_population(e, :) = population(sorted_indices(e), :);
            end
            
            selected_parents = selection(population, fitnesses);
            for i = (elitism_count + 1):2:pop_size
                p1 = population(selected_parents(i), :);
                if (i+1) <= pop_size
                    p2 = population(selected_parents(i+1), :);
                else
                    p2 = population(selected_parents(i), :);
                end
                [c1, c2] = crossover(p1, p2, crossover_rate);
                c1 = mutation(c1, mutation_rate);
                c2 = mutation(c2, mutation_rate);
                new_population(i, :) = c1;
                if (i+1) <= pop_size
                    new_population(i+1, :) = c2;
                end
            end
            population = new_population;
        end
        
        time_elapsed = toc;
        
        % Avaliação de combate do campeão
        [elite_surv, elite_dodges, elite_hits, elite_dmg_taken, elite_dmg_dealt] = simulate_episode(best_overall_chromosome, false, difficulty);
        
        % Exporta MAP-Elites
        linhas_desc = {'Lento', 'Medio', 'Rapido'};
        colunas_desc = {'Tank', 'Balanceado', 'Dano(GlassCannon)'};
        try
            map_fid = fopen(map_filename, 'a');
            if map_fid ~= -1
                if exist(map_filename, 'file') ~= 2 || dir(map_filename).bytes == 0
                    fprintf(map_fid, 'Data_Hora,Dificuldade,Modo_EDS,Mobilidade,Classe,Fitness,HP,Atk,AtkSpd,MovSpd\n');
                end
                ts = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                for r = 1:3
                    for c = 1:3
                        if map_elites_fitness(r, c) > 0
                            chromo = reshape(map_elites_chromosomes(r, c, :), 1, 4);
                            fprintf(map_fid, '%s,%d,%d,%s,%s,%.2f,%d,%d,%.2f,%.2f\n', ...
                                ts, difficulty, pure_mutation_mode, linhas_desc{r}, colunas_desc{c}, ...
                                map_elites_fitness(r, c), round(chromo(1)), round(chromo(2)), chromo(3), chromo(4));
                        end
                    end
                end
                fclose(map_fid);
            end
        catch
        end

        % Salvamento thread-safe com retry no CSV PRINCIPAL
        saved = false;
        attempts = 0;
        while ~saved && attempts < 10
            attempts = attempts + 1;
            try
                file_exists = exist(csv_filename, 'file') == 2;
                fid = fopen(csv_filename, 'a');
                if fid ~= -1
                    if ~file_exists
                        fprintf(fid, 'Data_Hora,Dificuldade,Populacao,Geracoes_Treinadas,Fitness_Max,Fitness_Medio,Elite_HP,Elite_Atk,Elite_AtkSpd,Elite_MovSpd,Elite_Sobrevivencia,Elite_Desvios,Elite_Colisoes,Elite_DanoCausado,Elite_DanoTomado,Tempo_Treino_Seg,Modo_EDS\n');
                    end
                    
                    timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                    fprintf(fid, '%s,%d,%d,%d,%.2f,%.2f,%d,%d,%.2f,%.2f,%.2f,%d,%d,%.2f,%.2f,%.2f,%d\n', ...
                        timestamp, difficulty, pop_size, real_gens, ...
                        best_overall_fitness, current_mean_fit, ...
                        round(best_overall_chromosome(1)), round(best_overall_chromosome(2)), ...
                        best_overall_chromosome(3), best_overall_chromosome(4), ...
                        elite_surv, elite_dodges, elite_hits, elite_dmg_dealt, elite_dmg_taken, time_elapsed, pure_mutation_mode);
                    fclose(fid);
                    saved = true;
                else
                    pause(0.1 + rand() * 0.2);
                end
            catch
                pause(0.1 + rand() * 0.2);
            end
        end
        
        fprintf('[Dificuldade %d] Rodada %02d/%02d concluída em %6.2fs | Gens: %02d | FitMax: %7.2f | HP: %3d | Atk: %2d | AtkSpd: %.2f | MovSpd: %.2f\n', ...
            difficulty, run, num_runs, time_elapsed, real_gens, best_overall_fitness, ...
            round(best_overall_chromosome(1)), round(best_overall_chromosome(2)), ...
            best_overall_chromosome(3), best_overall_chromosome(4));
    end

    fprintf('\n>>> BATCH DIFICULDADE %d CONCLUÍDO COM SUCESSO! <<<\n\n', difficulty);
end

% Executa automaticamente se chamado como script principal
if ~exist('is_subfunction_call', 'var')
    run_batch_experiment();
end
