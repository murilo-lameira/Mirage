function fitness = fitness_function(T_survival, N_dodge, N_collision, D_taken, D_inflicted, difficulty)
    % FITNESS_FUNCTION Calcula a aptidão multi-objetivo do NPC
    % 
    % Dificuldade 1 (Fácil): Ambiente brando. Incentiva bônus por dano infligido e sobrevivência.
    % Dificuldade 2 (Médio): Ambiente balanceado. Exige harmonia entre ataque e esquiva.
    % Dificuldade 3 (Difícil): Bullet Hell implacável. Evasão e sobrevivência são vitais.
    
    if difficulty == 1 % Fácil
        w1 = 2.0;  % Sobrevivência
        w2 = 3.0;  % Desvios
        w3 = 0.20; % Dano infligido
        p1 = 3.0;  % Penalidade por colisão
        p2 = 0.2;  % Penalidade por dano tomado
    elseif difficulty == 3 % Difícil
        w1 = 3.5;  % Sobrevivência
        w2 = 12.0; % Desvios com sucesso
        w3 = 0.05; % Dano infligido
        p1 = 25.0; % Penalidade severa por colisão
        p2 = 1.0;  % Penalidade por dano tomado
    else % Médio (difficulty == 2)
        w1 = 2.5;  % Sobrevivência
        w2 = 6.0;  % Desvios
        w3 = 0.10; % Dano infligido
        p1 = 12.0; % Penalidade por colisão
        p2 = 0.5;  % Penalidade por dano tomado
    end
    
    fitness = (w1 * T_survival) + (w2 * N_dodge) + (w3 * D_inflicted) - (p1 * N_collision) - (p2 * D_taken);
    fitness = max(0.1, fitness);
end

