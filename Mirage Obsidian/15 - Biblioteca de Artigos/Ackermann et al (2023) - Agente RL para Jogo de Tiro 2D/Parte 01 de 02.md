# 📖 Reinforcement Learning Agent for a 2D Shooter Game — Parte 1 de 2

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Thomas Ackermann, Moritz Spang, Hamza A. A. Gardi (2023)
> **Artigo Original:** `Reinforcement Learning Agent for a 2D Shooter Game - arXiv.html`

---

### Reinforcement Learning Agent for a 2D Shooter Game

Thomas Ackermann1 , Moritz Spang2 , Hamza A. A. Gardi2,3 {1 Faculty for Mathematics, 2
Department of Electrical Engineering and Information Technology, 3 IIIT at ETIT},
Karlsruhe Institute of Technology, 76131 Karlsruhe, Germany Abstract—Reinforcement
learning agents in complex game environments often suffer from sparse rewards, training
instability, and poor sample efficiency. This paper presents a hybrid training approach
that combines offline imitation learning with online reinforcement learning for a 2D
shooter game agent. We implement a multi-head neural network with separate outputs for
behavioral cloning and Q-learning, unified by shared feature extraction layers with
attention mechanisms. Initial experiments using pure deep Q-Networks exhibited significant
instability, with agents frequently reverting to poor policies despite occasional good
performance. To address this, we developed a hybrid methodology that begins with
behavioral cloning on demonstration data from rule-based agents, then transitions to
reinforcement learning. Our hybrid approach achieves consistently above 70% win rate
against rule-based opponents, substantially outperforming pure reinforcement learning
methods which showed high variance and frequent performance degradation. The multi-head
architecture enables effective knowledge transfer between learning modes while maintaining
training stability. Results demonstrate that combining demonstration-based initialization
with reinforcement learning optimization provides a robust solution for developing game AI
agents in complex multi-agent environments where pure exploration proves insufficient.
Index Terms—reinforcement learning, game agent, video games, shooter game. I. INTRODUCTION
Reinforcement Learning (RL) has emerged as a foundational paradigm in artificial
intelligence for training agents to make sequential decisions through interaction with
dynamic environments. By optimizing behavior through reward feedback rather than explicit
supervision, RL enables the development of systems capable of autonomously learning
complex tasks, a characteristic crucial for applications in robotics, autonomous systems,
personalized healthcare, finance, and more [1], [2]. One of the most significant
advantages of RL is its general applicability to real-world problems where the optimal
policy is not easily prescribed. For example, in robotics, RL facilitates the learning of
control policies for tasks such as manipulation and locomotion in unstructured
environments [3]. In healthcare, RL algorithms have shown promise in optimizing treatment
strategies for chronic diseases by adapting to individual patient responses over time [4].
Despite these promising directions, the deployment of RL in the real world is often
hindered by challenges such as sample inefficiency, lack of interpretability, and the high
cost of failure during training. As a result, video games have become an essential tool
for advancing RL research. Games offer rich, interactive environments that are safe,
scalable, and well-suited for benchmarking algorithmic progress [5], [6]. Notable
breakthroughs have demonstrated the potential of RL in complex game environments.
DeepMind’s AlphaGo achieved superhuman performance in the ancient board game Go, combining
deep neural networks with Monte Carlo Tree Search (MCTS) and RL to defeat world champions
[7]. Building on this, AlphaZero further demonstrated that RL alone can be used to master
multiple board games without human data [8]. These accomplishments highlight the value of
games as controlled experimental platforms where RL agents can learn to operate in
high-dimensional, partially observable, and stochastic environments. Insights gained from
these domains are now being transferred to robotics, autonomous driving, and other
high-stakes fields, where generalization, robustness, and real-time adaptability are
essential. In this paper, we explore strategies for implementing an agent through RL for a
2D shooter game developed in Python. With the help of state of the art strategies, we aim
to find the optimal strategy, so that the win rate of the agent in the game is maximized.
A game is won, when the agent, who serves as a player, is able to defeat the enemy on the
map by shooting him a total of 3 times while simultaneously being shot less than 3 times.
The player and the enemy entity have the same set of actions available to them. After
training is completed, the RL agent shall serve as an enemy in the shooter game. Thus,
playing the game on your own against an advanced enemy artificial intelligence becomes fun
and challenging. To find the optimal strategy for implementing the RL agent, our approach
is as follows:

