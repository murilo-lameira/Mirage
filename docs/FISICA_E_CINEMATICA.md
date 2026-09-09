# 🧭 Física, Cinemática e Dinâmica de Esquiva (Arena 2D)

<p align="center">
  <b>📑 Navegação:</b>
  <a href="../README.md">⬅️ Voltar ao README</a> •
  <a href="#-fundamentos-cinemáticos">Fundamentos</a> •
  <a href="#-steering-behaviors-de-craig-reynolds">Steering Behaviors</a> •
  <a href="#-cálculo-de-maior-aproximação-cpa">Cálculo CPA</a> •
  <a href="#-hitbox-vs-radar-periférico">Hitbox & Radar</a> •
  <a href="#-pilares-de-cobertura-física">Pilares de Cobertura</a> •
  <a href="#-padrões-compostos-bullet-hell">Padrões de Tiros</a>
</p>

---

## 🔬 Fundamentos Cinemáticos

O **Mirage** opera sobre um modelo de simulação cinemática em tempo contínuo discretizado com passo temporal fixo:

$$
\Delta t = 0.05\text{ s} \quad (20 \text{ Hz / } 50 \text{ FPS})
$$

A arena de combate é um plano cartesiano contínuo bidimensional:

$$
\Omega = [-20, 20] \times [-20, 20] \text{ metros}
$$

A cada frame $k$, as equações diferenciais de movimento são resolvidas por integração semi-implícita de Euler:

$$
\vec{v}_{\text{npc}}(k+1) = \text{truncate}\left(\vec{v}_{\text{npc}}(k) + \frac{\vec{F}_{\text{total}}(k)}{m} \cdot \Delta t, \; v_{\text{max}}\right)
$$

$$
\vec{p}_{\text{npc}}(k+1) = \vec{p}_{\text{npc}}(k) + \vec{v}_{\text{npc}}(k+1) \cdot \Delta t
$$

Onde:
* $\vec{p} = (x, y)^T$ é o vetor posição no espaço euclidiano $\mathbb{R}^2$.
* $\vec{v} = (v_x, v_y)^T$ é o vetor velocidade.
* $v_{\text{max}}$ é a velocidade máxima do NPC (ditada pelo gene $G_1$ do cromossomo).
* $m = 1.0 \text{ kg}$ é a massa unitária do agente.

---

## 🧭 Steering Behaviors de Craig Reynolds

Diferente de sistemas rudimentares baseados em Máquinas de Estados Finitas (FSM) discretas, o NPC do Mirage emprega a teoria de **Comportamentos de Direcionamento (*Steering Behaviors*)** introduzida por Craig W. Reynolds (1999).

O agente calcula forças vetoriais contínuas de aceleração para cada projétil perigoso ativo no campo:

$$
\vec{F}_{\text{total}} = \sum_{j \in \mathcal{P}_{\text{ameaça}}} \vec{F}_{\text{evade}}^{(j)} + \vec{F}_{\text{fronteira}} + \vec{F}_{\text{obstáculos}}
$$

```text
               Projétil j (Vp)
                 \
                  \  (Trajetória balística)
                   \
                    v
                     x  Ponto de Maior Aproximação (CPA)
                     |
                     |  d_evade (Vetor de repulsão)
                     v
                 [ NPC ] ------> F_evade (Vetor de Força Verde)
```

---

## ⏱️ Cálculo de Maior Aproximação (Closest Point of Approach - CPA)

Para evitar reações falsas a tiros que passarão longe ou que já se distanciam do NPC, o sistema aplica a formulação vetorial preditiva de CPA (Lee, 2014):

Para o projétil $j$ com posição $\vec{p}_p$ e velocidade $\vec{v}_p$, definem-se:
* **Posição Relativa:** $\vec{p}_r = \vec{p}_p - \vec{p}_{\text{npc}}$
* **Velocidade Relativa:** $\vec{v}_r = \vec{v}_p - \vec{v}_{\text{npc}}$

O tempo futuro estimado até a distância mínima de separação é dado pela derivada do produto escalar:

$$
t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}
$$

### Condição de Ativação do Gatilho Evasivo:
A força de esquiva $\vec{F}_{\text{evade}}^{(j)}$ só é ativada se forem satisfeitas simultaneamente três restrições físicas:
1. **Convergência temporal:** $0 < t_{\text{cpa}} < t_{\text{alerta}}$ (onde $t_{\text{alerta}} \approx 1.5\text{ s}$).
2. **Distância projetada crítica:** $\|\vec{p}_r + \vec{v}_r \cdot t_{\text{cpa}}\| < R_{\text{radar}}$ (onde $R_{\text{radar}} = 4.0\text{ m}$).
3. **Sentido do movimento:** $\vec{p}_r \cdot \vec{v}_r < 0$ (o projétil está de fato se aproximando, e não se afastando).

