# 📖 Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning — Parte 3 de 5

> **Índice:** [[00 - Índice do Artigo]]
> **Autores:** Tencent AI Lab (2023)
> **Artigo Original:** `Training Interactive Agent in Large FPS Game Map with Rule-enhanced Reinforcement Learning - arXiv.html`

---

#### III METHODS

Modern 3D FPS shooter games typically exhibit characteristics such as complex
environments and large-scale maps. The need for precise positioning in specific locations
poses challenges for global navigation. In Arena Breakout, PMCA is required to pursue any
encountered player on the map, further emphasizing the need for accurate navigation. On
the other hand, engaging in combat with players presents challenges as modern 3D FPS games
often simulate firearm recoil, resulting in realistic bullet trajectories. This becomes a
training challenge for the agent, as it must learn how to control the bullet trajectory to
hit opponents accurately. This section will discuss how to train a globally interactive
game on a 1000 × 400 1000\times 400 (unit: meters in UE4) map and the approaches adopted
to address these two challenges. The results of these approaches will be demonstrated in
the section IV.

##### III-A Framework

We illustrate our framework as shown in fig. 2. In each step, the game's basic
information is separately input into a feature extraction module. All scalar information
undergoes feature extraction through a feed-forward network. The depth map and the Lindar
[ 8] is input into the feature extraction module. By utilizing two-dimensional convolution
to perceive the contour features of objects represented in the depth map and employing
one-dimensional circular convolution to extract surrounding terrain features, we achieve a
multi-modal fusion-based environmental perception approach by fusing the features from
each feature extraction module with the environment information of the game after
concatenation. To give the model memory capacity, we utilized LSTM (Long Short-Term
Memory) networks. The features filtered through the LSTM are then input into the policy
network and value network, which are used for action prediction and value calculation
respectively. As mentioned in section II-B, we divided the action space into nine action
heads based on human operation. Each action head is represented by a one-hot vector that
indicates the execution state of the corresponding action. There are certain dependencies
among the action heads. For example, according to the limitations of the game itself, the
model should not predict both firing and movement simultaneously. To decouple the
dependencies among actions, we did not adopt the approach of parallel prediction for
action heads. Instead, we sequentially output the action heads using a hierarchical action
mask with auto-regressive embedding [ 11] . In typical reinforcement learning tasks,
action masking is employed to block corresponding actions in specific states to enhance
exploration efficiency. In our policy network, all action heads are sequentially
generated. Except for the first action head, the output of each subsequent action head is
determined jointly by the embedding of the previous action and the policy network's
output. Through auto-regressive embedding, the policy implicitly learns the dependencies
between preceding and succeeding actions and propagates them layer by layer. During action
prediction, the policy can temporarily mask actions in subsequent layers that conflict
with the current action. The policy also determines whether to mask the actions in the
current layer based on the preceding actions. In this way, we conduct hierarchical action
masking through auto-regressive prediction, ensuring action compliance while improving
exploration efficiency. After all action heads have completed their outputs, these actions
are delivered to the game client for execution.

##### III-B Navigation Mesh and Shooting-rule Enhanced Reinforcement Learning

To address the challenges of global navigation on a 1000 × 400 1000\times 400 (unit:
meters in UE4) map and the issue of firing when encountering enemies in-game, we employ
Navigation Mesh And Shooting-rule enhanced Reinforcement Learning (NSRL). This approach
combines the integration of a Navigation Mesh (Navmesh) and atomic shooting rules to
enhance the performance of the game's AI. Global Navigation. In the context of global
navigation, simply incorporating Navmesh directly into the program would lead to
rule-based behavior in game AI, thereby sacrificing the diversity provided by DRL models.
Therefore, in NSRL, a more gentle approach is employed. The decision-making power to use
the Navmesh is delegated to the DRL model, allowing the model to predict whether to enable
the Navmesh. By setting Navmesh as a predictable action, NSRL maintains the ability for
global navigation while still preserving the diversity of the game AI provided by the DRL
model. Fig. 3: The illustration of Navmesh enhanced global navigation. Fig. 4: The
illustration of shoot rules. As fig. 3 shown, in each step, the DRL agent will predict the
Path type before motion. When the DRL model predicts atomic movement, it also needs to
select an orientation from a set of 16 orientations, with each orientation spaced at a
fixed angle interval. Subsequently, the agent moves forward a fixed distance according to
the specified orientation. When the model chooses to use the Navmesh ( fig. 3), it
searches for the optimal path between the agent and the target using the Navmesh and moves
along that path. The Path type includes an action to keep the previous Navmesh, which aims
to avoid re-calling the Navmesh when the target is stationary, reducing resource
consumption. It is not feasible to call the Navmesh throughout the entire game as it would
be indistinguishable from directly using Navmesh for movement. To address this, we divide
the entire game into time slices. At fixed intervals, the client will check for any
requests to use the Navmesh. Once a request to use the Navmesh is detected, the
predictions of the DRL model for other Path types are masked, and the agent executes the
Navmesh until it reaches the target, encounters an enemy, or reaches the time limit for
Navmesh usage. This approach ensures global navigation while reducing resource consumption
and preserving the diversity inherent in DRL models. Note that when the agent is in a
combat scenario, it typically implies that the opponent is visible to the agent.
Therefore, to ensure smooth combat, atomic movement is preferred over Navmesh usage.
Navmesh is usually predicted when pursuing enemy targets. Shooting Rules. In Arena
Breakout, where realistic firearm ballistics and recoil are simulated, NSRL only needs to
predict the gun barrel direction and whether to fire to ensure shooting control. This
approach offers the advantage of maintaining stable shooting while enhancing the diversity
of shooting actions. In combat scenarios, the baseline firing point is determined based on
the visibility priority of the opponent's body parts. A shooting confidence region is
calculated that defines the area within which random shots are fired, while shots outside
the confidence region are truncated. As shown in fig. 4, We have set arctan ( 40 / 1500 )
\arctan(40/1500) as the baseline angle, and the confidence region radius r r for different
distances is calculated based on the baseline radius. Additionally, we have incorporated
an extra confidence region between two consecutive shots, which is represented by a circle
with a radius of r / 3 r/3 . This imitates the behavior of human players controlling
recoil in the game, simulating the concept of ”burst shooting” where shots are fired
within a certain range to maintain accuracy.


---

⬅️ [[Parte 02 de 05|Parte Anterior]] | 📑 [[00 - Índice do Artigo|Índice]] | [[Parte 04 de 05|Próxima Parte]] ➡️
