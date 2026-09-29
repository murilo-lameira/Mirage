function selected_parents = selection(population, fitnesses)
    % SELECTION Implementa Selecao por Torneio (Tournament Selection)
    % Protege a diversidade genetica (Quality-Diversity / Map-Elites)
    % Retorna os indices dos individuos selecionados para reproducao
    
    pop_size = size(population, 1);
    tournament_size = min(3, pop_size); % Tamanho K do torneio
    
    if tournament_size <= 1
        selected_parents = (1:pop_size)';
        return;
    end
    
    % Torneio vetorizado de alta performance (sem loops)
    competitors = randi(pop_size, tournament_size, pop_size);
    comp_fits = fitnesses(competitors);
    [~, best_rel] = max(comp_fits, [], 1);
    idx_linear = sub2ind(size(competitors), best_rel, 1:pop_size);
    selected_parents = competitors(idx_linear)';
end

