# 🧠 Memory Bank — Mirage

Documento de memória persistente entre sessões de agentes. Deve ser consultado no início de tarefas complexas e atualizado após entregas críticas.

## 📌 Estado Atual do Projeto
- **Fase Atual:** Produção & Curação de Documentação Científica, Redação do Artigo e Distribuição Standalone (.exe)
- **Última Entrega Relevante:** Refatoração editorial sênior IEEE/SBC do artigo científico (*"Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva"* em `paper/Mirage_Artigo_SENAI.tex` e `paper/Mirage_Artigo_SENAI.pdf`). Amostragem experimental oficial consolidada em $N = 90$ rodadas independentes ($N_1=N_2=N_3=30$) ao longo de $G = 50$ gerações, com $\text{QD-Score} = 39.114{,}40$ no catálogo MAP-Elites. Sincronizadas as notas técnicas de `60 - Artigo Cientifico/` e autoria formal com orientador Prof. Ricardo Martinez Vicentini.
- **Foco Imediato:** Governança contínua do pipeline genético, finalização do artigo para SBGames/SBC/IEEE e manutenção do cofre técnico.

## 🔒 Decisões Travadas (Locked Decisions)
Decisões de arquitetura e tecnologia que NÃO devem ser rediscutidas ou alteradas sem consentimento explícito:
- **[2026-09] Orçamento Global de Atributos:** Restrito a 1.8 pontos distribuídos entre HP, Ataque, Cadência e Velocidade. Impede a emergência de "tanques invencíveis" (combate ao *Reward Hacking*).
- **[2026-09] Dupla Compatibilidade Octave/MATLAB:** Todos os scripts de `src/` devem manter retrocompatibilidade com GNU Octave sem depender de toolboxes pagas proprietárias.
- **[2026-09] Parada Antecipada por Estagnação (Bhandari):** $K = 15$ gerações consecutivas com $\Delta\text{Fitness} < 1\%$ interrompe o treinamento para economizar ciclos computacionais e prevenir overfitting.
- **[2026-09] Atomicidade do Obsidian (< 200 Linhas):** Limite estrito de 200 linhas por nota em `Mirage Obsidian/`. Notas que se aproximarem ou atingirem o limite devem ser imediatamente fracionadas em arquivos atômicos complementares sequenciais (ex: `Nome (Parte 2).md`).
- **[2026-09] Escopo Editorial do Artigo:** O artigo técnico curto é parametrizado para 5 páginas completas de conteúdo técnico (IMRaD, equações, tabelas e discussões), com referências bibliográficas alocadas em páginas extras subsequentes (padrão SBGames/IEEE/ACM).
- **[2026-10] Executável Autônomo Windows:** O empacotamento deve sempre utilizar `run_mirage.py` como ponto de entrada para garantir isolamento de CWD (`os.chdir(exe_dir)`) e proteção contra forks recursivos no Windows (`multiprocessing.freeze_support()`).
- **[2026-10] Padronização Amostral e QD-Score do Artigo:** Amostragem científica oficial fixada em $N=90$ rodadas balanceadas ($30$ Fácil, $30$ Médio, $30$ Difícil) em $G=50$ gerações ($P=30$, $135.000$ combates), com matriz MAP-Elites $3 \times 3$ apresentando Cobertura $= 100\%$ e $\text{QD-Score} = 39.114{,}40$.
- **[2026-10] Título Oficial do Artigo:** *"Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva"* (Short paper de 5 páginas + referências em página extra no padrão IEEE/SBC).
- **[2026-10] Nomenclatura Oficial dos Arquétipos:** *Sniper / Glass Cannon* (Fácil — $D_1$), *Combatente Equilibrado* (Médio — $D_2$) e *Bruiser / Ladino* (Difícil — $D_3$, padronizado em substituição a "Ninja" ou "Evasor Tanque").

## ⚠️ Gotchas & Lições Aprendidas
- **Ruído Estocástico (Noisy Fitness):** Ambientes com balística contínua possuem variabilidade de sorte nos desvios. Para demonstrar monotonicidade acadêmica, é imperativo utilizar múltiplas baterias (N=30) e rastreamento do elite histórico global.
- **Truncamento Angular de Steering:** Forças de evasão não devem sofrer aceleração angular infinita para evitar movimentos inorgânicos ("teletransporte visual"). O truncamento de força máxima garante fluidez realista.
- **Git Hygiene:** Planejamentos de apresentação e roteiros de fala não pertencem a repositórios de código aberto/científico; devem permanecer restritos localmente via `.gitignore`.

## 📋 Backlog & Débito Técnico de Agente
- [ ] Validação contínua de novos operadores genéticos no benchmark de 30 rodadas.
- [ ] Expansão da arena para incluir padrões de projéteis adicionais e obstáculos dinâmicos móveis.
