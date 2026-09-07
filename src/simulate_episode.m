function [T_survival, N_dodge, N_collision, D_taken, D_inflicted] = simulate_episode(chromosome, visualize, difficulty, gif_filename)
    warning('off', 'all');
    try graphics_toolkit('qt'); catch; end;
    if nargin < 3
        difficulty = 2; % Se não for passado, assume Médio
    end
    if nargin < 4
        gif_filename = ''; % Opcional para gravar GIF animado
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
    
    % Pilares de Cobertura Física Estáticos (Obstáculos que bloqueiam projéteis)
    pillars = [-8.0, -8.0; 8.0, -8.0; -8.0, 8.0; 8.0, 8.0];
    pillar_radius = 1.3;
    
    % Histórico de rastro (Motion Trail) e Projéteis do NPC
    trail_history = [];
    npc_projectiles = [];
    gif_first_frame = true;
    frame_counter = 0;
    
    % Matriz de Projéteis Inimigos
    % Colunas: [posX, posY, velX, velY, status(1=ativo, 0=inativo), status_desvio]
    projectiles = [];
    
    % Setup Visual
    if visualize
        fig = figure('Name', 'Treinamento Tático - Arena Mirage', 'Position', [100, 100, 650, 650]);
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
        
        % PADRÕES AVANÇADOS DE BULLET HELL:
        % Padrão 1: Disparo em Leque (Shotgun Cone Spread) no Médio e Difícil
        if difficulty >= 2 && mod(t, 2.8) < dt && t > 1.0
            angle_shotgun = rand() * 2 * pi;
            spawn_sg = [18 * cos(angle_shotgun), 18 * sin(angle_shotgun)];
            aim_sg = (npc_pos - spawn_sg);
            aim_sg = aim_sg / norm(aim_sg);
            for spread = [-0.22, 0, 0.22]
                cs = cos(spread); ss = sin(spread);
                rot_v = [aim_sg(1)*cs - aim_sg(2)*ss, aim_sg(1)*ss + aim_sg(2)*cs];
                projectiles = [projectiles; spawn_sg, rot_v * (proj_base_speed * 1.05), 1, 0];
            end
        end
        
        % Padrão 2: Onda Espiral Contínua (Danmaku Spiral Vortex) no modo Difícil
        if difficulty == 3 && mod(t, 0.75) < dt && t > 2.0
            ang_spiral = 4.5 * t;
            dir_spiral = [cos(ang_spiral), sin(ang_spiral)];
            projectiles = [projectiles; [0, 0], dir_spiral * 9.5, 1, 0];
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
        
        % Restrição física contra colisão com pilares (NPC não atravessa coberturas)
        for p = 1:size(pillars, 1)
            d_p = npc_pos - pillars(p, :);
            dist_p = norm(d_p);
            min_dist_p = npc_radius + pillar_radius;
            if dist_p < min_dist_p
                if dist_p > 1e-4
                    normal_p = d_p / dist_p;
                    npc_pos = pillars(p, :) + normal_p * min_dist_p;
                    v_dot = dot(npc_vel, normal_p);
                    if v_dot < 0
                        npc_vel = npc_vel - v_dot * normal_p;
                    end
                else
                    npc_pos = npc_pos + [0.1, 0.1];
                end
            end
        end
        
        % Restrição espacial (Bordas da Arena)
        npc_pos = max(min(npc_pos, [18, 18]), [-18, -18]);
        
        % Atualiza os Projéteis e Checa Colisão/Radar/Pilares
        if ~isempty(projectiles)
            active_idx = find(projectiles(:, 5) == 1);
            for i = 1:length(active_idx)
                idx = active_idx(i);
                
                % Movimenta projétil
                projectiles(idx, 1:2) = projectiles(idx, 1:2) + projectiles(idx, 3:4) * dt;
                p_pos = projectiles(idx, 1:2);
                
                % Checa Colisão com Pilares (Pilares absorvem projéteis)
                collided_pillar = false;
                for p = 1:size(pillars, 1)
                    if norm(p_pos - pillars(p, :)) < (pillar_radius + 0.3)
                        projectiles(idx, 5) = 0; % Projétil bloqueado pela cobertura
                        collided_pillar = true;
                        break;
                    end
                end
                if collided_pillar
                    continue;
                end
                
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
        
        % Simula o Dano Causado com estabilidade de movimento e Disparos do NPC
        if mod(t, 1/AttackSpeed) < dt
            current_speed = norm(npc_vel);
            accuracy = max(0.5, 1.0 - (current_speed / MaxSpeed) * 0.3);
            D_inflicted = D_inflicted + (Attack * accuracy);
            
            % Disparo tático do NPC (Projéteis visíveis de contra-ataque)
            if visualize
                aim_angle = rand() * 2 * pi;
                if ~isempty(projectiles)
                    act = find(projectiles(:, 5) == 1);
                    if ~isempty(act)
                        dir_aim = projectiles(act(1), 1:2) - npc_pos;
                        if norm(dir_aim) > 1e-3
                            aim_angle = atan2(dir_aim(2), dir_aim(1));
                        end
                    end
                end
                shot_vel = [cos(aim_angle), sin(aim_angle)] * 16.0;
                npc_projectiles = [npc_projectiles; npc_pos, shot_vel, 1];
            end
        end
        
        % Atualiza projéteis do NPC
        if visualize && ~isempty(npc_projectiles)
            act_p = find(npc_projectiles(:, 5) == 1);
            if ~isempty(act_p)
                npc_projectiles(act_p, 1:2) = npc_projectiles(act_p, 1:2) + npc_projectiles(act_p, 3:4) * dt;
                out_bounds = abs(npc_projectiles(act_p, 1)) > 20 | abs(npc_projectiles(act_p, 2)) > 20;
                npc_projectiles(act_p(out_bounds), 5) = 0;
            end
        end
        
        % Atualiza rastro de movimento (Motion Trail)
        if visualize
            trail_history = [trail_history; npc_pos];
            if size(trail_history, 1) > 12
                trail_history(1, :) = [];
            end
        end
        
        % Atualiza tempo de sobrevivência (Até o NPC morrer ou o tempo acabar)
        T_survival = t;
        
        % RENDERIZAÇÃO GRÁFICA APRIMORADA
        if visualize
            cla; % Limpa o frame
            
            % 1. Limite da Arena, Centro e Pilares de Cobertura
            rectangle('Position', [-18, -18, 36, 36], 'EdgeColor', [0.8, 0.2, 0.2], 'LineStyle', ':', 'LineWidth', 1.5);
            plot(0, 0, 'k+', 'MarkerSize', 8, 'LineWidth', 1.5);
            
            for p = 1:size(pillars, 1)
                rectangle('Position', [pillars(p, 1)-pillar_radius, pillars(p, 2)-pillar_radius, pillar_radius*2, pillar_radius*2], ...
                          'Curvature', [1, 1], 'FaceColor', [0.45, 0.50, 0.55], 'EdgeColor', [0.2, 0.25, 0.3], 'LineWidth', 2);
                text(pillars(p, 1), pillars(p, 2), 'PILAR', 'HorizontalAlignment', 'center', ...
                     'Color', [0.9, 0.95, 1.0], 'FontSize', 7, 'FontWeight', 'bold');
            end
            
            % 2. Rastro de Movimento (Motion Trail)
            if size(trail_history, 1) > 1
                plot(trail_history(:, 1), trail_history(:, 2), 'b:', 'LineWidth', 1.5);
            end
            
            % 3. Radar Periférico do NPC
            rectangle('Position', [npc_pos(1)-radar_radius, npc_pos(2)-radar_radius, radar_radius*2, radar_radius*2], ...
                      'Curvature', [1,1], 'EdgeColor', [0.2, 0.8, 0.9], 'LineStyle', '--');
                      
            % 4. Corpo do NPC (Círculo Azul com borda)
            rectangle('Position', [npc_pos(1)-npc_radius, npc_pos(2)-npc_radius, npc_radius*2, npc_radius*2], ...
                      'Curvature', [1,1], 'FaceColor', [0.1, 0.4, 0.9], 'EdgeColor', 'b', 'LineWidth', 1.5);
            
            % 5. Vetor de Força de Esquiva de Reynolds (Seta Verde de Evasão)
            if norm(total_evade_force) > 0.2
                quiver(npc_pos(1), npc_pos(2), total_evade_force(1)*0.6, total_evade_force(2)*0.6, 0, ...
                       'Color', [0.1, 0.85, 0.2], 'LineWidth', 2.0, 'MaxHeadSize', 0.8);
            end
            
            % 6. Barra de Vida Dinâmica Colorida
            hp_ratio = max(0, HP) / max(1, HP_max);
            if hp_ratio > 0.5
                bar_col = [0.1, 0.8, 0.2]; % Verde
            elseif hp_ratio > 0.25
                bar_col = [0.95, 0.75, 0.1]; % Amarelo / Laranja
            else
                bar_col = [0.9, 0.2, 0.2]; % Vermelho
            end
            rectangle('Position', [npc_pos(1)-1.6, npc_pos(2)+1.8, 3.2, 0.4], 'FaceColor', [0.2, 0.2, 0.2], 'EdgeColor', 'k');
            if hp_ratio > 0.01
                rectangle('Position', [npc_pos(1)-1.6, npc_pos(2)+1.8, 3.2 * hp_ratio, 0.4], 'FaceColor', bar_col, 'EdgeColor', 'none');
            end
            text(npc_pos(1), npc_pos(2)+2.6, sprintf('HP: %d/%d', max(0, round(HP)), round(HP_max)), ...
                'HorizontalAlignment', 'center', 'Color', [0.1 0.1 0.1], 'FontSize', 8, 'FontWeight', 'bold');
            
            % 7. Projéteis Inimigos (Vermelhos)
            if ~isempty(projectiles)
                active = projectiles(:, 5) == 1;
                if any(active)
                    plot(projectiles(active, 1), projectiles(active, 2), 'ro', 'MarkerFaceColor', [0.9, 0.1, 0.1], 'MarkerSize', 6);
                end
            end
            
            % 8. Projéteis do NPC (Ciano / Contra-Ataque)
            if ~isempty(npc_projectiles)
                act_p = npc_projectiles(:, 5) == 1;
                if any(act_p)
                    plot(npc_projectiles(act_p, 1), npc_projectiles(act_p, 2), 'c^', 'MarkerFaceColor', [0.1, 0.9, 0.9], 'MarkerSize', 5);
                end
            end
            
            title(sprintf('Tempo: %.1fs | HP: %d | Desvios: %d | Colisões: %d | Dano: %.0f', t, max(0,round(HP)), N_dodge, N_collision, D_inflicted), 'FontSize', 10);
            axis([-20 20 -20 20]);
            drawnow;
            
            % 9. Gravação opcional de GIF
            if ~isempty(gif_filename)
                frame_counter = frame_counter + 1;
                if mod(frame_counter, 2) == 0 && t <= 8.0 % Grava até 8s em 15 FPS
                    try
                        temp_png = 'temp_gif_frame.png';
                        print(fig, temp_png, '-dpng', '-r60');
                        if exist(temp_png, 'file') == 2
                            img_f = imread(temp_png);
                            delete(temp_png);
                            [im_ind, map_pal] = rgb2ind(img_f);
                            if gif_first_frame
                                imwrite(im_ind, map_pal, gif_filename, 'gif', 'LoopCount', Inf, 'DelayTime', 0.06);
                                gif_first_frame = false;
                            else
                                imwrite(im_ind, map_pal, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.06);
                            end
                        end
                    catch err_gif
                        disp(['ERRO_GIF: ', err_gif.message]);
                    end
                end
                if t >= 6.0
                    break; % Finaliza imediatamente a simulação após gravar os 6s do GIF
                end
            end
            
            pause(0.02); % Mantém a taxa de quadros suave em tempo real (~50 FPS)
        end
    end
end
