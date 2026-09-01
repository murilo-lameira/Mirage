# 📚 Referência: Evolutionary Dynamic Scripting: Adaptation of Expert Rule Bases for Serious Games

- **Autores:** R. Kop, A. Toubman, M. Hogendoorn e J.J.M. Roessingh
- **Instituição:** National Aerospace Laboratory NLR, Amsterdã, Holanda (Relatório NLR-TP-2015-146)
- **Foco Temático:** Fusão de algoritmos evolutivos (Programação Genética) com aprendizado por reforço (Dynamic Scripting).
- **Origem no Notebook:** `TP-2015-146.pdf`

## 🔍 Detalhamento Técnico e Metodologia do Artigo
O trabalho apresenta o algoritmo **Evolutionary Dynamic Scripting (EDS)**. Ele foi criado para automatizar a geração de regras de comportamento em simuladores militares complexos, reduzindo a dependência de especialistas de domínio e evitando a estagnação típica de agentes que exploram as falhas do jogo sem restrições lógicas.

### 🔄 A Estrutura do Loop Principal (EDS Loop)
O EDS encapsula o algoritmo de **Dynamic Scripting (DS)** (que prioriza regras existentes) dentro de uma casca de **Programação Genética (GP)** (que sintetiza novas regras).

```text
Algoritmo 1: EDS Loop
1: rule_base <- initial_rule_base
2: results <- array[max_episodes]
3: for generation <- 1 to max_generation do
4:     for episode <- 1 to max_episode do
5:         results[episode] <- perform_DS(rule_base)
6:     fitness <- evaluate_fitness(results)
7:     rule_base <- evolve(rule_base, fitness)  // Componente de GP
```

### 🧬 Componente de Programação Genética (GP) e Estrutura de Árvore
As regras de comportamento de voo e combate são representadas formalmente como **estruturas de árvore sintática (syntax trees)**.

```text
Algoritmo 2: Componente de Evolução (GP)
1: while child_num < max_children do
2:     parents <- select_parents(rule_base, fitness) // Seleção Proporcional à Aptidão (FPA)
3:     if random() < prob_crossover do
4:         children <- crossover(parents)  // Subtree Crossover
5:     else
6:         children <- mutate(parents)     // Métodos de Mutação
7:     for child in children do
8:         rule_base <- survivors(rule_base + child) // Eliminação Determinística do Pior
```

#### Operadores Genéticos do EDS:
1. **Seleção de Pais:** Feita via seleção proporcional à aptidão (Roleta tradicional). Selecionam-se dois pais por ciclo.
2. **Subtree Crossover:** Troca subárvores aleatórias entre os dois pais. Cada subárvore tem probabilidade de seleção de $p = 1/n$, onde $n$ é o número de expressões na regra.
3. **Mutações (Três métodos com probabilidade igual de 1/3 cada):**
   - **Point Mutation (Mutação de Ponto):** Cada expressão na regra tem probabilidade de $1/n$ de se transformar em outra expressão aleatória válida.
   - **Subtraction Mutation (Mutação de Subtração):** Remove uma subárvore inteira da regra sintática.
   - **Addition Mutation (Mutação de Adição):** Insere uma nova subárvore, gerada aleatoriamente a partir de uma **gramática formal estrita** ou reaproveitada do buffer de subtrações. A gramática impede regras logicamente absurdas (como "atirar míssil em um aliado").
4. **Seleção de Sobreviventes:** Sempre que um filho é inserido, aplica-se uma seleção de sobrevivência estritamente determinística: **a regra com a menor aptidão na base é deletada**.

### 📈 Cenário de Teste e Resultados de Voo
- **Setup:** Simulação de combate aéreo tático na proporção 2v1 (dois caças azuis contra um caça vermelho).
- **Parâmetros:** 30 gerações, 10 episódios de aprendizado de DS por geração, e 50 confrontos físicos por episódio.
- **Descoberta Crítica:** Os autores observaram empiricamente que **gerar novas regras utilizando apenas o operador de mutação superou o uso combinado de cruzamento e mutação**. A mutação pura focou na exploração e refinamento fino das subregras sem desestruturar a lógica de combate consolidada.
- **Resultado:** O EDS gerou de forma autônoma regras simplificadas e especializadas que superaram significativamente o Dynamic Scripting tradicional em 4 das 6 táticas aéreas inimigas.

## 💡 Aplicação no Projeto Mirage
Esta referência fundamenta o uso de operadores genéticos para alterar o comportamento de NPCs. Ela fornece a base de engenharia de software para demonstrar como operadores estocásticos (como mutações controladas por gramáticas físicas de velocidade/ângulo) podem reescrever comportamentos evasivos sem gerar ações inválidas na arena.

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Parametrização Geral do GA]]
- [[Critério de Parada e Convergência]]