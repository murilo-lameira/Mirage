# 🛡️ DOSSIÊ CIENTÍFICO E DE APRESENTAÇÃO: Mirage COM ALGORITMO GENÉTICO

**Curso:** Engenharia de Controle e Automação  
**Instituição:** Centro Universitário SENAI SP – UNISENAI (Campus São Caetano do Sul – Boa Vista)  
**Disciplina:** Inteligência Artificial  
**Professor Orientador:** Me. Ricardo Martinez Vicentini  
**Grupo de Apresentadores:** Leonardo Retori, Henry Matheus, Murilo Lameira, Murilo Romualdo  
**Tema do Seminário:** *Comportamento de NPCs: Criação de inimigos virtuais que aprendem a desviar dos ataques do jogador através de Algoritmos Genéticos*  

> 🔗 **Índice Mestre do Projeto:** [[00 - MOC Principal]]

---

## 📑 ESTRUTURA DO DOSSIÊ

1. **📄 PARTE 1: HANDOUT CIENTÍFICO (Para Entrega à Banca)** — Fundamentação teórica, modelagem de cromossomo, restrições físicas de orçamento e equações de aptidão.
2. **🎚️ PARTE 2: BLUEPRINT VISUAL DE SLIDES (14 Slides)** — Guia slide por slide com elementos visuais, pontos destacados e notas de direção.
3. **🗣️ PARTE 3: ROTEIRO CRONOMETRADO DE APRESENTAÇÃO (15 Minutos)** — Divisão exata com scripts de fala para cada integrante.
4. **🧠 PARTE 4: GUIA DE DEFESA (FAQ da Banca)** — Perguntas técnicas prováveis e respostas científicas fundamentadas.

---

# 📄 PARTE 1: HANDOUT CIENTÍFICO (Entrega para a Banca)

### 1.1 Introdução e Paradigma da Evasão Adaptativa
No desenvolvimento de Inteligência Artificial para jogos eletrônicos clássicos, arquiteturas determinísticas como Máquinas de Estados Finitos (FSM) ou Árvores de Comportamento (BT) são o padrão devido à previsibilidade e facilidade de depuração. Contudo, esses sistemas são estáticos: quando o jogador reconhece as regras pré-programadas, o combate torna-se trivial e monótono.

A transição para **Sistemas Evolutivos e Adaptativos** baseados em **Algoritmos Genéticos (AG)** permite que os NPCs aprendam táticas de evasão e combate no espaço contínuo, descobrindo padrões cinemáticos que mitigam a previsibilidade humana.

---

### 1.2 Modelagem do Cromossomo e Orçamento Global de Atributos (Point-Buy Budget)

> 🔗 Veja também: [[Cromossomo & Genes]]

O indivíduo na população é o NPC. O cromossomo contínuo de 4 genes é definido por:

$$\text{Cromossomo} = [\text{HP}, \; \text{Attack}, \; \text{AttackSpeed}, \; \text{MovementSpeed}]$$

* **HP (Pontos de Vida):** $[10, 200]$
* **Attack (Poder de Ataque):** $[5, 50]$
* **AttackSpeed (Cadência):** $[0.5, 3.0\text{ Hz}]$
* **MovementSpeed (Velocidade de Movimento):** $[1.0, 8.0\text{ m/s}]$

#### Restrição de Orçamento Normalizado ($\sum u_i \le 1.8$):
Para evitar o surgimento de "Super-NPCs" invencíveis, cada atributo normalizado $u_i \in [0, 1]$ deve respeitar:

$$\sum_{i=1}^4 u_i \le 1.8$$

Isso força uma **relação de compromisso físico (trade-off)**: o NPC deve escolher entre ser um *Ninja Evasivo* (alta velocidade, baixo HP/ataque) ou um *Bruiser/Tanker* (alta vida e ataque, baixa velocidade).

---

### 1.3 Formulação Matemática da Função de Fitness Multi-Objetivo

> 🔗 Veja também: [[Função de Fitness]]

$$\text{Fitness} = \max\Big(0.1, \; (w_1 \cdot T_{\text{survival}}) + (w_2 \cdot N_{\text{dodge}}) + (w_3 \cdot D_{\text{inflicted}}) - (p_1 \cdot N_{\text{collision}}) - (p_2 \cdot D_{\text{taken}})\Big)$$

* $T_{\text{survival}}$: Tempo total de sobrevivência na arena ($0 \dots 15.0\text{s}$).
* $N_{\text{dodge}}$: Projéteis que entraram no radar periférico ($r = 4.0\text{m}$) e foram evitados com sucesso.
* $D_{\text{inflicted}}$: Dano causado ao jogador (com penalidade de estabilidade sob velocidade máxima).
* $N_{\text{collision}}$: Número de colisões sofridas com projéteis.
* $D_{\text{taken}}$: Total de dano acumulado ($25\text{ pts}$ por colisão).

