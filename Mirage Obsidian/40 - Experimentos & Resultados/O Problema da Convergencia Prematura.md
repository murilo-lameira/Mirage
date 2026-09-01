# 🛠️ Estudo de Caso: Convergência Prematura e Rebalanceamento do Algoritmo

Durante o ciclo de desenvolvimento do Mirage, a análise empírica dos dados do CSV revelou duas fases críticas de **Reward Hacking / Convergência Prematura** causadas pela formulação inicial das funções de recompensa.

---

## 🛑 Fase 1: O "Exploit do Tanque" (Reward Dominant)

### O Problema:
Nos primeiros testes, o peso do dano na função de fitness era muito elevado ($w_3 = 0.5$) e a taxa de tiros da arena era estática.
* **Comportamento da IA:** A população descobriu que era matematicamente mais lucrativo ficar totalmente imóvel no centro da arena, com HP máximo e Ataque máximo, recebendo tiros e atirando sem parar.
* **Consequência:** A IA "esqueceu" de desviar, pois atirar parado gerava milhares de pontos sem esforço cinemático.

### A Correção da Fase 1:
1. Redução drástica do peso de dano para $w_3 = 0.05$.
2. Modificação da arena por dificuldade (*Bullet Hell* no Difícil com tiros mais rápidos).
3. Aumento do critério de parada de Bhandari de $5$ para $15$ gerações.

---

## 🛑 Fase 2: O "Exploit do Canhão de Vidro" (Pontos Grátis)

### O Problema:
Após a correção da Fase 1, o NPC passou a focar em esquiva. No entanto, surgiu uma nova anomalia nos dados:
* Como o trade-off existia apenas entre HP e Velocidade, os atributos de **Ataque ($50$)** e **Cadência ($3.00\text{ Hz}$)** eram essencialmente "pontos grátis".
* O algoritmo convergia sempre para o mesmo campeão em todas as 3 dificuldades: Ataque $50$, Cadência $3.00$, Velocidade máxima ($\approx 7.8\text{ m/s}$) e HP mínimo ($\approx 10\text{ a }60$), gerando gráficos homogêneos.

### A Correção da Fase 2 (Solução Definitiva):
1. **Sistema de Orçamento Global (Point-Buy Budget):** A soma dos 4 atributos normalizados agora é limitada em $\sum u_i \le 1.8$. Para ter ataque alto, o NPC é obrigado a abrir mão de velocidade ou HP.
2. **Diferenciação Ambiental e Calibração dos Pesos:** Pesos diferenciados por dificuldade ($w_1, w_2, w_3, p_1, p_2$), forçando arquétipos distintos (Bruiser no Fácil e Ninja Evasivo no Difícil).
3. **Precisão Dinâmica em Movimento:** Disparar em velocidade terminal reduz a estabilidade e o dano infligido.

---

## 🎓 Impacto Acadêmico para o Seminário
Este estudo de caso é um dos pontos mais fortes da apresentação perante a banca examinadora, pois demonstra que o grupo:
1. Coletou e analisou dados experimentais reais.
2. Identificou falhas clássicas de IA (Reward Hacking / Ótimo Local).
3. Aplicou princípios formais de Engenharia de Software e Otimização para solucionar o problema matematicamente.

---

## 🔗 Conexões
- [[Diário de Testes]]
- [[Cromossomo & Genes]]
- [[Função de Fitness]]
- [[00 - MOC Principal]]
