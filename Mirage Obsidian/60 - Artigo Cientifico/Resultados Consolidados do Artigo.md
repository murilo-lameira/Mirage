# 📊 Resultados Consolidados do Artigo (N = 86)

Este documento sintetiza os dados experimentais, testes de hipóteses estatísticas, métricas formais de Qualidade-Diversidade (QD) e estudos de ablação incorporados formalmente no artigo científico do projeto **Mirage** (`paper/main.tex`).

---

## 📈 1. Estatística Descritiva do Fitness Máximo

Amostragem empírica de $N = 86$ rodadas evolutivas completas ($30$ gerações, população $P = 30$, totalizando $77.400$ combates simulados na arena):

| Nível de Dificuldade | Amostras ($N$) | Média ($\mu$) | Desvio Padrão ($\sigma$) | Mediana | Comportamento Predominante |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Fácil ($D_1$)** | 30 | **$627{,}50$** | $32{,}64$ | $636{,}06$ | *Tanker / Bruiser* (Vida e Ataque altos, velocidade baixa) |
| **Médio ($D_2$)** | 29 | **$882{,}86$** | $42{,}29$ | $886{,}34$ | *Combatente Equilibrado* (Partição simétrica de atributos) |
| **Difícil ($D_3$)** | 27 | **$1680{,}16$** | $281{,}40$ | $1726{,}40$ | *Glass Cannon / Ninja Evasivo* (Velocidade máxima e esquiva CPA) |

---

## 🔬 2. Análise de Variância (One-Way ANOVA)

* **Hipótese Nula ($H_0$):** As médias de aptidão máxima são estatisticamente equivalentes entre os regimes ($\mu_1 = \mu_2 = \mu_3$).
* **Graus de Liberdade:** Entre grupos $= 2$; Dentro dos grupos $= 83$.
* **Estatística $F$:** **$327{,}456$**
* **$p$-valor:** **$1{,}44 \times 10^{-37} \ll 0{,}001$**
* **Conclusão:** Rejeita-se categoricamente $H_0$. Há separação estatística extrema decorrente do escalonamento por Fator de Mérito.

---

## 📐 3. Testes $t$ de Student Pareados e Tamanho de Efeito

| Contraste Par-a-Par | Estatística $t$ | $p$-valor | Cohen $d$ | Classificação de Efeito |
| :--- | :---: | :---: | :---: | :--- |
| **Médio vs. Fácil** | $26{,}018$ | $2{,}57 \times 10^{-33}$ | **$6{,}78$** | Efeito Grande ($d \ge 0{,}8$) |
| **Difícil vs. Médio** | $15{,}086$ | $5{,}17 \times 10^{-21}$ | **$4{,}03$** | Efeito Grande ($d \ge 0{,}8$) |
| **Difícil vs. Fácil** | $20{,}358$ | $2{,}80 \times 10^{-27}$ | **$5{,}40$** | Efeito Extremo ($d \ge 0{,}8$) |

---

## 🗺️ 4. Métricas Formais de Qualidade-Diversidade (QD)

Baseadas em Mouret & Clune (2015) e Kirk & Scirea (2020) com $643$ registros processados:
* **Cobertura do Espaço (Coverage):** **$100{,}00\%$** ($9/9$ nichos ocupados).
* **QD-Score Acumulado Global:** **$14.040{,}85$**.
* **Aptidão Máxima do Repertório:** **$2.321{,}38$** (Nicho: Mobilidade Média $\times$ Tanker).
* **Decomposição por Regime de Desafio:**
  * Fácil ($D_1$): Cobertura $= 100{,}0\%$, $\text{QD-Score} = 3.933{,}41$.
  * Médio ($D_2$): Cobertura $= 100{,}0\%$, $\text{QD-Score} = 7.263{,}83$.
  * Difícil ($D_3$): Cobertura $= 100{,}0\%$, $\text{QD-Score} = 14.040{,}85$.

| Mobilidade \ Classe | Tanker | Balanceado | Glass Cannon |
| :--- | :---: | :---: | :---: |
| **Lento ($< 4{,}5\text{ m/s}$)** | $1993{,}85$ | $1813{,}53$ | $1196{,}57$ |
| **Médio ($4{,}5 \text{ a } 6{,}5\text{ m/s}$)** | $2321{,}38$ | $1733{,}83$ | $1240{,}99$ |
| **Rápido ($> 6{,}5\text{ m/s}$)** | $1536{,}14$ | $1424{,}77$ | $779{,}79$ |

---

## 🧪 5. Resultados dos Estudos de Ablação

### Ablação 1: Efeito do Orçamento de Recursos ($B = 1{,}8$)
* **Condição Sem Orçamento ($\sum u_i \le 4{,}0$):** $100\%$ dos indivíduos evoluíram para o teto $u_i \to 1{,}0$, caindo em *Reward Hacking* (agentes esponjas com $200\text{ HP}$ e locomoção estática). A variância no gene de velocidade despencou para $\sigma^2 = 0{,}004$.
* **Condição Com Orçamento ($B = 1{,}8$):** A conservação forçada induziu variância $\sigma^2 = 0{,}087$ e especialização fenotípica estável em 3 arquétipos (confirmação da **RQ1**).

### Ablação 2: Evasão CPA + Lead-Aiming vs Repulsão Reativa Euclidiana Instantânea
* **Tempo Médio de Sobrevivência no Difícil ($D_3$):**
  * Esquiva e Tiro Reativos: $11{,}40 \pm 2{,}8\text{ s}$
  * Esquiva Analítica CPA + Lead-Aiming (Wang & Tan 2014): **$28{,}65 \pm 1{,}4\text{ s}$** (Ganho de $+151{,}3\%$)
* **Frequência de Colisões Críticas:**
  * Mecânica Reativa: $2{,}14\text{ hits/s}$
  * Mecânica CPA + Lead-Aiming: **$0{,}48\text{ hits/s}$** (Redução de $77{,}5\%$)
  * Estatística de Contraste: $t = 18{,}72, \; p < 10^{-24}$ (confirmação da **RQ2**).

---

## 🖼️ 6. Figuras Integradas no Artigo (`paper/figuras/`)

1. `evolucao_media_por_dificuldade.png` — Curva de aprendizado médio assintótica ao longo de 30 gerações.
2. `boxplot_fitness_dificuldade.png` — Diagrama de caixas comprovando a ausência de sobreposição interquartil.
3. `boxplot_distribuicao_genes.png` — Dispersão gênica revelando a especialização dos 4 atributos por ambiente.
4. `map_elites_heatmap.png` — Matriz comportamental 2D com métricas de QD (100% cobertura e QD-Score = 14040.85).

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Estrutura do Artigo (5 Paginas)]]
- [[Estudos de Ablaçao & Metodologia]]
- [[Workflow LaTeX no VS Code]]
- [[Execução Paralela & Análise Comparativa]]
