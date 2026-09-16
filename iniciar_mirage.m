% =========================================================================
% 🚀 INICIAR_MIRAGE: MENU INTERATIVO PARA MATLAB E GNU OCTAVE
% =========================================================================
% Pressione F5 ou digite 'iniciar_mirage' no Command Window do MATLAB / Octave.
% =========================================================================

clear; close all; clc;

% Configuração automática de caminhos do projeto
root_dir = fileparts(mfilename('fullpath'));
cd(root_dir);
addpath(fullfile(root_dir, 'src'));

fprintf('=======================================================================\n');
fprintf('         PROJETO MIRAGE - ALGORITMOS GENÉTICOS EM JOGOS\n');
fprintf('     Inimigos Virtuais que Aprendem a Desviar em Tempo Real\n');
fprintf('   Engenharia de Controle e Automação - UNISENAI Joinville\n');
fprintf('=======================================================================\n\n');

escolha = menu('Painel Principal - Projeto Mirage', ...
               '1. Assistir NPC Campeão em Ação (Arena 2D)', ...
               '2. Demonstração Rápida no Modo Difícil (Bullet Hell)', ...
               '3. Iniciar Treinamento do Algoritmo Genético', ...
               '4. Gerar Todos os Gráficos Científicos e Boxplots', ...
               '5. Executar Teste Estatístico de Hipóteses (ANOVA / Teste t)', ...
               '6. Gerar GIF Animado de Combate', ...
               'Sair');

switch escolha
    case 1
        assistir_simulacao;
    case 2
        difficulty = 3;
        assistir_simulacao;
    case 3
        npc_evasivo_ga;
    case 4
        fprintf('\nGerando gráficos científicos e análises...\n');
        gerar_graficos_comparativos;
        analise_evolucao_media;
        gerar_heatmap_map_elites;
        gerar_boxplots;
        fprintf('\nTodos os gráficos foram exportados para data/graficos/\n');
    case 5
        teste_estatistico_hipoteses;
    case 6
        gerar_gif_animado;
    otherwise
        fprintf('Painel Mirage encerrado.\n');
end
