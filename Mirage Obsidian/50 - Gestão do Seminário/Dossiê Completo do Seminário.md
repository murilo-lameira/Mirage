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

# 🎚️ PARTE 2: BLUEPRINT VISUAL DE SLIDES (14 Slides)

* **Slide 1 — Capa do Projeto:** Título, Autores, Orientador Me. Ricardo Martinez Vicentini e Logo UNISENAI.
* **Slide 2 — O Problema do Determinismo em Jogos:** Limitações de FSMs e Árvores de Comportamento.
* **Slide 3 — Fundamentação Científica: Qualidade-Diversidade:** [[Ref - Kirk & Scirea (Map-Elites)]].
* **Slide 4 — Cinemática da Esquiva Preditiva:** [[Ref - Lee (KIOTS)]] e Steering Behaviors de Reynolds.
* **Slide 5 — O Genoma do NPC e o Orçamento Global (Point-Buy):** [[Cromossomo & Genes]].
* **Slide 6 — Função de Fitness Multi-Objetivo:** [[Função de Fitness]].
* **Slide 7 — A Arena 2D de Simulação Física:** Radar periférico e detecção de CPA.
* **Slide 8 — Parametrização e Operadores do AG:** [[Parametrização Geral do GA]].
* **Slide 9 — Escalonamento de Dificuldade (Fácil, Médio, Difícil):** [[Configuração de Dificuldade]].
* **Slide 10 — Critério de Parada e Estabilidade de Bhandari:** [[Critério de Parada e Convergência]].
* **Slide 11 — Estudo de Caso: O Problema da Convergência Prematura:** [[O Problema da Convergencia Prematura]].
* **Slide 12 — Automação Paralela e Resultados Experimentais (30 Testes):** [[Execução Paralela & Análise Comparativa]].
* **Slide 13 — Gráficos Comparativos de Convergência do Octave:** [[Diário de Testes]].
* **Slide 14 — Conclusões, Impacto da Engenharia e Trabalhos Futuros.**

---

# 🗣️ PARTE 3: ROTEIRO CRONOMETRADO (Script de Apresentação)

> 🔗 Veja o roteiro completo em: [[Roteiro de Apresentação (15 min)]]  
> 🔗 Divisão de responsabilidades em: [[Divisão de Tarefas & Apresentadores]]

```
 0:00          3:00          6:30          10:00        14:00  15:00
  ├─────────────┼─────────────┼─────────────┼────────────┼──────┤
  │  Leonardo   │    Henry    │  Murilo L.  │ Murilo R.  │ FAQ  │
  │  Contexto   │ QD & Teoria │Física/Budget│ Experim.   │Banca │
```

---

# 🧠 PARTE 4: GUIA DE DEFESA (FAQ da Banca)

### ❓ Pergunta 1: "Por que taxa de cruzamento tão alta (70–90%)? O que aconteceria com 10%?"
**Resposta:** O crossover é o motor principal do AG para recombinar subestruturas genéticas bem-sucedidas. Com apenas 10%, a evolução dependeria quase exclusivamente de mutações estocásticas cegas, tornando o aprendizado lento e errático.

### ❓ Pergunta 2: "Qual o papel da mutação e como vocês definem o equilíbrio?"
**Resposta:** A mutação injeta diversidade no espaço de busca para escapar de ótimos locais. Mutação abaixo de 1% gera estagnação prematura; mutação acima de 15% quebra as estratégias consolidadas pelo cruzamento (comportamento caótico).

### ❓ Pergunta 3: "Por que Seleção por Torneio e não Roleta Proporcional?"
**Resposta:** A roleta proporcional sofre com o "efeito super-indivíduo", onde um único NPC com pontuação inicial alta domina todo o pool genético. O Torneio ($k=3$) mantém a pressão seletiva constante e preserva a diversidade de nichos comportamentais.

### ❓ Pergunta 4: "Como o critério de Bhandari é superior à parada por número fixo de gerações?"
**Resposta:** Parar em um número fixo de gerações ou desperdiça CPU após a convergência ou interrompe o treino antes do aprendizado. Monitorar a taxa de melhoria ($\Delta < 1\%$ por 15 gerações) encerra o treino dinamicamente no momento exato em que a população atinge a estabilidade.

### ❓ Pergunta 5: "Por que Algoritmos Genéticos e não Aprendizado por Reforço Profundo (DQN/PPO)?"
**Resposta:** Deep RL exige redes neurais pesadas e centenas de milhares de passos de treino que consomem recursos excessivos de CPU/GPU incompatíveis com a taxa de quadros de um jogo. O AG é leve, opera diretamente sobre parâmetros contínuos de controle e treina em poucos segundos.

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
