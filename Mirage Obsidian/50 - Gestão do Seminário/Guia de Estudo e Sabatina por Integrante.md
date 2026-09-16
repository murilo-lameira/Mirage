# 📖 GUIA DEFINITIVO DE ESTUDOS E SABATINA: PROJETO MIRAGE
## Preparação Aprofundada para o Seminário de Inteligência Artificial — UNISENAI (2026)
### *Mecânica Vetorial, Cinemática Evasiva, Computação Evolutiva e Defesa Perante a Banca*

---

<p align="center">
  <b>Autores:</b> Leonardo Retori • Henry Matheus • Murilo Lameira • Murilo Romualdo<br>
  <b>Orientador:</b> Me. Ricardo Martinez Vicentini<br>
  <b>Instituição:</b> Centro Universitário SENAI SP – Campus São Caetano do Sul (Boa Vista)<br>
  <b>Curso:</b> Engenharia de Controle e Automação — Disciplina: Inteligência Artificial
</p>

> 🔗 **Conexões do Seminário:**
> - [[00 - MOC Principal]]
> - [[Divisão de Tarefas & Apresentadores]]
> - [[Roteiro de Apresentação (15 min)]]
> - [[Dossiê Completo do Seminário]]
> - [[Simulação & Física de Esquiva]]
> - [[Cromossomo & Genes]]
> - [[Função de Fitness]]

---

## 🎯 OBJETIVO DESTE DOCUMENTO

Este manual foi concebido para transformar cada integrante do grupo em um **especialista inabalável** no projeto **Mirage**. Aqui estão detalhados os fundamentos teóricos, o funcionamento do código-fonte em GNU Octave, as deduções matemáticas passo a passo e, com destaque especial, **toda a física e cinemática vetorial** subjacente ao simulador.

O documento está estruturado **nominalmente por integrante**, garantindo que cada um domine com precisão cirúrgica a sua seção de fala, saiba explicar como a física impacta a sua área e esteja pronto para responder às perguntas mais difíceis e "pegadinhas" que o professor ou a banca examinadora possam formular.

---

## 🗺️ ÍNDICE GERAL