- Analyze state of the art strategies for implementing RL agent in shooter games in the current literature
- Selecting the best suited and efficient strategies for implementation for teaching the RL agent how to play the game
- Implementing those strategies in the context of the shooter game
- Evaluate the outcome of the strategies regarding maximizing the win percentage
- From the evaluation, choose a suitable strategy for the RL agent in the 2D shooter game
This approach also reflects the structure of this paper. In the end, we will provide a conclusion of our approach and our findings and give an outlook, on what can be improved or rather adapted for future works.
II. FUNDAMENTALS
A. Reinforcement Learning
Reinforcement Learning (RL) is a computational framework in which an agent learns to make decisions by interacting with an environment to maximize cumulative rewards. This process is formalized as a Markov Decision Process (MDP) defined by the tuple (S,A, P,R, γ), where:
- S is the set of states,
- A is the set of actions,
- P (s′|s, a) is the transition probability from state s to s′
under action a,
- R(s, a) is the reward function,
- γ ∈ [0, 1) is the discount factor. The agent’s objective is to find a policy π(a|s) that maxi-
mizes the expected return, defined as:
Gt =
∞∑ k=0
γkRt+k+1 (1)
The value function V π(s) estimates the expected return starting from state s and following policy π:
V π(s) = Eπ
[ ∞∑ k=0
γkRt+k+1 |St = s
] (2)
Similarly, the action-value function Qπ(s, a) estimates the expected return from state s taking action a:
Qπ(s, a) = Eπ
[ ∞∑ k=0
γkRt+k+1 |St = s,At = a
] (3)
In order to calculate the expected future value from subsequent states, the following equation recursively defines the expected value of being in a state s, following a specific policy π.
V π(s) = ∑ a
π(a|s)
[ R(s, a) + γ
∑ s′
P (s′|s, a)V π(s′)
] (4)
The optimal value function V ∗(s) is defined as:
V ∗(s) = max π
V π(s) (5)
and thus
V ∗(s) = max a
[ R(s, a) + γ
∑ s′
P (s′|s, a)V ∗(s′)
] (6)
To estimate these value functions, various algorithms are employed. One example is Temporal Difference (TD) learning, where the estimate is updated incrementally:
V (St)← V (St) + α [Rt+1 + γV (St+1)− V (St)] (7)
where α is the learning rate. Policy gradient methods can then optimize the policy directly by adjusting parameters θ of πθ(a|s) to maximize expected returns.
B. Behavioral Cloning
Behavioral Cloning (BC) is a foundational approach within imitation learning, where an agent learns a policy by mimicking expert behavior through supervised learning. Rather than exploring the environment and receiving feedback via reward signals, as in traditional reinforcement learning (RL), BC directly maps observed states to expert actions using a dataset of demonstrations D = {(si, ai)}Ni=1 collected from an expert policy πE .
The learning objective in BC is to find a policy πθ parameterized by θ that minimizes a supervised loss function over the dataset:
L(θ) = 1
N
N∑ i=1
ℓ (πθ(si), ai) (8)
where ℓ is typically the cross-entropy loss for discrete actions or mean squared error for continuous control.
Although BC is simple and efficient to implement, especially in high-dimensional domains such as vision-based control [9], it suffers from the issue of covariate shift. Because the learned policy may encounter states that differ from those in the expert dataset, small prediction errors can compound over time, leading the agent to regions that are unseen or poorly represented in the state space [10]. This phenomenon can severely degrade performance.
To address this, methods like Dataset Aggregation (DAgger) have been proposed, which iteratively augment the dataset with new trajectories generated by the learned policy and relabeled by the expert [11].
Despite its limitations, BC remains a strong baseline and is particularly useful in domains where safe exploration is critical or when expert demonstrations are abundant.
C. Agentarena
Agentarena is a 2D shooter game developed by Thomas Ackermann. The objective of the game player is to defeat the enemy in the agent arena by shooting at them. The arena is 900 by 1200 pixels large and can be seen in the following figure.
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
#####

#####

#####

#####

#####

#####

#####

#####

#####

#####

#####


---

📑 [[00 - Índice do Artigo|Índice]] | [[Parte 02 de 02|Próxima Parte]] ➡️
