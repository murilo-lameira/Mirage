% Script de Teste Rápido (Sprint 1)
% Testa a física e evasão em um cenário visual

clc; clear; close all;

% Cria um cromossomo de testes balanceado
% [HP, Attack, AttackSpeed, MovementSpeed]
test_chromosome = [100, 15, 1.5, 6.5];

fprintf('Iniciando simulacao de teste...\n');
fprintf('NPC Genoma: Velocidade = %.1f, HP = %d\n', test_chromosome(4), test_chromosome(1));

% Roda 1 episódio inteiro forçando a visualização (true)
[T_surv, N_dodges, N_colls, D_taken, D_inflict] = simulate_episode(test_chromosome, true);

fprintf('--- RESULTADOS DO TESTE ---\n');
fprintf('Tempo Sobrevivencia: %.2f segundos\n', T_surv);
fprintf('Total de Desvios (Dodges): %d\n', N_dodges);
fprintf('Total de Colisoes: %d\n', N_colls);
fprintf('Dano Recebido: %d\n', D_taken);
fprintf('Dano Infligido: %d\n', D_inflict);
