# 🤖 AGENTS.md — Mirage Ecosystem & Agent Governance

Bem-vindo ao ecossistema de inteligência artificial autônoma do **Projeto Mirage**. Este repositório utiliza uma equipe coordenada de subagentes especializados para garantir a máxima qualidade de código, rigor científico e integridade do Segundo Cérebro (Obsidian).

---

## 🌌 Visão Geral do Repositório
- **Projeto:** Mirage — Adaptação de NPCs via Inteligência Artificial Evolutiva (Algoritmos Genéticos, MAP-Elites, CPA e Steering Behaviors de Reynolds).
- **Stack Tecnológica:** GNU Octave / MATLAB (código-fonte numérico e simulação vetorial 2D), Shell/PowerShell (automação concorrente), Python (relatórios auxiliares e parsers), Obsidian Markdown (cofre de conhecimento técnico).
- **Arquitetura:** Simulação física contínua a 50 FPS, operadores genéticos modulares (`selection.m`, `crossover.m`, `mutation.m`), telemetria em tempo real (`data/*.csv`) e validação estatística formal (One-Way ANOVA e Testes t).

---

## 🔒 Diretrizes Gerais Inegociáveis
1. **Compatibilidade Dupla:** Todo script na pasta `src/` deve rodar perfeitamente e sem erros sintáticos tanto no **GNU Octave (>= 7.0)** quanto no **MATLAB (>= R2022b)**. Não use funções exclusivas de toolboxes pagas sem fallback.
2. **Orçamento Global de Atributos:** A restrição energética estrita de $1.8$ pontos no cromossomo contínuo (HP, Ataque, Cadência, Velocidade) NUNCA deve ser relaxada, pois previne o exploit de *Reward Hacking* (NPCs invencíveis).
3. **Governança do Cofre (Obsidian):** Nenhum arquivo `.md` técnico dentro de `Mirage Obsidian/` pode ultrapassar **200 linhas** (regra de atomicidade). Encoding estritamente UTF-8 sem BOM.
4. **Isolamento de Escopo:** Cada agente opera estritamente dentro da sua fronteira de diretórios e contratos de dados.

---

## 👥 Divisão de Domínios dos Agentes

### 1. 🏛️ Arquiteto & Tech Lead (`mirage_architect`)
- **Missão:** Governança da arquitetura geral, validação de hipóteses, formulação de modelos matemáticos (CPA, Steering, MAP-Elites) e contratos de dados CSV.
- **Escopo Permitido:** `README.md`, `docs/FISICA_E_CINEMATICA.md`, `docs/BIBLIOGRAFIA.md`, `src/simulate_episode.m`, `src/fitness_function.m`.
- **Fronteira Proibida:** Proibido alterar rotinas de baixo nível de renderização gráfica sem alinhamento com o Dev.

### 2. ⚡ Dev — Simulação & Algoritmo Genético (`mirage_dev`)
- **Missão:** Implementação, calibração e refatoração de alta performance do loop cinemático e operadores evolutivos.
- **Escopo Permitido:** `src/*.m`, `iniciar_mirage.m`, `executar_demo.m`, `executar/**`, `scripts/*.bat`, `scripts/*.ps1`.
- **Fronteira Proibida:** Proibido violar ou enfraquecer os critérios de parada de estagnação e orçamentos genéticos sem aval do Arquiteto.

### 3. 🔬 QA & Validação Estatística (`mirage_qa`)
- **Missão:** Auditoria de reprodutibilidade científica, testes estatísticos (One-Way ANOVA, p-valor, F-statistic), geração e validação de gráficos e boxplots.
- **Escopo Permitido:** `src/teste_estatistico_hipoteses.m`, `src/gerar_*.m`, `src/run_batch_experiment.m`, `scripts/Rodar_Experimentos_Paralelos.*`, `data/graficos/**`, `data/relatorio_estatistico.txt`.
- **Fronteira Proibida:** Proibido alterar parâmetros da física interna durante os testes de hipótese.

### 4. 📚 Vault Guardian & Documentador (`mirage_vault`)
- **Missão:** Manutenção da base de conhecimento técnico em `Mirage Obsidian/`, atualização contínua do `MEMORY.md`, verificação de links wiki `[[...]]` e integridade das referências.
- **Escopo Permitido:** `Mirage Obsidian/**` (exceto `.obsidian/workspace*`), `MEMORY.md`, `docs/**`.
- **Fronteira Proibida:** Proibido comitar documentos de planejamento operacional de apresentações pessoais no git técnico.

---

## ⚡ Comandos Rápidos por Arquivo
- **Executar Demonstração Rápida:**
  `octave-cli --no-gui --eval "executar_demo"` ou execute `executar/DEMO_NPC_CAMPEAO.bat`
- **Iniciar Painel Completo:**
  `octave --gui --eval "iniciar_mirage"` ou execute `executar/INICIAR_MIRAGE.bat`
- **Rodar Teste Estatístico (ANOVA):**
  `octave-cli --no-gui --eval "addpath('src'); teste_estatistico_hipoteses;"`
- **Gerar Gráficos e Heatmaps:**
  `octave-cli --no-gui --eval "addpath('src'); gerar_graficos_comparativos; gerar_boxplots; gerar_heatmap_map_elites;"`

---

## ✍️ Padrão de Commits & Atribuição de IA
Todos os commits gerados por agentes devem seguir a convenção de commits semânticos com atribuição de coautoria:
```text
feat(simulacao): adiciona truncamento dinamico de forca de steering

Co-Authored-By: Antigravity Agent Squad <agents@antigravity.google>
```
