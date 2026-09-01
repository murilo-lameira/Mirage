# 🎯 Formulação da Função de Fitness (Aptidão Multi-Objetivo)

A função de fitness avalia quantitativamente o desempenho do NPC em uma arena de combate com física contínua e projéteis ativos.

---

## 🧮 Equação Multi-Objetivo

A aptidão de cada indivíduo é calculada ponderando sobrevivência, esquivas limpas, engajamento ofensivo e penalidades por dano:

$$\text{Fitness} = \max\Big(0.1, \; (w_1 \cdot T_{\text{survival}}) + (w_2 \cdot N_{\text{dodge}}) + (w_3 \cdot D_{\text{inflicted}}) - (p_1 \cdot N_{\text{collision}}) - (p_2 \cdot D_{\text{taken}})\Big)$$

### Parâmetros e Métricas:
* $T_{\text{survival}}$: Tempo total de sobrevivência na arena (máximo de $15.0\text{s}$ por rodada).
* $N_{\text{dodge}}$: Quantidade de projéteis que entraram no radar periférico ($r = 4.0\text{m}$) e foram evitados com sucesso sem colisão.
* $D_{\text{inflicted}}$: Dano acumulado causado ao jogador enquanto realiza manobras.
* $N_{\text{collision}}$: Número de projéteis que atingiram diretamente a *hitbox* do NPC ($r = 1.0\text{m}$).
* $D_{\text{taken}}$: Total de dano recebido das colisões ($25\text{ pts}$ por tiro).

---

## ⚖️ Matriz de Pesos por Nível de Dificuldade

Os pesos variam dinamicamente para calibrar a pressão de seleção exigida em cada modo:

| Dificuldade | $w_1$ (Tempo) | $w_2$ (Desvio) | $w_3$ (Dano) | $p_1$ (Hit) | $p_2$ (Dano Tomado) | Filosofia de Seleção |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Fácil (1)** | $2.0$ | $3.0$ | **$0.20$** | $3.0$ | $0.2$ | Recompensa dano ofensivo e sobrevivência geral. |
| **Médio (2)** | $2.5$ | $6.0$ | $0.10$ | $12.0$ | $0.5$ | Exige harmonia entre ataque contínuo e evasão de tiros médios. |
| **Difícil (3)** | **$3.5$** | **$12.0$** | $0.05$ | **$25.0$** | **$1.0$** | *Bullet Hell* estrito: colisões destroem a aptidão; foco total em evasão. |

---

## 🎯 Precisão Dinâmica sob Movimento

Para evitar que o NPC atire com precisão cirúrgica enquanto corre em velocidade terminal ($8.0\text{ m/s}$), o cálculo de dano infligido aplica um fator de estabilidade:

$$\text{Precisão} = \max\left(0.5, \; 1.0 - 0.3 \cdot \frac{|\vec{v}_{\text{npc}}|}{v_{\text{max}}}\right)$$
$$D_{\text{inflicted}} = D_{\text{inflicted}} + (\text{Attack} \cdot \text{Precisão})$$

---

## 🛡️ Prevenção de Modos de Falha (*Reward Hacking*)

1. **Anti-Turtling (Evitar Fuga Passiva nas Bordas):** O bônus $w_3 \cdot D_{\text{inflicted}}$ impede que o NPC simplesmente corra para um canto neutro e ignore o combate.
2. **Anti-Tank Exploit (Evitar Ganho de Ponto Parado):** Como $w_3$ foi balanceado e o custo de colisão $p_1$ é alto, NPCs imóveis acumulam colisões consecutivas e são eliminados na seleção por torneio.
3. **Piso Mínimo de Sobrevivência:** A função é truncada em $\text{Fitness} \ge 0.1$ para manter probabilidades de seleção numéricas bem-comportadas.

---

## 🔗 Conexões
- [[Cromossomo & Genes]]
- [[Simulação & Física de Esquiva]]
- [[O Problema da Convergencia Prematura]]
- [[00 - MOC Principal]]
