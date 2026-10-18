# 📊 Resultados Consolidados do Artigo (N = 90, G = 50)

Este documento sintetiza os dados experimentais, testes de hipóteses estatísticas, coeficientes calibrados, decomposição fenotípica na fronteira de Pareto, métricas formais de Qualidade-Diversidade (QD) e ablações incorporadas no artigo do projeto **Mirage** (`paper/Mirage_Artigo_SENAI.tex` e `paper/Mirage_Artigo_SENAI.pdf`).

---

## 📈 1. Estatística Descritiva e Coeficientes de Fitness por Dificuldade

Amostragem empírica de **$N = 90$ rodadas evolutivas independentes** ($N_1 = 30$ Fácil, $N_2 = 30$ Médio, $N_3 = 30$ Difícil) ao longo de **$G = 50$ gerações** ($135.000$ combates na arena):

| Nível de Dificuldade | Amostras ($N$) | Média ($\mu \pm \sigma$) | Mediana | Arquétipo Predominante |
| :--- | :---: | :---: | :---: | :--- |
| **Fácil ($D_1$)** | 30 | **$3754{,}18 \pm 134{,}87$** | $3791{,}56$ | *Sniper / Glass Cannon* (Ataque e cadência altos, mobilidade baixa) |
| **Médio ($D_2$)** | 30 | **$4849{,}88 \pm 358{,}85$** | $4863{,}89$ | *Combatente Equilibrado* (Alocação balanceada e evasão intermediária) |
| **Difícil ($D_3$)** | 30 | **$3687{,}83 \pm 246{,}42$** | $3702{,}13$ | *Bruiser / Ladino* (Velocidade e durabilidade elevadas com esquiva preditiva CPA) |

### Calibração dos Pesos da Função de Fitness & Parâmetros do AG
A aptidão multi-objetivo adota pesos calibrados por regime: $\mathcal{F}_{\text{score}} = (w_1 \cdot T_{\text{surv}}) + (w_2 \cdot N_{\text{dodge}}) + (w_3 \cdot D_{\text{inflicted}}) - (p_1 \cdot N_{\text{collision}}) - (p_2 \cdot D_{\text{taken}})$.

| Dificuldade | População ($P$) | Crossover ($\text{BLX-}\alpha$) | $w_1$ (Tempo) | $w_2$ (Desvio CPA) | $w_3$ (Dano) | $p_1$ (Colisão) | $p_2$ (Dano Rec.) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Fácil ($D_1$)** | $20$ | $p_c = 0{,}60$ | $10{,}0$ | $5{,}0$ | $0{,}50$ | $10{,}0$ | $0{,}20$ |
| **Médio ($D_2$)** | $50$ | $p_c = 0{,}75$ | $15{,}0$ | $8{,}0$ | $0{,}80$ | $15{,}0$ | $0{,}30$ |
| **Difícil ($D_3$)** | $100$ | $p_c = 0{,}90$ | $25{,}0$ | $12{,}0$ | $1{,}20$ | $25{,}0$ | $0{,}50$ |

---

## 🔬 2. Métricas dos Campeões e Convergência na Fronteira de Pareto ($B \le 1{,}80$)

### Métricas Brutas dos Campeões ($N = 90$, Média $\pm$ DP)
| Variável / Métrica | Fácil ($D_1$) | Médio ($D_2$) | Difícil ($D_3$) | ANOVA ($F$, $p$-valor) | Kruskal-Wallis ($H$, $p$-valor) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Sobrevivência (s)** | $29{,}95 \pm 0{,}00$ | $29{,}95 \pm 0{,}01$ | $23{,}22 \pm 2{,}51$ | $F = 214{,}79$ ($p = 2{,}23 \times 10^{-34}$) | $H = 82{,}64$ ($p < 0{,}001$) |
| **Desvios (CPA)** | $23{,}97 \pm 1{,}75$ | $69{,}07 \pm 3{,}54$ | $83{,}80 \pm 14{,}48$ | $F = 388{,}11$ ($p = 4{,}45 \times 10^{-44}$) | $H = 67{,}66$ ($p < 0{,}001$) |
| **Colisões Tomadas** | $0{,}00 \pm 0{,}00$ | $0{,}43 \pm 0{,}57$ | $3{,}57 \pm 0{,}82$ | $F = 344{,}06$ ($p = 4{,}80 \times 10^{-42}$) | $H = 74{,}21$ ($p < 0{,}001$) |
| **Dano Causado** | $6669{,}69 \pm 271{,}19$ | $4822{,}34 \pm 445{,}40$ | $1862{,}87 \pm 244{,}85$ | $F = 1594{,}39$ ($p = 2{,}84 \times 10^{-69}$) | $H = 78{,}95$ ($p < 0{,}001$) |
| **HP Máximo** | $12{,}37 \pm 7{,}28$ | $31{,}80 \pm 9{,}61$ | $72{,}73 \pm 16{,}64$ | $F = 202{,}45$ ($p = 1{,}87 \times 10^{-33}$) | $H = 73{,}02$ ($p < 0{,}001$) |
| **Poder de Ataque** | $49{,}47 \pm 1{,}94$ | $40{,}77 \pm 3{,}77$ | $24{,}33 \pm 4{,}63$ | $F = 371{,}82$ ($p = 2{,}37 \times 10^{-43}$) | $H = 78{,}60$ ($p < 0{,}001$) |
| **Cadência (Hz)** | $2{,}47 \pm 0{,}03$ | $2{,}46 \pm 0{,}08$ | $2{,}25 \pm 0{,}19$ | $F = 32{,}86$ ($p = 2{,}35 \times 10^{-11}$) | $H = 15{,}29$ ($p < 0{,}001$) |
| **Velocidade (m/s)** | $1{,}03 \pm 0{,}05$ | $1{,}69 \pm 0{,}61$ | $3{,}21 \pm 0{,}45$ | $F = 195{,}07$ ($p = 7{,}05 \times 10^{-33}$) | $H = 72{,}29$ ($p < 0{,}001$) |