---

### 1.4 A Engenharia Física da Esquiva (Steering Behaviors de Craig Reynolds)

> 🔗 Veja também: [[Simulação & Física de Esquiva]] | [[Ref - Lee (KIOTS)]]

O cálculo do Ponto de Maior Aproximação (*Closest Point of Approach - CPA*) determina o tempo futuro de impacto:

$$t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{|\vec{v}_r|^2}$$

Se $0 < t_{\text{cpa}} < 1.5\text{s}$ e a distância projetada for menor que o raio crítico de perigo, o NPC calcula a direção de fuga perpendicular e aplica a aceleração vetorial:

$$\vec{F}_{\text{evade}} = \left(\frac{\vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_{\text{proj}}(t_{\text{cpa}})}{|\vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_{\text{proj}}(t_{\text{cpa}})|} \cdot v_{\text{max}}\right) - \vec{v}_{\text{npc}}$$

---

# 🎚️ PARTE 2: BLUEPRINT VISUAL DE SLIDES (15 Slides)

* **Slide 1 — Capa Oficial:** Título do Mirage, Autores, Orientador Me. Ricardo Martinez Vicentini e Logo UNISENAI. *(Apresentador: Murilo Lameira)*
* **Slide 2 — O Problema do Determinismo em Jogos:** Limitações de FSMs e Árvores de Comportamento; como o jogador decora e vence facilmente. *(Apresentador: Murilo Lameira)*
* **Slide 3 — A Proposta do Mirage:** Visão geral da arena cinemática e aprendizado autônomo via Algoritmos Genéticos. *(Apresentador: Murilo Lameira)*
* **Slide 4 — Fundamentação: Qualidade-Diversidade (MAP-Elites):** [[Ref - Kirk & Scirea (Map-Elites)]] e o Heatmap 3x3 de nichos de combate (`map_elites_heatmap.png`). *(Apresentador: Leonardo Retori)*
* **Slide 5 — Skilled Experience Catalogue (SEC) & DDA:** Marcos de evolução off-line para ajuste dinâmico de dificuldade em jogos reais [[Ref - Glavin & Madden (Skilled Experience Catalogue)]]. *(Apresentador: Leonardo Retori)*
* **Slide 6 — Parametrização e Operadores do AG:** Seleção por Torneio ($k=3$), Crossover Uniforme, Mutação Gaussiana e Modo EDS [[Parametrização Geral do GA]]. *(Apresentador: Leonardo Retori)*
* **Slide 7 — Cinemática de Esquiva Preditiva:** [[Ref - Lee (KIOTS)]], cálculo de Ponto de Maior Aproximação (CPA) e Steering Behaviors de Craig Reynolds. *(Apresentador: Henry Matheus)*
* **Slide 8 — O Genoma do NPC e o Orçamento Global (Point-Buy):** Restrição de orçamento ($\sum u_i \le 1.8$) nos 4 genes para impedir Super-NPCs e forçar trade-offs [[Cromossomo & Genes]]. *(Apresentador: Henry Matheus)*
* **Slide 9 — Função de Fitness e Escalonamento por Fator de Mérito:** Equação multi-objetivo e bonificação heroica do modo Difícil [[Função de Fitness]]. *(Apresentador: Henry Matheus)*
* **Slide 10 — Arena 2D Dinâmica, Pilares de Cobertura e Bullet Hell:** Demonstração animada (`demonstracao_npc.gif`) com 4 pilares de absorção física, HUD com rastro/vetor Reynolds e contra-ataques azuis. *(Apresentador: Murilo Romualdo)*
* **Slide 11 — Estudo de Caso: O Combate ao Reward Hacking:** Como o exploit do "tanque parado" foi diagnosticado e eliminado [[O Problema da Convergencia Prematura]]. *(Apresentador: Murilo Romualdo)*
* **Slide 12 — Mitigação de Ruído Estocástico (Noisy Fitness):** Eliminação do ruído estocástico através do rastreamento de melhor histórico global monotônico [[Execução Paralela & Análise Comparativa]]. *(Apresentador: Murilo Romualdo)*
* **Slide 13 — Curva Média Consolidada & Parada Antecipada (Bhandari):** Análise comparativa das 30 baterias paralelas (`evolucao_media_por_dificuldade.png`) e comprovação de convergência precoce dos modos Difícil e Médio. *(Apresentador: Murilo Romualdo)*
* **Slide 14 — Validação Estatística Rigorosa (ANOVA & Boxplots):** Comprovação com One-Way ANOVA ($F = 138.24, \; p = 1.44 \times 10^{-15} \ll 0.05$) e gráficos de dispersão `boxplot_fitness_dificuldade.png` e `boxplot_distribuicao_genes.png`. *(Apresentador: Murilo Romualdo)*
* **Slide 15 — Conclusões, Engenharia de Software e Trabalhos Futuros:** Síntese dos resultados, repositório aberto e roadmap técnico. *(Apresentador: Murilo Romualdo)*

