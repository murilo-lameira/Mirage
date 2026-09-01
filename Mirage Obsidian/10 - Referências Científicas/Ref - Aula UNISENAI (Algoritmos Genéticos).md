# 📚 Referência: Algoritmo Genético - Teoria e Aplicações Práticas

- **Autor:** Me. Ricardo Martinez Vicentini
- **Instituição:** Centro Universitário SENAI SP – UNISENAI (Campus São Caetano do Sul – Boa Vista)
- **Foco Temático:** Fundamentos de Algoritmos Genéticos, operadores de recombinação, taxas estocásticas e convergência de funções complexas.
- **Origem no Notebook:** `Algoritmo Genético.pdf`

## 🔍 Detalhamento Técnico do Material de Aula
A ementa didática do material cobre a introdução de algoritmos evolucionários, comparando métodos de busca determinísticos com heurísticas probabilísticas e globais baseadas na metáfora darwiniana de seleção natural. O documento foca na modelagem matemática de componentes essenciais do AG (Cromossomos binários, funções de aptidão, roletas de seleção, e trade-offs de operadores).

### 🧮 O Caso Prático: Otimização Numérica de Função Complexa
Para comprovar o funcionamento do AG, o professor expõe um exemplo clássico de otimização de uma superfície matemática bidimensional com picos e vales (máximos locais).

O objetivo matemático é maximizar a função de aptidão $g(x,y)$:

$$f(x,y) = \left| x \cdot y \cdot \sin\left(rac{y\pi}{4}
ight) 
ight|$$

#### Parâmetros de Controle Definidos para o Teste:
- **Tamanho da População:** 6 indivíduos.
- **Codificação Genética:** Cromossomos binários de **8 bits no total** (sendo **4 bits para codificar $x$** e **4 bits para codificar $y$**). Como cada variável possui 4 bits, os valores inteiros possíveis de pesquisa de $x$ e $y$ pertencem estritamente ao intervalo $[0, 15]$.
- **Taxa de Mutação ($P_m$):** Configurada em **1%**.
- **Critério de Parada:** Limite rígido de **100 gerações**.

#### A Dinâmica da Evolução Prática:
- No início (Geração 0), a população é gerada aleatoriamente. Por exemplo, o cromossomo `01000011` representa o indivíduo com características corporais $x=4$ e $y=3$, resultando em uma aptidão inicial baixa de $g(4,3) = 9.5$. Outro indivíduo inicial, `10011011` ($x=9, y=11$), alcança $g(9,11) = 71$. A avaliação geral média da população de partida soma **$144.6$**.
- O sistema realiza seleção por **Roleta Proporcional (Aptidão Direta)**, cruzando e aplicando a mutação binária de 1% ao longo das gerações.
- **Resultado de Convergência:** No slide de encerramento da simulação, comprova-se que ao atingir a 100ª geração, a dinâmica evolutiva convergiu perfeitamente a população para o **máximo global absoluto** em $x=15$ e $y=14$. Todos os 6 indivíduos idênticos portavam o cromossomo final `11111110`, alcançando a aptidão máxima de **$211$ por indivíduo** (soma total de avaliação da geração estável = **$1266$**).

### 🧠 Diretrizes Acadêmicas e Teóricas Estabelecidas no Slide:
O material elenca cinco axiomas fundamentais que devem guiar o desenho de qualquer AG:
1. **Importância dos Desfavorecidos:** Indivíduos com baixa aptidão instantânea podem carregar genes/características cruciais para a convergência global saudável do algoritmo no longo prazo; não devem ser extintos sumariamente.
2. **Efeito de Dupla Face da Mutação:** A mutação genética pode aumentar ou diminuir a aptidão do indivíduo (pode ser positiva ou negativa); ela atua como um salto probabilístico estocástico.
3. **Mecanismo de Escape:** A mutação é a única ferramenta capaz de resgatar uma população estagnada em um pico de ótimo local (máximo local).
4. **Calibração de Taxas:** Taxas de mutação excessivamente baixas aprisionam o algoritmo em ótimos locais precoces; taxas excessivamente altas (ex: acima de 15%) destroem o conhecimento acumulado pelas gerações, transformando o AG em uma busca aleatória caótica ineficiente.
5. **Trade-offs de População:** Populações pequenas convergem de forma prematura a máximos locais ruins; populações excessivamente grandes deixam o tempo de processamento computacional lento e inviável para aplicações em tempo real.

## 💡 Aplicação no Projeto S.E.N.A.I.
É a **âncora metodológica** do nosso projeto. Os picos matemáticos da função representam as estratégias de esquiva. A dinâmica de controle demonstrada em sala pelo professor Ricardo fornece a justificativa perfeita para embasar cientificamente o porquê de termos calibrado nossa população, crossover e mutação no MATLAB de forma escalonada para as dificuldades Fácil, Média e Difícil, usando exatamente os axiomas definidos em aula para provar a convergência do nosso simulador de NPCs.

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Parametrização Geral do GA]]
- [[Configuração de Dificuldade]]
