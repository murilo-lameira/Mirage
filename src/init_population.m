function population = init_population(pop_size)
    % INIT_POPULATION Inicializa a geracao 0 de NPCs com orcamento de atributos (Point-Buy Budget).
    % Cromossomo: [HP, Attack, AttackSpeed, MovementSpeed]
    % Limites Físicos:
    %   HP: [10, 200]
    %   Attack: [5, 50]
    %   AttackSpeed: [0.5, 3.0] Hz
    %   MovementSpeed: [1.0, 8.0] m/s
    %
    % Regra do Orçamento (Budget Total = 1.8 de 4.0 possíveis):
    % Cada atributo normalizado u_i varia de 0 a 1. A soma sum(u_i) <= 1.8.
    % Isso impede que o NPC seja perfeito em tudo simultaneamente.
    
    budget = 1.8; % Orçamento máximo normalizado
    
    % Sorteia valores normalizados aleatórios [0, 1]
    u = rand(pop_size, 4);
    sum_u = sum(u, 2);
    
    % Se exceder o orçamento total, reescala proporcionalmente (Broadcasting compatível Octave/MATLAB)
    exceeded = sum_u > budget;
    if any(exceeded)
        scale = ones(pop_size, 1);
        scale(exceeded) = budget ./ sum_u(exceeded);
        u = bsxfun(@times, u, scale);
    end
    
    % Converte para as unidades físicas reais
    population = zeros(pop_size, 4);
    population(:, 1) = 10.0 + u(:, 1) * 190.0;
    population(:, 2) = 5.0  + u(:, 2) * 45.0;
    population(:, 3) = 0.5  + u(:, 3) * 2.5;
    population(:, 4) = 1.0  + u(:, 4) * 7.0;
end


