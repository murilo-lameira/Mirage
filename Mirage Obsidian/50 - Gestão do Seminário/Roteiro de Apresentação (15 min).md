# ⏱️ Roteiro Cronometrado de Apresentação (15 Minutos)

Script estruturado com marcações de tempo e falas sugeridas para o seminário.

---

## 🕒 Cronograma Geral

```
 0:00          3:00          6:30          10:00        14:00  15:00
  ├─────────────┼─────────────┼─────────────┼────────────┼──────┤
  │  Murilo L.  │    Henry    │  Leonardo   │ Murilo R.  │ FAQ  │
  │  Contexto   │ QD & Teoria │Física/Budget│ Experim.   │Banca │
```

---

## 🎙️ Bloco 1: Abertura e Contextualização ($0:00 \to 3:00$)
**Apresentador:** Murilo Lameira (Slides 1 a 3)

* **Fala Chave:** *"Boa noite aos membros da banca examinadora e ao professor orientador Ricardo Martinez Vicentini. Em jogos eletrônicos, quando os NPCs usam árvores de comportamento rígidas ou máquinas de estados determinísticas, o jogador rapidamente decora os padrões e o combate torna-se previsível. O projeto Mirage resolve isso aplicando Algoritmos Genéticos para criar inimigos virtuais que aprendem a desviar dinamicamente de projéteis em tempo real em um ambiente de Bullet Hell contínuo."*
* **Transição para Henry:** *"Para explicar como a literatura científica aborda a diversidade comportamental e os operadores evolutivos que impedem a IA de convergir para um único padrão previsível, passo a palavra ao Henry."*

---

## 🎙️ Bloco 2: Fundamentação e Operadores Genéticos ($3:00 \to 6:30$)
**Apresentador:** Henry Matheus (Slides 4 a 6)

* **Fala Chave:** *"Baseado na pesquisa de Kirk e Scirea sobre MAP-Elites (Qualidade e Diversidade), nós não queremos apenas um 'NPC perfeito', mas sim manter múltiplos arquétipos fenotípicos vivos na população (como Tanques, Equilibrados e Ninjas Evasivos). Adotamos Seleção por Torneio com k=3 para controlar a pressão de seleção, Crossover Uniforme para recombinação de atributos e Mutações Gaussianas com ruído estocástico, além do catálogo SEC de Glavin & Madden para salvar marcos geracionais."*
* **Transição para Leonardo:** *"Agora o Leonardo Retori vai detalhar a cinemática física da arena, a restrição de orçamento global e a formulação da função de fitness."*

---

## 🎙️ Bloco 3: Engenharia Física, Genes e Fitness ($6:30 \to 10:00$)
**Apresentador:** Leonardo Retori (Slides 7 a 9)

* **Fala Chave:** *"Nossa física é baseada nos Steering Behaviors de Craig Reynolds e no cálculo do Ponto de Maior Aproximação (CPA). O NPC prevê onde a colisão ocorrerá no futuro e gera uma força de fuga perpendicular. O cromossomo contém 4 genes físicos com um Orçamento Global restrito a 1.8 pontos, o que impede a criação de Super-NPCs e força escolhas táticas. Na função de fitness, aplicamos o Escalonamento por Fator de Mérito, premiando a sobrevivência heróica no modo Difícil com notas superiores às do modo Fácil."*
* **Transição para Murilo R.:** *"O Murilo Romualdo vai apresentar as mecânicas avançadas da arena, a validação estatística com ANOVA e a demonstração prática do campeão."*

---

## 🎙️ Bloco 4: Dificuldades, Resultados e Conclusão ($10:00 \to 14:00$)
**Apresentador:** Murilo Romualdo (Slides 10 a 14)

* **Fala Chave:** *"A arena foi enriquecida com 4 pilares físicos de cobertura que absorvem projéteis e padrões compostos de disparo em leque e vórtice espiral. Para comprovar a reprodutibilidade acadêmica, automatizamos 32 baterias em paralelo no Octave e eliminamos o ruído de fitness com curvas de convergência monotônicas. Aplicamos a One-Way ANOVA, que comprovou com F = 138.24 e p = 1.44 x 10^-15 que as estratégias evoluídas para cada dificuldade são estatisticamente distintas e significantes."*

---

## 🎙️ Bloco 5: Perguntas da Banca / FAQ ($14:00 \to 15:00$)
* Espaço aberto para a banca examinadora e orientador Me. Ricardo Martinez Vicentini.

---

## 🔗 Conexões
- [[Divisão de Tarefas & Apresentadores]]
- [[Dossiê Completo do Seminário]]
- [[00 - MOC Principal]]
