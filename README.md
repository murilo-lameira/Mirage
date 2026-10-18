# 🌌 Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva

<p align="center">
  <img src="https://img.shields.io/badge/Status-Publicado%20%2F%20Conclu%C3%ADdo-success?style=for-the-badge" alt="Status Concluído">
  <img src="https://img.shields.io/badge/Python-3.10%2B-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python 3.10+">
  <img src="https://img.shields.io/badge/Octave%20%2F%20MATLAB-Compat%C3%ADvel-0076A8?style=for-the-badge&logo=mathworks&logoColor=white" alt="Octave / MATLAB">
  <img src="https://img.shields.io/badge/LaTeX-IEEE%20%2F%20SBC%20Paper-008080?style=for-the-badge&logo=latex&logoColor=white" alt="LaTeX Article">
  <img src="https://img.shields.io/badge/GA-MAP--Elites%20%26%20Point--Buy-orange?style=for-the-badge" alt="MAP-Elites & Point-Buy">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
</p>

<p align="center">
  <b>📑 Navegação Rápida:</b><br>
  <a href="#-visão-geral">🌌 Visão Geral</a> •
  <a href="#-artigo-científico-oficial">📄 Artigo Científico</a> •
  <a href="#-demonstração-e-arquitetura-do-npc">🎮 Demonstração</a> •
  <a href="#-física-cinemática-cpa--lead-aiming">🧭 Física, CPA & Lead-Aiming</a> •
  <a href="#-algoritmo-genético-sob-orçamento-b--18">🧬 Genética & Orçamento</a> •
  <a href="#-validação-estatística-formal-n--90">📊 Validação Estatística</a> •
  <a href="#-map-elites--qualidade-diversidade-qd">🗺️ MAP-Elites & QD</a> •
  <a href="#-referências-bibliográficas">📚 Bibliografia</a> •
  <a href="#-estrutura-do-repositório">📁 Estrutura</a> •
  <a href="#-como-executar">🚀 Como Executar</a> •
  <a href="#-equipe-de-desenvolvimento">👥 Equipe</a>
</p>

---

## 🌌 Visão Geral

**Mirage** é um framework de computação evolucionária e inteligência cinemática vetorial desenvolvido para sintetizar comportamentos de evasão críveis e taticamente robustos em Agentes Não-Jogáveis (*NPCs - Non-Playable Characters*) imersos em ambientes dinâmicos de *Bullet Hell*.

O projeto soluciona de forma analítica o problema clássico de **Reward Hacking** em jogos digitais — onde algoritmos evolutivos convencionais convergem para "esponjas de dano" estáticas com acúmulo desproporcional de vida em detrimento de esquivas ágeis.

O Mirage implementa:
1. **Restrição Orçamentária Invariante (B = 1,8):** Operador de reparo homotético sobre simplex contínuo que coíbe a criação de "super-agentes" e catalisa a emersão autônoma de arquétipos táticos distintos;
2. **Cinemática Preditiva Dual (CPA + Lead-Aiming):** Estimativa analítica do Ponto de Maior Aproximação (*Closest Point of Approach*) acoplada às forças de aceleração de Craig Reynolds e cálculo de interceptação balística de primeira ordem;
3. **Mapeamento de Qualidade-Diversidade (MAP-Elites):** Repertório comportamental heterogêneo avaliado por métricas formais (Coverage de 100% e QD-Score de 39.114,40) integrado ao Catálogo de Experiência Especializada (*SEC*) para Ajuste Dinâmico de Dificuldade (*DDA*);
4. **Validação Estatística em Larga Escala (N = 90):** Amostragem balanceada com ANOVA One-Way, testes não-paramétricos de Kruskal-Wallis e tamanhos de efeito de Cohen (d entre 3,78 e 18,61) com significância estatística extrema (p ≪ 10⁻³⁰).

---

## 📄 Artigo Científico Oficial

O projeto deu origem ao artigo acadêmico completo estruturado no formato de conferência internacional (IEEE / SBC):

