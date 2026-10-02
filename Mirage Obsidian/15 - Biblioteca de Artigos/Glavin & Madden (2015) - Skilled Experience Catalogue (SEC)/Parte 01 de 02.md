# 📖 Skilled Experience Catalogue: A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning — Parte 1 de 2

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Frank G. Glavin, Michael G. Madden (2015)
> **Artigo Original:** `A Skill-Balancing Mechanism for Non-Player Characters using Reinforcement Learning - arXiv.html`

---

### Skilled Experience Catalogue: A Skill-Balancing Mechanism for Non-Player Characters using

### Reinforcement Learning

Frank G. Glavin School of Computer Science, National University of Ireland, Galway.
Email: frank.glavin@nuigalway.ie Michael G. Madden School of Computer Science, National
University of Ireland, Galway. Email: michael.madden@nuigalway.ie Abstract—In this paper,
we introduce a skill-balancing mechanism for adversarial non-player characters (NPCs),
called Skilled Experience Catalogue (SEC). The objective of this mechanism is to
approximately match the skill level of an NPC to an opponent in real-time. We test the
technique in the context of a First-Person Shooter (FPS) game. Specifically, the technique
adjusts a reinforcement learning NPC’s proficiency with a weapon based on its current
performance against an opponent. Firstly, a catalogue of experience, in the form of stored
learning policies, is built up by playing a series of training games. Once the NPC has
been sufficiently trained, the catalogue acts as a timeline of experience with incremental
knowledge milestones in the form of stored learning policies. If the NPC is performing
poorly, it can jump to a later stage in the learning timeline to be equipped with more
informed decision-making. Likewise, if it is performing significantly better than the
opponent, it will jump to an earlier stage. The NPC continues to learn in realtime using
reinforcement learning but its policy is adjusted, as required, by loading the most
suitable milestones for the current circumstances. I. INTRODUCTION This paper presents a
new mechanism for Dynamic Dif-ficulty Adjustment in the context of reinforcement learning
called Skilled Experience Catalogue (SEC). Specifically, we store the current policy of
the non-player character (NPC) at various intervals during an initial training phase. Once
the training phase is complete, the base policy of the NPC can be adjusted in real-time,
influenced by a threshold value, to approximately match the skill level of the current
opponent. To test our SEC mechanism, we apply it to the weapon proficiency of an NPC bot
in a First-Person Shooter (FPS) Deathmatch game. Specifically, the mechanism applies only
to the learned task of aiming/firing a weapon at an enemy. The NPC has fixed strategies
for the other in-game tasks such as item collection, opponent evasion and travelling
around the map. The NPC bot is initially trained against a single opponent and builds up a
catalogue of reinforcement learning policies as it gains experience from using the weapon
over time. These stored policies, that loosely represent skill level, can then be loaded
in subsequent games to balance the gameplay against the current opponent. We demonstrate
this SEC mechanism against five different levels of fixed-strategy opponents and show that
a single catalogue of experience can be used to closely match the performance of each. The
NPC that we have developed is an adversarial one [1] which contrasts with supportive
companion NPCs [2] found in some game genres. The approach that we present is novel in
that it is using a by-product of the bot’s learning process to create milestones which
represent the knowledge acquired at the different stages of learning. The policies of the
bot are stored, at different stages, to keep a sequential catalogue of experience. The bot
can then jump to the most appropriate policy to coincide with the skill level of the
current opponent while continuing to adapt based on its in-game experience. Our approach
does not require manually optimising parameters to represent different skill levels.
Conversely, we are sampling from the natural learning progress of the agent over time. II.
BACKGROUND INFORMATION A. Dynamic Difficulty Adjustment Traditionally, human computer game
players select a difficulty setting from a menu before beginning the game. This can be as
simple as selecting easy / medium / hard or can include more detailed options for the
player to choose from. These settings have a direct, and usually static, effect on the
skill level of the NPCs. Such fixed-difficulty settings can often be too broad. For
instance, a setting that is intended to be easy may nonetheless be too difficult for some
players. Players may also improve their performance at different rates. The traditional
approach does not make use of the player’s current performance measures to direct the
gameplay. While this approach has the benefit of simplicity, from a game development point
of view, it can lead to predictable gameplay when static rule-based opponents are deployed
which can adversely affect the entertainment value of the game. Dynamic Difficulty
Adjustment (DDA) [3], which can also be referred to as Dynamic Game Balancing (DGB) [4],
involves identifying the player’s performance and skill level, and then dynamically
adjusting the difficulty level accordingly. The goal of this is to ensure that the game
remains challenging and can cater for many different players of varying skill levels. B.
Reinforcement Learning Reinforcement learning (RL) is a branch of artificial intelligence
in which a learner, often called an agent, interacts with an environment to achieve an
explicit goal or goals [5]. The environment consists of a set of states, called the state
space, and the agent must choose an available action from the action space when in a given
state at each time step. The agent learns from its interactions with the environment,
receiving feedback for its actions in the form of numerical rewards, and aims to maximise
the reward values that it receives over time. Two common approaches to
storing/representing a policy in reinforcement learning are generalisation and tabular.
With generalisation, a function approximator is used to generalise a mapping of states to
actions. The tabular approach, which is used in our research, stores numerical
representations of all state-action pairs in a lookup table. The agent’s decisionmaking
involves choosing between exploring the effects of taking novel actions and exploiting the
knowledge that it has acquired from earlier exploration. Reinforcement learning is
inspired by the process by which humans interact with the world and learn from experience.
C. Game Environment and Development Tools For this research, we use the game Unreal
Tournament 2004 (UT2004) which is a commercial FPS game [6]. The agents are developed
using a toolkit called Pogamut 3 [7] which is an open-source development platform for
creating virtual agents in the 3D game environment of UT2004. The main objective of
Pogamut 3 is to simplify the coding of actions taken in the environment, such as path
finding, by providing a modular development platform. Making use of these primitives, the
focus of our development is on producing intelligent NPC behaviour. III. MOTIVATION When
computer-controlled opposition is too strong, human players can become frustrated with the
gameplay. Conversely, opponents that are too weak result in predictable games in which
human players do not feel challenged [8]. The challenge of a game is widely considered to
play a crucial role in the player’s overall enjoyment [9]. We believe that successful game
AI requires techniques to be developed in which the NPCs can learn good tactics
independently as well as being both unpredictable and adaptive to their surroundings.
Keeping a player’s win and loss rate close and unpredictable in a game can increase the
player’s overall suspense and the game’s outcome uncertainty. Abuhamdeh et al. [10]
carried out a study on the relevance of outcome uncertainty and suspense for intrinsic
motivation and concluded that games with higher outcome uncertainty were more enjoyable to
play. We observe that modern computer games can often lack flexibility with regards to
difficulty settings and this can lead to mismatches between the player’s ability and the
overall difficulty of the game. DDA can be used to ease the learning process for
beginners. Difficulty settings are balanced in real-time in contrast to traditional
approaches that involve extensive user testing and redesign in order to identify suitable
levels. This can be a costly and time-consuming process [11]. IV. RELATED RESEARCH Hunicke
and Chapman [3] presented an interactive DDA system called Hamlet which is an integrated
set of libraries within the Half-Life SDK. The Hamlet system has an evaluation function,
which maps the current state of the game world to an evaluation of the player’s
performance and an adjustment policy, for mapping the evaluation to adjustments in the
game world. Hamlet monitors incoming game data and estimates the player’s future state
from the data. If an undesirable state is predicted, the system will intervene and adjusts
the game settings as required. Hunicke [12] used Hamlet to examine the requirements for
incorporating effective dynamic difficulty adjustment into an FPS game. The aim of the
study was to identify if DDA could be performed effectively, without degrading the core
gameplay experience for the user. The authors reported that their preliminary results show
an improvement in player performance, while retaining the player’s sense of agency and
accomplishment. Spronck et al. [13] showed the extent to which their technique of dynamic
scripting [14] could be used to adapt game AI to balance the gameplay in a simulation

---

📑 [[00 - Índice do Artigo|Índice]] | [[Parte 02 de 02|Próxima Parte]] ➡️
