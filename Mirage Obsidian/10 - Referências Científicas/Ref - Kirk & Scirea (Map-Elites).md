# 📚 Referência: Towards Diverse Non-Player Character behaviour discovery in multi-agent environments

- **Autores:** Jan Kirk e Marco Scirea
- **Instituição:** The Mærsk Mc-Kinney Møller Institute, University of Southern Denmark
- **Foco Temático:** Algoritmos de Qualidade-Diversidade (Quality-Diversity - QD) em NPCs.
- **Origem no Notebook:** `Towards_Diverse_Non-Player_Character.pdf`

## 🔍 Detalhamento Técnico e Metodologia do Artigo
O artigo aborda o desenvolvimento de comportamentos diversos de NPCs em ambientes multiagente usando o algoritmo **MAP-Elites** (Multi-dimensional Archive of Phenotypic Elites) de Mouret e Clune. A premissa central é que NPCs tradicionais (como FSMs) tornam-se repetitivos e previsíveis. O MAP-Elites resolve isso mapeando soluções em um espaço de características definidos pelo desenvolvedor, chamado **Espaço de Características (Feature Space)**.

### 🧬 Arquitetura de Genes e Espaço de Características (Feature Space)
O algoritmo avalia os indivíduos e os posiciona em um arquivo de elites estruturado como uma matriz multidimensional. No artigo, a matriz possui **resolução de 10**, resultando em uma grade tridimensional de **$10 \times 10 \times 10 = 1000$ nichos/comportamentos possíveis**.

O comportamento do NPC é avaliado em 3 dimensões (eixos do Espaço de Características):
1. **Tendência de Grupo (`group-tendency` - Codificação Direta):** Variável que dita a inclinação física do NPC de se aproximar ou se afastar de outros agentes.
2. **Tempo de Sobrevivência (`survival-time` - Codificação Indireta):** O tempo que o NPC resiste ativo em combate.
3. **Dano Total Causado (`total-damage` - Codificação Indireta):** Métrica de agressividade física e combate ofensivo.

### 🔄 Operadores de Seleção, Cruzamento e Mutação no MAP-Elites
- **Estratégia de Seleção:** Para gerar uma nova população, o algoritmo escolhe pais combinando a população atual e os elites arquivados (definindo 100 elites e 100 agentes jogadores ativos).
- **Operador de Cruzamento (Crossover):** Implementação de **Cruzamento de Dois Pontos (two-point crossover)**.
- **Operador de Mutação:**
  - Taxa de mutação configurada estritamente em **1% por gene** para prevenir colapsos caóticos ou mudanças drásticas na população.
  - Para garantir que a mutação ocorra de forma realista (sem saltos absurdos), utiliza-se a **Transformada de Box-Muller** para gerar ruído gaussiano (normalizado) ao redor do valor original do gene.

### 📈 Descobertas e Resultados Científicos
- Devido à natureza estocástica do ambiente de jogo, os autores provaram que são necessários pelo menos **100 episódios/partidas (sample-size = 100) por agente** para reduzir o ruído ambiental e representar com precisão o comportamento de esquiva/ataque no mapa de elites.
- Sob esse setup (100 gerações, sample-size 100), o genoma do NPC foi capaz de prever **40% de toda a variação de fitness** da população.
- Individualmente, o genoma previu o tempo de sobrevivência em **70%**, mas o dano causado (devido à aleatoriedade das colisões mecânicas de ataque) teve previsibilidade de apenas **9.4%**.

## 💡 Aplicação no Projeto S.E.N.A.I.
Essa referência valida o uso de algoritmos evolutivos para diversificar os comportamentos de esquiva. Justifica cientificamente o uso do nosso cromossomo de atributos para povoar a arena com táticas únicas (por exemplo, dividindo os NPCs em nichos de "esquiva rápida e frágil" vs "tanque de reação curta"), garantindo a não previsibilidade exigida pelo jogador.

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Cromossomo & Genes]]
- [[Parametrização Geral do GA]]