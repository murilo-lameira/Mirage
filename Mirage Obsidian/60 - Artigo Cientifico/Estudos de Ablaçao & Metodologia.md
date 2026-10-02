# 🔬 Estudos de Ablação & Metodologia Experimental

Este documento detalha o protocolo científico formal para os experimentos de controle que fundamentam o artigo do **Mirage**.

---

## 🎯 Por que Fazer Estudos de Ablação?
Em artigos de ponta em Inteligência Computacional, não basta demonstrar que o sistema funciona; é imperativo provar **qual componente é responsável por cada ganho de desempenho** através do isolamento de variáveis.

---

## 🧪 1. Experimento de Ablação 1: O Efeito da Restrição Orçamentária

### Hipótese
- $H_0$: A ausência do teto de orçamento energético ($\sum u_i \le 1.8$) não altera a diversidade fenotípica nem induz colapso comportamental.
- $H_1$: Sem o teto energético, o algoritmo genético sofre *Reward Hacking*, convergindo monotonamente para indivíduos de HP máximo (*bullet sponges*), extinguindo arquétipos ágeis (*Glass Cannons*).

### Protocolo
1. **Grupo Controle (Mirage Original):** GA padrão com teto estrito de $1.8$.
2. **Grupo Ablação (Sem Budget):** GA com cada gene livre no intervalo $[0, 1]$ sem normalização de soma (orçamento máximo teórico $= 4.0$).
3. **Métricas de Comparação:**
   - Variabilidade fenotípica (Desvio padrão dos genes de velocidade e cadência).
   - Ocupação do mapa MAP-Elites (Número de células preenchidas / Coverage %).
   - Taxa de esquivas ativas vs dano puramente absorvido por tanque.

---

## 🧪 2. Experimento de Ablação 2: CPA Preditivo vs Repulsão Reativa

### Hipótese
- $H_0$: A antecipação temporal do CPA não produz vantagens mensuráveis frente a uma repulsão puramente euclidiana em tempo real.
- $H_1$: O CPA reduz expressivamente a taxa de colisões críticas ao calcular a janela futura $t_{\text{cpa}}$, enquanto a repulsão reativa falha sistematicamente em disparos rápidos cruzados.

### Protocolo
1. **Grupo CPA (Mirage Original):** Força calculada no ponto de maior aproximação temporal $t_{\text{cpa}}$.
2. **Grupo Reativo Simples:** Força de evasão calculada apenas com base na distância instantânea euclidiana atual $\mathbf{p}_{\text{proj}} - \mathbf{p}_{\text{npc}}$, sem considerar o vetor velocidade relativa.
3. **Métricas de Comparação:**
   - Tempo médio de sobrevivência ($T_{\text{survival}}$).
   - Contagem de esquivas limpas com sucesso ($N_{\text{dodge}}$).
   - Distância mínima de passagem (*minimum separation distance*).

---

## 📊 3. Métricas Oficiais de Qualidade-Diversidade (QD)
Para enriquecer a análise do MAP-Elites:
- **QD-Score:** $\sum_{c \in \mathcal{C}} \text{Fitness}(c)$, onde $\mathcal{C}$ é o conjunto de nichos ocupados.
- **Coverage (%):** $\frac{|\mathcal{C}|}{|\mathcal{C}_{\text{total}}|} \times 100$.
- **Max Fitness Geral:** O indivíduo mais apto gerado em todo o histórico.

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Estrutura do Artigo (5 Paginas)]]
- [[O Problema da Convergencia Prematura]]
- [[Execução Paralela & Análise Comparativa]]