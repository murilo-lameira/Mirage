function mutated_child = mutation(child, mutation_rate)
    % MUTATION Injeta variabilidade genetica na populacao
    % Impede que a evolucao congele em otimos locais
    % Garante que a mutacao respeite o orcamento de atributos (Budget)
    
    mutated_child = child;
    budget = 1.8;
    
    % Cromossomo: [HP, Attack, AttackSpeed, MovementSpeed]
    % Limites Absolutos: HP [10, 200], Attack [5, 50], AtkSpeed [0.5, 3.0], MovSpeed [1.0, 8.0]
    
    for g = 1:4
        if rand() < mutation_rate
            if g == 1 % HP
                mutated_child(g) = mutated_child(g) + (randn() * 15);
                mutated_child(g) = max(10, min(200, mutated_child(g)));
            elseif g == 2 % Attack
                mutated_child(g) = mutated_child(g) + (randn() * 5);
                mutated_child(g) = max(5, min(50, mutated_child(g)));
            elseif g == 3 % AttackSpeed
                mutated_child(g) = mutated_child(g) + (randn() * 0.25);
                mutated_child(g) = max(0.5, min(3.0, mutated_child(g)));
            elseif g == 4 % MovementSpeed
                mutated_child(g) = mutated_child(g) + (randn() * 0.7);
                mutated_child(g) = max(1.0, min(8.0, mutated_child(g)));
            end
        end
    end
    
    % NORMALIZAÇÃO E APLICAÇÃO DO ORÇAMENTO (TRADE-OFF GLOBAL)
    u = zeros(1, 4);
    u(1) = (mutated_child(1) - 10) / 190;
    u(2) = (mutated_child(2) - 5) / 45;
    u(3) = (mutated_child(3) - 0.5) / 2.5;
    u(4) = (mutated_child(4) - 1.0) / 7.0;
    
    % Garante limites unitários antes de somar
    u = max(0.0, min(1.0, u));
    
    sum_u = sum(u);
    if sum_u > budget
        u = u * (budget / sum_u);
    end
    
    mutated_child(1) = 10 + u(1) * 190;
    mutated_child(2) = 5 + u(2) * 45;
    mutated_child(3) = 0.5 + u(3) * 2.5;
    mutated_child(4) = 1.0 + u(4) * 7.0;
end

