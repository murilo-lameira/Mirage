# 📖 Desenvolvimento de Comportamento Evasivo e Aprendizado de Esquiva em NPCs: Uma Revisão Crítica da Literatura Científica — Parte 2 de 3

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Revisão Sistemática e Estado da Arte (2024)
> **Artigo Original:** `Desenvolvimento de Comportamento Evasivo e Aprendizado de Esquiva em NPCs_ Uma Revisão Crítica da Literatura Científica e Avanços de Inteligência Artificial em Jogos.html`

---

- Inicialização por Aprendizado por Imitação offline:  O agente é exposto a um conjunto de dados contendo trajetórias de combates reais de jogadores humanos ou scripts complexos criados por designers [cite: 4, 14, 29]. O modelo aprende uma política inicial de evasão e posicionamento por meio de Clonagem de Comportamento ( Behavioral Cloning ), o que o protege contra falhas catastróficas nas primeiras iterações [cite: 4, 14, 29].
- Otimização On-line por Aprendizado por Reforço:  Partindo dessa base de imitação estável, o NPC interage dinamicamente com o cenário e com o jogador humano para refinar as esquivas finas de maneira adaptativa através de gradientes de política [cite: 2, 14].
Essa metodologia híbrida alcança taxas de vitória consistentemente superiores a 70% contra oponentes heurísticos padrão, apresentando uma variância de desempenho substancialmente menor em comparação com métodos que dependem puramente de exploração do zero [cite: 14].
##### Arquitetura de Camada Dupla ( Dual-Layer System )

Uma abordagem industrial de alto desempenho desenvolvida pela Tencent Games adota uma
estrutura de controle hierárquico em duas camadas para agentes avançados em jogos de
combate tático [cite: 5, 24]:

+-------------------------------------------------------------+ | SISTEMA COGNITIVO DE
ALTO NÍVEL | | (Vision-Language Model ou Árvore de Comportamento) | | Decide de forma
abstrata: "O que fazer" (ex: Recuar) |
+------------------------------------+------------------------+ | | Comando Estratégico v
+-------------------------------------------------------------+ | SISTEMA DE EXECUÇÃO DE
BAIXO NÍVEL | | (Agente treinado por Reforço / RL) | | Resolve em tempo real: "Como fazer"
(ex: Esquiva Física) | +-------------------------------------------------------------+

O sistema de alto nível atua em uma escala de tempo semântica e macroscópica (tomando
decisões de alta latência), enquanto o controlador de baixo nível processa os motores
físicos do NPC a taxas de amostragem extremamente rápidas, fornecendo respostas reflexivas
de evasão, uso de coberturas estáticas e mudanças de postura dinâmica com base em
projeções de perigo imediatas [cite: 5]. Esse modelo foi implementado com sucesso em
ambientes de produção de larga escala, como no simulador tático Arena Breakout , sob a
denominação de Private Military Company Agent (PMCA) [cite: 24]. O agente integra dados de
navegação via Navmesh e regras de tiro a modelos de DRL, gerando inimigos que manobram e
desviam de forma taticamente coordenada ao longo de partidas prolongadas [cite: 24]. Essa
lógica de reação adaptativa também foi integrada à produção de títulos comerciais de ação
e aventura [cite: 9]. Na reestruturação de sistemas para Assassin's Creed Black Flag
Resynced , a inteligência dos inimigos foi reconstruída sobre motores de aprendizado de
hábitos [cite: 9]. O sistema pune a repetição excessiva de padrões do jogador humano: se o
usuário abusa de comandos de chute ou ataques sequenciais simples, a IA reajusta
dinamicamente a sua janela de tomada de decisão para disparar desvios rápidos e
contra-ataques indefensáveis, forçando o jogador a diversificar seu repertório mecânico de
jogo [cite: 9].

#### Algoritmos de Navegação e Otimização Geométrica Espacial

