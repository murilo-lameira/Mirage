# 📖 Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning — Parte 4 de 5

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Tencent AI Lab (2023)
> **Artigo Original:** `Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv.html`

---

##### III-C Reward Design

In reward design, it is important to ensure that the agent has a comprehensive
understanding of both global navigation and shooting. Therefore, when designing the
rewards, it is necessary to consider global navigation, shooting performance, and the
final reward. Since the PMCA is primarily used in high-level matches, it needs to exhibit
a certain level of strength. Given a horizon T T , the final reward r T r_{T} can be
defined as follows: r T = { 20 , i f w i n , − 20 , i f l o s e , − 25 , i f d r a w ,
r_{T}=\left{\begin{split}&20,if\ win,\ -&20,if\ lose,\ -&25,if\ draw,\end{split}\right.
The navigation reward r d r_{d} is r d = Δ d × 0.05 r_{d}=\Delta_{d}\times 0.05 . Where Δ
d \Delta_{d} is the distance between agent and opponent. We have implemented additional
auxiliary rewards r a u x r_{aux} for the agent's shooting behavior to enhance its
human-like characteristics. These rewards are categorized into two parts: combat and
movement, based on expert priors. This ensures that our agent does not exhibit confusing
behaviors that might perplex players. The final reward r defined as: r = r T + r d + r a u
x r=r_{T}+r_{d}+r_{aux}

##### III-D Training Process

To train the agent on a large 1000 × 400 1000\times 400 (unit: meters in UE4) map, we
initially divided the entire map into eight regions (red square in fig. 5). At the
beginning of each match, the agent and the opponent are randomly generated within the same
region. There is guaranteed to be cover or obstacles between the spawn points of the two
sides. When the two sides encounter each other, a battle begins as long as one side has a
line of sight to the other. This approach not only trains the agent's combat abilities but
also enhances its strategic decision-making by encouraging the use of non-combat tactics
to defeat opponents. During the training process, an episode ends when either one of the
players dies or the time reaches the timeout limit. Fig. 5: The map in Arena Breakout, the
farmland. PPO is used in our system for policy improvement. We employed the
importance-weighted actor-learner Architecture (IMPALA) [ 12] algorithm as the primary
algorithm in our training framework, which enables agents to learn from multiple sources
of experience. The agent interacts with the environment to collect data. After several
episodes, the data obtained by the agent is used to estimate the advantage function. We
use Generalized Advantage Estimation [ 13] to estimate the advantage function at each time
step t: A ^ = ∑ t = 0 T ( γ λ ) t A t + 1 π θ
\hat{A}=\sum\limits_{t=0}^{T}{(\gamma\lambda)}^{t}A_{t+1}^{\pi_{\theta}} (2) And the
advantage function A A is defined as: A π θ ( s t , a t ) = r ( s t , a t ) + γ V π θ ( S
t + 1 ) − V π θ ( S t ) {A}^{\pi_{\theta}}(s_{t},a_{t})=r(s_{t},a_{t})+\gamma
V^{\pi_{\theta}}(S_{t+1})-V^{\pi_{\theta}}(S_{t}) (3) Where a t ∼ π θ ( ⋅ | s t )
a_{t}\sim\pi_{\theta}(\cdot|s_{t}) . r ( s t , a t ) r(s_{t},a_{t}) is the reward function
according to the current state and action. V π θ V^{\pi_{\theta}} is the value function,
which defines the state value of the current policy. After having the advantage function,
we can calculate the loss of the policy. We use PPO with clip, and the loss function is
defined as: ℒ π ( θ ) = min [ ρ ( θ ) A ^ t , c l i p ( ρ ( θ ) , 1 − ϵ , 1 + ϵ ) A ^ ] ,
\mathcal{L}^{\pi}(\theta)=\min[\rho(\theta)\hat{A}{t},clip(\rho(\theta),1-\epsilon,1+\epsilon)\hat{A}],
(4) to constrain the distance between the sample policy and the target policy. The value
loss is defined as: ℒ v ( ϕ ) = 𝔼 a ∼ π θ [ ∑ k = t T γ k − t r ( s k , a k ) − V ( s t )
] 2 \mathcal{L}^{v}(\phi)=\mathbb{E} {a\sim\pi
{\theta}}[\sum\limits{k=t}^{T}\gamma^{k-t}r(s_{k},a_{k})-V(s_{t})]^{2} (5) And the total
loss of current policy π θ \pi_{\theta} is defined as: ℒ ( θ ) = ℒ π ( θ ) − α ℒ v ( ϕ ) +
β ℒ e
\mathcal{L}(\theta)=\mathcal{L}^{\pi}(\theta)-\alpha\mathcal{L}^{v}(\phi)+\beta\mathcal{L}^{e}
(6) ℒ e \mathcal{L}^{e} is the entropy of policy which enhances the exploration.

#### IV Experiment

##### IV-A Experimental Setup

In this section, we will present our experimental results. We will demonstrate the
improvements brought by NSRL in global navigation, shooting, and final win rate. The
experiments were conducted using 8 GPUs and 3200 CPU cores, with 4 actors, 4 learners, and
6000 clients involved in each training session. All experiments were based on the PPO
algorithm. To ensure fairness, all training sessions used the same set of resources. ((a))
Visualization of RL Global Navigation ((b)) Visualization of NSRL Global Navigation Fig.
6: Visualization of RL and NSRL Global Navigation. The closer the color is to purple, the
higher the number of traversals, while the closer it is to blue, the fewer the number of
traversals. The NSRL visualization shows that most areas are closer to purple, indicating
a higher number of traversals, while there are fewer areas close to blue. On the other
hand, the RL visualization reveals that only a small portion is close to purple,
suggesting limitations in RL's global navigation capabilities.

##### IV-B Results

Global Navigation. To compare the global navigation performance of the NSRL agent and the
RL agent under identical conditions, we conducted a study where both agents were trained
and tested in the same environment. The NSRL and RL agents were trained using the same
expert prior behavior tree as their opponent. The starting points and in-game resources
were kept consistent across the experiments. In this scenario, we recorded the traversal
points of both the NSRL agent and the RL agent on the map. We collected data from over
1000 game sessions for analysis. The NSRL and RL agent global navigation visualization is
shown in fig. 6. From the fig. 6(a) and fig. 6(b), it is evident that NSRL has a wider
motion range in terms of the length on the x-axis, breadth on the y-axis, and height on
the z-axis compared to RL. This indicates that under the same conditions, NSRL, which
benefits from rule enhancement, effectively improves the global navigation capability of
the DRL agent. Indeed, NSRL agent possesses a more diverse range of behaviors. This
diversity allows the NSRL agent to explore a wider range of areas in the environment,
enabling it to gather more valuable experiences. This result assists us in designing more
interactive agents that can navigate the entire map more effectively. Fig. 7: The trend of
win rates verses BT changes during the training process for the RL agent and NSRL agent.
Competence of NSRL agent. To demonstrate the competence of NSRL compared to pure RL, both
agents were trained using identical resources and opponents (based on expert prior
behavior trees) throughout the training process. We extracted the win rate changes of the
NSRL agent and RL agent at 200 timesteps and plotted them in fig. 7. At the same timestep,
the win rate of NSRL was consistently around 30% higher on average compared to the RL
agent. This highlights the superior performance of NSRL in adapting to expert prior
behavior trees. Furthermore, it emphasizes the improved training efficiency of NSRL, as it
is capable of producing more competent agents at the same timestep. Shooting of NSRL. Due
to the prevalent use of realistic firearm recoil and ballistic effects in modern 3D FPS
games, it is crucial for DRL agents to exhibit human-like shooting behavior that does not
confuse players. To analyze this, we designed a specific experimental scenario where the
NSRL and RL agents were tasked with shooting at fixed target locations. We collected the
coordinates of bullet impact patterns near the target locations and integrated them into
fig. 8. From the fig. 8(a), it can be observed that when human players shoot, their
bullets are dispersed around the central target point, which aligns with the logic of
realistic firearm recoil and ballistic effects. The result in fig. 8(b) shows the bullet
distribution of the NSRL agent exhibits a similar trend to that of humans but with a
higher degree of dispersion. This may be due to a lack of sufficient understanding of the
concept of ”spray control” in FPS games within the model. fig. 8(c) illustrates that pure
RL alone cannot effectively control firearms and may exhibit perplexing behaviors. In
summary, NSRL effectively enhances the global navigation capabilities of DRL agents,

---

⬅️ [[Parte 03 de 05|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]] | [[Parte 05 de 05|Próxima Parte]] ➡️
