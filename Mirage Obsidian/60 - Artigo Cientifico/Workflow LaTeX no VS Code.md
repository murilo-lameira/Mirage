# 🛠️ Workflow LaTeX no VS Code — Artigo Mirage

Guia de configuração e boas práticas para redigir o artigo científico do projeto **Mirage** em LaTeX diretamente no Visual Studio Code.

---

## 💻 1. Por que Escrever LaTeX no VS Code?
- **Versionamento Git Nativo:** Histórico de commits, diffs claros e coautoria com agentes.
- **Integração com o Código:** Acesso imediato aos gráficos em `data/graficos/` e tabelas exportadas pelo Octave/MATLAB.
- **Produtividade Máxima:** Atalhos de autocompletar citações BibTeX e compilação em segundo plano.

---

## 📦 2. Estrutura Recomendada de Diretórios do Artigo

Recomendamos criar uma pasta na raiz do repositório:
```text
Mirage/
├── paper/
│   ├── main.tex              # Arquivo LaTeX principal (estrutura, seções e includes)
│   ├── referencias.bib       # Base de dados bibliográfica BibTeX
│   ├── sbc.sty ou IEEEtran.cls # Folha de estilo do congresso
│   ├── figuras/              # Cópia das figuras de alta resolução (PDF ou PNG)
│   └── secoes/               # (Opcional) Divisão modular por seções
│       ├── 01_introducao.tex
│       ├── 02_relacionados.tex
│       ├── 03_cinematica.tex
│       ├── 04_algoritmo_genetico.tex
│       ├── 05_experimentos.tex
│       └── 06_conclusao.tex
```

---

## ⚙️ 3. Extensões Recomendadas no VS Code
1. **LaTeX Workshop** (James-Yu):
   - Compilação automática ao salvar (`Ctrl+S`).
   - Visualizador de PDF integrado lado a lado no próprio editor.
   - Navegação bidirecional (SyncTeX: clique no PDF para ir para a linha do `.tex`).
2. **LTeX – LanguageTool grammar checking**:
   - Correção ortográfica e gramatical inteligente em tempo real (Português e Inglês).

---

## 📑 4. Compiladores Locais
Para compilar localmente na máquina (Windows):
- **MiKTeX** (Recomendado pela instalação rápida e download automático de pacotes sob demanda) ou **TeX Live**.
- Alternativamente, todo o diretório `paper/` pode ser compactado em `.zip` e aberto com 1 clique no **Overleaf**.

---

## 🔗 Conexões
- [[00 - MOC Artigo Cientifico]]
- [[Estrutura do Artigo (5 Paginas)]]
- [[Guia de Uso & Comandos]]