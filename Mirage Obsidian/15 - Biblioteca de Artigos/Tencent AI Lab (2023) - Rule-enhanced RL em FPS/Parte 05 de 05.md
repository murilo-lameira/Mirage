# 📖 Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning — Parte 5 de 5

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Tencent AI Lab (2023)
> **Artigo Original:** `Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv.html`

---

enabling them to exhibit more diverse strategies and behaviors. NSRL improves training
efficiency while maintaining a certain level of competitiveness, making it a necessary
asset for deployment in high-level scenarios. Moreover, NSRL's shooting rule augmentation
enhances the human-like nature of DRL agents, ensuring that they do not exhibit confusing
behaviors that diminish the players' gaming experience. ((a)) Bullet Distribution of Human
Players ((b)) Bullet Distribution of NSRL agent ((c)) Bullet Distribution of RL agent Fig.
8: Bullet Distribution of Human Players, NSRL agent, and RL agent.

#### V RELATED WORK

##### V-A Reinforcement Learning in FPS Games

In the field of reinforcement learning, FPS is a highly valuable research environment. In
FPS games, it is necessary to balance both movement and firing actions under partial
observation and achieve the best performance in a competitive environment. Currently, many
FPS games are used for research on reinforcement learning algorithms. Two 1990s games were
introduced to the RL environment in the early stage. Kempka et al. \[14\] introduced
ViZDoom and Jaderberg et al. \[3\] built Quake III Arena as RL environment. There have
been many excellent works published based on these environments currently. The DRQN,
proposed by Hosu and Rebedea \[9\] , is one of the most influential works in ViZDoom. DRQN
is also modularized to allow different models to be independently trained for different
phases of the game which substantially outperforms built-in AI agents of the game as well
as average humans in deathmatch scenarios. Wu and Tian \[1\] using Actor-Critic curriculum
learning to train vision-based agents in VizDoom and win the champion of Track1 in ViZDoom
AI Competition 2016. Jaderberg et al. \[3\] demonstrate for the first time that an agent
can achieve human-level in a popular 3D multiplayer first-person video game, Quake III
Arena Capture the Flag (28), using only pixels and game points as input. The result is
achieved by a novel two-tier optimization process in which a population of independent RL
agents is trained concurrently from thousands of parallel matches with agents playing in
teams together and against each other on randomly generated environments. Besides ViZDoom
and Quake III Arena, Pearce and Zhu \[4\] learn an agent to play deathmatch in CS: GO with
adopting behavioral cloning. Their method shows reasonably good performance and high data
efficiency, a new way to apply RL in FPS games. Chen et al. \[5\] develop WILD-SCAV, a
powerful and extensible environment based on a 3D open-world FPS game which is an
environment with greater diversity and complexity. They want to bridge the gap that the
existing environment is hardly extensible to more complicated problems. zhao at al propose
a rule-enhanced deep reinforcement learning algorithm for three tasks. And their agent has
better performance over multiple rule-based and RL-based agents.

#### VI Conclusion

In this paper, we propose a full-map interactive agent, PMCA, for Arena Breakout that
addresses the challenges of global navigation and realistic ballistic behavior inherent in
applying DRL to modern FPS games. To address these challenges, we propose a novel method
that combines Navmesh and NSRL. The shooting-rule constraint is used to address the
human-like behavior problem, while the Navmesh enhances global movement capabilities.
Through experiments, we demonstrate the superiority of NSRL. This agent has been deployed
to Arena Breakout since early 2024, marking an important milestone in the practical
application of reinforcement learning in gaming. In our future work, we will further
investigate the agent's ability to explore large-scale 3D environments by adopting
occupancy maps and different computer vision techniques.

#### References

