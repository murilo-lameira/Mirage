# 📖 Diversity-based Deep Reinforcement Learning Towards Multidimensional Difficulty for Fighting Game AI — Parte 1 de 1

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Emily Halina, Matthew Guzdial (2022)
> **Artigo Original:** `arXiv_2211.02759v1 [cs.LG] 4 Nov 2022.html`

---

Diversity-based Deep Reinforcement Learning Towards Multidimensional Difficulty for
Fighting Game AI Emily Halina, Matthew Guzdial Department of Computing Science, Alberta
Machine Intelligence Institute (Amii) University of Alberta, Edmonton, Alberta, Canada
{ehalina, guzdial}@ualberta.ca Abstract In fighting games, individual players of the same
skill level often exhibit distinct strategies from one another through their gameplay.
Despite this, the majority of AI agents for fighting games have only a single strategy for
each “level” of difficulty. To make AI opponents more human-like, we’d ideally like to see
multiple different strategies at each level of difficulty, a concept we refer to as
“multidimensional” difficulty. In this paper, we introduce a diversity-based deep
reinforcement learning approach for generating a set of agents of similar difficulty that
utilize diverse strategies. We find this approach outperforms a baseline trained with
specialized, human-authored reward functions in both diversity and performance.
Introduction Fighting games have long featured AI agents that act as opponents for human
players to play against. The majority of these AI agents are created using a notion of
“linear” difficulty, meaning the only distinction between agents is a difficulty rating in
a fixed range from easy to hard. Despite its prevalence, this model of linear difficulty
is not well aligned with the average player’s experience playing against other humans. The
high amount of player expression within fighting games allows for human players of similar
skill levels to use the same mechanics in disparate ways to uniquely challenge their
opponents (Dhami 2021). For example, one player may use a character’s tools to keep their
distance and chip away at an opponent, while another may use the same tools to
aggressively approach the opponent in close quarters. This disconnect can make players
feel inadequately prepared for playing against other humans, and could cause some to drop
a game entirely. This problem could be mitigated through the use of a “multidimensional”
difficulty system in which agents are distinguished by both linear difficulty and
additional qualities such as playstyle. To the best of our knowledge, this is the first
academic work to identify this research problem. By incorporating a notion of
multidimensional difficulty, fighting games could provide players the experience of
playing against multiple diverse strategies. This could allow players Copyright © 2022,
Association for the Advancement of Artificial Intelligence (www.aaai.org). All rights
reserved. to better prepare for playing against other human players and push them to more
fully explore the mechanics of the game. A major challenge in attaining multidimensional
difficulty is the overall design burden of creating fighting game AI agents. Fighting
games agents often require significant hand-authoring to be effective, using rules-based
systems or Finite State Machines (FSMs) to accommodate complex game mechanics and
character interactions (Majchrzak, Quadflieg, and Rudolph 2015). Due to this difficulty,
some games resort to “cheating” by reading the player’s inputs to artificially increase
the difficulty of an AI agent, further breaking parity between human and AI opponents.
There has been prior work in alleviating this designer burden through the use of
Reinforcement Learning (RL) techniques to autonomously train AI agents to play fighting
games (Kim, Park, and Yang 2020; Oh et al. 2021). However, the majority of this work has
been focused solely on playing the game, which is a testament to the difficulty of
developing such agents. As such, the problem of automatically developing agents that
exhibit diverse strategies for fighting games has been relatively unexplored. In this
paper we focus on the task of training a group of agents of similar difficulty that
utilize diverse strategies from one another. Ideally, these agents would provide a more
complete, robust gameplay experience for players while providing a suitable challenge.
Towards this goal, we propose Brisket, a diversity-based deep RL approach for learning a
set of equally skilled, diverse strategies inspired by (Eysenbach et al. 2018)’s
Di-versity is All You Need (DIAYN). We implemented Brisket in FightingICE, a fighting game
research platform built for the testing and evaluation of AI agents (Lu et al. 2013). We
evaluated the policies learned by Brisket against a set of “human-authored” baseline
agents trained with specialized, human-authored reward functions, and found that they
outperformed these baseline agents in both effectiveness and diversity. Therefore, we
claim that a diversity-based RL approach can be an effective way to produce enemy AI
agents for fighting games with multidimensional difficulty.


---

📑 [[00 - Índice do Artigo|Índice]]
