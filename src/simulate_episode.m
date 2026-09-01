function [T_survival, N_dodge, N_collision, D_taken, D_inflicted] = simulate_episode(chromosome, visualize, difficulty)
    if nargin < 3
        difficulty = 2; % Se não for passado, assume Médio
    end
    % SIMULATE_EPISODE Roda a simulação de combate de 1 NPC contra uma
    % chuva de projéteis automatizados para avaliar o fitness físico.
    
    % Desempacotando o Cromossomo
    % [HP, Attack, AttackSpeed, MovementSpeed]
    HP_max = chromosome(1);
    Attack = chromosome(2);
    AttackSpeed = chromosome(3);
    MaxSpeed = chromosome(4);

    HP = HP_max;
    
    % Métricas de saída para a Função de Fitness
    T_survival = 0;
    N_dodge = 0;
    N_collision = 0;
    D_taken = 0;
    D_inflicted = 0;
    
    % Parâmetros Físicos do Tempo e Espaço
    dt = 0.05;              % Delta de tempo por frame
    max_time = 30.0;        % Duração máxima do round (30 segundos)
    npc_radius = 1.0;       % Tamanho da "hitbox" do NPC
    radar_radius = 4.0;     % Área de detecção periférica
    
    % Estado Inicial do NPC (Centro da arena)
    npc_pos = [0, 0];
    npc_vel = [0, 0];
    
    % Matriz de Projéteis
    % Colunas: [posX, posY, velX, velY, status(1=ativo, 0=inativo), status_desvio]
    projectiles = [];
    
    % Setup Visual
    if visualize
        fig = figure('Name', 'Treinamento Tático - Arena', 'Position', [100, 100, 600, 600]);
        axis([-20 20 -20 20]);
        hold on; grid on;
    end
    
    % Loop principal de Física
    for t = 0:dt:max_time
        if HP <= 0
            break; % NPC foi destruído
        end
        
        % Atirador Automatizado (Spawna projéteis periodicamente)
        % A Dificuldade afeta velocidade, cadência e precisão dos tiros
        if difficulty == 3 % Difícil (Bullet Hell de alta velocidade e precisão)
            spawn_rate = max(0.10, 0.30 - (t / max_time) * 0.15);
            proj_base_speed = 13.5;
            noise_scale = 0.08;
        elseif difficulty == 1 % Fácil (Poucos tiros, mais lentos e dispersos)
            spawn_rate = max(0.70, 1.40 - (t / max_time) * 0.30);
            proj_base_speed = 9.0;
            noise_scale = 0.25;
        else % Médio (Balanceado)
            spawn_rate = max(0.22, 0.75 - (t / max_time) * 0.35);
            proj_base_speed = 11.5;
            noise_scale = 0.15;
        end
        
        if mod(t, spawn_rate) < dt 
            % Spawna na borda da arena em um ângulo aleatório
            angle = rand() * 2 * pi;
            spawn_pos = [18*cos(angle), 18*sin(angle)];
            
            % Mira no NPC com ruído dependente da dificuldade
            aim_dir = (npc_pos - spawn_pos);
            aim_dir = aim_dir / norm(aim_dir);
            noise = (rand(1,2) - 0.5) * noise_scale; 
            
            proj_vel = (aim_dir + noise) * proj_base_speed;
            
            % Adiciona ao array de ativos
            projectiles = [projectiles; spawn_pos, proj_vel, 1, 0];
        end
        
        % O NPC escaneia o ambiente e calcula a força somada para fugir
        total_evade_force = [0, 0];
        if ~isempty(projectiles)
            active_idx = find(projectiles(:, 5) == 1);
            for i = 1:length(active_idx)
                idx = active_idx(i);
                p_pos = projectiles(idx, 1:2);
                p_vel = projectiles(idx, 3:4);
                
                % Aciona a mecânica matemática de Reynolds
                f = calculate_evade_force(npc_pos, npc_vel, p_pos, p_vel, MaxSpeed);
                total_evade_force = total_evade_force + f;
            end
        end
        
        % Atualização Física do NPC (F = m*a, assumindo massa = 1)
        npc_vel = npc_vel + total_evade_force * dt;
        
        % Aplica Limite Genético de Velocidade (MovementSpeed)
        speed = norm(npc_vel);
        if speed > MaxSpeed
            npc_vel = (npc_vel / speed) * MaxSpeed;
        end
        
        % Atrito natural (para o NPC frear se não houver perigo)
        if norm(total_evade_force) < 1e-3
            npc_vel = npc_vel * 0.85; 
        end
        
        % Integração da Posição
        npc_pos = npc_pos + npc_vel * dt;
        
        % Restrição espacial (Bordas da Arena)
        npc_pos = max(min(npc_pos, [18, 18]), [-18, -18]);
        
        % Atualiza os Projéteis e Checa Colisão/Radar
        if ~isempty(projectiles)
            active_idx = find(projectiles(:, 5) == 1);
            for i = 1:length(active_idx)
                idx = active_idx(i);
                
                % Movimenta projétil
                projectiles(idx, 1:2) = projectiles(idx, 1:2) + projectiles(idx, 3:4) * dt;
                p_pos = projectiles(idx, 1:2);
                
                % Checa distância do NPC
                dist = norm(npc_pos - p_pos);
                
                % 1) COLISÃO DIRETA
                if dist < npc_radius + 0.3
                    projectiles(idx, 5) = 0; % Desativa
                    N_collision = N_collision + 1;
                    
                    damage = 25; % Dano base do tiro
                    HP = HP - damage;
                    D_taken = D_taken + damage;
                
                % 2) ENTRA NO RADAR DE PERIGO (Fica perto, mas não acerta)
                elseif dist < radar_radius && projectiles(idx, 6) == 0
                    projectiles(idx, 6) = 1; % Marcado como "Ameaça Iminente"
                
                % 3) SAIU DO RADAR COM SUCESSO (Desvio efetuado!)
                elseif dist >= radar_radius && projectiles(idx, 6) == 1
                    projectiles(idx, 6) = 2; % Marcado como "Desvio Bem Sucedido"
                    N_dodge = N_dodge + 1;
                end
                
                % Desativa projéteis que saíram da arena
                if abs(p_pos(1)) > 20 || abs(p_pos(2)) > 20
                    projectiles(idx, 5) = 0;
                end
            end
        end
        
        % Simula o Dano Causado com estabilidade de movimento
        if mod(t, 1/AttackSpeed) < dt
            current_speed = norm(npc_vel);
            accuracy = max(0.5, 1.0 - (current_speed / MaxSpeed) * 0.3);
            D_inflicted = D_inflicted + (Attack * accuracy);
        end
        
        % Atualiza tempo de sobrevivência (Até o NPC morrer ou o tempo acabar)
        T_survival = t;
        
        % RENDERIZAÇÃO GRÁFICA
        if visualize
            cla; % Limpa o frame
            
            % Desenha Radar Periférico
            rectangle('Position', [npc_pos(1)-radar_radius, npc_pos(2)-radar_radius, radar_radius*2, radar_radius*2], ...
                      'Curvature', [1,1], 'EdgeColor', 'c', 'LineStyle', '--');
                      
            % Desenha Corpo do NPC
            rectangle('Position', [npc_pos(1)-npc_radius, npc_pos(2)-npc_radius, npc_radius*2, npc_radius*2], ...
                      'Curvature', [1,1], 'FaceColor', 'b');
            
            % Barra de Vida (Texto Flutuante)
            text(npc_pos(1), npc_pos(2)+2, sprintf('HP: %d', max(0, HP)), ...
                'HorizontalAlignment', 'center', 'Color', 'k', 'FontWeight', 'bold');
            
            % Desenha Projéteis
            if ~isempty(projectiles)
                active = projectiles(:, 5) == 1;
                if any(active)
                    plot(projectiles(active, 1), projectiles(active, 2), 'ro', 'MarkerFaceColor', 'r');
                end
            end
            
            title(sprintf('Sobrevivência: %.2fs | HP: %d | Desvios: %d | Colisões: %d', t, max(0,HP), N_dodge, N_collision));
            axis([-20 20 -20 20]);
            drawnow;
            pause(0.02); % Mantém a taxa de quadros suave em tempo real (~50 FPS)
        end
    end
end
