function fitness = fitness_function(T_survival, N_dodge, N_collision, D_taken, D_inflicted, difficulty)
    % FITNESS_FUNCTION Calcula a aptidão multi-objetivo do NPC
    % 
    % Dificuldade 1 (Fácil): Ambiente brando. Incentiva bônus por dano infligido e sobrevivência.
    % Dificuldade 2 (Médio): Ambiente balanceado. Exige harmonia entre ataque e esquiva.
    % Dificuldade 3 (Difícil): Bullet Hell implacável. Evasão e sobrevivência são vitais.
    
    if difficulty == 1 % Fácil
        w1 = 2.0;  % Sobrevivência (Modo brando)
        w2 = 2.0;  % Desvios simples
        w3 = 0.20; % Dano infligido
        p1 = 2.0;  % Penalidade leve por colisão
        p2 = 0.1;  % Penalidade leve por dano
    elseif difficulty == 3 % Difícil
        w1 = 15.0; % Sobrevivência heroica (vale muito no Bullet Hell)
        w2 = 20.0; % Desvios de alto risco
        w3 = 0.50; % Dano infligido sob estresse
        p1 = 5.0;  % Penalidade por colisão amenizada (a morte precoce já pune)
        p2 = 0.2;  % Penalidade por dano amenizada
    else % Médio (difficulty == 2)
        w1 = 6.0;  % Sobrevivência balanceada
        w2 = 8.0;  % Desvios
        w3 = 0.30; % Dano infligido
        p1 = 3.5;  % Penalidade por colisão
        p2 = 0.15; % Penalidade por dano
    end
    
    fitness = (w1 * T_survival) + (w2 * N_dodge) + (w3 * D_inflicted) - (p1 * N_collision) - (p2 * D_taken);
    fitness = max(0.1, fitness);
end

