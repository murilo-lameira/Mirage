# 📖 Towards Diverse Non-Player Character behaviour discovery in multi-agent environments — Parte 1 de 1

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Jan Kirk, Marco Scirea (2020)
> **Artigo Original:** `Towards_Diverse_Non-Player_Character.pdf.html`

---

### Towards Diverse Non-Player Character behaviour discovery in multi-agent environments

1st Jan Kirk The Mærsk Mc-Kinney Møller Institute University of Southern Denmark Odense,
Denmark jakir20@student.sdu.dk 2nd Marco Scirea SDU Metaverse Lab University of Southern
Denmark Odense, Denmark msc@mmmi.sdu.dk Abstract—This paper introduces a method for
developing diverse Non-Player Character (NPC) behaviour through a multiagent genetic
algorithm based on Map-Elites. We examine the outcomes of implementing our system in a
test environment, with a particular emphasis on the diversity of the evolved agents in the
feature space. This research is motivated by how diverse NPCs are an important factor for
improving player experience. We show how our multi agent map-elite algorithm is capable of
isolating the evolved NPCs in the chosen feature space. Results showed that variation in
agent fitness could be predicted with 40% from agent genomes, when agents played 100 games
each. I. INTRODUCTION The application of Artificial Intelligence (AI) in games is a vast
field, encompassing numerous aspects within a game such as generation of content for the
game world, like maps, objects, and music; these aspects could be unchanging, after
initial creation by AI techniques, or also subject to change over the course of the game,
by the use of AI. Content like the aforementioned are important aspects of a game; in
terms of creating rich and varied player experiences, they could be classified as
environmental aspects of a game. One of the classical applications of AI in games consists
in controlling Non-Player Characters (NPCs). This is usually achieved by creating some
structure for chaining scripted behaviours (like a Finite State Machine, as commonly used
in the games industry), or by applying some sort of machine learning approach. This paper
proposes a method to manufacture NPCs with diverse fixed behaviours, while maintaining
some reasonable level of performance in achieving the agent’s goals. The performance could
be defined as anything which is desired within the game, e.g., win, interact with human
players as much as possible, or make varied meaningful conversation. As a test
environment, we developed a simple game environment where performance is defined as
collecting gold, which is a win-condition. In the game, 200 agents will concurrently play
while being allowed to act both cooperatively and competitively. Each NPC is based on a
predefined Behaviour Tree (BT), which can be tweaked by MAP-Elites to express different
behaviours. The NPCs can gather food, weapons, gold, form groups, or fight against each
other. Since their behaviour is defined by a genome (a sequence of numbers), a specific
NPC could indeed just have its genome shifted to a slightly different one, in case
variance is desired. II. BACKGROUND / RELATED WORK A. Quality-diversity algorithms
Quality-diversity algorithms represent a specialized subset of evolutionary algorithms
that not only aim to find the best solution but also prioritize maintaining diversity
within the solutions discovered. By exploring a wide range of potential solutions and
identifying a diverse set of high-performing solutions, quality-diversity algorithms can
avoid premature convergence on a single optimal solution and enhance the robustness of the
solutions obtained [1]. Examples of qualitydiversity algorithms include the
Multi-dimensional Archive of Phenotypic Elites (MAP-Elites) and Novelty Search with Local
Competition [2]. These algorithms have demonstrated effectiveness in balancing exploration
and exploitation, leading to the discovery of a diverse set of high-quality solutions
across various domains, such as robotics, optimization, and machine learning [3]. Research
applying quality-diversity algorithms to games has shown significant promise in enhancing
the generation of game content. Quality-diversity algorithms, such as MAP-Elites, have
been utilized to evolve diverse and high-quality solutions for various aspects of game
design, including procedural content generation and level design [4]. By promoting
diversity in the solutions found, these algorithms have been instrumental in creating a
wide range of game content that covers different gameplay scenarios and challenges [5].
For instance, qualitydiversity algorithms have been applied to evolve diverse repertoires
of game elements, such as decks in card games like Hearthstone, providing insights into
game dynamics and aiding in rebalancing game elements [5]. These algorithms have also been
instrumental in evolving game levels and scenes through interactive and constrained
approaches, allowing for mixedinitiative design in creating levels typical of computer
roleplaying games [6]. By leveraging the principles of quality and diversity in
evolutionary computation, researchers have been able to address challenges in game content
generation, such as ensuring variety, balance, and player
engagement.979-8-3503-5067-8/24/$31.00 ©2024 IEEE

- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
-

---

📑 [[00 - Índice do Artigo|Índice]]