---

# 🗣️ PARTE 3: ROTEIRO CRONOMETRADO (Script de Apresentação)

> 🔗 Veja o roteiro completo em: [[Roteiro de Apresentação (15 min)]]  
> 🔗 Divisão de responsabilidades em: [[Divisão de Tarefas & Apresentadores]]

```
 0:00          3:00          6:30          10:00        14:00  15:00
  ├─────────────┼─────────────┼─────────────┼────────────┼──────┤
  │  Murilo L.  │  Leonardo   │    Henry    │ Murilo R.  │ FAQ  │
  │  Contexto   │ QD & Teoria │Física/Budget│ Experim.   │Banca │
```

---

# 🧠 PARTE 4: GUIA DE DEFESA (FAQ da Banca)

### ❓ Pergunta 1: "Como vocês provam cientificamente que as diferenças de desempenho não foram mero acaso?"
**Resposta:** Executamos 32 baterias independentes e submetemos os dados à Análise de Variância (One-Way ANOVA), calculando o $p$-valor exato via função beta incompleta (`betainc`). Obtivemos $F = 138.24$ e $p = 1.44 \times 10^{-15} \ll 0.05$, demonstrando rejeição inequívoca da hipótese nula e separabilidade estatística extrema entre as classes de dificuldade.

### ❓ Pergunta 2: "Por que taxa de cruzamento tão alta (70–90%)? O que aconteceria com 10%?"
**Resposta:** O crossover é o motor principal do AG para recombinar blocos construtivos genéticos (*building blocks*) bem-sucedidos. Com apenas 10%, a evolução dependeria quase exclusivamente de mutações estocásticas cegas, tornando o aprendizado lento e errático.

### ❓ Pergunta 3: "Qual o papel do Orçamento Global de Atributos (Point-Buy Budget)?"
**Resposta:** Sem o orçamento ($\sum u_i \le 1.8$), a evolução convergiria inevitavelmente para indivíduos com $100\%$ em todos os atributos (Super-NPCs invencíveis), eliminando a diversidade tática. O orçamento força um *trade-off* físico: para ganhar velocidade de fuga, o NPC deve abrir mão de vida e ataque.

### ❓ Pergunta 4: "Por que Seleção por Torneio e não Roleta Proporcional?"
**Resposta:** A roleta proporcional sofre com o "efeito super-indivíduo", onde um único indivíduo com pontuação inicial alta domina desproporcionalmente o pool genético, gerando convergência prematura. O Torneio ($k=3$) mantém a pressão seletiva calibrada e constante ao longo das gerações.

### ❓ Pergunta 5: "Por que Algoritmos Genéticos e não Aprendizado por Reforço Profundo (DQN/PPO)?"
**Resposta:** Deep RL exige redes neurais convolucionais densas e milhões de passos de treino com altíssimo custo computacional, incompatíveis com os ciclos de CPU de um jogo em tempo real. O AG associado ao MAP-Elites gera um catálogo diversificado de comportamentos em poucos segundos com footprint de memória mínimo.

### ❓ Pergunta 6: "Por que as curvas dos modos Médio e Difícil terminam por volta da geração 21/22 enquanto o Fácil foi até a 50?"
**Resposta:** Isso comprova a eficácia do nosso Critério de Parada Antecipada por Estagnação (Critério de Bhandari, com $K=15$ e $\epsilon=1\%$). Nos modos Médio e Difícil, o forte elitismo e altas taxas de recombinação (75% a 90%) fizeram a população convergir para a estratégia ideal logo por volta da 6ª geração. Como permaneceu 15 gerações estável com melhoria inferior a 1%, o algoritmo encerrou a execução para poupar processamento. No Fácil, a mutação agressiva (15%) e ausência de elitismo forçaram o algoritmo a explorar o espaço até o teto estipulado de 50 gerações.

---

## 🔗 Conexões do Dossiê

- [[00 - MOC Principal]]
- [[Ref - Lee (KIOTS)]]
- [[Ref - Kirk & Scirea (Map-Elites)]]
- [[Cromossomo & Genes]]
- [[Função de Fitness]]
- [[Simulação & Física de Esquiva]]
- [[Parametrização Geral do GA]]
- [[Configuração de Dificuldade]]
- [[Critério de Parada e Convergência]]
- [[Diário de Testes]]
- [[O Problema da Convergencia Prematura]]
- [[Execução Paralela & Análise Comparativa]]
- [[Divisão de Tarefas & Apresentadores]]
- [[Roteiro de Apresentação (15 min)]]
