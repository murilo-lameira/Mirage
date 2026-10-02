# 📖 Reinforcement Learning Methods to Evaluate the Impact of AI Changes in Game Design — Parte 1 de 2

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Pablo Gutiérrez-Sánchez, Marco A. Gómez-Martín, Pedro A. González-Calero, Pedro P. Gómez-Martín (2020)
> **Artigo Original:** `Reinforcement Learning Methods to Evaluate the Impact of AI Changes in Game Design.html`

---

Reinforcement Learning Methods to Evaluate the Impact of AI Changes in Game Design Pablo
Gutiérrez-Sánchez,1 Marco A. Gómez-Martı́n,2 Pedro A. González-Calero,2 Pedro P.
Gómez-Martı́n2 1PadaOne Games, Calle Profesor Jose Garcia Santesmases, 9, 28040, Madrid,
Spain 2Complutense University of Madrid, Madrid, Spain, pablo.gutierrez@padaonegames.com,
marcoa@fdi.ucm.es, pagoncal@ucm.es, pedrop@fdi.ucm.es Abstract Game development has become
a long process that requires many professionals working on a project during several months
or years. With this scenario the re-utilization of resources is crucial not only to
alleviate the process but also to bring coherence into the final product. In this paper we
focus on the reuse of NPCs and the problems it brings about. In particular it is common to
have different breeds (or personalities) of NPCs that are placed on different levels on
the game. The problem arises when their behaviors are fine-tuned to accommodate a specific
level needs without taking into consideration that this change may alter their performance
on previous already-tested levels. The paper presents the application of reinforcement
learning together with behavior trees to automatically test if modifications to the AIs of
a stealth game have an impact on the user experience. Our experiments reveal that this
approach provides a way of diagnosing alterations in level gameplay that correspond to the
effects observed by human testers. Introduction Quality control in modern video games can
be a major challenge. Nowadays it is not only necessary to keep a strict and continuous
control of technical failures or bugs that may arise during the development process, but
also of new problems derived from unexpected changes in the playability of the different
parts of the game. These changes can bring about various adverse effects such as
preventing players from being able to complete previously solvable sections, altering the
navigability of menus and environments, or modifying the difficulty perceived by the user,
in dissonance with the experience originally conceived by the designers. Quality assurance
(QA) tasks usually involve an immense testing effort in which developers and players
strive to detect and solve these problems. In light of this situation, in the last few
years several research works have emerged with the aim of proposing strategies to improve
the QA process in video games and reduce its cost. Many of these methods are aimed
primarily at developing agents (usually by using deep reinforcement learning, DRL) that
act as synthetic players capable of automating checks that may otherwise require numerous
hours of manual testing, in an attempt to redirect the Copyright © 2021, Association for
the Advancement of Artificial Intelligence (www.aaai.org). All rights reserved. efforts of
human testers towards less mechanical and more creative tasks. In this paper we focus on
automatic regression tests for detecting issues when modifications are made to AIs that
are reused in multiple sections of the game. These changes may be done when fine-tuning
the behavior of a NPC in a level without thinking about the implications of those small
variations on other levels where the NPC was placed before. Changes as simple as slightly
modifying an enemy’s movement speed could end up unexpectedly impacting how the player
interacts with the game’s levels. These changes need not be particularly drastic (such as
as sudden violations of the completability of a level), and may boil down to the player
taking more or less time to complete a part of the game, or exploiting a new way to beat a
level that was not originally contemplated. All of these design alterations should not go
unnoticed, but many of them are not usually straightforward to detect in typical testing
environments. In this paper we propose the application of different reinforcement learning
methods to produce testing agents capable of interacting with a set of levels in a stealth
game while collecting interaction statistics representative of the perceived gameplay in
each level. The agents are afterwards used to test whether a change in the specification
of an enemy type common to all levels induces significant changes in gameplay parameters
collected by the agents before applying the modification. Related Work By testing we refer
to the activity undertaken to evaluate the quality of a product and improve it by
identifying its defects and problems (Abran 2004). Video games are complex software
systems that must function correctly on different platforms with a range of
configurations. The video game market is a very competitive one with buyers expecting
increasingly more from them, which makes it unacceptable to release applications that are
not robust or suffer from bugs. The robustness of a video game covers a wide spectrum of
criteria, from the correct functioning of technical aspects such as performance or
functional correctness to attributes such as the aesthetic soundness of the application.
The validation of these criteria is a costly task in which a substantial part of the
development effort of a project is invested, hence numerous strategies have been proposed
in recent years in (AIIDE 2021) 10 an attempt to automate these tasks or reduce their
associated workload. One of the simplest alternatives is the use of game segments recorded
manually by human testers, which are subsequently used to check that the replayed
sequences are still capable of completing the established objective (Os-trowski and Aroudj
2013). However, when the structure or the game environment is modified, the tests
generated by these methods are no longer valid, and it is necessary to once again resort
to human testers to re-record new sequences for the modified scenarios. This continuous
obsolescence naturally leads to the proposal of alternatives that are capable of adapting
dynamically to variations in the game environments, giving rise to the use of AI-based
agents for testing. In (Hernández Bécares, Costero Valero, and Gómez Martı́n 2017), an AI
played following the specification of a game given by a Petri net, making use of
high-level actions, but required precise modeling of the level logic as well as manual
implementation of the player’s actions, whereas the techniques described in this paper do
not require such an accurate understanding of the underlying game mechanics in order to be
applied to a set of levels (being RL-based, our approach merely relies on the design of
reward functions specifying how good an action in a given state). DRL and IL techniques
used in (Pfau, Smeddinck, and Malaka 2017; Ariyurek, Betin-Can, and Surer 2021; Bergdahl
et al. 2020) show promising results, but most of these efforts are generally focused on
detecting technical errors, or verifying whether an automated agent succeeds in completing
given testing objectives within certain acceptable margins (typically, the designer
establishes an interval in which a set of parameters should lie and makes use of
artificial players to play the game repeatedly while recording these parameters’ metrics
and checking that they are contained in those intervals), with few references to the
detection of subtle gameplay modifications that may undermine game design plans. Our
approach uses this methodology as a reference point, but expands it with the inclusion of
hybrid BT-RL game-playing agents and statistical tests to evaluate the significance of a
change in gameplay when altering a level, rather than just checking if the parameters are
still within acceptable ranges. Moreover, these methods are not always trivial to
implement, often requiring a potentially daunting process of trial and error in the choice
of training algorithm, reward allocation policy, model features, or the hyperparameters of
the underlying neural networks. Fortunately, over the last few years, libraries for
popular game engines have been appearing that greatly facilitate this process, with
ML-Agents (Ju-liani et al. 2020) in the Unity 3D engine (Unity Technolo-gies 2021a) being
possibly one of the most well-known and actively maintained. Additionally, there has been
work integrating reinforcement learning into hand-scripted control structures such as
Behavior Trees (BTs) with the goal of narrowing learning problems to more controlled
situations (Pereira and Engel 2015), thus reducing the time and effort needed to train
agents. Taking ideas from these works, our experiments aim to make use of these advantages
in the context of regression testing in game levels. In (Holmgard et al. 2019) the use of
procedural personas for level playtesting characterized by different util- ity functions
employing a variant of the Monte Carlo Tree Search (MCTS) is proposed. These enable the
modeling of decision-making processes of players with different goals, play styles and
personal preferences in simple scenarios such as the levels in the 2D dungeon crawler used
for evaluation. However, the specification of the utility functions to be used is left to
the designer, and the method’s suitability for more complex environments requires further
confirmation. The idea is nonetheless relevant in this context, since reward functions can
be roughly thought of as utility functions in RL, and these ideas combined with hybrid BTs
to derive complex gameplay styles for the agents. Lastly, there exist several works
focused on facilitating the task of designing and adjusting the parameters of video game
contents, both in the field of playtesting and in level balancing and design.
(Gonzalez-Duque et al. 2020) proposes a method to obtain levels adjusted to a target

---

📑 [[00 - Índice do Artigo|Índice]] | [[Parte 02 de 02|Próxima Parte]] ➡️
