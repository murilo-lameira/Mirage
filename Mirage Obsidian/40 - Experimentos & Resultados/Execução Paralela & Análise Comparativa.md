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

4. **[`src/analise_evolucao_media.m`](file:///f:/Faculdade/Projetos/Mirage/src/analise_evolucao_media.m):**
   * Script analítico que lê `data/historico_geracoes.csv` e calcula a **curva média de aprendizado** geração a geração de todas as rodadas executadas, salvando a imagem em `data/graficos/evolucao_media_por_dificuldade.png`.

5. **[`src/gerar_boxplots.m`](file:///f:/Faculdade/Projetos/Mirage/src/gerar_boxplots.m):**
   * Renderiza boxplots estatísticos com medianas, quartis e outliers:
     * `data/graficos/boxplot_fitness_dificuldade.png`: Dispersão de fitness por dificuldade.
     * `data/graficos/boxplot_distribuicao_genes.png`: Dispersão dos 4 genes (HP, Ataque, Cadência, Velocidade).

6. **[`src/teste_estatistico_hipoteses.m`](file:///f:/Faculdade/Projetos/Mirage/src/teste_estatistico_hipoteses.m):**
   * Realiza One-Way ANOVA e testes $t$ bicaudais com cálculo exato de $p$-valor e tamanho de efeito de Cohen ($d$), gerando `data/relatorio_estatistico.txt`.

---

## 📈 Descobertas e Interpretação dos Gráficos

### 1. Suavização de Fitness Ruidoso (Noisy Fitness)
Ambientes com geração aleatória de projéteis (`rand()`) provocam variações nas notas dos indivíduos reavaliados. Para garantir que as curvas de evolução representem fielmente o conhecimento acumulado pelo GA sem oscilações caóticas para baixo, rastreamos o `history_best_so_far(gen)`. Isso produz curvas de convergência monotônicas (em degraus), ideais para apresentação acadêmica.

### 2. Escalonamento por Fator de Mérito ($\text{Difícil} > \text{Médio} > \text{Fácil}$)
Com o sistema de Fator de Mérito, o modo **Difícil** atinge médias de $\sim 1816\text{ pts}$, o **Médio** atinge $\sim 901\text{ pts}$ e o **Fácil** $\sim 602\text{ pts}$. A sobrevivência e evasão no inferno de balas são devidamente recompensadas com patamares superiores.

### 3. Validação Estatística das Diferenças
A One-Way ANOVA nos dados experimentais ($N=32$) confirmou:
* Estatística $F = 138.24$
* $p\text{-valor} = 1.44 \times 10^{-15} \ll 0.05$ (Rejeita-se $H_0$ com significância extrema).
* Testes $t$ pareados entre todas as dificuldades demonstraram $p < 10^{-8}$ e tamanho de efeito $d > 4.0$, comprovando a separabilidade estatística dos comportamentos evoluídos.

---

## 🎮 Como Executar
* **Lote Paralelo:** Duplo clique em `scripts/Rodar_Experimentos_Paralelos.bat`.
* **Gerar Gráficos e Relatório:** Duplo clique em `scripts/Gerar_Todos_Graficos.bat`.
* **Guia Completo de Comandos:** Consulte [[Guia de Uso & Comandos]].

---

## 🔗 Conexões
- [[Diário de Testes]]
- [[O Problema da Convergencia Prematura]]
- [[Arquitetura de Dados (Telemetria)]]
- [[00 - MOC Principal]]
