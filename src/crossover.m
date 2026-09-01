function [child1, child2] = crossover(parent1, parent2, crossover_rate)
    % CROSSOVER Realiza recombinacao genetica de dois NPCs
    % Utiliza o metodo Uniform Crossover (50% de chance para cada gene)
    
    child1 = parent1;
    child2 = parent2;
    
    % Checa se a reproducao vai ocorrer baseada na taxa (ex: 70% a 90%)
    if rand() < crossover_rate
        for g = 1:4
            % 50% de chance de trocar o gene entre os pais
            if rand() < 0.5
                child1(g) = parent2(g);
                child2(g) = parent1(g);
            end
        end
    end
end
