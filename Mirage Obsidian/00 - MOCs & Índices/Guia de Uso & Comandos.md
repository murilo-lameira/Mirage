# 📖 Guia de Uso, Comandos & Manual Operacional do Simulador Mirage

Este documento é o guia definitivo para operadores, pesquisadores e desenvolvedores do projeto **Mirage**. Aqui estão descritos todos os comandos, rotinas de execução, atalhos de automação e interpretação de dados da aplicação.

---

## ⚡ 1. Visão Geral das Formas de Execução

O sistema foi desenhado de forma modular, permitindo 4 fluxos principais de utilização:

| Modo de Uso | Finalidade | Arquivo Launcher | Arquivo Octave |
| :--- | :--- | :--- | :--- |
| **1. Simulador Interativo** | Treinar 1 rodada com menu visual, gráfico no final e combate ao vivo | `scripts/Rodar_Simulador.bat` | `src/npc_evasivo_ga.m` |
| **2. Treinamento em Lote (Batch)** | Treinar N rodadas em segundo plano (rápido e sem interface travando) | `scripts/Rodar_Experimentos_Paralelos.bat` | `src/run_batch_experiment.m` |
| **3. Assistir Campeão ao Vivo** | Carregar o melhor NPC do banco de dados e assistir na arena 2D em tempo real | `scripts/Assistir_Melhor_NPC.bat` | `src/assistir_simulacao.m` |
| **4. Central de Gráficos e Análise** | Gerar gráficos comparativos, médias e mapa de calor MAP-Elites | `scripts/Gerar_Todos_Graficos.bat` | `src/gerar_graficos_comparativos.m`<br>`src/analise_evolucao_media.m`<br>`src/gerar_heatmap_map_elites.m` |
| **5. Gerador de GIF Animado** | Gravar 6 segundos de combate do campeão em GIF para documentação e README | `scripts/Gerar_GIF_Animado.bat` | `src/gerar_gif_animado.m` |

---

## 🛠️ 2. Como Usar Cada Módulo

### 🎮 A. Treinamento Solo Interativo (`npc_evasivo_ga.m`)
Ideal para demonstrações rápidas ou testes de calibração interativa.

- **Como Rodar:**
  - **Opção 1 (Atalho):** Duplo clique em `scripts/Rodar_Simulador.bat`.
  - **Opção 2 (Octave GUI/CLI):** No console do Octave, digite:
    ```matlab
    addpath('src');
    npc_evasivo_ga;
    ```
- **Fluxo de Execução:**
  1. Abre uma caixa de diálogo solicitando o nível de dificuldade (**Fácil**, **Médio** ou **Difícil**).
  2. Executa as gerações do Algoritmo Genético reportando o progresso no console.
  3. Exibe o gráfico de convergência de fitness daquela rodada.
  4. Inicia a arena gráfica 2D exibindo o NPC campeão desviando dos projéteis em tempo real com HUD aprimorada (rastro, barra de vida dinâmica, vetor de esquiva de Reynolds e contra-ataques visíveis).

---

### 🚀 B. Execução em Lote Paralelo (`run_batch_experiment.m`)
Ideal para coletar massas de dados para testes estatísticos e relatórios.

- **Como Rodar:**
  - **Opção 1 (Atalho):** Duplo clique em `scripts/Rodar_Experimentos_Paralelos.bat` (dispara 3 instâncias simultâneas do Octave, uma para cada dificuldade, treinando 10 rodadas cada).
  - **Opção 2 (Linha de Comando / PowerShell):**
    ```powershell
    .\scripts\Rodar_Experimentos_Paralelos.ps1 -NumRuns 15
    ```
  - **Opção 3 (Chamada Direta no Octave):**
    ```matlab
    addpath('src');
    run_batch_experiment(2, 10, false); % 10 rodadas no Médio
    ```
- **O que ele faz:**
  - Desativa a interface gráfica para máxima velocidade de processamento (*Headless*).
  - Salva automaticamente os gráficos individuais de cada rodada em `data/graficos/rodadas/`.
  - Registra a telemetria nos arquivos `.csv` de forma concorrente e segura (*thread-safe*).

---

### 👁️ C. Assistir à Simulação do Melhor NPC (`assistir_simulacao.m`)
Ideal para visualização imediata da performance da IA sem precisar esperar novas gerações serem treinadas.

- **Como Rodar:**
  - **Opção 1 (Atalho):** Duplo clique em `scripts/Assistir_Melhor_NPC.bat`.
  - **Opção 2 (Octave GUI/CLI):**
    ```matlab
    addpath('src');
    assistir_simulacao;
    ```
