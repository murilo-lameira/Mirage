# 🎓 MOC — Artigo Científico (5 Páginas + Refs)

Mapa central de planejamento e redação do artigo científico derivado do projeto **Mirage**.

---

## 📌 Metadados da Publicação
- **Título Oficial:** *"Mirage: Adaptação Evolutiva de NPCs sob Restrição Orçamentária com Esquiva Preditiva"*
- **Formato-Alvo:** *Short Paper* (**5 páginas completas de conteúdo técnico + referências em páginas adicionais**).
- **Padrão Editorial:** IEEE / SBC (duas colunas, resumo e abstract bilíngues).
- **Ambiente de Escrita:** LaTeX no VS Code com compilação local (TeX Live / MiKTeX) e repositório Git (`paper/Mirage_Artigo_SENAI.tex` e `paper/Mirage_Artigo_SENAI.pdf`).
- **Congressos Prováveis:**
  - **SBGames (Trilha de Computação):** Maior simpósio de games da América Latina (Qualis Capes, indexado SBC/IEEE).
  - **ENIAC / BRACIS (Inteligência Computacional):** Foco em algoritmos bioinspirados e IA.
  - **IEEE Conference on Games (CoG):** Opção internacional em língua inglesa.

---

## 👥 Autoria Oficial & Afiliação Institucional
- **Autores:**
  1. **Murilo Lameira da Silva** (Autor Principal / Correspondente)
  2. **Henry Matheus Fregolente Ferreira**
  3. **Murilo Romualdo da Silva**
  4. **Leonardo Retori Apolônio**
- **Orientador:**
  - **Prof. Ricardo Martinez Vicentini**
- **Afiliação:** Engenharia de Controle e Automação — Centro Universitário SENAI SP (UNISENAI), Campus São Caetano do Sul, SP, Brasil.

---

## 🔒 Regra de Governança Documental (< 200 Linhas)
Caso qualquer documento técnico em `60 - Artigo Cientifico/` ultrapasse **200 linhas**, ele deve ser imediatamente seccionado em arquivos atômicos complementares (ex: `Nome (Parte 2).md`), mantendo o cofre navegável e atômico.

---

## 🧭 Documentos de Planejamento & Resultados
1. [[Estrutura do Artigo (5 Paginas)]] — Distribuição de espaço, seções técnicas (IMRaD) e posicionamento das 4 figuras vetoriais.
2. [[Resultados Consolidados do Artigo]] — Síntese das $N = 90$ rodadas ($G = 50$), ANOVA, Kruskal-Wallis, MAP-Elites ($\text{QD-Score} = 39.114{,}40$) e ablações.
3. [[Estudos de Ablaçao & Metodologia]] — Hipóteses formais de ablação (Budget e CPA) e métricas de QD.
4. [[Workflow LaTeX no VS Code]] — Guia prático para edição, compilação e template no VS Code.

---

## 🎯 Perguntas de Pesquisa (Research Questions)
- **RQ1:** A imposição de um orçamento energético rígido ($\sum u_i \le 1{,}8$) mitiga o *Reward Hacking* e garante a emergência de arquétipos táticos funcionais?
- **RQ2:** A predição analítica por Ponto de Maior Aproximação (CPA) supera esquivas reativas puramente geométricas sob alta densidade cinemática?
- **RQ3:** Como o MAP-Elites mapeia a transição comportamental dos agentes entre diferentes regimes de dificuldade sem exigir recalibração manual?

---

## 🔗 Conexões do Cofre
- [[00 - MOC Principal]]
- [[Ref - Kirk & Scirea (Map-Elites)]]
- [[Ref - Lee (KIOTS)]]
- [[Execução Paralela & Análise Comparativa]]
- [[Cromossomo & Genes]]
- [[Função de Fitness]]