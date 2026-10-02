# 📖 Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning — Parte 1 de 5

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Tencent AI Lab (2023)
> **Artigo Original:** `Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv.html`

---

Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement
Learning

###### Report GitHub Issue

× Title: Content selection saved. Describe the issue below: Description: Submit without
GitHub Submit in GitHub arXiv is now an independent nonprofit! Learn more × arXiv logo
Back to arXiv Why HTML? Report Issue Back to Abstract Download PDF 1. Abstract 1. I
Introduction 1. II Notation And Background 1. II-A Arena Breakout 1. II-B State Space and
Action Space 1. II-C Reinforcement Learning 1. III METHODS 1. III-A Framework 1. III-B
Navigation Mesh and Shooting-rule Enhanced Reinforcement Learning 1. III-C Reward Design
1. III-D Training Process 1. IV Experiment 1. IV-A Experimental Setup 1. IV-B Results 1. V
RELATED WORK 1. V-A Reinforcement Learning in FPS Games 1. VI Conclusion 1. References
License: CC BY-NC-ND 4.0 arXiv:2410.04936v1 [cs.AI] 07 Oct 2024

### Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning

PubID: pubid: 979-8-3503-5067-8/24/$31.00 ©2024 IEEE Chen Zhang 1,2, Huan Hu 2, Yuan Zhou
2, Qiyang Cao 2, Ruochen Liu 2, Wenya Wei 2, Elvis S. Liu 2,∗ † † thanks: *Corresponding
author Affiliation: 1 School of Software Engineering, University of Science and Technology
of China, Hefei, China Affiliation: 2 Tencent Games Affiliation:
zhangchenzc@mail.ustc.edu.cn, {luckyhu, ariellezhou, hughyycao, ruochenliu, wenyawei,
elvissyliu}@tencent.com

###### Abstract

In the realm of competitive gaming, 3D first-person shooter (FPS) games have gained
immense popularity, prompting the development of game AI systems to enhance gameplay.
However, deploying game AI in practical scenarios still poses challenges, particularly in
large-scale and complex FPS games. In this paper, we focus on the practical deployment of
game AI in the online multiplayer competitive 3D FPS game called Arena Breakout, developed
by Tencent Games. We propose a novel gaming AI system named Private Military Company Agent
(PMCA), which is interactable within a large game map and engages in combat with players
while utilizing tactical advantages provided by the surrounding terrain. To address the
challenges of navigation and combat in modern 3D FPS games, we introduce a method that
combines navigation mesh (Navmesh) and shooting-rule with deep reinforcement learning
(NSRL). The integration of Navmesh enhances the agent's global navigation capabilities
while shooting behavior is controlled using rule-based methods to ensure controllability.
NSRL employs a DRL model to predict when to enable the navigation mesh, resulting in a
diverse range of behaviors for the game AI. Customized rewards for human-like behaviors
are also employed to align PMCA's behavior with that of human players.

###### Index Terms:

game AI, deep reinforcement learning, navigation mesh, shooting rules, self-play,
rule-enhanced.

#### I Introduction

First-person shooter (FPS) games in 3D have gained immense popularity in the competitive
gaming realm. As these games have evolved from early titles like Maze War and Half-Life to
more recent ones such as Apex Legends, CS: GO, and Valorant, there has been a growing
interest in developing intelligent AI systems for FPS games. Traditional decision-making
approaches based on behavior trees (BT) have proven inadequate in exploring all possible
decisions within complex 3D environments. To address this limitation, deep reinforcement
learning (DRL) has been introduced as a flexible alternative for designing game AI in 3D
FPS games. However, despite significant advancements that have shown the power of DRL
agents [ 1, 2, 3, 4, 5] , the practical deployment of game AI in FPS games still faces
challenges. Existing environments used for training and testing AI agents often have small
game maps and limited game duration, which do not align with the scale and complexity of
modern FPS games. For example, in environments like VizDoom [ 1] , the duration of each
match is typically around 100 frames. Additionally, the complexity of 3D FPS game
environments, with physically modeled terrain and objects, poses difficulties for
environment perception and global navigation for AI agents. Furthermore, balancing global
navigation and combat engagement within the game AI presents significant demands,
requiring simultaneous macro-level navigation and micro-level combat decision-making.
There is also a need to ensure that the game AI exhibits both competitive strength and
human-like behavior. Fig. 1: The interface of Arena Breakout In this paper, we try to
solve these issues and focus on the practical deployment of game AI in an online
multiplayer 3D FPS game developed by Tencent Games called Arena Breakout. Players in Arena
Breakout control a first-person perspective game character and aim to reach a designated
location for evacuation within a limited timeframe. Throughout the game, players interact
with other players or game AI, either by evading or eliminating them, to achieve
evacuation. To enhance players' gaming experience, we propose a novel game AI system named
Private Military Company Agent (PMCA) which is interactiable in a large game map. PMCA is
primarily deployed in matches involving high-level players. When PMCA encounters players
at any location on the map, it will initiate attacks and engage in combat with the player,
utilizing the surrounding terrain to gain tactical advantages. In order to achieve the
objectives, PMCA must not only address the challenges of navigation and combat in modern
3D FPS games but also perform effectively in large-scale matches with an average duration
exceeding forty minutes. Furthermore, PMCA needs to constrain its behavior so that does
not confuse the players. To tackle these challenges, we propose a novel method that
combines Navigation Mesh (Navmesh) [ 6] and shooting rules with reinforcement learning
(NSRL). The integration of Navmesh enhances the agent's global navigation capabilities
while considering firefights and shooting behavior is executed using rule-based methods to
enhance controllability. Unlike previous approaches that directly incorporate rules into
the program, NSRL takes a more subtle approach by using a DRL model to predict whether to
enable the navigation mesh. The decision to switch to the navigation mesh is made only
when the DRL model determines it is appropriate, resulting in a more diverse range of
behaviors for the game AI. Additionally, customized rewards for human-like behaviors are
employed to ensure that PMCA's behavior aligns with human players, further enhancing its
human-like behavior. Overall, we construct the Markov decision process (MDP) of Arena
Breakout and employ the Proximal Policy Optimization (PPO) [ 7] algorithm to update the
policy. Experimental results show the ability of PMCA in global navigation and the
diversity of behavior. The contributions of this paper are as follows: * • We propose a
novel game AI system based on rule-enhanced reinforcement learning, integrating Navmesh
and shooting rules into deep reinforcement learning (DRL) to enhance the performance of
the DRL agent. This design allows the agent to balance global navigation across the entire
map while accurately aiming and firing at targets. * • We deploy the system in Arena
Breakout and engage in long-term interactions with players, representing a significant
milestone for the practical application of DRL. Fig. 2: Framework of PMCA.


---

📑 [[00 - Índice do Artigo|Índice]] | [[Parte 02 de 05|Próxima Parte]] ➡️
