# 🧠 Memory Bank — Mirage

Documento de memória persistente entre sessões de agentes. Deve ser consultado no início de tarefas complexas e atualizado após entregas críticas.

## 📌 Estado Atual do Projeto
- **Fase Atual:** Produção & Curação de Documentação Científica
- **Última Entrega Relevante:** Expurgada do repositório git toda a gestão interna de seminários pessoais (`50 - Gestão do Seminário/`, `documentos_seminario/`, scripts de exportação e manuais de sabatina). O cofre do Obsidian e o repositório agora contêm estritamente a documentação técnica e científica de referência internacional.
- **Foco Imediato:** Governança contínua do pipeline genético, reprodutibilidade de experimentos no Octave/MATLAB e manutenção do cofre técnico.

## 🔒 Decisões Travadas (Locked Decisions)
Decisões de arquitetura e tecnologia que NÃO devem ser rediscutidas ou alteradas sem consentimento explícito:
- **[2026-09] Orçamento Global de Atributos:** Restrito a 1.8 pontos distribuídos entre HP, Ataque, Cadência e Velocidade. Impede a emergência de "tanques invencíveis" (combate ao *Reward Hacking*).
- **[2026-09] Dupla Compatibilidade Octave/MATLAB:** Todos os scripts de `src/` devem manter retrocompatibilidade com GNU Octave sem depender de toolboxes pagas proprietárias.
- **[2026-09] Parada Antecipada por Estagnação (Bhandari):** $K = 15$ gerações consecutivas com $\Delta\text{Fitness} < 1\%$ interrompe o treinamento para economizar ciclos computacionais e prevenir overfitting.
- **[2026-09] Atomicidade do Obsidian:** Limite de 200 linhas por nota em `Mirage Obsidian/` para garantir carregamento leve e indexação precisa por agentes.

## ⚠️ Gotchas & Lições Aprendidas
- **Ruído Estocástico (Noisy Fitness):** Ambientes com balística contínua possuem variabilidade de sorte nos desvios. Para demonstrar monotonicidade acadêmica, é imperativo utilizar múltiplas baterias (N=30) e rastreamento do elite histórico global.
- **Truncamento Angular de Steering:** Forças de evasão não devem sofrer aceleração angular infinita para evitar movimentos inorgânicos ("teletransporte visual"). O truncamento de força máxima garante fluidez realista.
- **Git Hygiene:** Planejamentos de apresentação e roteiros de fala não pertencem a repositórios de código aberto/científico; devem permanecer restritos localmente via `.gitignore`.

## 📋 Backlog & Débito Técnico de Agente
- [ ] Validação contínua de novos operadores genéticos no benchmark de 30 rodadas.
- [ ] Expansão da arena para incluir padrões de projéteis adicionais e obstáculos dinâmicos móveis.
