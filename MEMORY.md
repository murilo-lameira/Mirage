# 🧠 Memory Bank — Mirage

Documento de memória persistente entre sessões de agentes. Deve ser consultado no início de tarefas complexas e atualizado após entregas críticas.

## 📌 Estado Atual do Projeto
- **Fase Atual:** Produção & Curação de Documentação Científica e Redação do Artigo (5 Páginas + Refs)
- **Última Entrega Relevante:** Higienizada a pasta `Sources/` (expurgo de blogs, reddit, apostilas informais). Criada a pasta `Mirage Obsidian/15 - Biblioteca de Artigos/` com 13 artigos científicos internacionais na íntegra, subdivididos em partes estritamente atômicas (< 200 linhas, sem BOM). Hubs integrados em `00 - MOC Biblioteca de Artigos.md` e `00 - MOC Principal.md`.
- **Foco Imediato:** Governança contínua do pipeline genético, redação do short paper para SBGames/ENIAC e manutenção do cofre técnico.

## 🔒 Decisões Travadas (Locked Decisions)
Decisões de arquitetura e tecnologia que NÃO devem ser rediscutidas ou alteradas sem consentimento explícito:
- **[2026-09] Orçamento Global de Atributos:** Restrito a 1.8 pontos distribuídos entre HP, Ataque, Cadência e Velocidade. Impede a emergência de "tanques invencíveis" (combate ao *Reward Hacking*).
- **[2026-09] Dupla Compatibilidade Octave/MATLAB:** Todos os scripts de `src/` devem manter retrocompatibilidade com GNU Octave sem depender de toolboxes pagas proprietárias.
- **[2026-09] Parada Antecipada por Estagnação (Bhandari):** $K = 15$ gerações consecutivas com $\Delta\text{Fitness} < 1\%$ interrompe o treinamento para economizar ciclos computacionais e prevenir overfitting.
- **[2026-09] Atomicidade do Obsidian (< 200 Linhas):** Limite estrito de 200 linhas por nota em `Mirage Obsidian/`. Notas que se aproximarem ou atingirem o limite devem ser imediatamente fracionadas em arquivos atômicos complementares sequenciais (ex: `Nome (Parte 2).md`).
- **[2026-09] Escopo Editorial do Artigo:** O artigo técnico curto é parametrizado para 5 páginas completas de conteúdo técnico (IMRaD, equações, tabelas e discussões), com referências bibliográficas alocadas em páginas extras subsequentes (padrão SBGames/IEEE/ACM).

## ⚠️ Gotchas & Lições Aprendidas
- **Ruído Estocástico (Noisy Fitness):** Ambientes com balística contínua possuem variabilidade de sorte nos desvios. Para demonstrar monotonicidade acadêmica, é imperativo utilizar múltiplas baterias (N=30) e rastreamento do elite histórico global.
- **Truncamento Angular de Steering:** Forças de evasão não devem sofrer aceleração angular infinita para evitar movimentos inorgânicos ("teletransporte visual"). O truncamento de força máxima garante fluidez realista.
- **Git Hygiene:** Planejamentos de apresentação e roteiros de fala não pertencem a repositórios de código aberto/científico; devem permanecer restritos localmente via `.gitignore`.

## 📋 Backlog & Débito Técnico de Agente
- [ ] Validação contínua de novos operadores genéticos no benchmark de 30 rodadas.
- [ ] Expansão da arena para incluir padrões de projéteis adicionais e obstáculos dinâmicos móveis.
