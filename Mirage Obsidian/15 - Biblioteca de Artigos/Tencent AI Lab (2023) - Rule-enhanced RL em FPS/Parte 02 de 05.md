# 📖 Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning — Parte 2 de 5

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Tencent AI Lab (2023)
> **Artigo Original:** `Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv.html`

---

#### II Notation And Background

##### II-A Arena Breakout

Arena Breakout is a 3D first-person shoot game developed by Tencent Games based on Unreal
Engine 4. Its interface is shown in fig. 1. At the time of writing this paper, it has more
than 80 million registered players worldwide. Different from the games mentioned above,
Arena Breakout not only retains the original shooting game logic but also adds more
tactical content. Players need to compete for resources and reach a designated location
for evacuation within a limited timeframe. The objective of the game is to survive while
obtaining as many resources (weapons, equipment, etc.) as possible, storing them in a
secure box, and reaching the evacuation point to complete the evacuation. Each player has
a secure box, and resources stored in the box will not be lost upon death, while items
outside the box will be lost. Therefore, the core of the gameplay is how players can
obtain the maximum amount of resources while staying alive. Owing to developed by Unreal
Engine 4, Arena Breakout features complex 3D modeling and detailed maps where most objects
are physically modeled. The player in Arena Breakout requires intricate operation, as
players need to control their direction and movement while aiming and firing at targets.
The game also includes actions such as crouching, crawling, and jumping to change the
player's posture. The complex environment and diverse operations add more replayability to
the game while increasing the difficulty of training the game AI.

##### II-B State Space and Action Space

In order to apply reinforcement learning algorithms to Arena Breakout, we need to
construct the Markov Decision Process (MDP) for the game. We decompose Arena Breakout into
the state space and the action space. In the state space of the Arena Breakout, we have
devised multiple information sources concerning the agent, encompassing scalar game
variables and perception information derived from raycast detection. The scalar game
variables, including the agent's position, rotation angle, orientation, and combat status
(such as health and engagement in combat), are directly acquired through the APIs provided
by Unreal Engine 4. These variables are subjected to mathematical processing and
synthesizing them into five distinct categories of fundamental information for input into
the neural network (Table I). Each category of information influences the agent's
decision-making and behavior differently. The perception information based on raycast
detection is also implemented through the Unreal Engine 4. The agent emits rays from its
position towards entities within the game and captures pertinent details, such as the
entity's surface normal vector. Consequently, the agent can ascertain the distance and
position of the entity relative to itself utilizing these rays. We further process this
information to generate depth maps and encapsulate the circular ray, which are
subsequently employed as inputs for the neural network. The operation of Arena Breakout is
achieved through a joystick that determines the direction combined with different action
buttons. Therefore, in the action space, we imitate the left and right-hand operations of
human players. Based on Euler rotation angles, we divide the executable actions into nine
action heads ( table I). Each action head is represented by a one-hot vector that
indicates the execution state of that action. Fire determines whether to initiate the
firing action. Gun_yaw and Gun_pitch represent how to adjust the position of the gun
barrel. Move_type determines the movement mode, such as running or walking. Path_type
indicates the pathfinding method, where the model determines whether to use atomic
movement or Navmesh movement. Motion represents the movement direction, indicating a
source motion at a fixed angle. Posture_type expresses the current character's posture,
such as crouching, prone, jumping, etc. Lean_type indicates whether to perform a leaning
action. Special_type represents special operations in the game, such as aiming down sights
(ADS) or other specific actions.

| State | Type | Dim |
| Basic_info | float | [1,124] |
| Opponent_info | float | [1,99] |
| Env_info | float | [1,301] |
| Depth Map | float | [40,80] |
| Lindar [ 8] | float | [144,3] |
| Action | Type | Dim |
| Fire | int | [2] |
| Gun_yaw | int | [13] |
| Gun_pitch | int | [8] |
| Move_type | int | [4] |
| Path_type | int | [4] |
| Motion | int | [17] |
| Posture_type | int | [4] |
| Lean_type | int | [3] |
| Special_type | int | [3] |
TABLE I: State space and action space of Arena Breakout

##### II-C Reinforcement Learning

In a standard reinforcement learning setting, the agent interacts with the environment
and receives full perceptual information about the state. The Markov decision process
(MDP) of Arena Breakout is formulated as a 5-tuple ⟨ 𝒮 , 𝒜 , 𝒫 , r , γ ⟩
\langle\mathcal{S},\mathcal{A},\mathcal{P},r,\gamma\rangle , where 𝒮 \mathcal{S} and 𝒜
\mathcal{A} are the state and action spaces; r : 𝒮 × 𝒜 → ℝ
r:\mathcal{S}\times\mathcal{A}\to\mathbb{R} and 𝒫 : 𝒮 × 𝒜 → Δ 𝒜
\mathcal{P}:\mathcal{S}\times\mathcal{A}\to\Delta_{\mathcal{A}} are the reward function
and transition probability distribution, with r ( s , a ) ∈ [ R m i n , R m a x ]
r(s,a)\in[R_{min},R_{max}] and P ( ⋅ | s , a ) P(\cdot|s,a) being the reward and the next
state probability of taking action a in state s; γ \gamma is discount factor. In each step
t, the agent gets a state s t ∈ 𝒮 s_{t}\in\mathcal{S} as the current state of the
environment. The agent predicting an action a t ∈ 𝒜 a_{t}\in\mathcal{A} given the state s
s with the policy π ( a t | s t ) \pi(a_{t}|s_{t}) . Agent gets a reward r ( s t , a t )
r(s_{t},a_{t}) after the action is executed. The state value function V π ( s ) = 𝔼 π [ ∑
k = 0 T γ k R t + k + 1 | S t = s ]
V_{\pi}(s)=\mathbb{E_{\pi}}[\sum\limits_{k=0}^{T}\gamma^{k}R_{t+k+1}|S_{t}=s] and the
action value function Q π ( s ) = 𝔼 π [ ∑ k = 0 T γ k R t + k + 1 | S t = s , A t = a ]
Q_{\pi}(s)=\mathbb{E_{\pi}}[\sum\limits_{k=0}^{T}\gamma^{k}R_{t+k+1}|S_{t}=s,A_{t}=a] are
always leveraged to optimize policy. The advantage function A ( s , a ) = Q ( s , a ) − V
( s ) A(s,a)=Q(s,a)-V(s) is used to measure the quality of action a a compared to the
average quality. The goal of the RL algorithm is to find an optimal policy π ∗ \pi^{} to
maximize the expectation of the discounted cumulative reward: π ∗ = arg max π 𝔼 [ ∑ t = 0
n γ t r ( s t , a t ) ]
\pi^{}=\arg\max\limits_{\pi}\mathbb{E}[\sum\limits_{t=0}^{n}\gamma^{t}r(s_{t},a_{t})] (1)
Several DRL algorithms have been proposed, some use value-based methods to find an optimal
value function such as Deep Q-net work (DQN) [ 9] , and others use policy gradient to
optimize policy with the gradient of reward [ 10] . Schulman et al. \[7\] utilizing
importance sampling to improve convergence efficiency, the characteristic of data reuse
also enables the application of distributed algorithms. Our work is based on PPO.


---

⬅️ [[Parte 01 de 05|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]] | [[Parte 03 de 05|Próxima Parte]] ➡️
