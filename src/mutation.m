function mutated_child = mutation(child, mutation_rate)
    % MUTATION Injeta variabilidade genetica na populacao
    % Impede que a evolucao congele em otimos locais
    % Garante que a mutacao respeite o orcamento de atributos (Budget = 1.8)
    
    mutated_child = child;
    budget = 1.8;
    
    % Cromossomo: [HP, Attack, AttackSpeed, MovementSpeed]
    % Limites Absolutos: HP [10, 200], Attack [5, 50], AtkSpeed [0.5, 3.0], MovSpeed [1.0, 8.0]
    min_vals = [10.0, 5.0, 0.5, 1.0];
    max_vals = [200.0, 50.0, 3.0, 8.0];
    scales   = [15.0, 5.0, 0.25, 0.7];
    ranges   = [190.0, 45.0, 2.5, 7.0];
    
    % Perturbação Gaussiana (Box-Muller) por gene com probabilidade mutation_rate
    mask = rand(1, 4) < mutation_rate;
    if any(mask)
        perturb = randn(1, 4) .* scales;
        mutated_child(mask) = mutated_child(mask) + perturb(mask);
        mutated_child = max(min_vals, min(max_vals, mutated_child));
    end
    
    % NORMALIZAÇÃO E APLICAÇÃO DO ORÇAMENTO (TRADE-OFF GLOBAL <= 1.8)
    u = (mutated_child - min_vals) ./ ranges;
    u = max(0.0, min(1.0, u));
    
    sum_u = sum(u);
    if sum_u > budget
        u = u * (budget / sum_u);
    end
    
    mutated_child = min_vals + u .* ranges;
end


