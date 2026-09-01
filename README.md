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
* **🧮 Fitness Multi-Objetivo Domiciliado:** Função de aptidão que se adapta às dificuldades (Fácil, Médio, Difícil), penalizando colisões severamente ou priorizando o tempo de sobrevivência e precisão.
* **🎯 MAP-Elites (Quality-Diversity):** Matriz tridimensional que força o surgimento de **diferentes classes fenotípicas** (Tanker, Balanceado, Glass Cannon) ao invés de buscar apenas um campeão absoluto.
* **📚 Skilled Experience Catalogue (SEC):** Módulo baseado na pesquisa de Glavin & Madden, que salva marcos de geração da IA para permitir **Ajuste Dinâmico de Dificuldade (DDA)** em aplicações de jogos reais.
* **💥 Evolutionary Dynamic Scripting (EDS):** Opcional "Modo Mutação Pura" validando as teses de adaptação imediata através do uso de ruídos Box-Muller (sem cruzamento).

---

## 📁 Estrutura de Diretórios Profissional

O repositório é projetado seguindo as melhores práticas de Engenharia de Software e Ciência de Dados:

```text
Mirage/
├── data/                       # 📊 Bancos de Dados CSV (Resultados, SEC, MAP-Elites)
├── src/                        # 🧠 Código-Fonte Octave/MATLAB (.m)
├── scripts/                    # ⚙️ Automação (.bat, .ps1) para testes paralelos 
├── logs/                       # 📝 Telemetria de background e stdout
└── Mirage Obsidian/            # 📚 Cofre completo de Documentação (Requer Obsidian)
```

---

## 🚀 Como Executar

Requisitos: O projeto foi construído para rodar de forma leve no **GNU Octave** (compatível com MATLAB).

1. **Modo Gráfico e Teste Rápido**
   * Vá até a pasta `scripts/` e execute o `Rodar_Simulador.bat`.
   * Selecione a Dificuldade e assista o NPC aprendendo a sobreviver à tempestade de tiros.

2. **Modo Headless Paralelo (Data Science)**
   * Para acelerar a obtenção de dados, execute o `Rodar_Experimentos_Paralelos.bat` na pasta `scripts/`.
   * O orquestrador em PowerShell abrirá 3 processos paralelos ocultos realizando $30$ treinamentos totais e salvará as matrizes de diversidade diretamente no `data/resultados_experimentos.csv`.
   * Ao finalizar, gráficos comparativos estatísticos serão renderizados automaticamente!

---

## 👥 Equipe de Desenvolvimento
* Leonardo Retori
* Henry Matheus
* Murilo Lameira
* Murilo Romualdo

*Desenvolvido em 2026 para a disciplina de Inteligência Artificial — Engenharia de Controle e Automação — UNISENAI.*