> ### **"Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva"**
> **Autores:** Murilo Lameira da Silva, Henry Matheus Fregolente Ferreira, Murilo Romualdo da Silva, Leonardo Retori Apolônio e Prof. Me. Ricardo Martinez Vicentini.  
> **Afiliação:** Engenharia de Controle e Automação — Centro Universitário SENAI SP (UNISENAI), Campus São Caetano do Sul, SP, Brasil.  
> 
> 📥 **Acesso aos Documentos Oficiais:**
> * 📄 **[Baixar Artigo Completo (PDF Compilado)](paper/Mirage_Artigo_SENAI.pdf)**
> * 📝 **[Acessar Código-Fonte em LaTeX (`paper/Mirage_Artigo_SENAI.tex`)](paper/Mirage_Artigo_SENAI.tex)**

```bibtex
@inproceedings{silva2026mirage,
  title     = {Mirage: Adapta{\c{c}}{\~a}o Evolutiva de NPCs sob Restri{\c{c}}{\~a}o Or{\c{c}}ament{\'a}ria com Esquiva Preditiva},
  author    = {Silva, Murilo Lameira da and Ferreira, Henry Matheus Fregolente and Silva, Murilo Romualdo da and Apol{\^o}nio, Leonardo Retori and Vicentini, Ricardo Martinez},
  booktitle = {Simp{\'o}sio Brasileiro de Jogos e Entretenimento Digital (SBGames) / IEEE CoG},
  year      = {2026},
  address   = {S{\~a}o Caetano do Sul, SP, Brasil}
}
```

---

## 🎮 Demonstração e Arquitetura do NPC

O simulador renderiza a física cinemática em tempo real a 50 FPS com interface visual tática (rastro de movimento em azul, vetor de força de Reynolds em verde, radar periférico, barra de vida dinâmica e contra-ataques azuis por *lead-aiming*):

<p align="center">
  <img src="data/graficos/demonstracao_npc.gif" alt="Demonstração do NPC Mirage em Combate" width="560">
</p>

---

## 🧭 Física, Cinemática, CPA & Lead-Aiming

### 1. Diagrama Esquemático da Arena 2D
A arena contínua de combate compreende o plano cartesiano Ω = [-20, 20] × [-20, 20] m (área total de 40 × 40 m), governada por zonas de colisão concêntricas, pilares rígidos de absorção e círculos balísticos:

<p align="center">
  <img src="data/graficos/fig_diagrama_arena.png" alt="Diagrama Esquemático da Arena 2D Mirage" width="620">
</p>

Os quatro pilares estruturais da arena operam de forma integrada:
1. **Zonas Concêntricas da Arena:**
   * **Hitbox Material (r = 1,0 m):** Colisões ocorrem se a separação entre o centro do NPC e o projétil for menor ou igual a 1,3 m (soma dos raios físicos), aplicando dano de -25 HP e penalizando a aptidão por colisão;
   * **Radar Periférico (R = 4,0 m):** Registra desvios com sucesso (*dodges*) sempre que um tiro hostil cruza a área do radar tangencialmente sem interceptar a hitbox;
   * **Círculo de Disparo Orbital (r = 18,0 m):** Perímetro de emissão dos disparos balísticos hostis direcionados ao NPC com dispersão angular Gaussiana;
   * **4 Pilares Cilíndricos de Cobertura (R = 1,3 m em ±8, ±8 m):** Absorvem projéteis inimigos e impõem reflexão elástica e deslizamento tangencial ao agente (*Occlusion Steering*).
2. **Integração Cinemática e Steering de Reynolds:**
   * A simulação opera a 50 FPS (passo temporal fixo Δt = 0,05 s) com massa unitária (m = 1,0 kg), utilizando integração semi-implícita de Euler com saturação de velocidade máxima ditada pelo genoma e aceleração limitada por força máxima de 25,0 N para eliminar *jittering*.
3. **Esquiva Preditiva via CPA (Closest Point of Approach):**
   * Em vez de reagir a tiros distantes, o agente estima em tempo real o instante futuro de maior aproximação balística (t_cpa). O gatilho de aceleração de Craig Reynolds só é disparado se forem atendidas simultaneamente três condições: convergência temporal crítica (0 < t_cpa ≤ 1,5 s), aproximação geométrica dentro do radar (< 4,0 m) e produto escalar relativo negativo (indicando aproximação real).
4. **Disparo Preditivo Inverso (Lead-Aiming):**
   * O agente soluciona analiticamente a interceptação balística de primeira ordem (projéteis a 16,0 m/s com bônus ofensivo de 15%), neutralizando projéteis inimigos no ar e abrindo ativamente corredores de fuga.

