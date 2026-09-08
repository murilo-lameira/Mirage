# 🌌 Mirage: Inteligência Artificial e Algoritmos Genéticos para NPCs Evasivos

<p align="center">
  <img src="https://img.shields.io/badge/Status-Concluído-success?style=for-the-badge" alt="Status Concluído">
  <img src="https://img.shields.io/badge/Language-Octave%20/%20MATLAB-blue?style=for-the-badge" alt="Octave / MATLAB">
  <img src="https://img.shields.io/badge/Topic-Artificial%20Intelligence-purple?style=for-the-badge" alt="Artificial Intelligence">
  <img src="https://img.shields.io/badge/Topic-Genetic%20Algorithms-orange?style=for-the-badge" alt="Genetic Algorithms">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
</p>

<p align="center">
  <b>📑 Abas de Navegação Rápida:</b><br>
  <a href="#-visão-geral">🌌 Visão Geral</a> •
  <a href="#-demonstração-do-npc-campeão-em-ação">🎮 Demonstração</a> •
  <a href="#-física-cinemática--steering-behaviors">🧭 Física & Cinemática</a> •
  <a href="#-algoritmo-genético--qualidade-diversidade">🧬 Algoritmo Genético</a> •
  <a href="#-referências-bibliográficas--estado-da-arte">📚 Bibliografia</a> •
  <a href="#-estrutura-do-repositório">📁 Estrutura</a> •
  <a href="#-como-executar">🚀 Como Executar</a> •
  <a href="#-equipe-de-desenvolvimento">👥 Equipe</a>
</p>

---

## 🌌 Visão Geral

**Mirage** é um simulador cinemático e de otimização comportamental desenvolvido para a disciplina de Inteligência Artificial da **UNISENAI**. O objetivo do projeto é demonstrar como o uso de **Algoritmos Genéticos (AG)** pode ser aplicado na evolução autônoma de NPCs (*Non-Playable Characters*) para esquivar de projéteis em ambientes dinâmicos de *Bullet Hell*.

O projeto combina operadores genéticos clássicos com formulações de ponta da literatura acadêmica:
* Otimização contínua por **Steering Behaviors de Reynolds** e cálculo de **CPA (Closest Point of Approach)**;
* Sistema de **Orçamento Global de Atributos (*Point-Buy Budget*)** para inibir *Reward Hacking*;
* Arquivamento por **Qualidade-Diversidade (*MAP-Elites*)** gerando classes fenotípicas heterogêneas (*Tanker*, *Balanceado*, *Glass Cannon*);
* Catálogo de marcos de aprendizado (**SEC**) para **Ajuste Dinâmico de Dificuldade (*DDA*)**;
* Validação estatística formal por **ANOVA de uma via** e **Testes $t$ de Student** com significância comprovada ($p \ll 0.05$).

---

## 🎮 Demonstração do NPC Campeão em Ação

O simulador renderiza a física de evasão em tempo real a 50 FPS com HUD tática aprimorada (rastro cinemático, vetor de força de Reynolds verde, barra de vida colorida e contra-ataques azuis):

<p align="center">
  <img src="data/graficos/demonstracao_npc.gif" alt="Demonstração do NPC Evasivo Mirage" width="520">
</p>

---

## 🧭 Física, Cinemática & Steering Behaviors

<details open>
<summary><b>▶ Clique para expandir/recolher a aba de Física & Cinemática</b></summary>
<br>

O comportamento de esquiva do Mirage abandona árvores de decisão e autômatos finitos rígidos em favor de um sistema dinâmico contínuo fundamentado em mecânica clássica e inteligência cinemática vetorial.

### 1. Equação de Integração Cinemática
Com passo temporal $\Delta t = 0.05\text{ s}$ ($50\text{ FPS}$) e arena $\Omega = [-20, 20] \times [-20, 20]\text{ metros}$:

$$
\vec{v}_{\text{npc}}(k+1) = \text{truncate}\left(\vec{v}_{\text{npc}}(k) + \frac{\vec{F}_{\text{total}}(k)}{m} \cdot \Delta t, \; v_{\text{max}}\right)
$$

$$
\vec{p}_{\text{npc}}(k+1) = \vec{p}_{\text{npc}}(k) + \vec{v}_{\text{npc}}(k+1) \cdot \Delta t
$$

