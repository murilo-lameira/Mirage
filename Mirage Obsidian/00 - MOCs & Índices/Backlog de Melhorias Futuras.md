# 📋 Backlog de Melhorias Futuras — Projeto Mirage

Este documento consolida o planejamento estratégico de evolução técnica e científica do projeto **Mirage**, priorizado para futuras iterações, publicações acadêmicas ou expansões de escopo.

---

## 🔬 1. Estatística Acadêmica & Validação Científica

Objetivo: Fornecer comprovação matemática rigorosa da convergência e reprodutibilidade do algoritmo genético para bancas de avaliação e artigos.

### 1.1 Testes de Hipótese Estatísticos (ANOVA / Teste $t$ de Student)
* **Objetivo:** Provar formalmente se as diferenças de desempenho entre os níveis de dificuldade (Fácil, Médio, Difícil) ou entre operadores (Cruzamento Híbrido vs. Mutação Pura EDS) são estatisticamente significantes.
* **Métrica:** Obtenção de $p$-valor ($p < 0.05$) e tamanho de efeito (*Cohen's $d$*).
* **Entregável:** Script analítico `src/teste_estatistico_hipoteses.m` gerando tabela com médias, desvios e valores $p$.

### 1.2 Gráficos de Variabilidade e Dispersão (Boxplots & Violin Plots)
* **Objetivo:** Visualizar a distribuição fenotípica final dos campeões em $N \ge 30$ rodadas.
* **Componentes:**
  * Boxplot de dispersão dos 4 genes (HP, Ataque, Cadência, Velocidade).
  * Boxplot do Fitness Máximo por dificuldade para identificar *outliers* ou convergência prematura.
* **Entregável:** Gráfico consolidado `data/graficos/boxplot_distribuicao_genes.png`.

### 1.3 Faixas de Incerteza (Intervalos de Confiança a 95%)
* **Objetivo:** Inserir áreas sombreadas de desvio-padrão / erro-padrão nas curvas médias de aprendizado (`evolucao_media_por_dificuldade.png`).

---

## 🎮 2. Mecânicas Avançadas de Bullet Hell & Arena Dinâmica

Objetivo: Elevar o desafio cinemático e tático do simulador com dinâmicas consagradas do gênero *bullet hell*.

### 2.1 Padrões de Disparo Compostos (*Bullet Patterns*)
* **Espiral Contínua (*Danmaku Vortex*):** Projéteis disparados do centro em rotação angular contínua, forçando o NPC a navegar em círculos concêntricos.
* **Disparo em Leque / Escopeta (*Cone Spread*):**rajadas simultâneas em múltiplos ângulos com intervalos estreitos, forçando o cálculo de microrrupturas na formação.
* **Feixes Contínuos / Lasers:** Zonas lineares de dano temporário que seccionam a arena, exigindo transição entre quadrantes.

### 2.2 Obstáculos Físicos e Cobertura (*Line of Sight*)
* **Pilares Sólidos:** Inclusão de 2 a 4 obstáculos circulares estáticos no mapa que absorvem projéteis.
* **Comportamento Emergente:** Avaliar se o Algoritmo Genético aprende naturalmente a usar pilares como escudo tático (*Occlusion Steering*).

### 2.3 Adversários Móveis / Chefões Ativos
* Substituir os disparos periféricos por um ou dois inimigos móveis que caçam o NPC, demandando algoritmos simultâneos de fuga e perseguição (*Pursuit-Evasion Game Theory*).

---

## 🧭 Histórico de Priorização

| Item | Área | Status |
| :--- | :--- | :---: |
| HUD Tática 2D (Rastro, Barra de Vida, Vetor Reynolds) | Visual & Simulação | ✅ **Implementado** |
| Disparos Visíveis do NPC (Combate Bidirecional) | Mecânica de Jogo | ✅ **Implementado** |
| Heatmap 2D do MAP-Elites (Quality-Diversity) | Análise de Dados | ✅ **Implementado** |
| Gerador de GIF Animado Automático | Apresentação / README | ✅ **Implementado** |
| Validação Estatística (ANOVA, Boxplots, $p$-value) | Estatística Acadêmica | ✅ **Implementado** |
| Padrões Bullet Hell (Espirais, Leque) & Pilares de Cobertura | Mecânica Avançada | ✅ **Implementado** |
| Lasers Lineares & Adversários Móveis | Expansões Futuras | ⏳ **No Backlog** |

---
*Documento de governança do projeto Mirage — UNISENAI.*

