# ⚙️ Parametrização Geral do Algoritmo Genético

O motor evolutivo do Mirage emprega operadores genéticos adaptados para variáveis contínuas em tempo real.

---

## 🧬 Operadores Evolutivos

### 1. Inicialização da População
* A população inicial é gerada aleatoriamente no espaço contínuo dos 4 genes, sujeita à regra de **Orçamento Global ($B = 1.8$)** implementada em `init_population.m`.
* Isso assegura que a geração $0$ contenha uma mistura equilibrada e diversificada de arquétipos (*ninjas, snipers, bruisers*).

### 2. Seleção por Torneio ($k = 3$)
* Em cada torneio, $k=3$ competidores são sorteados aleatoriamente da população. O indivíduo com maior pontuação de fitness vence e é admitido no pool reprodutivo.
* **Vantagem:** Evita a perda prematura de diversidade provocada por roletas de ranking desproporcionais e não requer normalização de fitness global a cada rodada.

### 3. Cruzamento Uniforme (Uniform Crossover)
* Dois pais selecionados combinam seu material genético com probabilidade $P_c \in [0.60, 0.90]$.
* Cada gene tem $50\%$ de chance de ser herdado do Pai 1 ou do Pai 2:
  $$c_1(g) = \begin{cases} p_1(g), & \text{se } \text{rand}() < 0.5 \\ p_2(g), & \text{caso contrário} \end{cases}$$

### 4. Mutação Gaussiana com Clamping de Orçamento
* Cada gene pode sofrer perturbação estocástica com probabilidade $P_m \in [0.01, 0.15]$:
  $$x_i \leftarrow x_i + \mathcal{N}(0, \sigma_i^2)$$
* **Correção Automática de Orçamento:** Imediatamente após a mutação, o cromossomo passa pela rotina de verificação de orçamento de $1.8$, garantindo que a mutação nunca gere indivíduos ilegais.

### 5. Elitismo Estrito ($N_e \in \{0, 1, 3\}$)
* Os $N_e$ melhores indivíduos da geração atual são clonados diretamente para a próxima geração sem sofrer crossover ou mutação, garantindo a preservação monótona da melhor estratégia já descoberta.

---

## 🔗 Conexões
- [[Configuração de Dificuldade]]
- [[Critério de Parada e Convergência]]
- [[Cromossomo & Genes]]
- [[00 - MOC Principal]]