> [!IMPORTANT]
> **Ganhos Comprovados por Ablação Experimental:**
> A substituição de repulsões euclidianas puramente reativas pela formulação analítica CPA com *lead-aiming* proporcionou **redução de 77,5%** nas colisões críticas (de 2,14 para 0,48 colisões/s, t = 18,72, p < 10⁻²⁴) e **aumento de +103,7%** no tempo de sobrevivência no regime Difícil (23,22 ± 2,51 s contra 11,40 ± 2,8 s).

> [!NOTE]
> **Dedução Matemática Completa:**
> As equações diferenciais completas, vetores de aproximação relativa e a dedução passo a passo do instante analítico ótimo t_cpa estão detalhados na **Seção 3 (Equações 1 a 11)** do artigo científico oficial [`paper/Mirage_Artigo_SENAI.pdf`](paper/Mirage_Artigo_SENAI.pdf) e no documento complementar [`docs/FISICA_E_CINEMATICA.md`](docs/FISICA_E_CINEMATICA.md).

---

## 🧬 Algoritmo Genético sob Orçamento (B = 1,8)

### 1. Cromossomo Fenotípico e Projeção Homotética
Cada agente carrega um cromossomo real contínuo composto por quatro atributos com limites físicos estritos:
* **Pontos de Vida (HP):** [10, 200] pts
* **Poder de Ataque:** [5, 50] pts
* **Cadência de Tiro:** [0,5; 3,0] Hz
* **Velocidade de Movimento:** [1,0; 8,0] m/s

Para coibir o *Reward Hacking* (onde o otimizador cria agentes invencíveis acumulando vida e velocidade infinitas), cada atributo é mapeado afim no intervalo normalizado unitário [0, 1] e submetido ao teto orçamentário estrito:

**Soma dos Genes Normalizados: u₁ + u₂ + u₃ + u₄ ≤ B = 1,8**

Quando uma mutação ou cruzamento ultrapassa o orçamento B = 1,8, um operador de projeção homotética reescala o vetor de genes de volta ao simplex viável. Essa restrição matemática força escolhas táticas reais de compromisso (*trade-offs*): todos os indivíduos campeões evoluídos saturam a fronteira de Pareto com soma de atributos em **1,78 a 1,79**.

> [!NOTE]
> **Formulação e Operadores Genéticos:**
> As equações de normalização afim, projeção no simplex, seleção por torneio e crossover BLX-α estão formalizadas na **Seção 4 (Equações 12 a 18)** do artigo oficial [`paper/Mirage_Artigo_SENAI.pdf`](paper/Mirage_Artigo_SENAI.pdf).

### 2. Os Três Arquétipos Táticos Emergentes

| Arquétipo Emergente | Regime de Treino | HP (pts) | Ataque (pts) | Cadência (Hz) | Velocidade (m/s) | Soma Normalizada |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Sniper / Glass Cannon** | Fácil (D1) | 22,07 (u ≈ 0,06) | 49,54 (u ≈ 0,99) | 2,32 (u ≈ 0,73) | 1,06 (u ≈ 0,01) | **1,79** |
| **Combatente Equilibrado** | Médio (D2) | 31,80 (u ≈ 0,11) | 40,77 (u ≈ 0,79) | 2,46 (u ≈ 0,78) | 1,69 (u ≈ 0,10) | **1,78** |
| **Bruiser / Ladino** | Difícil (D3) | 72,73 (u ≈ 0,33) | 24,33 (u ≈ 0,43) | 2,25 (u ≈ 0,70) | 3,21 (u ≈ 0,32) | **1,78** |

* **Sniper / Glass Cannon (Fácil):** Alocação ofensiva extrema (Ataque u ≈ 0,99), aniquilando alvos de forma fulminante à distância sem requerer alta mobilidade em ambiente balístico brando.
* **Combatente Equilibrado (Médio):** Distribuição balanceada com alto poder de fogo (Ataque u ≈ 0,79) e cadência (u ≈ 0,78), combinando velocidade intermediária para contornar salvas em leque.
* **Bruiser / Ladino (Difícil):** Realocação cinemática para evasão rápida (3,21 m/s, u ≈ 0,32) e pool de vida triplicado (72,73 pts) para absorver impactos residuais inevitáveis de vórtices contínuos.