Para que a resposta evasiva de um NPC seja percebida como inteligente, ela precisa estar
acoplada a um sistema de navegação robusto que garanta trajetórias de desvio livres de
colisões com elementos estáticos do cenário [cite: 2, 12, 33]. Contudo, a realização
contínua de verificações volumétricas tridimensionais em tempo real para múltiplos
projéteis ativos gera gargalos de processamento que degradam a taxa de quadros por segundo
(FPS) do jogo [cite: 34]. A engenharia de sistemas de jogos soluciona esse problema por
meio de técnicas geométricas e otimizações algorítmicas de busca de caminhos [cite: 12,
33].

##### Otimização de Busca de Caminho com Heaps Binárias

O algoritmo A* é o método padrão de busca de caminho na indústria de jogos devido à sua
eficiência matemática no cálculo do menor trajeto entre nós [cite: 33]. Contudo, em
cenários de combate dinâmico e perseguição e evasão (como em jogos de terror ou tiro
rápido), o custo computacional de gerenciar a ordenação e a busca do nó de menor custo de
deslocamento na fila de prioridades do algoritmo (denominada Open List ) pode ser
excessivamente alto [cite: 33]. A introdução de uma estrutura de dados baseada em Heap
Binária para organizar a Open List reduz a complexidade temporal das operações de busca e
extração do nó de custo mínimo [cite: 33]. A Tabela 3 resume a comparação empírica de
desempenho de desempenho entre a busca de caminho clássica e a versão otimizada com heap
binária, medida em um protótipo construído na engine Unity:

| Métrica de Desempenho | Algoritmo A* Clássico | Algoritmo A* com Otimização de Heap Binária | Percentual de Melhoria |
| Tempo Médio de Processamento | 3,16 ms | 1,60 ms | 49,37% de redução de tempo  [cite: 33] |
| Impacto no Comportamento | Latência perceptível em caminhos longos | Respostas imediatas e fluidas de perseguição e desvio de rota [cite: 33] | — |
Essa otimização permite que o NPC recalcule de forma responsiva suas rotas de fuga ou
movimentação evasiva, antecipando as ações de interceptação do jogador [cite: 33].

##### Heurísticas de Steering Behaviors aplicadas à Esquiva

Para a execução física da movimentação evasiva contínua em espaços de jogo bidimensionais
ou tridimensionais, utilizam-se os comportamentos de condução mecânica de Craig Reynolds,
conhecidos como Steering Behaviors [cite: 12]. O comportamento clássico de esquiva ( Evade
) é estruturado como uma extensão direta do comportamento de fuga ( Flee ) [cite: 12].
Enquanto a ação de fuga gera uma força vetorial que empurra o agente diretamente para
longe da coordenada atual de uma ameaça, a força evasiva prevê a interseção de trajetórias
[cite: 12]. O algoritmo calcula a distância atual entre o NPC e o projétil perseguidor e
projeta um vetor de fuga direcionado para longe da posição futura estimada da ameaça,
escalado com base nas velocidades relativas e no tempo de projeção necessário para desviar
da linha de impacto [cite: 12].

#### Modos de Falha de Recompensa e o Paradoxo do Balanceamento

A modelagem de agentes autônomos por meio de ciclos de feedback de recompensa e
penalidade frequentemente gera comportamentos indesejados devido ao fenômeno conhecido
como reward hacking (manipulação adaptativa da função de recompensa pelo algoritmo) [cite:
3, 35]. Em jogos de combate e luta em tempo real, onde os comportamentos permitidos
incluem ataque, defesa estática, movimentação geral e esquivas ativas, o balanceamento
incorreto dos termos escalares da função de recompensa induz o agente a convergir para
ótimos locais indesejados [cite: 25, 35]. A análise prática de testes de treinamento de
agentes de combate (como os registrados em ambientes abertos em navegadores utilizando
bibliotecas de Q-learning com tabelas de estados-ações) revela cinco modos de falha
estruturais em funções de recompensa [cite: 25]. A Tabela 4 categoriza essas falhas de
design, suas manifestações comportamentais no jogo e as soluções algorítmicas de
engenharia para sua correção:


---

⬅️ [[Parte 01 de 03|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]] | [[Parte 03 de 03|Próxima Parte]] ➡️