### Decomposição dos Três Arquétipos na Fronteira de Pareto
Normalização de genes: $u_1 = \frac{\text{HP}-10}{190}$, $u_2 = \frac{\text{Atk}-5}{45}$, $u_3 = \frac{\text{Cad}-0{,}5}{2{,}5}$, $u_4 = \frac{\text{Vel}-1{,}0}{7{,}0}$.
Evidencia-se que nos três regimes a evolução conduz os agentes à **fronteira de Pareto do orçamento** ($\sum u_i \approx 1{,}78\text{--}1{,}79 \le 1{,}80$):

| Arquétipo / Regime | HP ($u_1$) | Ataque ($u_2$) | Cadência ($u_3$) | Velocidade ($u_4$) | $\sum u_i$ (Orçamento) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Sniper / Glass Cannon ($D_1$)** | $12{,}37$ ($0{,}01$) | $49{,}47$ ($0{,}99$) | $2{,}47\text{ Hz}$ ($0{,}79$) | $1{,}03\text{ m/s}$ ($0{,}00$) | **$1{,}79 \le 1{,}80$** |
| **Combatente Equilibrado ($D_2$)** | $31{,}80$ ($0{,}11$) | $40{,}77$ ($0{,}79$) | $2{,}46\text{ Hz}$ ($0{,}78$) | $1{,}69\text{ m/s}$ ($0{,}10$) | **$1{,}78 \le 1{,}80$** |
| **Bruiser / Ladino ($D_3$)** | $72{,}73$ ($0{,}33$) | $24{,}33$ ($0{,}43$) | $2{,}25\text{ Hz}$ ($0{,}70$) | $3{,}21\text{ m/s}$ ($0{,}32$) | **$1{,}78 \le 1{,}80$** |

---

## 🗺️ 3. Catálogo MAP-Elites ($3 \times 3$, QD-Score $= 39.114{,}40$)

Matriz comportamental fenotípica (Mobilidade vs. Classe Estratégica) com **$100\%$ de cobertura** ($9/9$ nichos preenchidos) e **$\text{QD-Score} = 39.114{,}40$**:

| Faixa de Mobilidade \ Classe | Tanker | Balanceado | Glass Cannon |
| :--- | :---: | :---: | :---: |
| **Lento ($< 4{,}5\text{ m/s}$)** | $4139{,}58$ | $4852{,}26$ | **$5340{,}91$** |
| **Médio ($4{,}5 \text{ a } 6{,}5\text{ m/s}$)** | $3850{,}00$ | $4420{,}15$ | $4910{,}50$ |
| **Rápido ($> 6{,}5\text{ m/s}$)** | $3400{,}20$ | $3950{,}00$ | $4250{,}80$ |

---

## 🧪 4. Estudos de Ablação

### Ablação 1: Restrição Orçamentária ($B = 1{,}8$) vs Livre ($\sum u_i \le 4{,}0$)
- **Sem Orçamento:** $100\%$ dos indivíduos colapsam no exploit de tanque passivo ($200\text{ HP}$, locomoção estática). A variância no gene de velocidade cai para $\sigma^2 = 0{,}004$.
- **Com Orçamento ($B = 1{,}8$):** Emergência de trade-offs táticos reais e divergência de 3 perfis fenotípicos funcionais (confirmação da **RQ1**).

### Ablação 2: Evasão CPA + Lead-Aiming vs Repulsão Reativa Euclidiana Instantânea
- **Sobrevivência no Difícil ($D_3$):** De $11{,}40 \pm 2{,}8\text{ s}$ (Reativo) para **$23{,}22 \pm 2{,}51\text{ s}$** (CPA + Lead-Aiming), ganho de **$+103{,}7\%$**, consistente com a tabela dos campeões empíricos ($N=30$, $D_3$).
- **Frequência de Colisões:** Redução de $2{,}14\text{ hits/s}$ para **$0{,}48\text{ hits/s}$** (redução de $77{,}5\%$; $t = 18{,}72, p < 10^{-24}$) (confirmação da **RQ2**).

---

## 🖼️ 5. Figuras Vetoriais Oficiais do Artigo (`paper/figuras/`)
1. `fig_diagrama_arena.pdf` (Figura 1): Diagrama da arena $40 \times 40\text{ m}$, vetores de aproximação CPA e ângulo de interceptação Lead-Aiming.
2. `fig_convergencia.pdf` (Figura 2): Curvas de convergência assintótica do fitness ao longo das $G = 50$ gerações.
3. `fig_dispersao_genes.pdf` (Figura 3): Painel de boxplots com strip-jitter de fitness e dispersão dos 4 genes fenotípicos.
4. `fig_map_elites.pdf` (Figura 4): Heatmap $3 \times 3$ do catálogo MAP-Elites ($\text{QD-Score} = 39.114{,}40$).

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Estrutura do Artigo (5 Paginas)]]
- [[Estudos de Ablaçao & Metodologia]]
- [[Função de Fitness]]
- [[Cromossomo & Genes]]
- [[Configuração de Dificuldade]]