---

## 📊 Validação Estatística Formal (N = 90)

O protocolo experimental executou 90 rodadas evolutivas independentes ao longo de 50 gerações (30 no Fácil, 30 no Médio, 30 no Difícil), totalizando 135.000 episódios de combate simulados.

### 1. Curvas de Convergência Geracional
A evolução demonstra convergência assintótica estável e separabilidade nítida entre os regimes de hostilidade:

<p align="center">
  <img src="data/graficos/fig_convergencia.png" alt="Curvas de Convergência do Fitness Mirage" width="600">
</p>

* **Fácil (D1):** Fitness Máximo Médio = 3754,18 ± 134,87 (Mediana: 3791,56)
* **Médio (D2):** Fitness Máximo Médio = 4849,88 ± 358,85 (Mediana: 4863,89)
* **Difícil (D3):** Fitness Máximo Médio = 3687,83 ± 246,42 (Mediana: 3702,13)

### 2. Dispersão Fenotípica e Radar de Atributos

<p align="center">
  <img src="data/graficos/fig_dispersao_genes.png" alt="Dispersão Fenotípica dos Genes" width="440">
  <img src="data/graficos/radar_fenotipos_campeoes.png" alt="Radar de Fenótipos dos Campeões" width="440">
</p>

### 3. Tabela Comparativa de Métricas Brutas e Genes (N = 90)

| Métrica / Atributo Fenotípico | Fácil (D1) | Médio (D2) | Difícil (D3) | ANOVA One-Way (F) | Valor-p |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Tempo de Sobrevivência (s)** | 29,95 ± 0,00 | 29,95 ± 0,01 | 23,22 ± 2,51 | F(2, 87) = 214,79 | p < 10⁻³⁵ |
| **Desvios Limpos (CPA)** | 23,97 ± 1,75 | 69,07 ± 3,54 | 83,80 ± 14,48 | F(2, 87) = 388,11 | p < 10⁻⁴⁵ |
| **Colisões Críticas** | 0,00 ± 0,00 | 0,43 ± 0,57 | 3,57 ± 0,82 | F(2, 87) = 344,06 | p < 10⁻⁴³ |
| **Dano Infligido** | 6669,69 ± 271,19 | 4822,34 ± 445,40 | 1862,87 ± 244,85 | F(2, 87) = 1594,39 | p = 3,13 × 10⁻⁶⁹ |
| **Pontos de Vida (HP)** | 12,37 ± 7,28 | 31,80 ± 9,61 | 72,73 ± 16,64 | F(2, 87) = 202,45 | p < 10⁻³⁴ |
| **Poder de Ataque** | 49,47 ± 1,94 | 40,77 ± 3,77 | 24,33 ± 4,63 | F(2, 87) = 371,82 | p < 10⁻⁴⁴ |
| **Cadência de Tiro (Hz)** | 2,47 ± 0,03 | 2,46 ± 0,08 | 2,25 ± 0,19 | F(2, 87) = 32,86 | p < 10⁻¹⁰ |
| **Velocidade Máxima (m/s)** | 1,03 ± 0,05 | 1,69 ± 0,61 | 3,21 ± 0,45 | F(2, 87) = 195,07 | p < 10⁻³³ |

* **Validação Paramétrica (ANOVA):** F(2, 87) = 184,55 (p = 2,12 × 10⁻³²) para o Fitness Máximo;
* **Validação Não-Paramétrica (Kruskal-Wallis):** H = 61,80 (p = 3,80 × 10⁻¹⁴) confirmando robustez a desvios de normalidade;
* **Tamanhos de Efeito de Cohen:** d = 18,61 (Fácil vs Difícil) e d = 8,23 (Médio vs Difícil) para dano infligido, comprovando separabilidade fenotípica drástica.

---

## 🗺️ MAP-Elites & Qualidade-Diversidade (QD)

O arquivo de Qualidade-Diversidade discretiza o repertório em um espaço de características 3 × 3 (9 nichos formados pela Razão HP/Ataque vs. Faixas de Mobilidade):

<p align="center">
  <img src="data/graficos/fig_map_elites.png" alt="Heatmap MAP-Elites 3x3 Mirage" width="560">
</p>

