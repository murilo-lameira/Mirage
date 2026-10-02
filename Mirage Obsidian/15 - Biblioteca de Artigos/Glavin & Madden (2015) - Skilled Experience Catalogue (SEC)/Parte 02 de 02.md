# 📖 Skilled Experience Catalogue: A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning — Parte 2 de 2

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Frank G. Glavin, Michael G. Madden (2015)
> **Artigo Original:** `A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning - arXiv.html`

---

closely related to the Role-Playing Game (RPG) Baldur’s Gate. The authors focussed on
enhancing the difficulty-scaling properties of the dynamic scripting technique. These were
high-fitness penalising, weight clipping, and top culling. The reward peak value in
dynamic scripting determines how effective the opponent behaviour will be. With
high-fitness penalising, this value is adjusted after every fight depending on the
outcome. If the computer-controlled opponent wins, it is reduced; otherwise it is
increased. There is also a maximum and minimum value that this reward peak value can be.
The maximum weight value determines the maximum level of optimisation a learned tactic can
achieve. With weight clipping, this value is automatically changed to balance the overall
gameplay. Top culling is similar to weight clipping, however, rules with a weight greater
than the maximum weight value are allowed. Those that exceed the maximum weight value will
not be selected for a generated script which will force the computer-controlled opponent
to use weaker tactics. The authors reported that, of the three different
difficulty-scaling enhancements, the topculling enhancement was the best choice. It was
reported that it produced results with low variance, was easily implemented, and was the
only one of the three enhancements that managed to force a balanced game when inferior
tactics were used. Tan et al. [15] presented two adaptive algorithms, based on ideas from
reinforcement learning and evolutionary computation, to scale the difficulty of the game
AI to improve player satisfaction. They introduced two controllers, namely, the adaptive
uni-chromosome controller (AUC) and the adaptive duo-chromosome controller (ADC). The
authors examined the effects of varying the learning and mutation rates and proposed
general rules for setting these parameters. The authors carried


---

⬅️ [[Parte 01 de 02|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]]
