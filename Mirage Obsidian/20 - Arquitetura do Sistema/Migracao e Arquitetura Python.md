# 🐍 Migração e Arquitetura Python (Mirage v2.0)

## 📌 Contexto & Racional de Decisão
Originalmente concebido em GNU Octave e MATLAB, o ecossistema Mirage foi completamente modernizado para Python 3.12+ / 3.14. A migração permitiu:
1. **Aceleração Numérica:** Uso de NumPy vetorizado e Numba JIT para cálculo de CPA (*Closest Point of Approach*) e Steering Behaviors a 50 FPS.
2. **Qualidade de Diversidade (QD):** MAP-Elites formal integrado com catálogo SEC (*Strategic Elite Catalogue*) para DDA (*Dynamic Difficulty Adjustment*).
3. **Validação Estatística:** Suíte com SciPy e Seaborn para One-Way ANOVA, testes t de Welch, Cohen's $d$ e gráficos de alta resolução a 300 DPI.
4. **Interface Gráfica e Demonstração:** Renderização com Pygame-CE com feedback tátil, shaders de arena cibernética, anéis de radar e modo humano jogável.

---

## 🏗️ Estrutura do Pacote `mirage`
- `mirage/config.py`: Constantes físicas, perfis de dificuldade ($D_1, D_2, D_3$) e orçamento genético restrito $B=1.8$.
- `mirage/core/kinematics.py`: Funções de física vetorial, Reynolds steering, predição balística com Lead-Aiming.
- `mirage/core/simulation.py`: Motor de simulação contínua (50 FPS), gerenciador de projéteis e orquestrador de combate.
- `mirage/core/ga.py`: Algoritmo Genético contínuo com projeção de simplex ($\sum u_i \le 1.8$), crossover BLX-$\alpha$ e early stopping.
- `mirage/core/map_elites.py`: Grade 3x3 de MAP-Elites baseada em Mobilidade vs. Defensividade/Agressividade.
- `mirage/core/batch_runner.py`: Execução paralela de experimentos via `multiprocessing`.
- `mirage/analysis/stats.py`: Análise estatística inferencial completa (ANOVA, testes post-hoc).
- `mirage/analysis/plotting.py`: Pipeline de gráficos científicos (Boxplots com jitter, curvas de convergência, heatmaps QD).
- `mirage/gui/arena_view.py`: Renderizador de arena cibernética em Pygame-CE.
- `mirage/gui/game_app.py`: Controlador dos modos Espectador e Jogador Humano.
- `mirage/main.py`: Ponto de entrada CLI unificado.

---

## 🔒 Invariantes Preservados
- **Orçamento Genético Restrito:** $\sum_{i=1}^4 u_i \le 1.8$, garantindo ausência de agentes onipotentes (*Reward Hacking*).
- **Taxa de Amostragem:** Física síncrona com $\Delta t = 0.02$ s (50 FPS).
- **Reprodutibilidade:** Controle de sementes randômicas para validação em 92 episódios experimentais.