### 1. Métricas Formais de QD
* **Cobertura Espacial:** **100,00%** (9 de 9 nichos fenotípicos preenchidos);
* **QD-Score Global:** **39.114,40** pontos acumulados;
* **Fitness Máximo Global:** 5.340,91 (Nicho *Glass Cannon Lento*).

### 2. Matriz de Aptidão dos Elites

| Estrato de Mobilidade | Tanker (HP/Atk > 3) | Balanceado (1 ≤ HP/Atk ≤ 3) | Glass Cannon (HP/Atk < 1) | Subtotal do Estrato |
| :--- | :---: | :---: | :---: | :---: |
| **Lento (< 4,5 m/s)** | 4139,58 | 4852,26 | 5340,91 | **14.332,75** |
| **Médio (4,5 a 6,5 m/s)** | 3850,00 | 4420,15 | 4910,50 | **13.180,65** |
| **Rápido (> 6,5 m/s)** | 3400,20 | 3950,00 | 4250,80 | **11.601,00** |
| **Total Acumulado (QD-Score)** | — | — | — | **39.114,40** |

---

## 📚 Referências Bibliográficas

* **Lee, G.-S. (2014):** *Dynamic evasion algorithms for mobile autonomous robots based on closest point of approach estimation.* Int. J. Adv. Robot. Syst.
* **Reynolds, C. W. (1999):** *Steering Behaviors For Autonomous Characters.* Game Developers Conference (GDC).
* **Wang, D.; Tan, K. C. (2014):** *A self-tuning lead-aiming strategy for autonomous target interception.* IEEE Trans. Cybern.
* **Kirk, J.; Scirea, M. (2020):** *Towards Diverse Non-Player Character behaviour discovery in multi-agent environments.* IEEE CoG.
* **Mouret, J.-B.; Clune, J. (2015):** *Illuminating search spaces by mapping elites.* arXiv preprint.
* **Glavin, F. G.; Madden, M. G. (2015):** *The Skilled Experience Catalogue: A technique for dynamic difficulty adjustment in games.* IEEE Trans. Games.
* **Spronck, P. et al. (2006):** *Adaptive game AI with evolutionary dynamic scripting.* Machine Learning.

👉 *Fichamento analítico e normas completas em:* [`docs/BIBLIOGRAFIA.md`](docs/BIBLIOGRAFIA.md)

---

## 📁 Estrutura do Repositório

```text
Mirage/
├── paper/                             # 📄 ARTIGO CIENTÍFICO OFICIAL
│   ├── Mirage_Artigo_SENAI.pdf        # Artigo compilado pronto para publicação
│   ├── Mirage_Artigo_SENAI.tex        # Fonte LaTeX (Padrão IEEE / SBC)
│   ├── referencias.bib                # Base BibTeX com citações do estado da arte
│   └── figuras/                       # Figuras vetoriais e PDF para compilação
├── mirage/                            # 🐍 PACOTE PYTHON MODULAR (ENGINE HÍBRIDA)
│   ├── core/                          # Simulação física, CPA, Reynolds, AG e MAP-Elites
│   ├── gui/                           # Interface gráfica Pygame 50 FPS e HUD tática
│   ├── analysis/                      # ANOVA, Kruskal-Wallis, gráficos e estatística
│   ├── config.py                      # Parâmetros físicos e restrição B = 1.8
│   └── main.py                        # Menu CLI / GUI integrado
├── dist/                              # 📦 EXECUTÁVEL STANDALONE COMPILADO (.EXE)
│   └── Mirage.exe                     # Executável nativo portátil Windows (sem instalar Python)
├── executar/                          # 🚀 LAUNCHERS AUTOMATIZADOS (1-CLIQUE)
│   ├── RODAR_MIRAGE_EXE.bat           # Abre o executável compilado instantaneamente
│   ├── COMPILAR_EXE.bat               # Compila novo executável via PyInstaller
│   ├── INICIAR_MIRAGE_PYTHON.bat      # Inicia o menu interativo Python
│   ├── DEMO_PYTHON_PYGAME.bat         # Roda demonstração rápida em Pygame
│   ├── JOGAR_MODO_HUMANO.bat          # Permite jogar manualmente contra o Bullet Hell
│   ├── DEMO_NPC_CAMPEAO.bat           # Executa simulação nativa em Octave/MATLAB
│   └── GERAR_TODAS_MIDIAS.bat         # Gera todos os gráficos, boxplots e vídeos
├── src/                               # 🔬 IMPLEMENTAÇÃO OCTAVE / MATLAB (.M)
│   ├── simulate_episode.m             # Simulação cinemática contínua da arena 2D
│   ├── calculate_evade_force.m        # Algoritmo CPA analítico e aceleração de Reynolds
│   ├── fitness_function.m             # Função de aptidão multi-objetivo
│   ├── init_population.m              # Inicialização sob orçamento de 1.8 pontos
│   ├── npc_evasivo_ga.m               # Algoritmo genético clássico
│   └── teste_estatistico_hipoteses.m  # Rotinas analíticas de ANOVA e Testes t
├── scripts/                           # ⚙️ SCRIPTS DE AUTOMAÇÃO E BENCHMARKS
│   └── run_full_academic_pipeline.py  # Executa pipeline completo (N=90), ANOVA e gráficos
├── data/                              # 💾 BANCOS DE DADOS E TELEMETRIA
│   ├── graficos/                      # Figuras de alta resolução (300 DPI) e GIFs
│   ├── resultados_experimentos.csv    # Registros brutos consolidados (N=90)
│   ├── historico_geracoes.csv         # Curvas geracionais completas (G=50)
│   └── map_elites.csv                 # Tabela de nichos fenotípicos
├── docs/                              # 📖 DOCUMENTAÇÃO TÉCNICA E MATEMÁTICA
│   ├── FISICA_E_CINEMATICA.md         # Deduções completas de mecânica e CPA
│   └── BIBLIOGRAFIA.md                # Fichamento de artigos científicos
├── run_mirage.py                      # Ponto de entrada Python protegido contra forks
└── README.md                          # Documentação central do ecossistema
```

