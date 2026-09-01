# 📚 Referência: Adaptive NPC Behavior in Maze Chase Game Using Genetic Algorithms

- **Autor:** Sangav Menon
- **Instituição:** The College of Wooster (Senior Thesis)
- **Foco Temático:** Estruturação de loops genéticos e controle de comportamento adaptativo em jogos eletrônicos.

---

## 🔍 Resumo Científico
Este trabalho descreve a implementação de um Algoritmo Genético clássico para adaptar o comportamento de NPCs em jogos de perseguição (*maze chase*). O diferencial científico é a exposição detalhada da engenharia de software do projeto, ilustrando como o loop genético é acoplado ao motor de física.

O autor divide a estrutura do AG em três classes de programação principais:
1. `GeneticController`: Responsável por rodar o loop de simulação e calcular a fitness das partidas.
2. `GeneticData`: Armazena os dados estatísticos de convergência e telemetria.
3. `Genome`: Representa a cadeia de cromossomos dos indivíduos.

A função de fitness é baseada no tempo de sobrevivência ativa e eficácia das ações sob pressão de perigo.

---

## 💡 Conexão com o Nosso Projeto (Mirage)
Esta obra serve como o nosso **modelo de arquitetura de código**. Ela nos dá a base para estruturar a integração do nosso simulador no Octave e no VS Code, definindo como o controlador genético deve instanciar a arena física de esquiva, coletar telemetria e reiniciar os ciclos evolutivos de forma limpa.

---

## 🔗 Conexões (Obsidian)
- [[00 - MOC Principal]]
- [[Parametrização Geral do GA]]
- [[Critério de Parada e Convergência]]
- [[Simulação & Física de Esquiva]]

