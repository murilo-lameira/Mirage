# 📖 Desenvolvimento de Comportamento Evasivo e Aprendizado de Esquiva em NPCs: Uma Revisão Crítica da Literatura Científica — Parte 3 de 3

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Revisão Sistemática e Estado da Arte (2024)
> **Artigo Original:** `Desenvolvimento de Comportamento Evasivo e Aprendizado de Esquiva em NPCs_ Uma Revisão Crítica da Literatura Científica e Avanços de Inteligência Artificial em Jogos.html`

---

| Modo de Falha de Recompensa | Manifestação no Jogo | Causa Algorítmica do Ótimo Local | Contrapartida de Engenharia e Correção |
| Mutual Avoidance (Evitação Mútua)  [cite: 25] | Ambos os agentes (NPC e oponente) afastam-se continuamente até os limites opostos da arena, provocando empates por tempo limite em até 99% das rodadas de treino [cite: 25]. | A penalidade aplicada ao sofrer dano é excessiva, e o sistema carece de incentivos para redução de distância e ataque [cite: 25]. | Implementação de modelagem de recompensa ( reward shaping ) que recompense o NPC com pequenos valores positivos ao reduzir a distância útil de engajamento [cite: 35]. |
| Block Turtling (Bloqueio Infinito)  [cite: 25] | O NPC recusa-se a realizar esquivas ativas ou se movimentar, mantendo-se na pose de bloqueio estático durante até 94% da partida [cite: 25]. | A penalidade de sofrer dano atenuado pela guarda é muito inferior ao risco estatístico de tentar um rolamento evasivo mal cronometrado [cite: 25]. | Introdução de quebras de guarda físicas, ataques imbloqueáveis no jogador, penalização incremental por inatividade e danos residuais cumulativos ( chip damage ) [cite: 9, 25]. |
| Damage Collapse (Colapso de Dano)  [cite: 25] | O dano médio desferido pelo NPC cai de valores altos (ex: de 196) para valores irrisórios (ex: 16) ao longo do treinamento [cite: 25]. | O modelo prioriza a segurança absoluta do desvio de forma tão intensa que o risco de se expor ao contra-ataque durante as janelas de golpes ofensivos torna-se proibitivo [cite: 25]. | Ajuste proporcional do fator de escala da recompensa ofensiva em relação às perdas defensivas, penalizando a ausência de tentativas de ataque no tempo [cite: 25]. |
| Idle Agent (Paralisia de Agente)  [cite: 25] | O NPC permanece imóvel no centro da arena em cerca de 44% do tempo de combate, falhando em reagir a projéteis distantes [cite: 25]. | A penalidade por frame transcorrido é irrelevante, permitindo que a inatividade seja tratada como o caminho de menor risco comparado a ações exploratórias perigosas [cite: 25]. | Atribuição de penalidades temporais estritas a cada passo de simulação em que o NPC não execute movimentação coerente ou avanço tático [cite: 11, 25]. |
| HP Blindness (Cegueira de Pontos de Vida)  [cite: 25] | O agente exibe desvios refinados enquanto está com vida cheia, mas desmorona para táticas aleatórias de colisão direta quando sua saúde está baixa (cobrindo apenas 41 de 864 estados mapeados) [cite: 25]. | A amostragem de dados no vetor de estados é insuficiente; devido à alta letalidade do jogador quando o NPC está com vida baixa, o agente morre rápido demais para treinar a política defensiva sob perigo extremo [cite: 25]. | Emprego de inicialização assistida e reinicialização de episódios de treinamento em estados em que o NPC é colocado diretamente com baixa saúde em proximidade com o inimigo [cite: 14, 25]. |
Para além dos desafios puramente matemáticos e de otimização de funções, os projetistas
de jogos enfrentam o paradoxo de que um agente que aprende a se esquivar com acurácia
matemática absoluta anula a diversão do jogo [cite: 32, 36]. A mitigação de tal
comportamento perfeitamente reativo é resolvida pela imposição de limites máximos de
aprendizado, limitação de pesos lógicos ( weight clipping ) e introdução deliberada de
ruído aleatório em tomadas de decisão críticas [cite: 17, 32, 37]. Um exemplo notável de
balanceamento tático não visual é a incorporação de sistemas de trilha sonora adaptativa
que informam o estado de perigo ao agente [cite: 38]. Na plataforma DareFightingICE , uma
trilha sonora dinâmica reajusta o volume e a presença de cinco instrumentos distintos
(piano, violoncelo, flauta, violino e ukulele) com base nos pontos de vida, energia
interna e distância relativa dos lutadores [cite: 38]. Esse sistema permite que agentes de
aprendizado profundo focados em combate (utilizando apenas sinais de áudio estéreo de dois
canais como dados de entrada na rede neural, sem frames visuais) realizem a leitura
espacial de projéteis e executem esquivas eficientes orientadas pela modulação acústica do
cenário [cite: 38].

#### Diretrizes Técnicas e Conclusões da Revisão