1. [Visão Panorâmica da Arquitetura do Mirage](#-visão-panorâmica-da-arquitetura-do-mirage)
2. [Compêndio Mestre de Física e Cinemática Vetorial (Leitura Obrigatória para Todos)](#-compêndio-mestre-de-física-e-cinemática-vetorial)
3. [Módulo 1: Murilo Lameira — Contexto, Problema dos NPCs Clássicos e Visão Geral](#-módulo-1-murilo-lameira)
4. [Módulo 2: Leonardo Retori — Teoria Evolutiva, MAP-Elites, SEC e Operadores Genéticos](#-módulo-2-leonardo-retori)
5. [Módulo 3: Henry Matheus — Engenharia da Física de Esquiva, Genes e Fitness](#-módulo-3-henry-matheus)
6. [Módulo 4: Murilo Romualdo — Arena Dinâmica, Balística, ANOVA e Fechamento](#-módulo-4-murilo-romualdo)
7. [Glossário Mestre de Variáveis, Constantes Físicas e Unidades SI](#-glossário-mestre-de-variáveis-constantes-físicas-e-unidades-si)

---

# 🌌 VISÃO PANORÂMICA DA ARQUITETURA DO MIRAGE

O **Mirage** é um ambiente de simulação física e otimização comportamental em tempo contínuo discretizado ($\Delta t = 0.05\text{ s}$ / $20\text{ Hz}$). Nele, um NPC (*Non-Playable Character*) combate em uma arena bidimensional $\Omega = [-20, 20] \times [-20, 20]\text{ metros}$ contra padrões hostis de projéteis balísticos (*Bullet Hell*).

O diferencial científico do projeto é a **integração entre mecânica clássica vetorial e computação evolutiva**:
- O NPC **não** decide suas ações por lógica booleana fixa (como "se projétil perto, vire à esquerda").
- Ele calcula forças de aceleração física contínua com base nos **Steering Behaviors de Craig Reynolds** guiados pela predição analítica de **CPA (*Closest Point of Approach*)**.
- O genoma do NPC regula parâmetros físicos reais: pontos de vida ($HP$), poder de fogo ($Attack$), cadência de disparo ($AttackSpeed$) e velocidade escalar máxima ($v_{\text{max}} = MovementSpeed$).
- Um sistema de **Orçamento Global de Atributos (*Point-Buy Budget*)** atua como conservador de energia/capacidade, forçando um compromisso (*trade-off*) biofísico: NPCs rápidos são frágeis; NPCs resistentes são lentos.

```text
       ┌────────────────────────────────────────────────────────┐
       │                   LOOP POR FRAME (Δt = 0.05s)          │
       └───────────────────────────┬────────────────────────────┘
                                   │
           ┌───────────────────────┴───────────────────────┐
           ▼                                               ▼
  [ DETECÇÃO BALÍSTICA ]                          [ INTEGRAÇÃO MECÂNICA ]
  - Posição e velocidade dos projéteis            - Soma de forças: Σ F_evade
  - Cálculo de CPA preditivo:                     - a = F / m (m = 1 kg)
      t_cpa = -(p_r · v_r) / ||v_r||²             - v(k+1) = truncate(v(k) + a·Δt, vmax)
  - Filtro: 0 < t_cpa < 1.5s & dist < 2.5m        - p(k+1) = p(k) + v(k+1)·Δt
  - Direção de fuga perpendicular Reynolds        - Colisão elástica / deslizamento pilares
           │                                               │
           └───────────────────────┬───────────────────────┘
                                   ▼
                         [ FEEDBACK DINÂMICO ]
              - Hitbox (r = 1.0m): -25 HP por colisão
              - Radar (R = 4.0m): +1 Desvio bem-sucedido
              - Cobertura física: Pilares neutralizam tiros
              - Dano infligido: Penalizado por velocidade alta
```

---

# 🧭 COMPÊNDIO MESTRE DE FÍSICA E CINEMÁTICA VETORIAL
> **Atenção:** Esta seção contém toda a base matemática e física do simulador. **Todos os 4 integrantes devem ler e compreender este capítulo.**

### 1. Modelo de Integração Numérica: Euler Semi-Implícito (Euler-Cromer)
A cada passo de tempo $\Delta t = 0.05\text{ s}$, o motor de simulação resolve as equações diferenciais de segunda ordem do movimento translacional:

$$m \frac{d^2 \vec{p}}{dt^2} = \sum \vec{F}_{\text{total}}$$

Como a massa do agente é calibrada como $m = 1.0\text{ kg}$, a aceleração instantânea é numericamente idêntica à força resultante: $\vec{a}(k) = \vec{F}_{\text{total}}(k)$.

O método de integração adotado em `src/simulate_episode.m` é o **Euler Semi-Implícito (Euler-Cromer)**:

$$\vec{v}_{\text{npc}}(k+1) = \text{truncate}\left(\vec{v}_{\text{npc}}(k) + \frac{\vec{F}_{\text{total}}(k)}{m} \cdot \Delta t, \; v_{\text{max}}\right)$$

$$\vec{p}_{\text{npc}}(k+1) = \vec{p}_{\text{npc}}(k) + \vec{v}_{\text{npc}}(k+1) \cdot \Delta t$$

#### ❓ Por que Euler Semi-Implícito e não Euler Explícito Tradicional?
* No **Euler Explícito**, a posição é atualizada com a velocidade antiga: $\vec{p}(k+1) = \vec{p}(k) + \vec{v}(k)\Delta t$. Em sistemas oscilatórios ou com forças de repulsão elástica (como as paredes e pilares), o Euler explícito injeta energia espúria no sistema, fazendo o NPC "explodir" numericamente para o infinito.
* O **Euler Semi-Implícito** utiliza a **nova velocidade** $\vec{v}(k+1)$ para atualizar a posição. Ele é um integrador simplético: preserva o espaço de fase e a energia mecânica do sistema, garantindo estabilidade incondicional para o passo $\Delta t = 0.05\text{ s}$.

#### Amortecimento Natural (Atrito de Frenagem):
Quando o radar do NPC não detecta nenhuma ameaça no horizonte ($\|\vec{F}_{\text{total}}\| < 10^{-3}\text{ N}$), o simulador aplica um amortecimento viscoso exponencial:

$$\vec{v}_{\text{npc}}(k+1) = \vec{v}_{\text{npc}}(k) \cdot 0.85$$

Isso evita que o NPC continue deslizando por inércia infinita no vácuo quando a arena estiver calma.

---

### 2. Dedução Matemática Rigorosa do CPA (*Closest Point of Approach*)
O cálculo de CPA (Lee, 2014) é o cérebro preditivo da esquiva. Em vez de fugir da posição presente do projétil, o NPC calcula a distância mínima futura e o instante exato em que ela ocorrerá.

Sejam:
- $\vec{p}_{\text{npc}}, \vec{v}_{\text{npc}} \in \mathbb{R}^2$: posição e velocidade instantâneas do NPC.
- $\vec{p}_p, \vec{v}_p \in \mathbb{R}^2$: posição e velocidade instantâneas do projétil $j$.

Definem-se os vetores relativos de posição e velocidade:

$$\vec{p}_r = \vec{p}_p - \vec{p}_{\text{npc}}$$

$$\vec{v}_r = \vec{v}_p - \vec{v}_{\text{npc}}$$

Assumindo que em um pequeno intervalo de tempo as velocidades são retilíneas e uniformes, a posição relativa futura em função de $t$ é:

$$\vec{r}(t) = \vec{p}_r + \vec{v}_r \cdot t$$

A distância euclidiana entre eles ao quadrado é dada pelo produto escalar:

$$D(t)^2 = \|\vec{r}(t)\|^2 = (\vec{p}_r + \vec{v}_r t) \cdot (\vec{p}_r + \vec{v}_r t)$$

Expandindo a expressão:

$$D(t)^2 = \|\vec{p}_r\|^2 + 2 (\vec{p}_r \cdot \vec{v}_r) t + \|\vec{v}_r\|^2 t^2$$

Para encontrar o instante $t_{\text{cpa}}$ onde a distância é **mínima**, derivamos $D(t)^2$ em relação a $t$ e igualamos a zero:

$$\frac{d}{dt}\left[ D(t)^2 \right] = 2(\vec{p}_r \cdot \vec{v}_r) + 2\|\vec{v}_r\|^2 t = 0$$

$$2\|\vec{v}_r\|^2 t = -2(\vec{p}_r \cdot \vec{v}_r)$$

$$t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\vec{v}_r \cdot \vec{v}_r}$$

#### Prova de que é um Ponto de Mínimo:
A segunda derivada é:

$$\frac{d^2}{dt^2}\left[ D(t)^2 \right] = 2\|\vec{v}_r\|^2$$

Como $\|\vec{v}_r\|^2 > 0$ (para qualquer velocidade relativa não-nula), a concavidade é estritamente positiva para cima, provando que $t_{\text{cpa}}$ é um **mínimo global de distância**.

#### As 3 Condições Físicas de Disparo da Esquiva:
A força de evasão **só é gerada** se três testes lógicos forem verdadeiros simultaneamente em `src/calculate_evade_force.m`:
1. **$t_{\text{cpa}} > 0$:** Significa que $\vec{p}_r \cdot \vec{v}_r < 0$. O ângulo entre a posição relativa e a velocidade relativa é obtuso ($> 90^\circ$), o que atesta que os dois corpos estão **se aproximando**. Se $t_{\text{cpa}} \le 0$, o projétil já cruzou o ponto mais próximo e está **se afastando** (não há perigo).
2. **$t_{\text{cpa}} < 1.5\text{ s}$:** Horizonte de predição temporal finito. Evita que o NPC gaste energia reagindo a tiros no outro extremo da arena.
3. **$\|\vec{r}(t_{\text{cpa}})\| < 2.5\text{ metros}$:** A distância mínima projetada de passagem é inferior ao envelope de segurança. Se o tiro vai passar a $3.5\text{ m}$ de distância, o NPC simplesmente o ignora!

---

### 3. Dinâmica dos Steering Behaviors (Craig Reynolds, 1999)
Uma vez detectada a colisão iminente no instante $t_{\text{cpa}}$, o NPC calcula as posições projetadas de ambos no futuro:

$$\vec{p}_{\text{npc}}(t_{\text{cpa}}) = \vec{p}_{\text{npc}} + \vec{v}_{\text{npc}} \cdot t_{\text{cpa}}$$

$$\vec{p}_p(t_{\text{cpa}}) = \vec{p}_p + \vec{v}_p \cdot t_{\text{cpa}}$$

O vetor de repulsão no momento do impacto projetado é:

$$\vec{d}_{\text{evade}} = \vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})$$

#### Tratamento de Singularidade (Colisão Frontal Perfeita):
Se o tiro estiver perfeitamente alinhado com o centro do NPC ($\|\vec{d}_{\text{evade}}\| < 10^{-6}$), a divisão por zero geraria uma indefinição matemática. O código resolve isso aplicando uma **rotação ortogonal de $90^\circ$** sobre o vetor do projétil:

$$\vec{d}_{\text{evade}} = [-v_{py}, \; v_{px}]$$

Isso força o NPC a esquivar perpendicularmente à trajetória do tiro.

#### Equação da Força de Direcionamento:
Normaliza-se a direção de fuga e escala-se para a velocidade máxima do indivíduo ($v_{\text{max}}$):

$$\hat{u}_{\text{evade}} = \frac{\vec{d}_{\text{evade}}}{\|\vec{d}_{\text{evade}}\|}, \quad \vec{v}_{\text{desejada}} = \hat{u}_{\text{evade}} \cdot v_{\text{max}}$$

A força de condução de Reynolds ($\vec{F}_{\text{evade}}$) é a diferença entre para onde o agente **deseja ir** e para onde ele **está se movendo**:

$$\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$$

Se houver múltiplos projéteis perigosos, o NPC realiza a **superposição linear de forças**:

$$\vec{F}_{\text{total}} = \sum_{j \in \mathcal{Ameaças}} \vec{F}_{\text{evade}}^{(j)}$$

---

### 4. Mecânica de Colisão com Pilares e Deslizamento Tangencial (*Occlusion Steering*)
A arena conta com 4 pilares circulares rígidos de raio $R_{\text{pillar}} = 1.3\text{ m}$ em $(\pm 8, \pm 8)\text{ m}$.
O raio de colisão do NPC é $R_{\text{npc}} = 1.0\text{ m}$. A distância mínima permitida entre seus centros é:

$$D_{\text{min}} = R_{\text{npc}} + R_{\text{pillar}} = 1.0 + 1.3 = 2.3\text{ metros}$$

Quando o vetor distância $\vec{d}_p = \vec{p}_{\text{npc}} - \vec{p}_{\text{pillar}}$ atinge $\|\vec{d}_p\| < D_{\text{min}}$, o motor de física realiza duas operações:

#### A) Correção Cinemática de Posição (Projeção Rígida):
O NPC é reposicionado imediatamente na casca cilíndrica exterior do pilar:

$$\hat{n} = \frac{\vec{d}_p}{\|\vec{d}_p\|}, \quad \vec{p}_{\text{npc}} \leftarrow \vec{p}_{\text{pillar}} + \hat{n} \cdot D_{\text{min}}$$

#### B) Decomposição Vetorial da Velocidade e Deslizamento Tangencial:
Calcula-se a projeção escalar da velocidade na normal:

$$v_n = \vec{v}_{\text{npc}} \cdot \hat{n}$$

Se $v_n < 0$ (o NPC está tentando se mover na direção do centro do pilar), a componente normal é instantaneamente anulada:

$$\vec{v}_{\text{npc}} \leftarrow \vec{v}_{\text{npc}} - v_n \hat{n}$$

A componente tangencial permanece inalterada ($\vec{v}_t = \vec{v}_{\text{npc}} - v_n \hat{n}$), permitindo que o NPC **deslize suavemente ao redor do pilar** enquanto usa sua massa rígida como escudo balístico!

---

### 5. Balística e Cinemática dos Projéteis Inimigos
Os tiros do atirador automatizado são governados por cinemática balística linear:

$$\vec{p}_p(k+1) = \vec{p}_p(k) + \vec{v}_p \cdot \Delta t$$

Os tiros possuem 3 padrões geradores:
1. **Tiros Lineares Direcionados:** Gerados na borda circular da arena ($R = 18\text{ m}$) apontados para o NPC, com perturbação angular Gaussiana:
   $$\vec{v}_p = \left( \frac{\vec{p}_{\text{npc}} - \vec{p}_{\text{spawn}}}{\|\vec{p}_{\text{npc}} - \vec{p}_{\text{spawn}}\|} + \vec{\eta} \right) \cdot v_{\text{base}}, \quad \vec{\eta} \sim \mathcal{U}(-\sigma, \sigma)$$
2. **Cone em Leque (*Shotgun Spread*):** Salvas de 3 tiros a cada $2.8\text{ s}$ no Médio e Difícil, gerados aplicando a matriz de rotação $2\text{D}$ com ângulos $\theta \in \{-0.22\text{ rad}, 0, +0.22\text{ rad}\} \approx \pm 12.6^\circ$:
   $$\begin{bmatrix} v_{px}' \\ v_{py}' \end{bmatrix} = \begin{bmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{bmatrix} \begin{bmatrix} v_{px} \\ v_{py} \end{bmatrix}$$
3. **Vórtice Espiral Contínuo (*Danmaku Vortex*):** No modo Difícil, emissão circular contínua a partir do centro $(0,0)$ com velocidade angular constante $\omega = 4.5\text{ rad/s}$:
   $$\vec{v}_{\text{espiral}}(t) = [\cos(4.5 t), \; \sin(4.5 t)]^T \cdot 9.5\text{ m/s}$$

---

# 🧑‍💼 MÓDULO 1: MURILO LAMEIRA
### *Abertura, Gancho, Contexto e Visão Geral do Mirage*
**Tempo no Roteiro:** $0\text{min}00\text{s} \to 3\text{min}00\text{s}$ (Slides 1 a 3)

---

### 🎯 Sua Missão no Seminário
Você abre a apresentação com energia e impacto. Seu papel é demonstrar **por que a Inteligência Artificial clássica falhou em jogos dinâmicos** e introduzir a proposta revolucionária do **Mirage**. Você deve prender a atenção do professor e da banca mostrando que o determinismo deixa os jogos chatos e previsíveis, e que a modelagem física contínua aliada a Algoritmos Genéticos é a solução para agentes com capacidade de adaptação real.

---

### 📚 Fundamentos Conceituais que Você Deve Dominar
1. **A Fragilidade dos NPCs Determinísticos Clássicos:**
   - **FSMs (*Finite State Machines*):** Máquinas de estados discretos (`PATROL`, `CHASE`, `EVADE`). São rígidas. O jogador rapidamente percebe: *"se eu atirar em determinado ângulo, o NPC sempre pula para a direita"*.
   - **Behaviour Trees (BTs):** Embora modulares, continuam sendo árvores de regras booleanas estáticas escritas por um designer humano.
   - **O Efeito Memorização:** O combate vira um quebra-cabeça fixo. O jogador não precisa se adaptar; basta decorar o padrão.

2. **A Proposta de Ruptura do Mirage:**
   - Trocar regras estáticas por um **sistema dinâmico contínuo fundamentado em leis da física**.
   - Em vez de escolher um estado discreto, o NPC computa **vetores de força em tempo real** no plano cartesiano bidimensional.
   - O NPC **aprende sozinho** a melhor combinação de atributos físicos (velocidade, vida, poder de fogo) para sobreviver em uma arena implacável através de Algoritmos Genéticos.

---

### 🧭 Como a FÍSICA Impacta Diretamente a sua Seção
Mesmo sendo o responsável pela introdução, a física é a sua maior aliada argumentativa:
- **Espaço Contínuo vs. Discreto:** Explique que o mundo real e os jogos de ação de alta fidelidade não funcionam em um grid discreto de tabuleiro de xadrez. A física do Mirage opera com vetores de posição $\vec{p} \in \mathbb{R}^2$ e velocidade $\vec{v} \in \mathbb{R}^2$ contínuos, integrados a $20\text{ Hz}$ com passo de tempo $\Delta t = 0.05\text{ s}$.
- **Dinâmica Newtons-Euler:** O NPC possui massa ($m = 1\text{ kg}$) e inércia. Ele não teletransporta; ele precisa aplicar força para acelerar e frear, respeitando os limites físicos de velocidade terminal impostos pelo seu genoma.

---

### 🧠 Sabatina da Banca: Perguntas Difíceis & Respostas Modelo

#### ❓ Pergunta 1: "Por que não usar árvores de decisão ou FSMs com um gerador de números aleatórios (`rand`) para quebrar o determinismo? Isso não resolveria o problema sem precisar de IA evolutiva?"
> **Sua Resposta:** *"Adicionar aleatoriedade estocástica a uma FSM ou árvore de decisão torna o inimigo imprevisível, mas **não o torna inteligente nem adaptado**. Um NPC com ruído aleatório frequentemente toma decisões absurdas, como pular na direção de uma bala ou colidir contra uma parede. No Mirage, não queríamos apenas que o NPC fosse imprevisível; queríamos que ele aprendesse a **estratégia ótima de preservação física**. O Algoritmo Genético associado à mecânica vetorial de Reynolds descobre trajetórias de escape ótimas no espaço contínuo que nenhum designer humano conseguiria prever ou codificar manualmente em uma FSM."*

#### ❓ Pergunta 2: "Qual é o passo temporal de integração física da arena e por que essa escolha é importante?"
> **Sua Resposta:** *"Utilizamos um passo temporal de integração fixo de $\Delta t = 0.05\text{ segundos}$, o que corresponde a uma taxa de amostragem física de $20\text{ Hz}$ e $50\text{ FPS}$ na visualização gráfica. Essa taxa é ideal porque garante a estabilidade numérica da integração de Euler semi-implícita — evitando que forças de repulsão causem saltos de posição anômalos — ao mesmo tempo em que permite executar centenas de simulações em modo headless em poucos segundos durante o treinamento evolutivo."*

#### ❓ Pergunta 3: "Se o NPC aprende com AG, ele está aprendendo online enquanto o jogador joga?"
> **Sua Resposta:** *"Excelente pergunta. O treinamento evolutivo do AG é realizado de forma simulada e offline, catalogando os melhores genomas no Skilled Experience Catalogue (SEC) e na matriz MAP-Elites. Durante a partida em tempo real, o jogo pode carregar instantaneamente o arquétipo mais apropriado para o nível de habilidade do jogador sem causar nenhum lag de processamento na CPU. No entanto, o Mirage também inclui o modo EDS (Evolutionary Dynamic Scripting), que permite mutações rápidas em tempo real se desejado."*

---

### 📝 Cartão de Bolso / Fórmulas Rápidas para Murilo Lameira
- **Arena:** $\Omega = [-20, 20] \times [-20, 20]\text{ metros}$ (fronteiras rígidas em $\pm 18\text{ m}$).
- **Passo Temporal:** $\Delta t = 0.05\text{ s}$ ($20\text{ Hz}$ física / $50\text{ FPS}$ gráfico).
- **Massa do NPC:** $m = 1.0\text{ kg}$ $\implies \vec{a} = \vec{F}$.
- **Conceito Chave:** Transição de IA Simbólica/Regras (FSM) $\to$ Sistemas Dinâmicos Contínuos & Computação Evolutiva.

---

# 🧬 MÓDULO 2: LEONARDO RETORI
### *Fundamentação Teórica, MAP-Elites, SEC e Operadores Genéticos*
**Tempo no Roteiro:** $3\text{min}00\text{s} \to 6\text{min}30\text{s}$ (Slides 4 a 6)

---

### 🎯 Sua Missão no Seminário
Você é o guardião da **ciência da computação evolutiva de ponta**. Seu papel é provar à banca que o grupo não se limitou a um algoritmo genético básico de livro didático. Você apresentará o **MAP-Elites (Kirk & Scirea, 2020)** para preservação de diversidade e classes comportamentais, o catálogo de marcos **SEC (Glavin & Madden, 2015)** para ajuste dinâmico de dificuldade, e detalhará a parametrização e operadores de reprodução implementados no Octave.

---

### 📚 Fundamentos Conceituais que Você Deve Dominar
1. **O Paradigma da Qualidade-Diversidade (MAP-Elites - Kirk & Scirea, 2020):**
   - Em problemas tradicionais de otimização, o AG busca um único indivíduo que maximize o fitness. Em jogos, isso é **péssimo**, pois gera um único "meta" chato e repetitivo.
   - O **MAP-Elites (*Multi-dimensional Archive of Phenotypic Elites*)** mantém um arquivo espacial discretizado em nichos fenotípicos. O Mirage utiliza uma matriz $3 \times 3$:
     - **Eixo Y (Mobilidade / Velocidade Máxima):** Lento ($< 4.5\text{ m/s}$), Médio ($4.5 \dots 6.5\text{ m/s}$), Rápido ($> 6.5\text{ m/s}$).
     - **Eixo X (Classe de Durabilidade / Razão $HP / Attack$):** Tanker ($HP/Atk > 3.0$), Balanceado ($1.0 \le ratio \le 3.0$), Glass Cannon ($ratio < 1.0$).
   - Cada célula guarda o campeão absoluto daquele nicho. O resultado é um portfólio rico com 9 estratégias viáveis!

2. **Skilled Experience Catalogue (SEC - Glavin & Madden, 2015):**
   - O simulador exporta checkpoints geracionais automáticos para `data/catalogo_sec.csv` aos $20\%$, $50\%$ e $100\%$ do treinamento.
   - Isso permite ao designer de jogos implementar **DDA (*Dynamic Difficulty Adjustment*)**: se o jogador for iniciante, o motor puxa um NPC do SEC aos $20\%$ de evolução; se for veterano, puxa o campeão de $100\%$.

3. **Operadores Genéticos do Mirage:**
   - **Seleção por Torneio ($k = 3$):** Sorteia 3 indivíduos aleatórios e escolhe o mais apto. Mantém a pressão seletiva calibrada e imune a discrepâncias de escala de fitness (ao contrário da roleta viciada).
   - **Crossover Uniforme:** Para cada um dos 4 genes, sorteia com probabilidade de $50\%$ se ele vem do Pai 1 ou do Pai 2. Recombina blocos construtivos com alta variabilidade.
   - **Mutação Gaussiana Normalizada com Transformada de Box-Muller:** Adiciona ruído estocástico $\Delta G \sim \mathcal{N}(0, \sigma^2)$ reescala proporcionalmente para respeitar o teto do orçamento de atributos.
   - **Modo EDS (Evolutionary Dynamic Scripting - Spronck et al., 2006):** Módulo de mutação pura sem crossover ($C_r = 0$, $M_r = 30\%$) para resposta e adaptação tática rápida.

---

### 🧭 Como a FÍSICA Impacta Diretamente a sua Seção
- **Espaço de Busca com Restrição de Conservação (Orçamento Físico):**
  A mutação e o crossover não podem gerar super-humanos. Quando um gene físico é mutado (ex: o NPC ganha $+2\text{ m/s}$ de velocidade), o operador em `src/mutation.m` recalcula a soma normalizada:
  $$u_i = \frac{G_i - G_i^{\text{min}}}{G_i^{\text{max}} - G_i^{\text{min}}}$$
  Se $\sum u_i > 1.8$, o algoritmo projeta o cromossomo de volta para a superfície do hiperplano simplex físico:
  $$u_i \leftarrow u_i \cdot \frac{1.8}{\sum u_k}$$
  Isso significa que **a física dita as fronteiras do espaço de busca genético**! O ganho de energia cinética (velocidade) exige necessariamente a perda de massa estrutural ($HP$) ou cadência de armas.

---

### 🧠 Sabatina da Banca: Perguntas Difíceis & Respostas Modelo

#### ❓ Pergunta 1: "Por que vocês escolheram Seleção por Torneio ($k=3$) em vez da clássica Roleta Proporcional de Aptidão (*Roulette Wheel Selection*)?"
> **Sua Resposta:** *"A Roleta Proporcional sofre de duas patologias graves: no início da evolução, se surgir um indivíduo moderadamente bom, ele terá uma fatia desproporcional da roleta, gerando super-dominação e **convergência prematura** para um ótimo local. No final da evolução, quando todos os indivíduos têm fitness parecidos, a roleta perde a pressão seletiva e vira uma amostragem quase aleatória. A **Seleção por Torneio com $k=3$** resolve isso porque depende apenas do ranking ordinal dos candidatos sorteados, mantendo uma pressão seletiva estável, rigorosa e independente de desvios de escala numérica."*

#### ❓ Pergunta 2: "Como o MAP-Elites difere de um Algoritmo Genético tradicional com elitismo simples?"
> **Sua Resposta:** *"No AG tradicional com elitismo, apenas o indivíduo de maior pontuação absoluta é preservado. Isso invariavelmente empurra toda a população para um único arquétipo dominante (geralmente o Ninja ultra-rápido). O **MAP-Elites**, fundamentado em Kirk & Scirea (2020), mapeia o espaço de características comportamentais em uma matriz $3 \times 3$ de nichos físicos. Se um indivíduo for um Tanker super-resistente com velocidade baixa, ele não concorre com o Ninja veloz; ele compete apenas dentro do nicho dele. Isso garante a descoberta e preservação simultânea de 9 arquétipos táticos distintos em uma única execução."*

#### ❓ Pergunta 3: "O que é o modo EDS e quando ele é ativado?"
> **Sua Resposta:** *"O EDS (Evolutionary Dynamic Scripting), baseado em Spronck et al. (2006), é o nosso modo de mutação pura sem crossover ($C_r = 0.0$ e $M_r = 0.30$). Ele é ideal para adaptação rápida em cenários onde a recombinação de dois pais distintos poderia quebrar uma cadeia de atributos altamente refinada. Usando ruído Gaussiano pela transformada de Box-Muller, o EDS faz uma busca local exploratória contínua ao redor da solução viável."*

---

### 📝 Cartão de Bolso / Fórmulas Rápidas para Leonardo Retori
- **MAP-Elites:** Matriz $3 \times 3$ (Mobilidade: Lento $<4.5$, Médio, Rápido $>6.5$ | Classe: Tank $HP/Atk > 3$, Balanceado $1 \le ratio \le 3$, Glass Cannon $ratio < 1$).
- **Seleção:** Torneio com tamanho $k=3$.
- **Crossover Uniforme:** Máscara booleana equiprovável de troca de genes.
- **SEC Checkpoints:** Exportação automática em $20\%$, $50\%$ e $100\%$ de $G_{\text{max}}$.
- **Artigos Chave:** Kirk & Scirea (IEEE CoG 2020), Glavin & Madden (IEEE ToG 2015), Spronck et al. (Machine Learning 2006).

---

# 🦾 MÓDULO 3: HENRY MATHEUS
### *Arquitetura Física, Genes e Equação de Fitness*
**Tempo no Roteiro:** $6\text{min}30\text{s} \to 10\text{min}00\text{s}$ (Slides 7 a 9)

---

### 🎯 Sua Missão no Seminário
Você é o **especialista do núcleo de física e formulação matemática** do projeto. Sua responsabilidade é apresentar a cinemática de esquiva preditiva (Reynolds e CPA de Lee), o cromossomo contínuo com a restrição do Orçamento Global de Atributos ($B = 1.8$), e detalhar a função de fitness multi-objetivo calibrada por nível de hostilidade física. Você demonstrará à banca o rigor matemático e a engenharia por trás de cada movimento do NPC.

---

### 📚 Fundamentos Conceituais que Você Deve Dominar
1. **Cálculo de CPA (*Closest Point of Approach*) e Evasão de Reynolds:**
   - Dominar de cabeça a dedução de $t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}$.
   - Saber explicar a força de direcionamento de Craig Reynolds: $\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$.
   - As 3 restrições para acionar a esquiva: $t_{\text{cpa}} \in (0, 1.5\text{s})$, aproximação com $\vec{p}_r \cdot \vec{v}_r < 0$ e distância crítica futura $< 2.5\text{ m}$.

2. **O Cromossomo Contínuo de 4 Genes:**
   - $G_1 = HP \in [10, 200]$ (pontos de integridade estrutural).
   - $G_2 = Attack \in [5, 50]$ (dano infligido por contra-ataque).
   - $G_3 = AttackSpeed \in [0.5, 3.0]\text{ Hz}$ (frequência de tiro).
   - $G_4 = MovementSpeed \in [1.0, 8.0]\text{ m/s}$ ($v_{\text{max}}$ cinemática).

3. **Orçamento Global de Atributos (*Point-Buy Budget*):**
   - A soma dos valores normalizados $u_i \in [0, 1]$ não pode ultrapassar o teto:
     $$\sum_{i=1}^4 u_i \le 1.8$$
   - Se o indivíduo tentar ter $100\%$ em tudo ($\sum u_i = 4.0$), o operador de projeção corta proporcionalmente todos os atributos. Isso elimina os "Super-NPCs" e força a especialização física!

4. **Função de Aptidão Multi-Objetivo (Fitness):**
   $$\text{Fitness} = \max\Big(0.1, \; w_1 T_{\text{survival}} + w_2 N_{\text{dodge}} + w_3 D_{\text{inflicted}} - p_1 N_{\text{collision}} - p_2 D_{\text{taken}}\Big)$$
   - **Fácil ($1$):** $w_1 = 2, w_2 = 2, w_3 = 0.20, p_1 = 2.0, p_2 = 0.1$.
   - **Médio ($2$):** $w_1 = 6, w_2 = 8, w_3 = 0.30, p_1 = 3.5, p_2 = 0.15$.
   - **Difícil ($3$):** $w_1 = 15, w_2 = 20, w_3 = 0.50, p_1 = 5.0, p_2 = 0.20$.
   - **Fator de Mérito do Difícil:** No modo Difícil, esquivar de uma bala em alta velocidade vale 10 vezes mais pontos ($w_2 = 20$) do que no modo Fácil ($w_2 = 2$).

---

### 🧭 Como a FÍSICA Impacta Diretamente a sua Seção
Você está imerso na física durante 100% da sua apresentação:
- **Penalidade de Precisão por Movimento Rápido:**
  No cálculo de dano infligido pelo NPC em `src/simulate_episode.m`, introduzimos uma lei de estabilidade de tiro:
  $$\text{accuracy} = \max\left(0.5, \; 1.0 - \left(\frac{\|\vec{v}_{\text{npc}}\|}{v_{\text{max}}}\right) \cdot 0.3\right)$$
  Se o NPC estiver correndo na velocidade limite para fugir de balas, sua mira sofre uma penalidade de até $30\%$. Isso cria uma tensão dinâmica real: atirar parado é mais letal, mas arrisca a vida; correr garante a sobrevivência, mas degrada a precisão do combate.

---

### 🧠 Sabatina da Banca: Perguntas Difíceis & Respostas Modelo

#### ❓ Pergunta 1: "Mostre a dedução matemática do CPA. Por que há um sinal negativo na fórmula $t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}$?"
> **Sua Resposta:** *"A distância quadrática entre NPC e projétil no futuro é dada por $D(t)^2 = \|\vec{p}_r + \vec{v}_r t\|^2 = \|\vec{p}_r\|^2 + 2(\vec{p}_r \cdot \vec{v}_r)t + \|\vec{v}_r\|^2 t^2$. Para achar o ponto de maior aproximação, derivamos em relação a $t$ e igualamos a zero: $2(\vec{p}_r \cdot \vec{v}_r) + 2\|\vec{v}_r\|^2 t = 0$. Isolando $t$, temos $t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}$. O sinal negativo surge do isolamento algébrico da equação da derivada. Fisicamente, quando dois corpos estão se aproximando, o produto escalar $\vec{p}_r \cdot \vec{v}_r$ é **estritamente negativo** (já que o vetor posição e a velocidade apontam em sentidos opostos). Portanto, o sinal de menos na frente anula esse valor negativo, garantindo um tempo futuro positivo ($t_{\text{cpa}} > 0$). Se o produto escalar fosse positivo, os corpos estariam se afastando e o tempo daria negativo, indicando que a máxima aproximação já ocorreu no passado."*

#### ❓ Pergunta 2: "O que acontece se um projétil colidir exatamente de frente com o centro do NPC? Como o código evita a divisão por zero no vetor de fuga?"
> **Sua Resposta:** *"Se o projétil estiver exatamente em rota de colisão frontal no instante $t_{\text{cpa}}$, o vetor de deslocamento projetado $\vec{d}_{\text{evade}} = \vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})$ é nulo ($\|\vec{d}_{\text{evade}}\| < 10^{-6}$). Para evitar uma indeterminação matemática ($\frac{0}{0}$), implementamos uma salvaguarda em `src/calculate_evade_force.m` que rotaciona o vetor velocidade do projétil em $90^\circ$: $\vec{d}_{\text{evade}} = [-v_{py}, \; v_{px}]$. Isso força o NPC a esquivar perpendicularmente à trajetória do tiro com aceleração lateral máxima."*

#### ❓ Pergunta 3: "Por que definir o orçamento global de atributos em $\sum u_i \le 1.8$ em vez de $2.0$ ou outro número qualquer?"
> **Sua Resposta:** *"Cada um dos 4 genes normalizados varia de $0.0$ a $1.0$. Portanto, o máximo teórico que um NPC poderia ter se não houvesse restrições seria $4.0$. Fixamos o orçamento em $1.8$, o que representa exatamente $45\%$ da capacidade máxima combinada. Em nossos testes preliminares com orçamento em $2.5$, o NPC conseguia maximizar velocidade e dano simultaneamente sem sacrificar vida quase nada. Com $1.8$, estabelecemos o ponto crítico de compromisso físico: para um indivíduo ter velocidade máxima ($u_4 = 1.0$, ou $8\text{ m/s}$), ele tem apenas $0.8$ restantes para dividir entre HP, Ataque e Cadência, forçando a seleção natural a escolher entre os arquétipos Ninja, Tanker ou Balanceado."*

---

### 📝 Cartão de Bolso / Fórmulas Rápidas para Henry Matheus
- **Fórmula do CPA:** $t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}$.
- **Steering Force:** $\vec{F}_{\text{evade}} = \vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$, com $\vec{v}_{\text{desejada}} = \frac{\vec{d}_{\text{evade}}}{\|\vec{d}_{\text{evade}}\|} \cdot v_{\text{max}}$.
- **Orçamento Global:** $\sum_{i=1}^4 u_i \le 1.8$ (equivalente a $45\%$ da pontuação máxima teórica).
- **Penalidade de Precisão:** $\text{accuracy} = \max(0.5, \; 1.0 - (v / v_{\text{max}}) \cdot 0.3)$.
- **Escalonamento de Fitness:** Fácil ($w_1=2, w_2=2$) vs. Difícil ($w_1=15, w_2=20$).

---

# 📊 MÓDULO 4: MURILO ROMUALDO
### *Arena Dinâmica, Balística, ANOVA, Demonstração e Fechamento*
**Tempo no Roteiro:** $10\text{min}00\text{s} \to 14\text{min}00\text{s}$ (Slides 10 a 15)

---

### 🎯 Sua Missão no Seminário
Você conduz o clímax e o fechamento da apresentação. Sua responsabilidade é apresentar a complexidade física da arena (pilares com absorção balística e padrões Danmaku), revelar o estudo de caso empírico de **Reward Hacking** superado pelo grupo, apresentar os resultados do treinamento paralelo com o critério de parada precoce de **Bhandari**, provar a validade científica do projeto com a **One-Way ANOVA ($p \ll 0.05$)**, exibir o GIF do NPC campeão e concluir o seminário com autoridade técnica.

---

### 📚 Fundamentos Conceituais que Você Deve Dominar
1. **Dinâmica Balística da Arena e Pilares de Cobertura:**
   - **4 Pilares de Absorção Rígidos:** Localizados em $(\pm 8, \pm 8)\text{ m}$ com raio $R = 1.3\text{ m}$. Absorvem e neutralizam projéteis inimigos, criando zonas de sombra balística.
   - **Restrição de Contato com Pilares:** O NPC não pode atravessar os pilares. O código cancela a componente normal da velocidade ($v_n = \vec{v} \cdot \hat{n} < 0$) e mantém a componente tangencial, gerando **deslizamento tangencial elástico (*Occlusion Steering*)**.
   - **Padrões de Bullet Hell:** Disparos direcionados com ruído, salvas em leque (*Shotgun Cone* com $\pm 12.6^\circ$) e vórtice espiral contínuo ($\omega = 4.5\text{ rad/s}$).

2. **Estudo de Caso Empírico: Combate ao Reward Hacking:**
   - **Fase 1 (O Exploit do Tanque):** No início, o peso do dano era alto. A IA descobriu que era melhor ficar parada no meio da arena, com HP máximo e sem desviar de nada, atirando sem parar.
   - **Fase 2 (O Exploit do Canhão de Vidro):** Ataque e cadência eram atributos livres, então todas as dificuldades convergiam para o mesmo NPC Ninja com dano no teto.
   - **A Solução:** Implementação do Orçamento Global de Atributos ($B = 1.8$), pesos balanceados na fitness e penalidade de estabilidade de tiro ao correr.

3. **Análise de Convergência e Critério de Parada Antecipada de Bhandari:**
   - Analisou 30 baterias independentes executadas em paralelo (`scripts/Rodar_Experimentos_Paralelos.ps1`).
   - Critério de Bhandari: se o melhor fitness não melhorar ao menos $\epsilon = 1\%$ nas últimas $K = 15$ gerações consecutivas, a simulação encerra prematuramente para economizar computação.
   - **Comportamento por Dificuldade:** Os modos Médio e Difícil convergiram e pararam antecipadamente na geração $\approx 21\text{ e }22$ devido ao elitismo forte e alto crossover ($75\%\dots 90\%$). O modo Fácil correu até a geração 50 devido à alta mutação ($15\%$) e ausência de elitismo.

4. **Validação Estatística Rigorosa (One-Way ANOVA & Testes $t$):**
   - **One-Way ANOVA:** $F = 138.24$, $p = 1.44 \times 10^{-15} \ll 0.05$.
   - **Interpretação:** Como $p \ll 0.05$, **rejeita-se categoricamente a hipótese nula ($H_0$)**. As diferenças de desempenho entre Fácil, Médio e Difícil **não foram fruto do acaso**, comprovando que a pressão ambiental física moldou genomas fenotipicamente distintos com significância estatística extrema!

---

### 🧭 Como a FÍSICA Impacta Diretamente a sua Seção
- **Hostilidade Balística Diferenciada:**
  A tabela de hostilidade física da arena dita a sobrevivência do agente:
  - Fácil: Projéteis lentos ($9\text{ m/s}$), esparsos ($1.4\text{s} \to 0.7\text{s}$) e imprecisos ($\sigma = 0.25$).
  - Médio: Projéteis balanceados ($11.5\text{ m/s}$), mais frequentes ($0.75\text{s} \to 0.22\text{s}$) e salvas em cone.
  - Difícil: Projéteis ultra-rápidos ($13.5\text{ m/s}$), cadência extrema ($0.30\text{s} \to 0.10\text{s}$), mira cirúrgica ($\sigma = 0.08$) e vórtice espiral contínuo ($\omega = 4.5\text{ rad/s}$).
- **Estatística da Física:** Os boxplots comprovam que no modo Difícil a seleção física exterminou qualquer indivíduo com velocidade inferior a $6.0\text{ m/s}$, enquanto no Fácil indivíduos com $3.0\text{ m/s}$ conseguiram sobreviver devido à brandura cinemática das ameaças.

---

### 🧠 Sabatina da Banca: Perguntas Difíceis & Respostas Modelo

#### ❓ Pergunta 1: "Vocês afirmam um p-valor de $1.44 \times 10^{-15}$ na ANOVA. Como ele foi calculado no código e o que esse número realmente significa?"
> **Sua Resposta:** *"No script `src/teste_estatistico_hipoteses.m`, calculamos a razão entre a Variância Entre Grupos ($MS_{\text{between}}$) e a Variância Dentro dos Grupos ($MS_{\text{within}}$), obtendo a estatística $F = 138.24$ com graus de liberdade $df_1 = 2$ e $df_2 = N_{\text{total}} - 3$. O $p$-valor exato foi obtido analiticamente integrando a cauda da distribuição $F$ através da função beta incompleta (`betainc`). Um $p$-valor da ordem de $10^{-15}$ está dezenas de ordens de magnitude abaixo do limiar padrão de $\alpha = 0.05$. Isso nos dá mais de $99.999999999999\%$ de certeza de que as trajetórias de adaptação dos NPCs em cada nível de dificuldade são estatisticamente independentes e regidas pelas exigências cinemáticas de cada arena."*

#### ❓ Pergunta 2: "Por que as curvas dos modos Médio e Difícil terminam por volta da geração 21 enquanto o Fácil foi até a geração 50 no gráfico comparativo?"
> **Sua Resposta:** *"Isso não foi um erro de execução, mas sim a prova viva do funcionamento do nosso **Critério de Parada Antecipada por Estagnação de Bhandari** com janela $K=15$ e tolerância $\epsilon=1\%$. Nos modos Médio e Difícil, a taxa de crossover é alta ($75\%$ a $90\%$) e há elitismo ($1$ a $3$ indivíduos). A população descobriu os genes ótimos de esquiva muito rapidamente (por volta da geração 6). Como o fitness permaneceu estagnado com melhora inferior a $1\%$ durante 15 gerações seguidas, o simulador interrompeu o treino na geração 21 para poupar ciclos de processamento da CPU. Já no modo Fácil, a taxa de mutação é extrema ($15\%$) e não há elitismo ($0$), impedindo que a população se estabilize e forçando o AG a explorar o espaço até o teto estipulado de 50 gerações."*

#### ❓ Pergunta 3: "Como funciona a mecânica dos pilares? Se o NPC ficar atrás do pilar, ele fica imune aos tiros?"
> **Sua Resposta:** *"Os 4 pilares em $(\pm 8, \pm 8)\text{ m}$ possuem raio de absorção balística de $1.6\text{ m}$. Se qualquer tiro atingir o pilar, ele é destruído imediatamente. Se o NPC se posicionar estrategicamente atrás do pilar em relação ao canhão atirador, ele ganha uma zona de sombra segura. Além disso, se o NPC tocar no pilar, nossa equação de restrição normal elástica cancela a velocidade perpendicular e preserva a velocidade tangencial, permitindo que ele contorne o obstáculo suavemente sem ficar travado."*

---

### 📝 Cartão de Bolso / Fórmulas Rápidas para Murilo Romualdo
- **ANOVA One-Way:** $F = 138.24$, $p = 1.44 \times 10^{-15} \ll 0.05$ (Rejeição total de $H_0$).
- **Parada de Bhandari:** Janela $K = 15$ gerações, $\epsilon = 1\%$ de melhoria.
- **Dificuldade vs. Parada:** Fácil $\to 50$ ger. | Médio $\to 21$ ger. | Difícil $\to 22$ ger.
- **Pilares de Cobertura:** 4 cilindros em $(\pm 8, \pm 8)\text{ m}$, raio $R=1.3\text{ m}$ (absorção balística em $1.6\text{ m}$).
- **Padrões Bullet Hell:** Tiro Linear com ruído $\sigma$, Shotgun Spread ($\pm 12.6^\circ$) e Vórtice Espiral ($\omega = 4.5\text{ rad/s}$).

---

# 📖 GLOSSÁRIO MESTRE DE VARIÁVEIS, CONSTANTES FÍSICAS E UNIDADES SI

Para evitar qualquer deslize de nomenclatura ou unidades durante a sabatina, use esta tabela como referência padronizada:

| Símbolo | Nome Técnico | Valor / Faixa | Unidade SI | Função no Mirage |
| :--- | :--- | :---: | :---: | :--- |
| $\Delta t$ | Passo Temporal de Integração | $0.05$ | $\text{s}$ (segundos) | Discretização temporal do simulador ($20\text{ Hz}$ / $50\text{ FPS}$). |
| $\Omega$ | Limite Espacial da Arena | $[-20, 20] \times [-20, 20]$ | $\text{m}$ (metros) | Plano cartesiano contínuo 2D de combate. |
| $m$ | Massa Inercial do Agente | $1.0$ | $\text{kg}$ (quilogramas) | Massa unitária para aplicação de Newton: $\vec{F} = m \vec{a} \implies \vec{a} = \vec{F}$. |
| $\vec{p}_{\text{npc}}, \vec{v}_{\text{npc}}$ | Posição e Velocidade do NPC | Contínuos | $\text{m}$ e $\text{m/s}$ | Vetores instantâneos de estado cinemático do agente. |
| $\vec{p}_p, \vec{v}_p$ | Posição e Velocidade do Tiro | Contínuos | $\text{m}$ e $\text{m/s}$ | Vetores instantâneos de estado cinemático do projétil. |
| $\vec{p}_r, \vec{v}_r$ | Vetores Relativos | $\vec{p}_p - \vec{p}_{\text{npc}}, \; \vec{v}_p - \vec{v}_{\text{npc}}$ | $\text{m}$ e $\text{m/s}$ | Base cinemática relativa para o cálculo analítico do CPA. |
| $t_{\text{cpa}}$ | Tempo até Maior Aproximação | $-\frac{\vec{p}_r \cdot \vec{v}_r}{\|\vec{v}_r\|^2}$ | $\text{s}$ (segundos) | Instante de tempo futuro de menor distância entre corpos. |
| $\vec{d}_{\text{evade}}$ | Vetor de Evasão Projetado | $\vec{p}_{\text{npc}}(t_{\text{cpa}}) - \vec{p}_p(t_{\text{cpa}})$ | $\text{m}$ (metros) | Direção perpendicular para onde o NPC deve acelerar para fugir. |
| $\vec{F}_{\text{evade}}$ | Força de Direcionamento | $\vec{v}_{\text{desejada}} - \vec{v}_{\text{npc}}$ | $\text{N}$ (Newtons) | Força de Reynolds para condução cinemática do NPC. |
| $r_{\text{hit}}$ | Raio da Hitbox do NPC | $1.0$ | $\text{m}$ (metros) | Área de impacto do corpo físico; toque causa $-25\text{ HP}$. |
| $R_{\text{radar}}$ | Raio do Radar Periférico | $4.0$ | $\text{m}$ (metros) | Área de detecção de perigo; tiro que sai sem tocar gera $+1\text{ Dodge}$. |
| $R_{\text{pillar}}$ | Raio dos Pilares Físicos | $1.3$ | $\text{m}$ (metros) | Raio dos 4 obstáculos rígidos localizados em $(\pm 8, \pm 8)\text{ m}$. |
| $B$ | Orçamento Global de Atributos | $1.8$ | Adimensional (Normalizado) | Teto da soma dos 4 atributos normalizados ($\sum u_i \le 1.8$). |
| $G_1 \; (HP)$ | Gene de Vida Máxima | $[10, 200]$ | Pontos de vida | Energia estrutural do NPC. |
| $G_2 \; (Attack)$ | Gene de Poder de Ataque | $[5, 50]$ | Dano base | Dano infligido por contra-ataque. |
| $G_3 \; (AtkSpeed)$ | Gene de Cadência de Disparo | $[0.5, 3.0]$ | $\text{Hz}$ ($\text{s}^{-1}$) | Frequência de contra-ataques do NPC. |
| $G_4 \; (MovSpeed)$ | Gene de Velocidade Máxima | $[1.0, 8.0]$ | $\text{m/s}$ | Velocidade terminal cinemática $v_{\text{max}}$. |
| $\omega$ | Velocidade Angular do Vórtice | $4.5$ | $\text{rad/s}$ | Taxa de rotação do padrão espiral no modo Difícil. |
| $F$ | Estatística F da ANOVA | $138.24$ | Adimensional | Razão de variâncias entre grupos vs dentro de grupos. |
| $p$ | P-valor de Significância | $1.44 \times 10^{-15}$ | Adimensional | Probabilidade de $H_0$ ser verdadeira ($p \ll 0.05 \implies$ Rejeição). |

---

## 🏁 DICAS FINAIS DE SUCESSO PARA A APRESENTAÇÃO

1. **Apresentação em Bloco e Confiança:** Quando um colega estiver falando, os outros três devem manter postura atenta, olhando para o apresentador ou para a banca. Isso transmite coesão e profissionalismo militar.
2. **Uso dos Termos Físicos e Matemáticos Corretos:** Substitua expressões informais como *"o NPC sai correndo"* por termos de engenharia: *"o NPC aplica uma força de direcionamento de Reynolds proporcional à velocidade terminal calibrada pelo seu gene de mobilidade"*. Isso eleva a nota de apresentação técnica imediatamente.
3. **Se um Integrante for Pressionado pela Banca:** Caso o professor faça uma pergunta muito difícil a um integrante e ele hesite, o integrante da área correlata pode entrar de forma educada: *"Complementando a resposta do Leonardo, sob a ótica da cinemática..."*. Isso mostra trabalho de equipe exemplar.

---
*Dossiê elaborado e revisado para o Projeto Mirage — Engenharia de Controle e Automação — UNISENAI 2026.*