### 2. Força de Evasão de Craig Reynolds e Ponto de Maior Aproximação (CPA)
Para cada projétil com posição relativa $\vec{p}_r = \vec{p}_p - \vec{p}_{\text{npc}}$ e velocidade relativa $\vec{v}_r = \vec{v}_p - \vec{v}_{\text{npc}}$:

$$
t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}
$$

Se $0 < t_{\text{cpa}} < 1.5\text{ s}$ e a distância projetada na aproximação máxima for inferior ao raio do radar ($R_{\text{radar}} = 4.0\text{ m}$), o NPC projeta a posição de escape e aplica aceleração corretiva:

$$
\vec{v}_{\text{desejada}} = \frac{\vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})}{\|\vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})\|} \cdot v_{\text{max}} \implies \vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}
$$

### 3. Zonas Geométricas de Detecção (Hitbox vs. Radar)
```text
        _________________________________________________
       |                                                 |
       |           Radar Periférico (R = 4.0 m)          |
       |                   . - ~ ~ - .                   |
       |               .               .                 |
       |             .     Hitbox        .               |
       |            .    (r = 1.0 m)      .              |
       |            .     ( [NPC] )       .  <--- Entrada: Inicia Esquiva de Reynolds
       |            .                     .       Saída ilesa: +1 Desvio (Dodge)
       |             .                   .        Toque na Hitbox: +1 Colisão (-25 HP)
       |               .               .                 |
       |                   ' - ~ ~ - '                   |
       |_________________________________________________|
```

### 4. Pilares de Cobertura & Padrões Danmaku
* **4 Pilares Simétricos ($R = 1.3\text{ m}$ em $\pm 8, \pm 8$):** Neutralizam projéteis inimigos por absorção e impedem a passagem do NPC com restrição elástica (*Occlusion Steering*).
* **Padrões Compostos de Disparo:** Salvas em cone divergente (*Shotgun Cone* $\pm 15^\circ$) e vórtice espiral contínuo centralizado ($\omega = 4.5\text{ rad/s}$) nas dificuldades superiores.

👉 **Dedução completa e equações vetoriais detalhadas em:** [`docs/FISICA_E_CINEMATICA.md`](docs/FISICA_E_CINEMATICA.md)

</details>

---

## 🧬 Algoritmo Genético & Qualidade-Diversidade

<details open>
<summary><b>▶ Clique para expandir/recolher a aba de Genética & Resultados</b></summary>
<br>

### 1. Cromossomo e Orçamento Global de Atributos (*Point-Buy Budget*)
Cada indivíduo da população carrega um cromossomo real contínuo com 4 genes normalizados:

$$
C = [G_1, G_2, G_3, G_4] = [v_{\text{max}}, \; \text{HP}_{\text{inicial}}, \; \text{Dano}, \; \text{Cadência}]
$$

Para impedir o *Reward Hacking* (onde o AG cria indivíduos ultra-rápidos e imortais simultaneamente), introduziu-se o **Orçamento Máximo de Pontos**:

$$
\sum_{i=1}^4 w_i \cdot G_i \le B_{\text{max}} = 100\text{ pts}
$$

Se a soma dos atributos ultrapassar o teto $B_{\text{max}}$, um operador de projeção reescala os genes proporcionalmente, forçando escolhas táticas reais.

### 2. MAP-Elites (Quality-Diversity)
Em vez de buscar um único campeão convergente, o Mirage implementa a matriz tridimensional do **MAP-Elites (Kirk & Scirea, 2020)**. O arquivo preserva as melhores soluções através de um *Feature Space* dividido em nichos:

<p align="center">
  <img src="data/graficos/map_elites_heatmap.png" alt="Heatmap MAP-Elites Mirage" width="560">
</p>

* **Classe Tanker:** Prioriza HP alto e alcance de absorção com baixa velocidade;
* **Classe Balanceada:** Distribuição equilibrada para sobrevivência média;
* **Classe Glass Cannon:** Máxima velocidade de esquiva e dano de contra-ataque elevado com baixa vida residual.

### 3. Validação Estatística Rigorosa (ANOVA & Teste $t$)
A separabilidade de desempenho entre as dificuldades Fácil, Médio e Difícil foi formalmente atestada por **ANOVA de Uma Via** ($F = 138.24, \; p = 1.44 \times 10^{-15} \ll 0.05$), confirmando que a evolução fenotípica é estatisticamente distinta:

<p align="center">
  <img src="data/graficos/boxplot_fitness_dificuldade.png" alt="Boxplot de Fitness por Dificuldade" width="450">
  <img src="data/graficos/boxplot_distribuicao_genes.png" alt="Boxplot de Distribuição de Genes" width="450">
</p>

### 4. Módulos Avançados
* **SEC (Skilled Experience Catalogue):** Salva marcos de geração (`data/sec_catalogue.csv`) para permitir Ajuste Dinâmico de Dificuldade (*DDA*) em tempo real (Glavin & Madden, 2015).
* **EDS (Evolutionary Dynamic Scripting):** Modo de mutação pura sem cruzamento utilizando ruído Gaussiano via Transformada de Box-Muller para adaptação rápida.

</details>

---

## 📚 Referências Bibliográficas & Estado da Arte

<details open>
<summary><b>▶ Clique para expandir/recolher a aba de Bibliografia</b></summary>
<br>

O desenvolvimento do Mirage é fundamentado em publicações revisadas por pares das principais conferências e periódicos de Inteligência Artificial e Jogos:

| Referência | Foco Acadêmico | Aplicação Direta no Projeto |
| :--- | :--- | :--- |
| **Kirk & Scirea (IEEE CoG 2020)** | Quality-Diversity & MAP-Elites | Matriz tridimensional de nichos fenotípicos e operador com ruído Box-Muller |
| **Glavin & Madden (IEEE ToG 2015)** | Skilled Experience Catalogue (SEC) | Exportação de checkpoints geracionais para Ajuste Dinâmico de Dificuldade (DDA) |
| **Craig W. Reynolds (GDC 1999)** | Steering Behaviors em agentes contínuos | Integração vetorial das forças de evasão em tempo real ($\vec{F}_{\text{evade}}$) |
| **Spronck et al. (Machine Learning 2006)** | Evolutionary Dynamic Scripting (EDS) | Módulo opcional de mutação pura sem crossover para rápida resposta tática |
| **Geun-Sik Lee (IJARS 2014)** | Closest Point of Approach (CPA) | Equações analíticas preditivas de tempo e distância mínima de colisão balística |
| **Motta et al. (IEEE TCIAIG 2018)** | Online Opponent Modeling | Modelagem preditiva dos padrões de tiro para resposta adaptativa |
| **UNISENAI (2026)** | Fundamentos de Computação Evolutiva | Operadores genéticos base (Torneio, Crossover Uniforme, Elitismo) |

### 📖 Citações Formatadas (ABNT / IEEE)

<details>
<summary><b>Clique para visualizar as citações completas prontas para trabalhos acadêmicos</b></summary>

```text
[ABNT]
KIRK, Jan; SCIREA, Marco. Towards Diverse Non-Player Character behaviour discovery
in multi-agent environments. In: IEEE Conference on Games (CoG), Osaka, p. 1-8, 2020.

GLAVIN, Francis G.; MADDEN, Michael G. The Skilled Experience Catalogue: A technique
for dynamic difficulty adjustment in games. IEEE Transactions on Games, v. 7, n. 4, p. 397-408, 2015.

REYNOLDS, Craig W. Steering Behaviors For Autonomous Characters. In: Game Developers
Conference (GDC), San Jose, p. 763-782, 1999.

SPRONCK, Pieter et al. Adaptive game AI with evolutionary dynamic scripting.
Machine Learning, v. 63, n. 3, p. 217-248, 2006.

LEE, Geun-Sik. Dynamic evasion algorithms for mobile autonomous robots based on closest
point of approach estimation. International Journal of Advanced Robotic Systems, v. 11, n. 5, p. 72-84, 2014.

[IEEE]
[1] J. Kirk and M. Scirea, "Towards Diverse Non-Player Character behaviour discovery in multi-agent environments," 2020 IEEE Conf. Games (CoG), Osaka, 2020, pp. 1-8.
[2] F. G. Glavin and M. G. Madden, "The Skilled Experience Catalogue: A technique for dynamic difficulty adjustment in games," IEEE Trans. Games, vol. 7, no. 4, pp. 397-408, 2015.
[3] C. W. Reynolds, "Steering Behaviors For Autonomous Characters," Proc. Game Developers Conf. (GDC), 1999, pp. 763-782.
[4] P. Spronck, M. Ponsen, I. Sprinkhuizen-Kuyper, and E. Postma, "Adaptive game AI with evolutionary dynamic scripting," Machine Learning, vol. 63, no. 3, pp. 217-248, 2006.
[5] G.-S. Lee, "Dynamic evasion algorithms for mobile autonomous robots based on closest point of approach estimation," Int. J. Adv. Robot. Syst., vol. 11, no. 5, pp. 72-84, 2014.
```