A análise consolidada das pesquisas científicas sobre inteligência artificial aplicada ao
comportamento evasivo de NPCs fornece um conjunto claro de diretrizes de arquitetura de
software para engenheiros e desenvolvedores de jogos digitais:

- Substituição de Redes de Decisão Puras por Arquiteturas Híbridas Coerentes:  Projetar o controle do NPC em camadas distintas [cite: 5]. A tomada de decisão de alto nível (estratégica e baseada em contexto) deve permanecer sob o controle de frameworks explicáveis e altamente ajustáveis, como Árvores de Comportamento ou linguagens de regras [cite: 3, 4, 5, 18]. A camada motora de baixo nível (reflexiva e espacial) deve empregar algoritmos de aprendizado por reforço especializados (como o PPO), treinados com foco estrito em tarefas singulares de sobrevivência e posicionamento [cite: 1, 5, 24].
- Controle da Predictabilidade através de Amostragem Probabilística:  Evitar respostas puramente determinísticas baseadas em estados discretos [cite: 7]. A implementação de sistemas de modelagem de oponente on-line baseados em contagens estatísticas de preferência do jogador, acoplados a tomadas de ação via loterias ponderadas, assegura que o NPC mantenha um comportamento diversificado de desvios, reduzindo a sensação artificial de leitura direta de inputs ( input reading ) [cite: 7].
- Implementação de Otimizações de Busca de Caminho e Geometria Temporal:  Para garantir que as esquivas de projéteis ocorram de maneira barata na CPU do jogo, utilizar otimizações de filas de prioridade com heaps binárias na estrutura do algoritmo A* (permitindo cortes de processamento de até 49%) [cite: 33] e projetar detecção preditiva de trajetórias no instante de geração dos ataques na cena, evitando testes redundantes de colisão por raycasting a cada frame [cite: 34].
- Uso de Modelagem de Recompensa Cuidadosa para Evitar Hacking de Comportamento:  Ao projetar fases de treinamento de inimigos autônomos por aprendizado por reforço, contrabalançar as penalidades por colisão com recompensas de engajamento ativo [cite: 25, 35]. O uso combinado de Clonagem de Comportamento offline com dados reais de jogo atua como um estabilizador essencial, reduzindo a incidência de modos de falha graves de aprendizado como a evitação mútua e a paralisia do agente [cite: 14, 25].
Em suma, a criação de inimigos virtuais que aprendem a desviar dos ataques do jogador não reside na busca pela otimização computacional perfeita e na criação de agentes imbatíveis, mas na orquestração de sistemas adaptativos que simulam o tempo de reação, os limites perceptivos e a plasticidade tática de oponentes humanos [cite: 28, 32, 36]. Através da união de modelos estatísticos em tempo real, aprendizado de máquina hierárquico e restrições lógicas de design, a engenharia de jogos consegue produzir inimigos que evoluem dinamicamente com o jogador, enriquecendo o senso de agência, desafio e imersão no ambiente de combate digital [cite: 1, 2, 37].
- (PDF) Enhancing Non-Player Characters (NPC) Behaviour in Video Games Using Reinforcement Learning - ResearchGate, https://www.researchgate.net/publication/395811549_Enhancing_Non-Player_Characters_NPC_Behaviour_in_Video_Games_Using_Reinforcement_Learning
- Game AI Development using Reinforcement Learning - IJIRT, https://ijirt.org/publishedpaper/IJIRT181050_PAPER.pdf
- Kotelkin D. PROGRAMMING NPC BEHAVIOR IN GAMES USING ARTIFICIAL INTELLIGENCE - Вестник науки»., https://www.xn----8sbempclcwd3bmt.xn--p1ai/article/28975
- Customizing Scripted Bots: Sample Efficient Imitation Learning for Human-like Behavior in Minecraft - ALA 2019, https://ala2019.vub.ac.be/papers/ALA2019_paper_27.pdf
- Tencent Unveils Shooter AI Agent That Rejects Player Orders - Inven Global, https://www.invenglobal.com/articles/25084/tencent-unveils-shooter-ai-agent-that-rejects-player-orders
- Creating autonomous adaptive agents in a real-time first-person shooter computer game - InK@SMU.edu.sg, https://ink.library.smu.edu.sg/cgi/viewcontent.cgi?article=6215&context=sis_research
- An Online Adaptive Algorithm for Fighting Games - SBGames, https://www.sbgames.org/sbgames2015/anaispdf/artesedesign-short/147836.pdf
- Kagemusha, Stealth / Strategy Game - Community Showcases - Unity Discussions, https://discussions.unity.com/t/kagemusha-stealth-strategy-game/545749
- AC Black Flag Resynced Combat System Explained and What's New - games.gg, https://games.gg/news/black-flag-resynced-combat-more-demanding/
- (PDF) Testbed for Action Fighting Game AI - ResearchGate, https://www.researchgate.net/publication/393514385_Testbed_for_Action_Fighting_Game_AI
- The Player Learns. Why Don't the Enemies? Building a Reinforcement Learning Souls-Like in One Week | by Jacob James | Medium, https://medium.com/@jpon24/the-player-learns-why-dont-the-enemies-building-a-reinforcement-learning-souls-like-in-one-week-8c4bc3b3d62f
- Game Ai Chapter 3 | Hexo, https://lc1995.github.io/2018/03/13/Game%20Ai%20Chapter%203/
- (PDF) Evolutionary Dynamic Scripting: Adaptation of Expert Rule Bases for Serious Games, https://www.researchgate.net/publication/300897799_Evolutionary_Dynamic_Scripting_Adaptation_of_Expert_Rule_Bases_for_Serious_Games
- Reinforcement Learning Agent for a 2D Shooter Game - arXiv, https://arxiv.org/pdf/2509.15042
- (PDF) Creating Autonomous Adaptive Agents in a Real-Time First-Person Shooter Computer Game - ResearchGate, https://www.researchgate.net/publication/278413947_Creating_Autonomous_Adaptive_Agents_in_a_Real-Time_First-Person_Shooter_Computer_Game
- Skilled Experience Catalogue: A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning - ResearchGate, https://www.researchgate.net/publication/328308718_Skilled_Experience_Catalogue_A_Skill-Balancing_Mechanism_for_Non-Player_Characters_using_Reinforcement_Learning
- A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning - arXiv, https://arxiv.org/pdf/1806.07637
- dynamic npc ai using reinforcement learning for an enhanced gaming experience - ResearchGate, https://www.researchgate.net/publication/389846089_DYNAMIC_NPC_AI_USING_REINFORCEMENT_LEARNING_FOR_AN_ENHANCED_GAMING_EXPERIENCE
- Improving player skills in action games using dynamic scripting AI | Scilit, https://www.scilit.com/publications/0950f78862636085e493e695e46ee7d6
- arXiv:2211.02759v1 [cs.LG] 4 Nov 2022, https://arxiv.org/pdf/2211.02759
- MSMAR-RL: Multi-Step Masked-Attention Recovery Reinforcement Learning for Safe Maneuver Decision in High-Speed Pursuit-Evasion Game | IJCAI, https://www.ijcai.org/proceedings/2025/36
- Reinforcement Learning Methods to Evaluate the Impact of AI Changes in Game Design, https://cdn.aaai.org/ojs/18885/18885-52-22651-1-2-20211004.pdf
- Intelligent NPCs with Unity's ML agents toolkit - Arm Developer, https://developer.arm.com/community/arm-community-blogs/b/mobile-graphics-and-gaming-blog/posts/intelligent-npcs-with-machine-learning
- Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv, https://arxiv.org/html/2410.04936
- Ar9av/human-fight-rl - GitHub, https://github.com/Ar9av/human-fight-rl
- An orb learns to dodge obstacles, collect other orbs and reach the end platform by itself using PPO RL AI : r/godot - Reddit, https://www.reddit.com/r/godot/comments/10h3mmr/an_orb_learns_to_dodge_obstacles_collect_other/
- TRAINING AGENT FOR FIRST-PERSON SHOOTER GAME WITH ACTOR-CRITIC CURRICULUM LEARNING - OpenReview, https://openreview.net/pdf?id=Hk3mPK5gg
- Welcome to Fighting Game AI Competition, https://www.ice.ci.ritsumei.ac.jp/~ftgaic/index-1.html
- I trained an AI to play Resident Evil 4 Remake using Behavioral Cloning + LSTM - Reddit, https://www.reddit.com/r/reinforcementlearning/comments/1s6hhcp/i_trained_an_ai_to_play_resident_evil_4_remake/
- Computer Out-Plays Humans in "Doom" - News - Carnegie Mellon University, https://www.cmu.edu/news/stories/archives/2016/september/AI-agent-survives-doom.html
- AMP: adversarial motion priors for stylized physics-based character control - ResearchGate, https://www.researchgate.net/publication/353626682_AMP_adversarial_motion_priors_for_stylized_physics-based_character_control
- Will we ever see games where the enemy AI is primarily self learning and will get way better as you play? - Reddit, https://www.reddit.com/r/gamedesign/comments/skby20/will_we_ever_see_games_where_the_enemy_ai_is/
- Heap Optimization in A* Pathfinding for Horror Games - Journal of Information Systems and Informatics, https://journal-isi.org/index.php/isi/article/download/941/538
- Making AI dodge projectiles without constant collision checks? : r/gamedev - Reddit, https://www.reddit.com/r/gamedev/comments/anyez2/making_ai_dodge_projectiles_without_constant/
- Teaching a Neural Net to Fight - Luke Salamone's Blog, https://blog.lukesalamone.com/posts/fighting-game-rl/
- Artificial intelligence in video games - Wikipedia, https://en.wikipedia.org/wiki/Artificial_intelligence_in_video_games
- Exploring Dynamic Difficulty Adjustment in Videogames - arXiv, https://arxiv.org/pdf/2007.07220
- Adaptive Background Music for a Fighting Game: A Multi-Instrument Volume Modulation Approach - arXiv, https://arxiv.org/html/2303.15734v3

---

⬅️ [[Parte 02 de 03|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]]
