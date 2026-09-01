# 🧬 Definição do Cromossomo (Genoma do NPC)

Para que o NPC se adapte tanto ofensiva quanto defensivamente de forma balanceada, estruturamos nosso cromossomo como uma cadeia contínua de valores reais representando os atributos vitais do inimigo.

---

## 🔬 Composição dos Genes

Cada indivíduo da população é codificado por um vetor de **4 genes fundamentais**:

$$\text{Cromossomo} = [\text{HP}, \text{Attack}, \text{AttackSpeed}, \text{MovementSpeed}]$$

| Gene | Unidade | Limites Físicos | Papel no Combate |
| :--- | :---: | :---: | :--- |
| **HP (Pontos de Vida)** | Inteiro ($pts$) | $[10, 200]$ | Capacidade de absorver colisões sem morrer. |
| **Attack (Poder de Ataque)** | Dano ($dmg$) | $[5, 50]$ | Quantidade de dano bruto infligido ao jogador. |
| **AttackSpeed (Cadência)** | Frequência ($\text{Hz}$) | $[0.5, 3.0]$ | Disparos/golpes desferidos por segundo ($1/\text{tempo}$). |
| **MovementSpeed (Velocidade)** | Velocidade ($\text{m/s}$) | $[1.0, 8.0]$ | Limite cinemático vetorial para manobras de esquiva (*Steering*). |

---

## ⚖️ Sistema de Orçamento Global de Atributos (Point-Buy Budget)

Para impedir o surgimento de **"Super-NPCs"** (indivíduos que maximizam todos os atributos simultaneamente e quebram a coerência do jogo), implementamos uma restrição matemática de orçamento normalizado:

1. Cada gene $x_i$ é normalizado no intervalo unitário $u_i \in [0, 1]$:
   $$u_1 = \frac{\text{HP} - 10}{190}, \quad u_2 = \frac{\text{Attack} - 5}{45}, \quad u_3 = \frac{\text{AttackSpeed} - 0.5}{2.5}, \quad u_4 = \frac{\text{MovementSpeed} - 1.0}{7.0}$$

2. A soma dos atributos normalizados é limitada pelo **Orçamento Máximo ($B = 1.8$)**:
   $$\sum_{i=1}^4 u_i \le 1.8$$

3. Se a combinação genética (por mutação ou cruzamento) ultrapassar $1.8$, o vetor de genes é reescalado proporcionalmente:
   $$\vec{u} \leftarrow \vec{u} \times \left(\frac{1.8}{\sum u_i}\right)$$

---

## 🎭 Arquétipos Emergentes da Evolução

Graças ao Orçamento Global, o Algoritmo Genético é obrigado a especializar os indivíduos conforme a hostilidade do ambiente:

```
                [ VELOCIDADE ]
                     /\
                    /  \
     Ninja Evasivo /    \ Assassino Ágil
     (Difícil: 3) /      \
                 /        \
                /__________\
          [ HP ]            [ ATAQUE ]
       Tanque / Bruiser       Sniper / Canhão
         (Fácil: 1)
```

* **Modo Fácil (Ambiente Brando):** O AG favorece arquétipos de **Alto Dano e Vida**, pois a baixa frequência de tiros perdoa a lentidão.
* **Modo Difícil (Bullet Hell):** O AG é forçado a selecionar arquétipos de **Alta Velocidade e Esquiva**, sacrificando poder de ataque para conseguir desviar da chuva densa de projéteis.

---

## 🔗 Conexões
- [[Função de Fitness]]
- [[Parametrização Geral do GA]]
- [[Configuração de Dificuldade]]
- [[00 - MOC Principal]]
