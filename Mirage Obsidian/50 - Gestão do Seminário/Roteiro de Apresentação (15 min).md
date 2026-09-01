# ⏱️ Roteiro Cronometrado de Apresentação (15 Minutos)

Script estruturado com marcações de tempo e falas sugeridas para o seminário.

---

## 🕒 Cronograma Geral

```
 0:00          3:00          6:30          10:00        14:00  15:00
  ├─────────────┼─────────────┼─────────────┼────────────┼──────┤
  │  Leonardo   │    Henry    │  Murilo L.  │ Murilo R.  │ FAQ  │
  │  Contexto   │ QD & Teoria │Física/Budget│ Experim.   │Banca │
```

---

## 🎙️ Bloco 1: Abertura e Contextualização ($0:00 \to 3:00$)
**Apresentador:** Leonardo Retori (Slides 1 a 3)

* **Fala Chave:** *"Boa noite a todos. Em jogos eletrônicos, quando os NPCs usam árvores de comportamento rígidas, o jogador rapidamente decora os padrões e o jogo perde a graça. O nosso projeto, Mirage, resolve isso aplicando Algoritmos Genéticos para criar inimigos virtuais que aprendem a desviar ativamente dos ataques do jogador."*
* **Transição para Henry:** *"Para explicar como a literatura científica aborda a diversidade comportamental para evitar esse problema, passo a palavra ao Henry."*

---

## 🎙️ Bloco 2: Fundamentação e Operadores Genéticos ($3:00 \to 6:30$)
**Apresentador:** Henry Matheus (Slides 4 a 6)

* **Fala Chave:** *"Baseado no trabalho de Kirk e Scirea sobre MAP-Elites, não queremos apenas um 'inimigo perfeito', mas sim manter diversidade comportamental. Usamos Seleção por Torneio para proteger a população de super-indivíduos precoces, Crossover Uniforme e Mutação Gaussiana com controle rigoroso."*
* **Transição para Murilo L.:** *"Agora o Murilo Lameira vai mostrar como estruturamos a física de esquiva e a equação matemática de fitness."*

---

## 🎙️ Bloco 3: Engenharia Física, Genes e Fitness ($6:30 \to 10:00$)
**Apresentador:** Murilo Lameira (Slides 7 a 9)

* **Fala Chave:** *"Nossa física é baseada nos Steering Behaviors de Craig Reynolds e no trabalho de Lee. O NPC calcula o Ponto de Maior Aproximação (CPA) do projétil e aplica esquiva perpendicular. Nosso cromossomo possui 4 genes com um sistema de Orçamento Global de 1.8 pontos, o que impede que o NPC seja perfeito em tudo e força o surgimento de arquétipos táticos."*
* **Transição para Murilo R.:** *"O Murilo Romualdo vai apresentar os parâmetros de dificuldade, o estudo de caso do balanceamento e os gráficos de convergência."*

---

## 🎙️ Bloco 4: Dificuldades, Resultados e Conclusão ($10:00 \to 14:00$)
**Apresentador:** Murilo Romualdo (Slides 10 a 14)

* **Fala Chave:** *"Calibramos três dificuldades: no Fácil, o NPC é um atacante lento; no Difícil, a arena se torna um Bullet Hell e a evolução gera um Ninja Evasivo de alta velocidade. Durante os testes, detectamos dois problemas clássicos de Reward Hacking nos dados do CSV e solucionamos com o Orçamento Global e pesos proporcionais. Rodamos 30 testes em paralelo no Octave comprovando a convergência matemática estável."*

---

## 🎙️ Bloco 5: Perguntas da Banca / FAQ ($14:00 \to 15:00$)
* Espaço aberto para a banca examinadora e orientador Me. Ricardo Martinez Vicentini.

---

## 🔗 Conexões
- [[Divisão de Tarefas & Apresentadores]]
- [[Dossiê Completo do Seminário]]
- [[00 - MOC Principal]]
