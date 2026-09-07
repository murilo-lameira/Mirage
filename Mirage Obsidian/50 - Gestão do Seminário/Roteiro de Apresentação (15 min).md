# ⏱️ Roteiro Cronometrado de Apresentação (15 Minutos)

Script estruturado com marcações de tempo e falas sugeridas para o seminário.

---

## 🕒 Cronograma Geral

```
 0:00          3:00          6:30          10:00        14:00  15:00
  ├─────────────┼─────────────┼─────────────┼────────────┼──────┤
  │  Murilo L.  │  Leonardo   │    Henry    │ Murilo R.  │ FAQ  │
  │  Contexto   │ QD & Teoria │Física/Budget│ Experim.   │Banca │
```

---

## 🎙️ Bloco 1: Abertura e Contextualização ($0:00 \to 3:00$)
**Apresentador:** Murilo Lameira (Slides 1 a 3)

* **Fala Chave:** *"Boa noite aos membros da banca examinadora e ao professor orientador Ricardo Martinez Vicentini. Em jogos eletrônicos, quando os NPCs usam árvores de comportamento rígidas ou máquinas de estados determinísticas, o jogador rapidamente decora os padrões e o combate torna-se previsível. O projeto Mirage resolve isso aplicando Algoritmos Genéticos para criar inimigos virtuais que aprendem a desviar dinamicamente de projéteis em tempo real em um ambiente de Bullet Hell contínuo."*
* **Transição para Leonardo:** *"Para explicar como a literatura científica aborda a diversidade comportamental e os operadores evolutivos que impedem a IA de convergir para um único padrão previsível, passo a palavra ao Leonardo."*

---

## 🎙️ Bloco 2: Fundamentação e Operadores Genéticos ($3:00 \to 6:30$)
**Apresentador:** Leonardo Retori (Slides 4 a 6)

* **Fala Chave:** *"Baseado na pesquisa de Kirk e Scirea sobre MAP-Elites (Qualidade e Diversidade), nós não queremos apenas um 'NPC perfeito', mas sim manter múltiplos arquétipos fenotípicos vivos na população (como Tanques, Equilibrados e Ninjas Evasivos). Adotamos Seleção por Torneio com k=3 para controlar a pressão de seleção, Crossover Uniforme para recombinação de atributos e Mutações Gaussianas com ruído estocástico, além do catálogo SEC de Glavin & Madden para salvar marcos geracionais."*
* **Transição para Henry:** *"Agora o Henry Matheus vai detalhar a cinemática física da arena, a restrição de orçamento global e a formulação da função de fitness."*

---

## 🎙️ Bloco 3: Engenharia Física, Genes e Fitness ($6:30 \to 10:00$)
**Apresentador:** Henry Matheus (Slides 7 a 9)

* **Fala Chave:** *"Nossa física é baseada nos Steering Behaviors de Craig Reynolds e no cálculo do Ponto de Maior Aproximação (CPA). O NPC prevê onde a colisão ocorrerá no futuro e gera uma força de fuga perpendicular. O cromossomo contém 4 genes físicos com um Orçamento Global restrito a 1.8 pontos, o que impede a criação de Super-NPCs e força escolhas táticas. Na função de fitness, aplicamos o Escalonamento por Fator de Mérito, premiando a sobrevivência heróica no modo Difícil com notas superiores às do modo Fácil."*
* **Transição para Murilo R.:** *"O Murilo Romualdo vai apresentar as mecânicas avançadas da arena, a validação estatística com ANOVA e a demonstração prática do campeão."*

---

## 🎙️ Bloco 4: Dificuldades, Resultados e Conclusão ($10:00 \to 14:00$)
**Apresentador:** Murilo Romualdo (Slides 10 a 15)

* **Slide 10 — Arena 2D Dinâmica, Pilares de Cobertura e Bullet Hell:**
  *"Para testar a resiliência física do NPC, enriquecemos a arena com 4 pilares simétricos de absorção balística, além de disparos em cone e vórtices espirais. O agente precisa não apenas fugir dos tiros, mas utilizar a geometria do ambiente como escudo tático (Occlusion Steering)."*

* **Slide 11 — Estudo de Caso: Combate ao Reward Hacking:**
  *"Durante os testes iniciais, identificamos que o AG aprendeu um 'exploit': criar um tanque gigante e ficar parado tomando tiros. Eliminamos essa anomalia introduzindo o Orçamento Global de Atributos, obrigando o cromossomo a trocar vida por agilidade de esquiva."*

* **Slide 12 — Mitigação de Ruído Estocástico (Noisy Fitness):**
  *"Em ambientes balísticos dinâmicos, a avaliação de um único indivíduo é ruidosa: um NPC medíocre pode ter sorte e sobreviver por desvio acidental. Para garantir rigor científico, desenvolvemos um módulo de rastreamento do melhor histórico global, convertendo oscilações estocásticas em curvas de aprendizado monotônicas."*

* **Slide 13 — Curva Média Consolidada & Critério de Parada Antecipada (Bhandari):**
  *"Executamos baterias paralelas no Octave com cerca de 30 rodadas por dificuldade. Como vemos neste gráfico consolidado de 50 gerações:*
  * *No **Modo Difícil (linha vermelha)**, graças ao crossover alto (90%) e à preservação dos 3 melhores elites, o NPC aprende rápido e estabiliza em ~1770 pontos. O critério de estagnação de Bhandari encerra a execução aos 21 passos porque detectou que a população já convergiu plenamente (15 gerações sem ganho > 1%), economizando tempo e poder de processamento.*
  * *No **Modo Médio (linha azul)**, ocorre o mesmo fenômeno na geração 22, estabilizando no platô de ~880 pontos.*
  * *Já no **Modo Fácil (linha verde)**, configuramos intencionalmente uma mutação altíssima de 15% e sem elitismo. Por ser caótico e não estagnar, ele explora continuamente o espaço de busca até atingir o teto de 50 gerações."*

* **Slide 14 — Validação Estatística Rigorosa (ANOVA & Boxplots):**
  *"Submetemos todas as baterias à Análise de Variância (One-Way ANOVA). Com F = 138.24 e p-valor = 1.44 x 10^-15 (muito menor que 0.05), comprovamos matematicamente que as estratégias evoluídas para cada dificuldade são completamente distintas, reproduzíveis e estatisticamente significantes."*

* **Slide 15 — Conclusões, Engenharia de Software e Trabalhos Futuros:**
  *"O Mirage comprova a viabilidade de usar Computação Evolutiva e MAP-Elites para gerar comportamentos de NPCs adaptativos, imprevisíveis e leves em jogos de tempo real. Todo o código-fonte, dados e documentação modular estão abertos sob licença MIT."*

---

## 🎙️ Bloco 5: Perguntas da Banca / FAQ ($14:00 \to 15:00$)
* Espaço aberto para a banca examinadora e orientador Me. Ricardo Martinez Vicentini.

---

## 🔗 Conexões
- [[Divisão de Tarefas & Apresentadores]]
- [[Dossiê Completo do Seminário]]
- [[00 - MOC Principal]]
