# 🌌 Mirage: Inteligência Artificial e Algoritmos Genéticos para NPCs Evasivos

![Status](https://img.shields.io/badge/Status-Concluído-success)
![Language](https://img.shields.io/badge/Language-Octave%20/%20MATLAB-blue)
![Topic](https://img.shields.io/badge/Topic-Artificial%20Intelligence-purple)
![Topic](https://img.shields.io/badge/Topic-Genetic%20Algorithms-orange)
![License](https://img.shields.io/badge/License-MIT-green)

**Mirage** é um simulador cinemático e de otimização comportamental desenvolvido para a disciplina de Inteligência Artificial da **UNISENAI**. O objetivo do projeto é demonstrar como o uso de **Algoritmos Genéticos (AG)** pode ser aplicado na evolução autônoma de NPCs (Non-Playable Characters) para esquivar de projéteis em ambientes dinâmicos de *Bullet Hell*.

---

## 🧠 Destaques Teóricos e Arquitetura

Este projeto consolida os fundamentos acadêmicos de algoritmos evolutivos combinados a abordagens modernas da academia:

* **🧬 Algoritmo Genético Clássico:** Operadores de Seleção por Torneio, Crossover Uniforme, Mutação Gaussiana e Elitismo.
* **⚖️ Orçamento Global (Point-Buy Budget):** Evita o *Reward Hacking* forçando *trade-offs* táticos (Velocidade e Esquiva vs. Dano e Cadência).
* **🏆 Escalonamento por Fator de Mérito:** Calibração proporcional da função de aptidão baseada na densidade do desafio, garantindo um sistema de pontuação justo onde a sobrevivência no modo Difícil concede patamares superiores aos modos Médio e Fácil ($\text{Difícil} > \text{Médio} > \text{Fácil}$).
* **📈 Suavização de Fitness Ruidoso (Noisy Fitness):** Rastreamento de aptidão histórica (`history_best_so_far`) para gerar curvas de convergência monotônicas (em degraus), eliminando oscilações causadas pela imprevisibilidade dos projéteis.
* **🎯 MAP-Elites (Quality-Diversity):** Matriz tridimensional que força o surgimento de **diferentes classes fenotípicas** (Tanker, Balanceado, Glass Cannon) ao invés de buscar apenas um campeão absoluto.
* **📚 Skilled Experience Catalogue (SEC):** Módulo baseado na pesquisa de Glavin & Madden, que salva marcos de geração da IA para permitir **Ajuste Dinâmico de Dificuldade (DDA)** em aplicações de jogos reais.
* **💥 Evolutionary Dynamic Scripting (EDS):** Opcional "Modo Mutação Pura" validando as teses de adaptação imediata através do uso de ruídos Box-Muller (sem cruzamento).

---

## 📁 Estrutura do Repositório

O repositório é projetado seguindo as melhores práticas de Engenharia de Software e Ciência de Dados:

```text
Mirage/
├── data/              # Bancos de dados CSV e gráficos gerados (.png)
├── src/               # Código-fonte Octave/MATLAB (.m)
├── scripts/           # Automação de testes em lote (.bat, .ps1)
├── logs/              # Telemetria e logs de execução dos workers
└── Mirage Obsidian/   # Cofre de documentação científica e guias (Obsidian)
```

---

## 🚀 Como Executar

> **Requisito:** O projeto é executado nativamente no **GNU Octave** (compatível com MATLAB).

### 1. Treinamento Solo Interativo
Execute o atalho `scripts/Rodar_Simulador.bat` (ou invoque `npc_evasivo_ga` no Octave). Escolha a dificuldade e assista ao treinamento completo com animação e gráfico de convergência final.

### 2. Treinamento em Lote Paralelo (*Headless Data Science*)
Para coletar massas de dados rapidamente sem travar a tela, execute `scripts/Rodar_Experimentos_Paralelos.bat`. O orquestrador dispara 3 instâncias em segundo plano, registrando a telemetria em `data/historico_geracoes.csv` e `data/resultados_experimentos.csv`.

### 3. Assistir à Arena 2D com o Melhor Campeão
Execute `scripts/Assistir_Melhor_NPC.bat` (ou `assistir_simulacao` no Octave). O sistema busca automaticamente o NPC mais adaptado no banco de dados e abre a simulação gráfica em tempo real (~50 FPS).

### 4. Gerar Gráficos e Análise Consolidada
Execute `scripts/Gerar_Todos_Graficos.bat` (ou `analise_evolucao_media` e `gerar_graficos_comparativos` no Octave). Todos os gráficos comparativos e a curva média de aprendizado por dificuldade serão exportados para `data/graficos/`.

---

## 📚 Documentação no Obsidian

Para um detalhamento completo dos fundamentos teóricos, equações de física, modelos científicos e comandos, consulte o cofre localizado na pasta `Mirage Obsidian/`, em especial o **Guia de Uso & Comandos**.

---

## 👥 Equipe de Desenvolvimento
* **Leonardo Retori**
* **Henry Matheus**
* **Murilo Lameira**
* **Murilo Romualdo**

*Orientador:* Me. Ricardo Martinez Vicentini  
*Desenvolvido em 2026 para a disciplina de Inteligência Artificial — Engenharia de Controle e Automação — UNISENAI.*
