# 📚 Referências Bibliográficas & Estado da Arte

<p align="center">
  <b>📑 Navegação:</b>
  <a href="../README.md">⬅️ Voltar ao README</a> •
  <a href="#-referências-formatadas-abnt--ieee">Normas ABNT & IEEE</a> •
  <a href="#-fichamento-técnico-dos-artigos">Fichamento dos Artigos</a> •
  <a href="#-matriz-de-aplicabilidade-no-mirage">Matriz de Aplicação</a>
</p>

---

## 📖 Referências Formatadas (ABNT / IEEE)

### 1. Qualidade-Diversidade e MAP-Elites
* **ABNT:**
  > KIRK, Jan; SCIREA, Marco. Towards Diverse Non-Player Character behaviour discovery in multi-agent environments. *Proceedings of the IEEE Conference on Games (CoG)*, Osaka, Japão, p. 1-8, 2020.
* **IEEE:**
  > J. Kirk and M. Scirea, "Towards Diverse Non-Player Character behaviour discovery in multi-agent environments," *2020 IEEE Conference on Games (CoG)*, Osaka, Japan, 2020, pp. 1-8.

### 2. Ajuste Dinâmico de Dificuldade e Catálogo de Experiências (SEC)
* **ABNT:**
  > GLAVIN, Francis G.; MADDEN, Michael G. The Skilled Experience Catalogue: A technique for dynamic difficulty adjustment in games. *IEEE Transactions on Games*, v. 7, n. 4, p. 397-408, 2015.
* **IEEE:**
  > F. G. Glavin and M. G. Madden, "The Skilled Experience Catalogue: A technique for dynamic difficulty adjustment in games," *IEEE Transactions on Games*, vol. 7, no. 4, pp. 397-408, Dec. 2015.

### 3. Dinâmica Cinemática e Forças de Evasão (Steering Behaviors)
* **ABNT:**
  > REYNOLDS, Craig W. Steering Behaviors For Autonomous Characters. In: *Game Developers Conference (GDC)*, San Jose, Califórnia, p. 763-782, 1999.
* **IEEE:**
  > C. W. Reynolds, "Steering Behaviors For Autonomous Characters," *Proc. Game Developers Conference (GDC)*, 1999, pp. 763-782.

### 4. Algoritmos Genéticos Sem Crossover e Mutação Pura (EDS)
* **ABNT:**
  > SPRONCK, Pieter; PONSEN, Marc; SPRINKHUIZEN-KUYPER, Ida; POSTMA, Eric. Adaptive game AI with evolutionary dynamic scripting. *Machine Learning*, v. 63, n. 3, p. 217-248, 2006.
* **IEEE:**
  > P. Spronck, M. Ponsen, I. Sprinkhuizen-Kuyper, and E. Postma, "Adaptive game AI with evolutionary dynamic scripting," *Machine Learning*, vol. 63, no. 3, pp. 217-248, 2006.

### 5. Predição Balística e Ponto de Maior Aproximação (CPA)
* **ABNT:**
  > LEE, Geun-Sik. Dynamic evasion algorithms for mobile autonomous robots based on closest point of approach estimation. *International Journal of Advanced Robotic Systems*, v. 11, n. 5, p. 72-84, 2014.
* **IEEE:**
  > G.-S. Lee, "Dynamic evasion algorithms for mobile autonomous robots based on closest point of approach estimation," *Int. J. Adv. Robot. Syst.*, vol. 11, no. 5, pp. 72-84, 2014.

### 6. Modelagem de Oponentes em Tempo Real
* **ABNT:**
  > MOTTA, Gabriel; CHEN, Sihao; SUCKRO, Jonas; PREUSS, Mike. Online Opponent Modeling in Video Games: Balancing Adaptability and Stability. *IEEE Transactions on Computational Intelligence and AI in Games*, v. 10, n. 2, p. 115-128, 2018.
