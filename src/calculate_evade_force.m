function F_evade = calculate_evade_force(npc_pos, npc_vel, proj_pos, proj_vel, max_speed)
    % calculate_evade_force Calcula a força de esquiva perpendicular 
    % usando os princípios de Steering Behaviors (Evade) de Reynolds.
    % 
    % Baseado no artigo de Lee (KIOTS): O NPC não foge simplesmente da
    % posição atual do projétil, mas sim do ponto futuro de interseção.

    % Vetor posição e velocidade relativa
    pr = proj_pos - npc_pos;
    vr = proj_vel - npc_vel;

    % Tempo até o ponto mais próximo de aproximação (CPA - Closest Point of Approach)
    speed_sq = dot(vr, vr);
    if speed_sq < 1e-6
        t_cpa = 0;
    else
        t_cpa = -dot(pr, vr) / speed_sq;
    end

    F_evade = [0, 0];
    
    % Se o tempo for positivo, o projétil está vindo em nossa direção.
    % Limitamos a predição a um horizonte de tempo de 1.5s (não desvia de coisas muito longe)
    if t_cpa > 0 && t_cpa < 1.5 
        % Posições projetadas no futuro
        npc_future = npc_pos + npc_vel * t_cpa;
        proj_future = proj_pos + proj_vel * t_cpa;
        
        % Distância no momento de maior aproximação
        dist_cpa = norm(npc_future - proj_future);
        
        % Se a distância futura for menor que um raio de segurança (ex: 2.5 metros)
        if dist_cpa < 2.5
            % A direção de fuga é oposta ao projétil no futuro
            evade_dir = npc_future - proj_future;
            
            if norm(evade_dir) < 1e-6
                % Se for uma colisão exata (na mosca), escolhe uma 
                % perpendicular genérica baseada na velocidade do projétil
                evade_dir = [-proj_vel(2), proj_vel(1)];
            end
            
            % Normaliza a direção
            evade_dir = evade_dir / norm(evade_dir);
            
            % A velocidade desejada é fugir na velocidade máxima
            desired_vel = evade_dir * max_speed;
            
            % Força de condução (Steering Force)
            F_evade = desired_vel - npc_vel;
        end
    end
end
