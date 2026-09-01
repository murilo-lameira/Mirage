function population = init_population(pop_size)
    % INIT_POPULATION Inicializa a geracao 0 de NPCs com orcamento de atributos (Point-Buy Budget).
    % Cromossomo: [HP, Attack, AttackSpeed, MovementSpeed]
    % Limites Físicos:
    %   HP: [10, 200]
    %   Attack: [5, 50]
    %   AttackSpeed: [0.5, 3.0] Hz
    %   MovementSpeed: [1.0, 8.0] m/s
    %
    % Regra do Orçamento (Budget Total = 2.0 de 4.0 possíveis):
    % Cada atributo normalizado u_i varia de 0 a 1. A soma sum(u_i) <= 2.0.
    % Isso impede que o NPC seja perfeito em tudo simultaneamente.
    
    population = zeros(pop_size, 4);
    budget = 1.8; % Orçamento máximo normalizado
    
    for i = 1:pop_size
        % Sorteia valores normalizados aleatórios [0, 1]
        u = rand(1, 4);
        
        % Se exceder o orçamento total, reescala proporcionalmente
        sum_u = sum(u);
        if sum_u > budget
            u = u * (budget / sum_u);
        end
        
        % Converte para as unidades físicas reais
        hp = 10 + u(1) * 190;
        attack = 5 + u(2) * 45;
        atk_speed = 0.5 + u(3) * 2.5;
        mov_speed = 1.0 + u(4) * 7.0;
        
        population(i, :) = [hp, attack, atk_speed, mov_speed];
    end
end