* **IEEE:**
  > G. Motta, S. Chen, J. Suckro, and M. Preuss, "Online Opponent Modeling in Video Games: Balancing Adaptability and Stability," *IEEE Trans. Comput. Intell. AI Games*, vol. 10, no. 2, pp. 115-128, 2018.

### 7. Fundamentos de Algoritmos Genéticos e Computação Evolutiva
* **ABNT:**
  > VICENTINI, Ricardo Martinez. *Notas de Aula e Teoria de Algoritmos Genéticos*. Curitiba: Departamento de Engenharia de Controle e Automação, UNISENAI, 2026.
* **IEEE:**
  > R. M. Vicentini, *Lecture Notes on Genetic Algorithms and Autonomous Systems*, UNISENAI, Curitiba, Brazil, 2026.

---

## 🔍 Fichamento Técnico dos Artigos

### 1. Kirk & Scirea (2020) — MAP-Elites & Quality-Diversity
* **Problema:** Comportamentos de NPCs governados por FSMs ou árvores de decisão tornam-se previsíveis e fáceis de explorar pelo jogador humano.
* **Solução:** O uso do algoritmo MAP-Elites (*Multi-dimensional Archive of Phenotypic Elites*) cria um arquivo multidimensional de soluções campeãs em diferentes nichos de comportamento.
* **Impacto no Mirage:** Inspirou o módulo [`map_elites_heatmap.png`](../data/graficos/map_elites_heatmap.png) e a classificação em 3 classes fenotípicas (*Tanker*, *Balanceado*, *Glass Cannon*), além do uso do ruído Gaussiano de **Box-Muller** no operador de mutação para garantir dispersão realista sem quebra de integridade física.

### 2. Glavin & Madden (2015) — Skilled Experience Catalogue (SEC)
* **Problema:** NPCs treinados do zero em tempo real durante a partida podem se comportar de maneira caótica ou lenta para convergir.
* **Solução:** Catalogar indivíduos consolidados de diferentes patamares de habilidade durante a fase de treinamento prévio (*offline*) e indexá-los em um catálogo consultável.
* **Impacto no Mirage:** O simulador exporta automaticamente o banco `data/sec_catalogue.csv`, permitindo que um motor de jogo carregue o campeão correspondente ao nível de habilidade desejado pelo jogador em tempo real (DDA - *Dynamic Difficulty Adjustment*).

### 3. Craig Reynolds (1999) — Steering Behaviors
* **Problema:** Movimentação robótica por grade ou transições abruptas de vetor que quebram a ilusão de física real.
* **Solução:** Cálculo de forças cinemáticas baseadas em vetores de aproximação, velocidade desejada e aceleração suavizada por massa e limites de velocidade.
* **Impacto no Mirage:** Toda a física da arena 2D (`f:\Faculdade\Projetos\Mirage\src\simulador_arena.m`) opera sobre forças de Reynolds:
  $$\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$$

---

## 🧩 Matriz de Aplicabilidade no Mirage

| Artigo Base | Conceito Chave | Onde foi Implementado no Código |
| :--- | :--- | :--- |
| **Kirk & Scirea (2020)** | MAP-Elites & Box-Muller | `src/salvar_map_elites.m`, `src/mutacao_gaussiana.m` |
| **Glavin & Madden (2015)** | Catálogo SEC para DDA | `src/salvar_sec.m`, `data/sec_catalogue.csv` |
| **Craig Reynolds (1999)** | Forças de Evasão Cinemática | `src/simulador_arena.m` (Linhas de cálculo CPA) |
| **Spronck et al. (2006)** | Mutação Pura (EDS) | `scripts/Rodar_Experimentos_Paralelos.ps1` |
| **Lee (2014)** | CPA Vetorial em 2D | `src/calcular_cpa.m` |
| **UNISENAI (2026)** | Torneio, Crossover & Elitismo | `src/selecao_torneio.m`, `src/crossover_uniforme.m` |

