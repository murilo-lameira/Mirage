# 📐 Estrutura & Orçamento de Espaço do Artigo (5 Páginas + Refs)

Diretriz de formatação: **5 páginas completas de conteúdo técnico** + **Referências Bibliográficas em página adicional** (padrão SBGames / IEEE / ACM).

> [!NOTE] Regra de Páginas
> As referências bibliográficas **não contam** no limite das 5 páginas. Isso libera espaço integral para aprofundamento das deduções matemáticas, tabelas estatísticas e visualizações gráficas de alta densidade.

---

## 📄 Orçamento de Páginas (Padrão 2 Colunas)

```text
[Página 1] ─── Título, Resumo/Abstract, Introdução & RQs Formais
[Página 2] ─── Trabalhos Relacionados & Modelagem Cinemática (CPA + Reynolds)
[Página 3] ─── Arquitetura Genética, Restrição Orçamentária (1.8) & MAP-Elites
[Página 4] ─── Metodologia Experimental & Resultados Estatísticos (ANOVA / Boxplots)
[Página 5] ─── Estudos de Ablação (Com/Sem Budget, Com/Sem CPA) & Conclusão
[Página 6+] ── Referências Bibliográficas (Página Extra sem Limite Rígido)
```

---

## 📝 Detalhamento Seção por Seção

### 1. Introdução & Motivação (Pág. 1 — ~1.0 colunas)
- **Desafio em Jogos:** Comportamentos mecânicos previsíveis vs custos proibitivos de RL.
- **Proposta Mirage:** Simulação física 2D acoplada a AG contínuo com CPA e Reynolds.
- **Fenômeno de Reward Hacking:** O exploit do tanque com HP massivo.
- **Questões de Pesquisa (RQs):** Declaração explícita de RQ1, RQ2 e RQ3.

### 2. Trabalhos Relacionados & Fundamentação (Págs. 1-2 — ~1.0 colunas)
- *Steering Behaviors* de Reynolds (1999) e Closest Point of Approach (Lee, 2014).
- Dynamic Difficulty Adjustment & Checkpoints SEC (Glavin & Madden, 2015).
- Algoritmos de Qualidade-Diversidade (MAP-Elites de Mouret & Clune, 2015; Kirk & Scirea, 2020).

### 3. Modelagem Física & Cinemática (Pág. 2 — ~2.0 colunas)
- Equação temporal analítica $t_{\text{cpa}} = -\frac{\mathbf{p}_{\text{rel}} \cdot \mathbf{v}_{\text{rel}}}{\|\mathbf{v}_{\text{rel}}\|^2}$ e vetor de cruzamento $\mathbf{d}_{\text{cpa}}$.
- Força de Reynolds truncada $\mathbf{F}_{\text{steer}} = \text{trunc}(\mathbf{v}_{\text{desired}} - \mathbf{v}_{\text{current}}, F_{\text{max}})$.
- Integração semi-implícita de Euler com $\Delta t = 0.05\,\text{s}$ (50 FPS estáveis).

### 4. Arquitetura Genética sob Orçamento (Pág. 3 — ~2.0 colunas)
- Cromossomo contínuo $\mathbf{u} = [u_{\text{hp}}, u_{\text{atk}}, u_{\text{cad}}, u_{\text{vel}}]$.
- Restrição invariável: $\sum_{i=1}^4 u_i \le 1.8$, normalização proporcional.
- Função de Fitness multi-objetivo (sobrevivência, acertos e esquivas ativas).
- Espaço comportamental 2D do MAP-Elites (Mobilidade vs Classe).

### 5. Metodologia Experimental & Resultados (Pág. 4 — ~2.0 colunas)
- $N = 86$ rodadas empíricas distribuídas entre Fácil ($D_1$), Médio ($D_2$) e Difícil ($D_3$).
- Tabela compacta de ANOVA One-Way ($F = 327.46, p < 0.001$) e Testes $t$ pareados ($d > 4.0$).
- Gráficos integrados: Boxplot de dispersão gênica e Heatmap do MAP-Elites.

### 6. Estudos de Ablação & Conclusão (Pág. 5 — ~2.0 colunas)
- **Ablação 1:** Com vs Sem Budget (comprovação matemática do colapso de diversidade).
- **Ablação 2:** CPA Preditivo vs Força Reativa Pura (ganho em tempo de sobrevivência).
- **Conclusão:** Síntese dos achados, limites de generalização e trabalhos futuros (NEAT).

### 7. Referências Bibliográficas (Pág. 6+ — Extra)
- Citações completas em formato ABNT / IEEE compiladas via BibTeX.

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Estudos de Ablaçao & Metodologia]]
- [[Workflow LaTeX no VS Code]]