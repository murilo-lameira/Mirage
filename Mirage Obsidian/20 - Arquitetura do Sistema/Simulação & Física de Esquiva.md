# 🎮 Simulação & Física de Esquiva (Arena 2D)

O comportamento evasivo do NPC é implementado através de um simulador dinâmico de passos discretos de tempo ($\Delta t = 0.05\text{s}$) com integração cinemática vetorial.

---

## 🧭 Cinemática e Steering Behaviors (Craig Reynolds)

Em vez de tomar decisões baseadas em regras de estados estáticas, o NPC calcula forças de aceleração contínuas no espaço bidimensional da arena ($[-20, 20] \times [-20, 20]$ metros):

$$\vec{F}_{\text{total}} = \sum_{j \in \text{projéteis ativos}} \vec{F}_{\text{evade}}^{(j)}$$

### 1. Cálculo de Ponto de Maior Aproximação (CPA)
Para cada projétil com posição $\vec{p}_p$ e velocidade $\vec{v}_p$, em relação ao NPC ($\vec{p}_{\text{npc}}, \vec{v}_{\text{npc}}$):
* Posição relativa: $\vec{p}_r = \vec{p}_p - \vec{p}_{\text{npc}}$
* Velocidade relativa: $\vec{v}_r = \vec{v}_p - \vec{v}_{\text{npc}}$
* Tempo estimado até a aproximação mínima:
  $$t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{|\vec{v}_r|^2}$$

### 2. Condição de Ativação da Esquiva
A força de esquiva só é gerada se o tiro estiver em rota de aproximação no curto prazo ($0 < t_{\text{cpa}} < 1.5\text{s}$) e a distância projetada $\text{dist}_{\text{cpa}} < 2.5\text{m}$:

$$\vec{d}_{\text{evade}} = \vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})$$
$$\vec{v}_{\text{desejada}} = \frac{\vec{d}_{\text{evade}}}{|\vec{d}_{\text{evade}}|} \cdot v_{\text{max}}$$
$$\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$$

---

## 🎯 Configuração da Arena por Nível de Dificuldade

A hostilidade física do ambiente varia em função da dificuldade selecionada:

| Dificuldade | Cadência de Tiros ($\text{Intervalo}$) | Velocidade dos Tiros ($v_p$) | Dispersão / Ruído da Mira |
| :--- | :---: | :---: | :---: |
| **Fácil (1)** | $1.4\text{s} \to 0.7\text{s}$ (Esparsos) | $9.0\text{ m/s}$ (Lentos) | $\pm 0.25$ (Imprecisos) |
| **Médio (2)** | $0.75\text{s} \to 0.22\text{s}$ (Moderados) | $11.5\text{ m/s}$ (Balanceados) | $\pm 0.15$ (Precisos) |
| **Difícil (3)** | $0.30\text{s} \to 0.10\text{s}$ (*Bullet Hell*) | $13.5\text{ m/s}$ (Rápidos) | $\pm 0.08$ (Cirúrgicos) |

---

## 📡 Zonas de Detecção (Hitbox vs Radar)

```
        _________________________________
       |                                 |
       |     Radar Periférico (r = 4.0m) |
       |           . - ~ ~ - .           |
       |       .               .         |
       |     .    Hitbox        .        |
       |    .    (r = 1.0m)      .       |
       |    .     ( [NPC] )      .  <--- Tiro entra no Radar: Inicia Esquiva
       |     .                  .        Tiro sai sem colidir: +1 Dodge
       |       .               .         Tiro toca Hitbox: +1 Collision
       |           ' - ~ ~ - '           |
       |_________________________________|
```

1. **Hitbox ($r = 1.0\text{m}$):** Se a distância centro-a-centro for menor que $1.3\text{m}$, o projétil colide, causa $25\text{ pts}$ de dano e é destruído.
2. **Radar Periférico ($r = 4.0\text{m}$):** Quando um projétil penetra o radar e sai dele sem tocar a hitbox, o NPC contabiliza um **Desvio Bem Sucedido ($N_{\text{dodge}} + 1$)**.

---

## 🔗 Conexões
- [[Ref - Lee (KIOTS)]]
- [[Função de Fitness]]
- [[Cromossomo & Genes]]
- [[00 - MOC Principal]]
