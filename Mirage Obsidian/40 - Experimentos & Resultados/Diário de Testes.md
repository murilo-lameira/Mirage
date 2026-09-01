# 📓 Diário de Testes e Experimentos Evolutivos

Registro histórico consolidado dos testes e experimentos executados no GNU Octave, integrando as telemetrias salvas nos bancos de dados em `data/` (`resultados_experimentos.csv`, `catalogo_sec.csv` e `map_elites.csv`).

---

## 📊 Tabela de Resultados Consolidados

| Data / Hora | Dificuldade | População | Gerações | Fitness Máx | Fitness Médio | HP (Elite) | Atk (Elite) | AtkSpd (Elite) | MovSpd (Elite) | Tempo Treino |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **2026-09-01 11:42** | **Fácil (1)** | 20 | 28 | 171.50 | 159.34 | 10 | 50 | 3.00 Hz | 7.73 m/s | 33.25s |
| **2026-09-01 11:44** | **Médio (2)** | 50 | 21 | 237.10 | 165.43 | 66 | 50 | 3.00 Hz | 6.22 m/s | 97.61s |
| **2026-09-01 11:49** | **Difícil (3)** | 100 | 17 | 430.49 | 169.65 | 57 | 45 | 2.84 Hz | 7.39 m/s | 193.70s |
| **Pós-Patch (Orçamento)** | **Fácil (1)** | 20 | 24 | 363.40 | 215.10 | 10 | 48 | 2.38 Hz | 1.56 m/s | 29.26s |
| **Pós-Patch (Orçamento)** | **Difícil (3)** | 100 | 18 | 594.84 | 280.30 | 93 | 26 | 1.04 Hz | 5.68 m/s | 185.10s |

---

## 🔍 Análise Comparativa dos Comportamentos

1. **Modo Fácil (Pós-Patch):**
   * O NPC campeão especializou-se em **Ataque ($48$)** e **Cadência ($2.38\text{ Hz}$)**, operando com velocidade baixa ($1.56\text{ m/s}$).
   * *Conclusão Tática:* Como os tiros são poucos e lentos, vale muito mais a pena atirar sem parar e acumular pontos de dano ofensivo.

2. **Modo Difícil (Pós-Patch):**
   * O NPC campeão investiu a maior parte do seu orçamento em **Velocidade de Movimento ($5.68\text{ m/s}$)** e **HP ($93$)**, reduzindo o Ataque ($26$) e a Cadência ($1.04\text{ Hz}$).
   * *Conclusão Tática:* Na tempestade de tiros rápidos, qualquer erro custa caro. A evolução priorizou esquiva e sobrevivência.

---

## 📈 Visualização Gráfica
Para visualizar os gráficos comparativos consolidados das 3 dificuldades lado a lado:
* Execute `src/gerar_graficos_comparativos.m` no Octave.
* Ou execute o batch completo de 30 rodadas via `scripts/Rodar_Experimentos_Paralelos.bat`.

---

## 🔗 Conexões
- [[O Problema da Convergencia Prematura]]
- [[Execução Paralela & Análise Comparativa]]
- [[Arquitetura de Dados (Telemetria)]]
- [[Critério de Parada e Convergência]]
- [[00 - MOC Principal]]
