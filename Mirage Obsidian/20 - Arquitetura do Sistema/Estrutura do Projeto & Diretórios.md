# 📁 Estrutura do Projeto & Organização de Diretórios

Para manter os padrões de desenvolvimento de software e ciência de dados exigidos em projetos acadêmicos e profissionais de Inteligência Artificial, o projeto **Mirage** segue uma separação rigorosa de responsabilidades entre código-fonte, dados salvos, automação e documentação.

---

## 🏗️ Hierarquia Geral de Pastas

```text
Mirage/
├── data/
│   ├── resultados_experimentos.csv
│   ├── historico_geracoes.csv
│   ├── catalogo_sec.csv
│   ├── map_elites.csv
│   └── graficos/
├── src/
│   ├── npc_evasivo_ga.m
│   ├── run_batch_experiment.m
│   ├── assistir_simulacao.m
│   ├── analise_evolucao_media.m
│   ├── gerar_graficos_comparativos.m
│   └── simulate_episode.m
├── scripts/
│   ├── Rodar_Simulador.bat
│   ├── Assistir_Melhor_NPC.bat
│   ├── Rodar_Experimentos_Paralelos.bat
│   └── Gerar_Todos_Graficos.bat
├── logs/
└── Mirage Obsidian/
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

