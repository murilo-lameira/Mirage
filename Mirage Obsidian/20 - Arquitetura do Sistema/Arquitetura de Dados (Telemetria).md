# 📊 Arquitetura de Dados e Telemetria (CSVs)

Para fundamentar as teses estatísticas e comportamentais do projeto Mirage para a banca avaliadora, nosso simulador exporta a telemetria do treinamento para três bases de dados estruturadas em CSV de forma assíncrona (*thread-safe*).

Esses arquivos suportam desde a **Geração de Gráficos Comparativos** até a mecânica teórica de **Ajuste Dinâmico de Dificuldade** (SEC) e **Quality-Diversity** (MAP-Elites).

---

## 1. Banco de Dados Principal (`resultados_experimentos.csv`)
Grava o desfecho final do treinamento evolutivo, ou seja, o desempenho do "Campeão Global" (Elite Supremo) de cada rodada.

### Estrutura (Colunas)
- `Data_Hora`: Timestamp exato da conclusão do treinamento.
- `Dificuldade`: 1 (Fácil), 2 (Médio) ou 3 (Difícil).
- `Populacao`, `Geracoes_Treinadas`: Setup de treinamento do GA (o algoritmo pode parar cedo via Critério de Bhandari).
- `Fitness_Max`, `Fitness_Medio`: Métricas puras da aptidão da população.
- **DNA (Genes):** `Elite_HP`, `Elite_Atk`, `Elite_AtkSpd`, `Elite_MovSpd`.
- **Telemetria de Combate Pós-Treino:** `Elite_Sobrevivencia`, `Elite_Desvios`, `Elite_Colisoes`, `Elite_DanoCausado`, `Elite_DanoTomado`.
- `Tempo_Treino_Seg`: Performance computacional em segundos.
- `Modo_EDS`: *Flag* teórica (0 = Híbrido Crossover+Mutação, 1 = Mutação Pura Box-Muller).

---

## 2. Catálogo Histórico de Experiência (`catalogo_sec.csv`)
Baseado no artigo de **Glavin & Madden**, este banco de dados salva *Snapshots* (fotografias) do campeão em momentos intermediários do treinamento evolutivo.

- **Objetivo Científico:** Habilitar o Ajuste Dinâmico de Dificuldade (DDA) no projeto final, permitindo que a IA carregue um inimigo "burro" ou "especialista" em tempo real caso o jogador esteja frustrado ou entediado.
- **Marcos Salvos (Milestones):** $20\%$, $50\%$ e $100\%$ do progresso das gerações.
- **Estrutura de Colunas:** `Data_Hora`, `Dificuldade`, `Geracao`, `Modo_EDS`, `Fitness`, `HP`, `Atk`, `AtkSpd`, `MovSpd`.

---

## 3. Matriz de Diversidade de Nichos (`map_elites.csv`)
Baseado na teoria de **Kirk & Scirea**, o foco deixa de ser apenas o Fitness Absoluto (Quality) e passa a focar também na variação genética (Diversity).

- **Objetivo Científico:** Evitar a previsibilidade e repetição, descobrindo diferentes **Classes de Combate** viáveis. O algoritmo não salva apenas o campeão global, mas o *melhor de cada sub-nicho*.
- **Estrutura da Matriz 3x3 no Octave:**
  - **Eixo Y (Mobilidade):** `Lento` (< 4.5 m/s), `Medio` (4.5 a 6.5 m/s), `Rapido` (> 6.5 m/s).
  - **Eixo X (Classe Física):** Razão HP/Ataque determinando `Tank`, `Balanceado` e `Dano(GlassCannon)`.
- **Estrutura de Colunas:** `Data_Hora`, `Dificuldade`, `Modo_EDS`, `Mobilidade`, `Classe`, `Fitness`, `HP`, `Atk`, `AtkSpd`, `MovSpd`.
- **Resultado Prático:** Permite ao jogo *spawnar* uma equipe inteira onde cada membro tem uma estratégia completamente diferente de evasão (um frágil muito veloz, ou um tanque imovível, mas impenetrável).

---

## 🔗 Conexões Relacionadas
- [[00 - MOC Principal]]
- [[Execução Paralela & Análise Comparativa]]
- [[Ref - Glavin & Madden (Skilled Experience Catalogue)]]
- [[Ref - Kirk & Scirea (Map-Elites)]]

