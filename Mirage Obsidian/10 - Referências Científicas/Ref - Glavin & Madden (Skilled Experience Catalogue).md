# 📚 Referência: Skilled Experience Catalogue: A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning

- **Autores:** Frank G. Glavin e Michael G. Madden
- **Instituição:** School of Computer Science, National University of Ireland, Galway
- **Foco Temático:** Balanceamento dinâmico de dificuldade (DDA), Aprendizado por Reforço e marcos de experiência de NPCs.
- **Origem no Notebook:** `A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning - arXiv` (e duplicado em `PID5441363.pdf`)

## 🔍 Detalhamento Técnico e Metodologia do Artigo
Os autores propõem o mecanismo **Skilled Experience Catalogue (SEC)** como uma solução inovadora de Ajuste Dinâmico de Dificuldade (DDA) para jogos de tiro em primeira pessoa (FPS), combatendo a rigidez e a monotonia de oponentes tradicionais controlados por FSMs.

### ⚙️ O Funcionamento do SEC (Catalisador de Experiência)
A metodologia consiste em duas fases estruturadas de engenharia:
1. **Fase de Treinamento Offline (Construção do Catálogo):** O NPC do jogo é colocado para treinar continuamente contra um oponente utilizando Aprendizado por Reforço (RL). Ao longo de sua linha de evolução temporal, o sistema salva e armazena de forma persistente as políticas de aprendizado (*stored policies*) do NPC em intervalos fixos de tempo. Estas políticas de conhecimento salvos funcionam como "marcos" (*knowledge milestones*) representando níveis incrementais de habilidade/proficiência.
2. **Ajuste e Balanceamento em Tempo Real:** Durante o jogo real contra um jogador humano, o sistema monitora o desempenho do NPC em tempo real (através de um limite tático ou limiar de pontuação).
   - Se o NPC estiver perdendo de forma humilhante, o SEC força um "salto temporal" para a frente na linha do tempo de experiência, carregando uma política de aprendizado mais treinada e avançada para dotar o NPC de mira cirúrgica e reações velozes.
   - Se o NPC estiver dominando de forma excessiva e frustrando o jogador, o SEC realiza um retrocesso na linha temporal, carregando uma política antiga mais amigável e com mais falhas de timing.

### 🛡️ Escopo de Controle e Restrição do NPC
O SEC foi implementado de forma modular no jogo de tiro *Unreal Tournament*:
- O mecanismo de balanceamento dinâmico e aprendizado do SEC foi aplicado **estritamente à habilidade física de pontaria e disparo (aiming/firing proficiency)** do NPC.
- Todas as demais tarefas lógicas de baixo nível do agente — tais como movimentação pelo mapa tático, coleta de itens (armas/vida) e **esquiva de ameaças (opponent evasion)** — permaneceram sob controle de regras estáticas e fixas (*fixed-strategy*).
- Isso isolou cientificamente a variável de teste, demonstrando que as políticas armazenadas pelo catálogo do SEC conseguiram equilibrar a partida contra 5 perfis distintos de oponentes de forma rápida, sem latência excessiva, mantendo o NPC em constante aprendizado paralelo on-line.

## 💡 Aplicação no Projeto S.E.N.A.I.
Essa referência apoia teoricamente a nossa lógica de Dificuldade Escalável. O conceito de carregar diferentes perfis de conhecimento e modular as reações e falhas físicas para aproximar a proficiência da habilidade do jogador é exatamente o que fazemos na nossa matriz de parâmetros Easy/Medium/Hard, fornecendo a base teórica de DDA exigida pela banca.

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Configuração de Dificuldade]]
- [[Função de Fitness]]