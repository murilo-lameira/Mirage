# 🎯 Formulação da Função de Fitness (Aptidão Multi-Objetivo)

A função de fitness avalia quantitativamente o desempenho do NPC em uma arena de combate com física contínua e projéteis ativos.

---

## 🧮 Equação Multi-Objetivo

A aptidão de cada indivíduo é calculada ponderando sobrevivência, esquivas limpas, engajamento ofensivo e penalidades por dano:

$$\text{Fitness} = \max\Big(0.1, \; (w_1 \cdot T_{\text{survival}}) + (w_2 \cdot N_{\text{dodge}}) + (w_3 \cdot D_{\text{inflicted}}) - (p_1 \cdot N_{\text{collision}}) - (p_2 \cdot D_{\text{taken}})\Big)$$

### Parâmetros e Métricas:
* $T_{\text{survival}}$: Tempo total de sobrevivência na arena (máximo de $30.0\text{s}$ por rodada).
* $N_{\text{dodge}}$: Quantidade de projéteis que entraram no radar periférico ($r = 4.0\text{m}$) e foram evitados com sucesso sem colisão.
* $D_{\text{inflicted}}$: Dano acumulado causado ao jogador enquanto realiza manobras.
* $N_{\text{collision}}$: Número de projéteis que atingiram diretamente a *hitbox* do NPC ($r = 1.0\text{m}$).
* $D_{\text{taken}}$: Total de dano recebido das colisões ($25\text{ pts}$ por tiro).

---

## ⚖️ Matriz de Pesos Equalizada (30 Segundos)

Para evitar que a evolução beneficie apenas a velocidade e vida (desprezando o ataque e cadência), os pesos e a simulação de $30\text{s}$ exigem um perfil versátil e balanceado:

| Dificuldade | $w_1$ (Tempo 30s) | $w_2$ (Desvio) | $w_3$ (Dano) | $p_1$ (Hit) | $p_2$ (Dano Tomado) | Filosofia de Seleção |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Fácil (1)** | $3.0$ | $3.0$ | **$0.25$** | $4.0$ | $0.2$ | Recompensa dano ofensivo contínuo e sobrevivência ao longo de 30s. |
| **Médio (2)** | $3.5$ | $5.0$ | **$0.20$** | $10.0$ | $0.5$ | Exige harmonia entre ataque contínuo e evasão de tiros médios. |
| **Difícil (3)** | **$4.0$** | **$7.0$** | **$0.18$** | **$18.0$** | **$0.8$** | Foco em sobreviver aos 30s de *Bullet Hell* sem zerar poder de fogo. |

---

## 🎯 Precisão Dinâmica sob Movimento

Para evitar que o NPC atire com precisão cirúrgica enquanto corre em velocidade terminal ($8.0\text{ m/s}$), o cálculo de dano infligido aplica um fator de estabilidade:

$$\text{Precisão} = \max\left(0.5, \; 1.0 - 0.3 \cdot \frac{|\vec{v}_{\text{npc}}|}{v_{\text{max}}}\right)$$
$$D_{\text{inflicted}} = D_{\text{inflicted}} + (\text{Attack} \cdot \text{Precisão})$$

---

## 🛡️ Prevenção de Modos de Falha (*Reward Hacking*)

1. **Equalização de Atributos:** Com a simulação de $30\text{s}$ e $w_3 \ge 0.18$ no Difícil, a IA não pode descartar Ataque/Cadência. NPCs que negligenciam poder de fogo perdem valiosos pontos de dano acumulados nos 30s.
2. **Anti-Tank Exploit (Evitar Ganho de Ponto Parado):** Como o tempo de prova é longo ($30\text{s}$), um NPC parado acumula colisões consecutivas e sua aptidão despenca devido a $p_1$.
3. **Piso Mínimo de Sobrevivência:** A função é truncada em $\text{Fitness} \ge 0.1$ para manter probabilidades de seleção numéricas bem-comportadas.

---

## 🔗 Conexões
- [[Cromossomo & Genes]]
- [[Simulação & Física de Esquiva]]
- [[O Problema da Convergencia Prematura]]
- [[00 - MOC Principal]]
