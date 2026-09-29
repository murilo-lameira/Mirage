function [child1, child2] = crossover(parent1, parent2, crossover_rate)
    % CROSSOVER Realiza recombinacao genetica de dois NPCs
    % Utiliza o metodo Uniform Crossover (50% de chance para cada gene)
    % Assegura o respeito estrito ao Orcamento Global de Atributos (Budget = 1.8)
    
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
        
        % Garantia do Orcamento Global (Budget = 1.8) e limites fisicos nos descendentes
        budget = 1.8;
        ch = [child1; child2];
        u = [(ch(:, 1) - 10.0) / 190.0, ...
             (ch(:, 2) - 5.0)  / 45.0, ...
             (ch(:, 3) - 0.5)  / 2.5, ...
             (ch(:, 4) - 1.0)  / 7.0];
        u = max(0.0, min(1.0, u));
        sum_u = sum(u, 2);
        
        exceeded = sum_u > budget;
        if any(exceeded)
            scale = ones(2, 1);
            scale(exceeded) = budget ./ sum_u(exceeded);
            u = bsxfun(@times, u, scale);
        end
        
        ch(:, 1) = 10.0 + u(:, 1) * 190.0;
        ch(:, 2) = 5.0  + u(:, 2) * 45.0;
        ch(:, 3) = 0.5  + u(:, 3) * 2.5;
        ch(:, 4) = 1.0  + u(:, 4) * 7.0;
        
        child1 = ch(1, :);
        child2 = ch(2, :);
    end
end