---

## 🚀 Como Executar

O Mirage foi projetado com arquitetura híbrida para máxima conveniência e reprodutibilidade:

### ⚡ Opção 1: Executável Standalone Windows (Sem Instalação)
Basta dar **duplo clique** em:
* **`executar/RODAR_MIRAGE_EXE.bat`** (ou executar diretamente `dist/Mirage.exe`).
> Não requer Python, Octave ou bibliotecas externas. Funciona de forma portátil em qualquer máquina com Windows 10/11.

---

### 🐍 Opção 2: Python 3.10+ com Interface Pygame
1. Instale as dependências:
   ```bash
   pip install pygame numpy scipy matplotlib pandas
   ```
2. Inicie a aplicação:
   ```bash
   python run_mirage.py
   ```
   *(Ou utilize o atalho de 1-clique `executar/INICIAR_MIRAGE_PYTHON.bat`)*

---

### 🔬 Opção 3: Reprodução Completa do Pipeline Acadêmico (N = 90)
Para executar todas as 90 rodadas evolutivas independentes, recomputar a ANOVA One-Way, Kruskal-Wallis, d de Cohen e gerar todos os gráficos científicos em alta resolução (300 DPI):
```bash
python scripts/run_full_academic_pipeline.py
```

---

### 📐 Opção 4: GNU Octave (≥ 7.0) ou MathWorks MATLAB (≥ R2022b)
1. Abra a pasta do projeto no MATLAB ou GNU Octave;
2. Para assistir à demonstração da arena 2D com o NPC Campeão:
   * Execute `executar_demo.m` (ou pressione **F5**);
3. Para abrir o painel de treinamento:
   * Execute `iniciar_mirage.m`.
> 100% compatível com o interpretador nativo, dispensando a aquisição de toolboxes proprietárias pagas.

---

## 👥 Equipe de Desenvolvimento

Projeto desenvolvido no ano acadêmico de 2026 para a disciplina de **Inteligência Artificial** do curso de **Engenharia de Controle e Automação** do **Centro Universitário SENAI SP (UNISENAI)**, Campus São Caetano do Sul, SP, Brasil:

* **Murilo Lameira da Silva**
* **Henry Matheus Fregolente Ferreira**
* **Murilo Romualdo da Silva**
* **Leonardo Retori Apolônio**

**Orientador:**  
* **Prof. Me. Ricardo Martinez Vicentini**

---
<p align="center">
  <sub>Mirage: Inteligência Artificial Evolutiva e Cinemática Preditiva para Jogos Digitais © 2026. Licenciado sob MIT License.</sub>
</p>