- **Recursos Visuais da Arena:**
  - **Rastro de Movimento (Motion Trail):** Linhas pontilhadas azuis destacando a trajetória recente.
  - **Barra de Vida Gráfica:** Barra sobre o NPC que muda de cor (Verde $\rightarrow$ Amarela $\rightarrow$ Vermelha).
  - **Vetor de Força de Esquiva:** Seta verde em tempo real mostrando a direção da força calculada por Reynolds.
  - **Projéteis do NPC:** Tiros azuis/ciano disparados em resposta a ameaças.

---

### 📊 D. Geração de Gráficos e Análise de Dados
Gera todo o material visual consolidado para artigos, relatórios e documentação técnica.

- **Como Rodar:**
  - **Opção 1 (Atalho):** Duplo clique em `scripts/Gerar_Todos_Graficos.bat`.
  - **Opção 2 (Octave GUI/CLI):**
    ```matlab
    addpath('src');
    gerar_graficos_comparativos;  % Gráficos de Genes e Fitness
    analise_evolucao_media;       % Curva média de aprendizado consolidado
    gerar_heatmap_map_elites;     % Grade 3x3 do MAP-Elites
    ```
- **Gráficos Gerados em `data/graficos/`:**
  1. **`comparativo_genes.png`:** Gráficos de barras comparando os fenótipos médios entre as 3 dificuldades.
  2. **`comparativo_fitness.png`:** Relação entre o Fitness Máximo dos campeões e o Fitness Médio das populações.
  3. **`evolucao_media_por_dificuldade.png`:** Curva unificada com a média matemática da evolução geração a geração.
  4. **`map_elites_heatmap.png`:** Mapa de calor 3x3 dos 9 nichos de combate (Lento/Médio/Rápido vs. Tank/Balanceado/Glass Cannon).
  5. **`demonstracao_npc.gif`:** GIF animado de 6 segundos em 15 FPS gerado via `scripts/Gerar_GIF_Animado.bat`.

---

## 🧠 3. Entendendo os Resultados e Fenômenos do GA

### 🏆 Escalonamento por Fator de Mérito ($\text{Difícil} > \text{Médio} > \text{Fácil}$)
O sistema adota pesos calibrados pelo nível de hostilidade:
- No modo **Difícil**, cada segundo sobrevivido no inferno de balas rende $15.0\text{ pts}$ e cada esquiva perfeita rende $20.0\text{ pts}$, fazendo o teto da aptidão alcançar $\sim 1500 - 2300\text{ pts}$.
- No modo **Fácil**, como a densidade de perigo é baixa, cada segundo rende apenas $2.0\text{ pts}$, mantendo a pontuação em $\sim 200 - 400\text{ pts}$.
- Isso garante que a curva do modo Difícil fique no topo do gráfico consolidado, recompensando o mérito da IA.

### 📈 Como a Curva Monotônica de Convergência Funciona?
Para evitar oscilações causadas pela aleatoriedade dos projéteis (*noisy fitness*), o sistema rastreia o `history_best_so_far(gen)`. Isso garante que o gráfico sempre demonstre o aprendizado acumulado (curva não-decrescente em formato de degraus de evolução).

---

## 🗄️ 4. Estrutura e Dicionário dos Bancos de Dados (`data/`)

1. **`resultados_experimentos.csv`:** Telemetria final pós-treinamento do campeão supremo de cada rodada (17 colunas incluindo genes, desvios, colisões, dano e tempo).
2. **`historico_geracoes.csv`:** Histórico completo de cada geração de cada rodada, utilizado para traçar as curvas médias de aprendizado.
3. **`catalogo_sec.csv`:** *Snapshots* nos marcos de 20%, 50% e 100% para suporte a Ajuste Dinâmico de Dificuldade (DDA).
4. **`map_elites.csv`:** Matriz 3x3 de nichos fenotípicos (Quality-Diversity), registrando o melhor indivíduo por arquétipo (ex: *Tank*, *Glass Cannon*, *Rápido*, *Lento*).

---

## 🔧 5. Resolução de Problemas Comuns (FAQ)

- **"O Octave dá erro de gráficos ao rodar sem interface":** O sistema já está configurado com o toolkit `qt` nativo e supressão de avisos.
- **"Quero resetar os dados para começar experimentos do zero":** Basta apagar ou renomear os arquivos `.csv` da pasta `data/` (o sistema cria novos cabeçalhos automaticamente na próxima execução).
- **"A simulação 2D fecha muito rápido":** O tempo de animação está travado em 30 segundos com 50 FPS (`pause(0.02)`). Certifique-se de executar via `Assistir_Melhor_NPC.bat` ou `assistir_simulacao.m`.

---

## 🔗 Conexões
- [[00 - MOC Principal]]
- [[Execução Paralela & Análise Comparativa]]
- [[Arquitetura de Dados (Telemetria)]]
- [[Estrutura do Projeto & Diretórios]]
- [[Simulação & Física de Esquiva]]

---
*Documento integrado à documentação oficial do projeto Mirage — UNISENAI.*

