# ⚡ Execução Paralela & Análise Comparativa de Experimentos

Para validar a solidez estatística dos Algoritmos Genéticos sem depender de uma única execução isolada, desenvolvemos uma infraestrutura de automação para testes em lote paralelos.

---

## 🚀 Arquitetura de Execução Paralela

A automação dispara **3 processos independentes do GNU Octave CLI simultaneamente**, executando 10 rodadas de treinamento em cada dificuldade ($30$ experimentos completos no total):

```
                     [ scripts/Rodar_Experimentos_Paralelos.bat ]
                                          │
                                          ▼
                     [ scripts/Rodar_Experimentos_Paralelos.ps1 ]
                                          │
        ┌────────────────────────────────┼────────────────────────────────┐
        ▼                                ▼                                ▼
  [ Worker 1 (Octave) ]            [ Worker 2 (Octave) ]            [ Worker 3 (Octave) ]
   Dificuldade Fácil (1)            Dificuldade Médio (2)           Dificuldade Difícil (3)
       (10 Rodadas)                     (10 Rodadas)                     (10 Rodadas)
        │                                │                                │
        └────────────────────────────────┼────────────────────────────────┘
                                         ▼
                      [ data/resultados_experimentos.csv ]
                               (Append Thread-Safe)
                                         │
                                         ▼
                    [ src/gerar_graficos_comparativos.m ]
                               (Gráficos Finais)
```

---

## 🛠️ Componentes do Sistema

1. **[`src/run_batch_experiment.m`](file:///f:/Faculdade/Projetos/Mirage/src/run_batch_experiment.m):**
   * Executor *headless* em Octave que recebe a dificuldade, o número de rodadas e o modo de mutação pura via argumentos.
   * Possui rotina de persistência com *retry* para evitar bloqueios concorrentes de escrita nos arquivos CSV em `data/`.

2. **[`scripts/Rodar_Experimentos_Paralelos.ps1`](file:///f:/Faculdade/Projetos/Mirage/scripts/Rodar_Experimentos_Paralelos.ps1):**
   * Script PowerShell com painel de telemetria em tempo real que monitora os 3 processos, exibe o progresso de cada dificuldade, salva logs em `logs/` e calcula o tempo total de execução.

3. **[`src/gerar_graficos_comparativos.m`](file:///f:/Faculdade/Projetos/Mirage/src/gerar_graficos_comparativos.m):**
   * Script analítico que lê o histórico consolidado de `data/resultados_experimentos.csv` e plota automaticamente:
     * **Figura 1:** Comparativo de Genes dos Campeões por Dificuldade (HP, Ataque, Cadência e Velocidade).
     * **Figura 2:** Comparativo de Fitness Máximo vs. Médio da População.

---

## 🎮 Como Executar
* Dê um duplo clique em `Rodar_Experimentos_Paralelos.bat` dentro da pasta `scripts/`.

---

## 🔗 Conexões
- [[Diário de Testes]]
- [[O Problema da Convergencia Prematura]]
- [[Arquitetura de Dados (Telemetria)]]
- [[00 - MOC Principal]]