Quando acionado:
$$
\vec{d}_{\text{evade}} = \vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})
$$

$$
\vec{v}_{\text{desejada}} = \frac{\vec{d}_{\text{evade}}}{\|\vec{d}_{\text{evade}}\|} \cdot v_{\text{max}}
$$

$$
\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}
$$

---

## 📡 Hitbox vs. Radar Periférico

A integridade do NPC é monitorada por duas zonas geométricas concêntricas:

```text
        _________________________________________________
       |                                                 |
       |           Radar Periférico (R = 4.0 m)          |
       |                   . - ~ ~ - .                   |
       |               .               .                 |
       |             .     Hitbox        .               |
       |            .    (r = 1.0 m)      .              |
       |            .     ( [NPC] )       .  <--- Entrada de Tiro: Aciona Esquiva
       |            .                     .       Saída ilesa: +1 Desvio (Dodge)
       |             .                   .        Toque na Hitbox: +1 Colisão
       |               .               .          (Dano: 25 HP)
       |                   ' - ~ ~ - '                   |
       |_________________________________________________|
```

* **Hitbox ($r_{\text{hit}} = 1.0\text{ m}$):** Se a distância centro-a-centro entre projétil e NPC for menor ou igual a $1.3\text{ m}$ (soma dos raios físicos de colisão), ocorre impacto:
  * Redução imediata de $-25\text{ HP}$ na barra de vida.
  * O projétil é destruído.
  * Incremento no contador de penalidade de colisões ($N_{\text{col}}$).
* **Radar Periférico ($R_{\text{radar}} = 4.0\text{ m}$):** Monitora a aproximação de perigo iminente. Se o projétil cruzar a área do radar e passar tangencialmente sem colidir com a hitbox, o simulador registra um **Desvio Evasivo Válido ($N_{\text{dodge}}$)** para cômputo da função de fitness.

---

## 🏛️ Pilares de Cobertura Física (*Cover Pillars*)

A arena apresenta **4 pilares cilíndricos rígidos** ($R_{\text{pillar}} = 1.3\text{ m}$) posicionados simetricamente em $(\pm 8, \pm 8)$:

1. **Absorção Balística:** Projéteis que atingem a área dos pilares são absorvidos e destruídos, limpando o campo e criando "zonas seguras" para o agente.
2. **Restrição Mecânica e Deslizamento Tangencial (*Occlusion Steering*):**
   O NPC não pode atravessar os pilares. Se colidir, sofre reflexão elástica e atrito tangencial:

$$
\vec{p}_{\text{npc}} \leftarrow \vec{p}_{\text{pilar}} + R_{\text{seguro}} \cdot \frac{\vec{p}_{\text{npc}} - \vec{p}_{\text{pilar}}}{\|\vec{p}_{\text{npc}} - \vec{p}_{\text{pilar}}\|}
$$

---

## 🌪️ Padrões Compostos de Bullet Hell

O ambiente simula ameaças balísticas com três assinaturas principais:

| Modo de Disparo | Cinemática | Taxa / Frequência | Modos Ativos |
| :--- | :--- | :---: | :---: |
| **Disparo Direcionado Simples** | Vetor linear direto em direção à posição instantânea do NPC com ruído angular Gaussiano $\mathcal{N}(0, \sigma^2)$ | A cada $0.10\text{s} \sim 1.4\text{s}$ | Fácil, Médio, Difícil |
| **Cone em Leque (*Shotgun Spread*)** | Salva simultânea de 3 projéteis com abertura angular de $\theta \in \{-15^\circ, 0^\circ, +15^\circ\}$ | A cada $2.8\text{ s}$ | Médio, Difícil |
| **Vórtice Espiral (*Danmaku Vortex*)** | Emissão circular contínua a partir da origem com velocidade angular constante $\omega = 4.5\text{ rad/s}$ | Contínuo | Difícil |

---

## 📊 Matriz de Hostilidade Física

| Nível de Dificuldade | Velocidade dos Tiros ($v_p$) | Intervalo entre Disparos | Dispersão da Mira ($\sigma$) | Padrões Balísticos |
| :--- | :---: | :---: | :---: | :--- |
| **Fácil (1)** | $9.0\text{ m/s}$ | $1.4\text{ s} \to 0.7\text{ s}$ | $\pm 0.25\text{ rad}$ (Baixa precisão) | Tiros lineares esparsos |
| **Médio (2)** | $11.5\text{ m/s}$ | $0.75\text{ s} \to 0.22\text{ s}$ | $\pm 0.15\text{ rad}$ (Média precisão) | Tiros lineares + Cones em leque |
| **Difícil (3)** | $13.5\text{ m/s}$ | $0.30\text{ s} \to 0.10\text{ s}$ | $\pm 0.08\text{ rad}$ (Cirúrgico) | Tiros rápidos + Cones + Espiral contínua |
