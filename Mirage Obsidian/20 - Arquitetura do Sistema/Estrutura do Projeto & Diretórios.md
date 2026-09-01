# 📁 Estrutura do Projeto & Organização de Diretórios

Para manter os padrões de desenvolvimento de software e ciência de dados exigidos em projetos acadêmicos e profissionais de Inteligência Artificial, o projeto **Mirage** segue uma separação rigorosa de responsabilidades entre código-fonte, dados salvos, automação e documentação.

---

## 🏗️ Hierarquia Geral de Pastas

```text
Mirage/
├── data/                       # 📊 Bancos de Dados e Telemetria (CSVs)
│   ├── resultados_experimentos.csv   # Histórico do campeão supremo por rodada
│   ├── catalogo_sec.csv              # Snapshots de gerações (DDA)
│   └── map_elites.csv                # Matriz 3x3 de nichos fenotípicos (QD)
│
├── src/                        # 🧠 Código-Fonte Octave/MATLAB (.m)
│   ├── npc_evasivo_ga.m              # Script principal e interface com visualização
│   ├── run_batch_experiment.m        # Executor headless para lote
│   ├── simulate_episode.m            # Motor físico de colisão e combate 2D
│   ├── fitness_function.m            # Avaliação multi-objetivo
│   ├── init_population.m             # Inicialização com Orçamento Global (Point-Buy)
│   ├── selection.m                   # Seleção por Torneio
│   ├── crossover.m                   # Crossover Aritmético/Uniforme
│   ├── mutation.m                    # Mutação Gaussiana / Box-Muller
│   ├── calculate_evade_force.m       # Cálculo preditivo de vetor de evasão (Reynolds)
│   ├── gerar_graficos_comparativos.m # Gerador de gráficos comparativos
│   └── test_physics.m                # Testes unitários de física e colisão
│
├── scripts/                    # ⚙️ Automação e Executáveis
│   ├── Rodar_Simulador.bat           # Lança o simulador gráfico
│   ├── Rodar_Experimentos_Paralelos.bat # Launcher de lote em paralelo
│   └── Rodar_Experimentos_Paralelos.ps1 # Orquestrador multithread de workers
│
├── logs/                       # 📝 Telemetria de Execução dos Workers
│   ├── worker_diff1.log / worker_diff1_err.log
│   ├── worker_diff2.log / worker_diff2_err.log
│   └── worker_diff3.log / worker_diff3_err.log
│
└── Mirage Obsidian/            # 📚 Cofre de Documentação Científica e MOCs
```

---

## 🔑 Regras de Separação de Arquivos

1. **Separação de Dados e Código:** Nenhum arquivo `.csv` é armazenado na pasta `src/`. Todas as rotinas de leitura e escrita de telemetria utilizam a pasta `data/`.
2. **Executáveis Roteados:** Todos os scripts de conveniência (`.bat` e `.ps1`) residem na pasta `scripts/` e ajustam o diretório de trabalho (*working directory*) de forma transparente para a raiz do repositório antes de invocar o Octave.
3. **Logs Isolados:** Saídas brutas de erro e execução em segundo plano não poluem a raiz, ficando isoladas na pasta `logs/`.

---

## 🔗 Conexões
- [[Arquitetura de Dados (Telemetria)]]
- [[Execução Paralela & Análise Comparativa]]
- [[00 - MOC Principal]]

