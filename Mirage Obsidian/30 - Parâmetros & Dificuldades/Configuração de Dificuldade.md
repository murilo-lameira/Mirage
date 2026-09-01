# 🎚️ Configuração de Dificuldade Escalável

Para oferecer um desafio balanceado de acordo com a habilidade do jogador, o Algoritmo Genético reajusta sua dinâmica evolutiva em três níveis de proficiência:

---

## 📊 Matriz Comparativa de Hiperparâmetros

| Parâmetro | Modo Fácil (1) | Modo Médio (2) | Modo Difícil (3) |
| :--- | :---: | :---: | :---: |
| **Tamanho da População ($N_{\text{pop}}$)** | $20$ indivíduos | $50$ indivíduos | $100$ indivíduos |
| **Gerações Máximas ($G_{\text{max}}$)** | $30$ gerações | $50$ gerações | $60$ gerações |
| **Taxa de Cruzamento ($P_c$)** | $60\%$ | $75\%$ | $90\%$ |
| **Taxa de Mutação ($P_m$)** | $15\%$ (alta dispersão) | $5\%$ (balanceada) | $1\%$ (busca cirúrgica) |
| **Elitismo ($N_e$)** | $0$ (sem preservação) | $1$ campeão | $3$ mestres absolutos |
| **Cadência de Tiros da Arena** | $1.4\text{s} \to 0.7\text{s}$ | $0.75\text{s} \to 0.22\text{s}$ | $0.30\text{s} \to 0.10\text{s}$ (*Bullet Hell*) |
| **Velocidade dos Projéteis** | $9.0\text{ m/s}$ | $11.5\text{ m/s}$ | $13.5\text{ m/s}$ |
| **Dispersão de Mira (Ruído)** | $\pm 0.25$ | $\pm 0.15$ | $\pm 0.08$ |
| **Peso do Desvio no Fitness ($w_2$)** | $3.0$ | $6.0$ | $12.0$ |
| **Penalidade por Hit ($p_1$)** | $3.0$ | $12.0$ | $25.0$ |

---

## 🧠 Justificativa Científica dos Níveis

1. **Modo Fácil (Comportamento Errático e Disperso):**
   * População pequena ($20$) com mutação altíssima ($15\%$) e sem elitismo ($0$).
   * A evolução perde estratégias ótimas intencionalmente, gerando um NPC com movimentos desajeitados, lentos e fáceis de abater pelo jogador casual.

2. **Modo Médio (Equilíbrio Dinâmico):**
   * Parâmetros balanceados que permitem convergência estável em torno de 20 a 30 gerações. O NPC equilibra esquivas eficazes e capacidade ofensiva.

3. **Modo Difícil (Convergência Cirúrgica / Evasão Pura):**
   * População robusta ($100$), alto crossover ($90\%$), mutação ultra-baixa ($1\%$) e forte elitismo ($3$).
   * O espaço de busca é explorado rapidamente e converge com precisão cirúrgica para NPCs com velocidade de movimento maximizada e capacidade de esquiva em série.

---

## 🔗 Conexões
- [[Parametrização Geral do GA]]
- [[Critério de Parada e Convergência]]
- [[Função de Fitness]]
- [[00 - MOC Principal]]
