# 📖 Guia de Uso, Comandos & Manual Operacional do Simulador Mirage

Este documento é o guia definitivo para operadores, pesquisadores e apresentadores do projeto **Mirage**. Aqui estão descritos todos os comandos, rotinas de execução, atalhos de automação e interpretação de dados da aplicação.

---

## ⚡ 1. Visão Geral das Formas de Execução

O sistema foi desenhado de forma modular, permitindo 4 fluxos principais de utilização:

| Modo de Uso | Finalidade | Arquivo Launcher | Arquivo Octave |
| :--- | :--- | :--- | :--- |
| **1. Simulador Interativo** | Treinar 1 rodada com menu visual, gráfico no final e combate ao vivo | `scripts/Rodar_Simulador.bat` | `src/npc_evasivo_ga.m` |
| **2. Treinamento em Lote (Batch)** | Treinar N rodadas em segundo plano (rápido e sem interface travando) | `scripts/Rodar_Experimentos_Paralelos.bat` | `src/run_batch_experiment.m` |
| **3. Assistir Campeão ao Vivo** | Carregar o melhor NPC do banco de dados e assistir na arena 2D em tempo real | `scripts/Assistir_Melhor_NPC.bat` | `src/assistir_simulacao.m` |
| **4. Central de Gráficos e Análise** | Gerar gráficos comparativos e curvas médias consolidadas | `scripts/Gerar_Todos_Graficos.bat` | `src/gerar_graficos_comparativos.m`<br>`src/analise_evolucao_media.m` |

---

## 🛠️ 2. Como Usar Cada Módulo

### 🎮 A. Treinamento Solo Interativo (`npc_evasivo_ga.m`)
Ideal para demonstrações rápidas durante o seminário ou testes de calibração.

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
  4. Inicia a arena gráfica 2D exibindo o NPC campeão desviando dos projéteis em tempo real.

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
    % Assinatura: run_batch_experiment(dificuldade, num_rodadas, modo_eds_mutacao_pura)
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
- **Fluxo de Execução:**
  1. Permite escolher a dificuldade da arena.
  2. Faz uma busca automática no banco `data/resultados_experimentos.csv` para encontrar o genoma com a maior aptidão histórica já registrada para aquela dificuldade.
  3. Abre a janela da arena 2D renderizando a 50 FPS estáveis, com exibição de HP, raio de radar e detecção de ameaças.

---

### 📊 D. Geração de Gráficos e Análise de Dados
Gera todo o material visual consolidado para slides, artigos e relatórios.

- **Como Rodar:**
  - **Opção 1 (Atalho):** Duplo clique em `scripts/Gerar_Todos_Graficos.bat`.
  - **Opção 2 (Octave GUI/CLI):**
    ```matlab
    addpath('src');
    gerar_graficos_comparativos;  % Gráficos de Genes e Fitness
    analise_evolucao_media;       % Curva média de aprendizado consolidado
    ```
- **Gráficos Gerados em `data/graficos/`:**
  1. **`comparativo_genes.png`:** Gráficos de barras comparando os fenótipos médios (HP, Ataque, Velocidade de Ataque, Velocidade de Desvio) entre as 3 dificuldades.
  2. **`comparativo_fitness.png`:** Relação entre o Fitness Máximo dos campeões e o Fitness Médio das populações.
  3. **`evolucao_media_por_dificuldade.png`:** Curva unificada com a média matemática da evolução geração a geração para Fácil (Verde), Médio (Azul) e Difícil (Vermelho).
  4. **`rodadas/evolucao_difX_rodadaYY_....png`:** Gráficos individuais de cada rodada executada.

---

## 🧠 3. Entendendo os Resultados e Fenômenos do GA

### ❓ Por que o modo Fácil atinge um Fitness MAIOR que o modo Difícil?
Ao analisar os gráficos consolidados, nota-se que a curva Fácil (Verde) atinge patamares de ~800 pontos, enquanto a Difícil (Vermelha) atinge ~550 pontos. 

> [!IMPORTANT]
> **Explicação Teórica:**
> A função de fitness mede a **performance física bruta** (tempo de sobrevivência, ausência de colisões e dano causado). 
> - No modo **Fácil**, a arena atira poucos projéteis, lentos e imprecisos. O NPC facilmente sobrevive os 30s sem levar dano, atingindo notas altíssimas.
> - No modo **Difícil**, o ambiente é hostil (*Bullet Hell* com disparos a cada 0.1s em alta velocidade). Mesmo os melhores NPCs sofrem colisões inevitáveis e levam dano, limitando matematicamente a nota máxima possível que qualquer organismo consegue alcançar.

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
*Documento integrado à documentação oficial do projeto Mirage — UNISENAI.*

