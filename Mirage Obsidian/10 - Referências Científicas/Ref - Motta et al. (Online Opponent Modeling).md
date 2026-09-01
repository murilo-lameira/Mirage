# 📚 Referência: An Online Adaptive Algorithm for Fighting Games

- **Autores:** Renan Motta G., Pinto G. A. e Fonseca Neto, R.
- **Instituição:** Pós-Graduação em Ciência da Computação, Universidade Federal de Juiz de Fora (UFJF), Brasil
- **Foco Temático:** Modelagem on-line de oponente, predição de ações em tempo real e seleção probabilística de contra-medidas.
- **Origem no Notebook:** `An Online Adaptive Algorithm for Fighting Games - SBGames`

## 🔍 Detalhamento Técnico e Metodologia do Artigo
Este trabalho propõe um controlador adaptativo de tempo real para jogos de luta construído sobre o simulador de código aberto **FightingICE** (plataforma oficial das competições internacionais de IA do IEEE Conference on Games). O algoritmo foi projetado para rodar em tempo real sob restrições físicas pesadas, em que a IA dispõe de uma **janela máxima de 16.67 ms (1 frame)** para tomar decisões táticas.

O algoritmo divide-se em duas etapas de processamento:

### 1. Modelagem e Análise Online do Oponente (Opponent Analysis)
A IA registra ativamente cada ataque desferido pelo oponente. Para cada tipo de ataque possível do inimigo, o sistema mantém:
- Um contador de frequência de uso acumulado.
- Um **vetor circular (circular array)** contendo as coordenadas das últimas posições em que o oponente se encontrava ao deflagrar o golpe.
- O sistema calcula de forma contínua a **média aritmética** e o **desvio padrão (standard deviation)** dessas coordenadas espaciais.
- A partir disso, o algoritmo define cientificamente a **Faixa de Utilização (Usage Range)** física daquele ataque específico do inimigo:

$$	ext{Nearest Position} = 	ext{Average Position} - 	ext{Standard Deviation}$$

$$	ext{Farthest Position} = 	ext{Average Position} + 	ext{Standard Deviation}$$

### 2. Escolha Probabilística de Contra-Medida (Choice of Countermeasure)
Quando o combate ocorre, o controlador lê a distância física instantânea entre os dois lutadores. Ele varre o banco de ataques do inimigo e filtra apenas aqueles cuja *Faixa de Utilização* engloba a distância atual.

A probabilidade $P_a$ de o oponente usar um determinado ataque $a$ é modelada como:

$$P_a = rac{	ext{Count}_a}{\sum_{i \in 	ext{Eligible}} 	ext{Count}_i}$$

#### O Mecanismo da Loteria Ponderada (Weighted Lottery):
Após calcular a probabilidade de cada ataque iminente do oponente, o algoritmo realiza um **sorteio probabilístico (loteria ponderada)** para selecionar qual golpe o inimigo deve disparar.
* **Justificativa de Engenharia:** Escolher probabilisticamente por sorteio ponderado — em vez de selecionar deterministicamente o ataque de maior probabilidade — é um requisito funcional obrigatório. Isso preserva a **variabilidade e a imprevisibilidade do NPC** (referenciando a teoria de dynamic scripting de Spronck), impedindo que o oponente humano descubra e explore um padrão fixo na nossa IA.

Uma vez predito o ataque do oponente via loteria, o NPC executa o melhor golpe de contra-medida contido em uma lista de prioridades pré-calculada empiricamente para obter vantagem física (esquivando-se do projétil ou contra-atacando).

### 📈 Resultados da Competição
O algoritmo foi validado na prestigiada competição **Fighting Game AI Competition no CIG 2014**, conquistando o **3º lugar mundial** na categoria de múltiplos personagens (3C), comprovando sua alta capacidade de aprendizado e velocidade de execução online em hardware modesto.

## 💡 Aplicação no Projeto S.E.N.A.I.
Essa referência valida o uso de modelos matemáticos reativos de distância para prever colisões. Ela serve como fundamentação científica para a nossa rotina de esquiva, provando que modelar o movimento com base em dados vetoriais de proximidade espacial e aplicar seleção estocástica impede que nossos NPCs se tornem previsíveis contra ataques do jogador.

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Simulação & Física de Esquiva]]
- [[Diário de Testes]]