*  [1] Yuxin Wu and Yuandong Tian. Training agent for first-person shooter game with actor-critic curriculum learning. In  *International Conference on Learning Representations* , 2016.
*  [2] Guillaume Lample and Devendra Singh Chaplot. Playing fps games with deep reinforcement learning. In  *Proceedings of the AAAI Conference on Artificial Intelligence* , volume 31, 2017.
*  [3] Max Jaderberg, Wojciech M Czarnecki, Iain Dunning, Luke Marris, Guy Lever, Antonio Garcia Castaneda, Charles Beattie, Neil C Rabinowitz, Ari S Morcos, Avraham Ruderman, et al. Human-level performance in 3d multiplayer games with population-based reinforcement learning.  *Science* , 364(6443):859–865, 2019.
*  [4] Tim Pearce and Jun Zhu. Counter-strike deathmatch with large-scale behavioural cloning. In  *2022 IEEE Conference on Games (CoG)* , pages 104–111. IEEE, 2022.
*  [5] Xi Chen, Tianyu Shi, Qingpeng Zhao, Yuchen Sun, Yunfei Gao, and Xiangjun Wang. Wild-scav: Benchmarking fps gaming ai on unity3d-based environments.  *arXiv preprint arXiv:2210.09026* , 2022.
*  [6] Greg Snook. Simplified 3d movement and pathfinding using navigation meshes. In Mark DeLoura, editor,  *Game Programming Gems* , pages 288–304. Charles River Media, 2000.
*  [7] John Schulman, Filip Wolski, Prafulla Dhariwal, Alec Radford, and Oleg Klimov. Proximal policy optimization algorithms.  *arXiv preprint arXiv:1707.06347* , 2017.
*  [8] Bowen Baker, Ingmar Kanitscheider, Todor Markov, Yi Wu, Glenn Powell, Bob McGrew, and Igor Mordatch. Emergent tool use from multi-agent autocurricula.  *arXiv preprint arXiv:1909.07528* , 2019.
*  [9] Ionel-Alexandru Hosu and Traian Rebedea. Playing atari games with deep reinforcement learning and human checkpoint replay.  *arXiv preprint arXiv:1607.05077* , 2016.
*  [10] David Silver, Guy Lever, Nicolas Heess, Thomas Degris, Daan Wierstra, and Martin Riedmiller. Deterministic policy gradient algorithms. In  *International conference on machine learning* , pages 387–395. Pmlr, 2014.
*  [11] Oriol Vinyals, Igor Babuschkin, Wojciech M Czarnecki, Michaël Mathieu, Andrew Dudzik, Junyoung Chung, David H Choi, Richard Powell, Timo Ewalds, Petko Georgiev, et al. Grandmaster level in starcraft ii using multi-agent reinforcement learning.  *Nature* , 575(7782):350–354, 2019.
*  [12] Lasse Espeholt, Hubert Soyer, Remi Munos, Karen Simonyan, Vlad Mnih, Tom Ward, Yotam Doron, Vlad Firoiu, Tim Harley, Iain Dunning, et al. Impala: Scalable distributed deep-rl with importance weighted actor-learner architectures. In  *International conference on machine learning* , pages 1407–1416. PMLR, 2018.
*  [13] John Schulman, Philipp Moritz, Sergey Levine, Michael Jordan, and Pieter Abbeel. High-dimensional continuous control using generalized advantage estimation.  *arXiv preprint arXiv:1506.02438* , 2015.
*  [14] Michał Kempka, Marek Wydmuch, Grzegorz Runc, Jakub Toczek, and Wojciech Jaśkowski. Vizdoom: A doom-based ai research platform for visual reinforcement learning. In  *2016 IEEE conference on computational intelligence and games (CIG)* , pages 1–8. IEEE, 2016.
Experimental support, please view the build logs for errors. Generated by L A T E
xml\[LOGO\] .

#### Instructions for reporting errors

We are continuing to improve HTML versions of papers, and your feedback helps enhance
accessibility and mobile support. To report errors in the HTML that will help us improve
conversion and rendering, choose any of the methods listed below: * Click the "Report
Issue" ( ) button, located in the page header. Tip: You can select the relevant text
first, to include it in your report. Our team has already identified the following issues.
We appreciate your time reviewing and reporting rendering errors we may not have found
yet. Your efforts will help us improve the HTML versions for all readers, because
disability should not be a barrier to accessing research. Thank you for your continued
support in championing open access for all. Have a free development cycle? Help support
accessibility at arXiv! Our collaborators at LaTeXML maintain a list of packages that need
conversion, and welcome developer contributions. We gratefully acknowledge support from
our major funders , member institutions, , and all contributors. About · Help · Contact ·
Subscribe · Copyright · Privacy · Accessibility · Operational Status (opens in new tab)
Major funding support from


---

⬅️ [[Parte 04 de 05|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]]