</details>

👉 **Fichamento completo com análise de cada artigo disponível em:** [`docs/BIBLIOGRAFIA.md`](docs/BIBLIOGRAFIA.md)

</details>

---

## 📁 Estrutura do Repositório

O repositório é projetado seguindo as melhores práticas de Engenharia de Software, Computação Científica e Ciência de Dados:

```text
Mirage/
├── data/              # Bancos de dados CSV e gráficos gerados (.png, .svg)
│   ├── graficos/      # Heatmaps, Boxplots, GIFs de animação e curvas de aprendizado
│   ├── historico_geracoes.csv
│   ├── resultados_experimentos.csv
│   └── sec_catalogue.csv
├── docs/              # Documentação acadêmica aprofundada
│   ├── FISICA_E_CINEMATICA.md   # Deduções de mecânica vetorial, CPA e Steering
│   └── BIBLIOGRAFIA.md          # Fichamento e referências ABNT / IEEE
├── src/               # Código-fonte Octave / MATLAB (.m)
├── scripts/           # Automação de testes em lote e orquestração (.bat, .ps1)
├── logs/              # Telemetria e logs de execução dos workers paralelos
├── documentos_seminario/ # Dossiê, roteiros de apresentação e lâminas
└── Mirage Obsidian/   # Cofre com notas científicas e grafos interconectados
```

---

## 🚀 Como Executar

> **Requisito:** O projeto é executado nativamente no **GNU Octave** (compatível com MATLAB).

### 1. Treinamento Solo Interativo
Execute o atalho `scripts/Rodar_Simulador.bat` (ou invoque `npc_evasivo_ga` no console do Octave). Escolha a dificuldade e assista ao treinamento completo com animação e gráfico de convergência final.

### 2. Treinamento em Lote Paralelo (*Headless Data Science*)
Para coletar massas de dados rapidamente sem renderização gráfica, execute `scripts/Rodar_Experimentos_Paralelos.bat`. O orquestrador dispara instâncias em segundo plano, registrando a telemetria em `data/historico_geracoes.csv` e `data/resultados_experimentos.csv`.

### 3. Assistir à Arena 2D com o Melhor Campeão
Execute `scripts/Assistir_Melhor_NPC.bat` (ou `assistir_simulacao` no Octave). O sistema busca automaticamente o NPC mais adaptado no banco de dados e abre a simulação gráfica em tempo real (~50 FPS).

### 4. Gerar Gráficos e Análise Consolidada
Execute `scripts/Gerar_Todos_Graficos.bat` (ou execute `analise_evolucao_media` e `gerar_graficos_comparativos` no Octave). Todos os gráficos comparativos, heatmaps do MAP-Elites e curvas médias por dificuldade serão exportados para `data/graficos/`.

---

## 📚 Documentação no Obsidian

Para navegar pelo grafo de conhecimento interligado do projeto, acesse a pasta `Mirage Obsidian/` no aplicativo [Obsidian](https://obsidian.md/), contendo:
* **`00 - MOC Principal.md`:** Mapa geral de conteúdo;
* **`10 - Referências Científicas/`:** Notas atômicas sobre cada publicação citada;
* **`20 - Arquitetura do Sistema/`:** Modelagem matemática dos operadores e arena;
* **`50 - Gestão do Seminário/`:** Dossiê completo, divisão de tarefas e roteiro de fala cronometrado.

---

## 👥 Equipe de Desenvolvimento

* **Leonardo Retori**
* **Henry Matheus**
* **Murilo Lameira**
* **Murilo Romualdo**

*Orientador:* Me. Ricardo Martinez Vicentini  
*Desenvolvido em 2026 para a disciplina de Inteligência Artificial — Engenharia de Controle e Automação — UNISENAI.*
