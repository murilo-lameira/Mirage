# 📐 Estrutura & Orçamento de Espaço do Artigo (5 Páginas + Refs)

Diretriz de formatação: **5 páginas completas de conteúdo técnico** + **Referências Bibliográficas em página adicional** (padrão SBGames / SBC / IEEE).

> [!NOTE] Regra de Páginas & Referências Extras
> As referências bibliográficas **não contam** no limite das 5 páginas. Isso libera espaço integral para aprofundamento das deduções matemáticas, tabelas com testes ANOVA/Kruskal-Wallis e visualizações gráficas vetoriais de alta densidade.

---

## 👥 Identificação & Autoria Institucional
- **Título Oficial:** *"Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva"*
- **Autores:** Murilo Lameira da Silva, Henry Matheus Fregolente Ferreira, Murilo Romualdo da Silva, Leonardo Retori Apolônio
- **Orientador:** Prof. Ricardo Martinez Vicentini
- **Instituição:** Centro Universitário SENAI SP (UNISENAI), Campus São Caetano do Sul, SP, Brasil

---

## 📄 Orçamento de Páginas (Padrão 2 Colunas IEEE/SBC)

```text
[Página 1] ─── Título, Resumo & Abstract Bilíngue, Introdução & RQs Formais
[Página 2] ─── Trabalhos Relacionados & Modelagem Cinemática (CPA + Reynolds) + Fig. 1
[Página 3] ─── Arquitetura Genética, Restrição Orçamentária (1.8) & MAP-Elites
[Página 4] ─── Metodologia Experimental & Resultados Estatísticos (Tabela N=90 + Fig. 2 e 3)
[Página 5] ─── Estudos de Ablação, Discussão, Conclusão & Fig. 4 (MAP-Elites)
[Página 6+] ── Referências Bibliográficas (Página Adicional sem Limite Rígido)
```

---

## 📝 Detalhamento Seção por Seção

### 1. Introdução & Motivação (Pág. 1 — ~1.0 coluna)
- **Desafio em Jogos:** Comportamentos mecânicos previsíveis vs custos proibitivos de RL.
- **Proposta Mirage:** Simulação física 2D contínua acoplada a AG contínuo com CPA e Reynolds.
- **Reward Hacking Mitigado:** O exploit do tanque com HP massivo resolvido via orçamento estrito ($\sum u_i \le 1.8$).
- **Questões de Pesquisa (RQs):** Declaração explícita de RQ1, RQ2 e RQ3.

### 2. Trabalhos Relacionados & Fundamentação (Págs. 1-2 — ~1.0 coluna)
- *Steering Behaviors* de Reynolds (1999) e Closest Point of Approach (Lee, 2014).
- Dynamic Difficulty Adjustment & Checkpoints SEC (Glavin & Madden, 2015).
- Algoritmos de Qualidade-Diversidade (MAP-Elites de Mouret & Clune, 2015; Kirk & Scirea, 2020).

### 3. Modelagem Física & Cinemática (Pág. 2 — ~2.0 colunas)
- Equação temporal analítica $t_{\text{cpa}} = -\frac{\mathbf{p}_{\text{rel}} \cdot \mathbf{v}_{\text{rel}}}{\|\mathbf{v}_{\text{rel}}\|^2}$ e vetor de cruzamento $\mathbf{d}_{\text{cpa}}$.
- Força de Reynolds truncada $\mathbf{F}_{\text{steer}} = \text{trunc}(\mathbf{v}_{\text{desired}} - \mathbf{v}_{\text{current}}, F_{\text{max}})$.
- Integração semi-implícita de Euler com $\Delta t = 0{,}02\,\text{s}$ (50 FPS estáveis).
- **Figura 1:** `fig_diagrama_arena.pdf` (Esquema da arena $40 \times 40\text{ m}$ e evasão preditiva).

### 4. Arquitetura Genética sob Orçamento (Pág. 3 — ~2.0 colunas)
- Cromossomo contínuo $\mathbf{u} = [u_{\text{hp}}, u_{\text{atk}}, u_{\text{cad}}, u_{\text{vel}}]$ com restrição invariável $\sum_{i=1}^4 u_i \le 1{,}80$.
- Função de Fitness multi-objetivo com coeficientes reais calibrados por dificuldade:
  - Fácil ($D_1$): $10{,}0 / 5{,}0 / 0{,}50 / 10{,}0 / 0{,}20$
  - Médio ($D_2$): $15{,}0 / 8{,}0 / 0{,}80 / 15{,}0 / 0{,}30$
  - Difícil ($D_3$): $25{,}0 / 12{,}0 / 1{,}20 / 25{,}0 / 0{,}50$
- Escalonamento de tamanho populacional ($P \in \{20, 50, 100\}$ indivíduos), operador de recombinação $\text{BLX-}\alpha$, mutação gaussiana Box-Muller e elitismo estrito.
- Espaço comportamental 2D do MAP-Elites (Mobilidade vs Classe).

### 5. Metodologia Experimental & Resultados (Pág. 4 — ~2.0 colunas)
- **Amostragem:** $N = 90$ rodadas empíricas independentes ($N_1 = N_2 = N_3 = 30$) e $G = 50$ gerações ($135.000$ episódios).
- **Validação Estatística:** Tabela comparativa de métricas brutas e genes dos campeões com ANOVA One-Way e teste Kruskal-Wallis ($p < 10^{-10}$).
- **Emergência na Fronteira de Pareto:** Decomposição dos 3 arquétipos (Sniper/Glass Cannon, Combatente Equilibrado e Bruiser / Ladino), demonstrando que a evolução converge para a fronteira do orçamento ($\sum u_i \approx 1{,}78\text{--}1{,}79 \le 1{,}80$).
- **Figuras Integradas:**
  - **Figura 2:** `fig_convergencia.pdf` (Curvas de convergência ao longo de $G = 50$ gerações).
  - **Figura 3:** `fig_dispersao_genes.pdf` (Painel de boxplots com strip-jitter dos 4 genes).

### 6. Estudos de Ablação, Discussão & Conclusão (Pág. 5 — ~2.0 colunas)
- **Ablação 1:** Com vs Sem Budget (demonstração do colapso de variância $\sigma^2 = 0{,}004$ para velocidade).
- **Ablação 2:** CPA Preditivo vs Reativo (aumento de sobrevivência em $+103{,}7\%$, de $11{,}40\text{ s}$ para $23{,}22\text{ s}$, e redução de $77{,}5\%$ de colisões).
- **Figura 4:** `fig_map_elites.pdf` (Heatmap $3 \times 3$, cobertura $100\%$ e $\text{QD-Score} = 39.114{,}40$).
- **Conclusão:** Síntese das contribuições, limites de generalização e trabalhos futuros (NEAT).

### 7. Referências Bibliográficas (Página 6+ — Extra)
- Citações completas em formato SBC / IEEE compiladas via BibTeX em página extra.

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Resultados Consolidados do Artigo]]
- [[Estudos de Ablaçao & Metodologia]]
- [[Workflow LaTeX no VS Code]]
- [[Função de Fitness]]
- [[Cromossomo & Genes]]