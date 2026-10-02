# 🗺️ Mapeamento de Conteúdo (MOC) - Projeto Mirage com AG

Este cofre reúne toda a fundamentação científica, arquitetura de simulação e controle de experimentos do nosso projeto de **Inteligência Artificial aplicada ao comportamento evasivo de NPCs com Algoritmos Genéticos**.

---

## 🧬 Estrutura Geral do Cofre

### 10 - Referências Científicas
- [[Ref - Kirk & Scirea (Map-Elites)]]: Teoria de Qualidade-Diversidade (QD) e mapeamento fenotípico para evitar previsibilidade.
- [[Ref - Glavin & Madden (Skilled Experience Catalogue)]]: Marcos evolutivos off-line para o DDA (Ajuste Dinâmico de Dificuldade).
- [[Ref - NLR (Evolutionary Dynamic Scripting)]]: Utilização de Mutações Puras no lugar de Crossover para ajuste tático militar.
- [[Ref - Lee (KIOTS)]]: Otimização cinemática de esquiva por *Steering Behaviors* de Reynolds e cálculo de CPA.
- [[Ref - Sangav Menon (Maze Chase)]]: Arquitetura de software para controle genético adaptativo em jogos eletrônicos.
- [[Ref - Motta et al. (Online Opponent Modeling)]]: Técnicas de modelagem de oponentes adaptativas em tempo real.
- [[Ref - Aula UNISENAI (Algoritmos Genéticos)]]: Notas teóricas de base sobre o funcionamento dos operadores genéticos na academia.

### 15 - Biblioteca de Artigos Científicos (Íntegra)
- [[00 - MOC Biblioteca de Artigos]]: Catálogo central reunindo 13 obras científicas internacionais na íntegra, particionadas atômicas (< 200 linhas).

### 00 - Guias & Operação
- 🎨 [[Painel do Projeto.canvas|Painel Visual do Projeto (Canvas)]]: Mapa visual interativo do ecossistema Mirage.
- [[Guia de Uso & Comandos]]: Manual completo de operação, atalhos, comandos Octave e interpretação de gráficos.
- [[Backlog de Melhorias Futuras]]: Planejamento de melhorias avançadas (Validação Estatística ANOVA, Padrões Bullet Hell e Obstáculos).

### 20 - Arquitetura do Sistema
- [[Estrutura do Projeto & Diretórios]]: Organização das pastas `data/`, `src/`, `scripts/` e `logs/`.
- [[Cromossomo & Genes]]: Mapeamento físico dos 4 genes, limites dimensionais e sistema de **Orçamento Global (Point-Buy Budget)**.
- [[Função de Fitness]]: Equação multi-objetivo balanceada, matriz de pesos por dificuldade e penalidades de colisão.
- [[Simulação & Física de Esquiva]]: Integração cinemática 2D, detecção preditiva de projéteis e radar periférico.
- [[Arquitetura de Dados (Telemetria)]]: Documentação e estruturação dos 3 bancos de dados CSV (`resultados`, `sec`, `map_elites`).

### 30 - Parâmetros & Dificuldades
- [[Parametrização Geral do GA]]: Operadores evolutivos (Seleção por Torneio, Crossover Uniforme, Mutação Gaussiana e Elitismo).
- [[Configuração de Dificuldade]]: Calibração detalhada dos três níveis operacionais (Fácil, Médio, Difícil).
- [[Critério de Parada e Convergência]]: Critério de estagnação de Bhandari ($K$ gerações sem melhora) e estabilidade de variância.

### 40 - Experimentos & Resultados
- [[Diário de Testes]]: Registro consolidado das rodadas experimentais, telemetria de combate e curvas de evolução.
- [[O Problema da Convergencia Prematura]]: Estudo de caso sobre o *Reward Hacking* (o exploit do tanque) e o patch de balanceamento com Orçamento de Atributos.
- [[Execução Paralela & Análise Comparativa]]: Automação de 30 rodadas simultâneas (`Rodar_Experimentos_Paralelos.bat`) e gerador automático de gráficos.

### 60 - Artigo Científico
- [[00 - MOC Artigo Cientifico]]: Hub central de redação do short paper (5 páginas, padrão SBC/IEEE).
- [[Estrutura do Artigo (5 Paginas)]]: Planejamento seção a seção e orçamento rigoroso de espaço (IMRaD).
- [[Estudos de Ablaçao & Metodologia]]: Hipóteses formais de ablação (Budget e CPA) e métricas de QD.
- [[Workflow LaTeX no VS Code]]: Guia prático de ambiente, extensões e compilação LaTeX no VS Code.

---
*Projeto desenvolvido para a disciplina de Inteligência Artificial — Engenharia de Controle e Automação — UNISENAI.*


