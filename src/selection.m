function selected_parents = selection(population, fitnesses)
    % SELECTION Implementa Selecao por Torneio
    % Protege a diversidade genetica (Quality-Diversity / Map-Elites)
    % Retorna os indices dos individuos selecionados para reproducao
    
    pop_size = size(population, 1);
    selected_parents = zeros(pop_size, 1);
    tournament_size = 3; % Tamanho K do torneio
    
    for i = 1:pop_size
        % Sorteia K competidores aleatorios da populacao
        competitors = randi(pop_size, tournament_size, 1);
        
        % Vence o torneio quem tiver o maior fitness dentro deste grupo
        best_fitness = -1;
        best_idx = 1;
        
        for j = 1:tournament_size
            idx = competitors(j);
            if fitnesses(idx) > best_fitness
                best_fitness = fitnesses(idx);
                best_idx = idx;
            end
        end
        
        % Adiciona o vencedor ao pool de reproducao
        selected_parents(i) = best_idx;
    end
end
