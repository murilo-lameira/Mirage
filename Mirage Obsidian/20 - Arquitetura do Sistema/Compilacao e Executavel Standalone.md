# 📦 Compilação e Executável Standalone (.exe)

Este documento descreve o fluxo de empacotamento, arquitetura de runtime e diretrizes de distribuição do executável autônomo (standalone `.exe`) do ecossistema **Mirage**.

---

## 🎯 1. Motivação e Objetivos de Distribuição
Para avaliação por bancas examinadoras, submissões em conferências científicas e jogadores sem conhecimento técnico, é fundamental que a simulação funcione **sem a necessidade de instalar Python, Git ou bibliotecas externas** (NumPy, Pygame-CE, SciPy, Matplotlib, Seaborn).

O executável standalone:
1. **Encapsula o Runtime Completo:** Empacota o interpretador Python 3.12+ e todas as dependências pré-compiladas.
2. **Preserva a Dualidade Operacional:** Oferece interface interativa via console gráfico e suporte total a argumentos CLI (`--demo`, `--play`, etc.).
3. **Persistência Relativa de Dados:** Grava e lê telemetrias em `data/` a partir do diretório onde o executável reside, não interferindo nas pastas do sistema.

---

## 🧱 2. Ponto de Entrada Dedicado (`run_mirage.py`)
Para contornar particularidades do runtime congelado do PyInstaller no Windows, foi implementado o wrapper `run_mirage.py`:

```python
# Trecho de inicialização em run_mirage.py
if getattr(sys, "frozen", False):
    exe_dir = Path(sys.executable).parent.resolve()
    os.chdir(exe_dir)
    sys.path.insert(0, str(exe_dir))
else:
    root_dir = Path(__file__).parent.resolve()
    os.chdir(root_dir)
    sys.path.insert(0, str(root_dir))

import multiprocessing
from mirage.main import main

if __name__ == "__main__":
    multiprocessing.freeze_support()
    main()
```

### Invariantes Críticos do Launcher:
- **`sys.frozen` & `os.chdir(exe_dir)`:** Garante que o *Current Working Directory* (CWD) aponte para a pasta real do executável e não para a pasta temporária `_MEIxxxx` descompactada pelo PyInstaller.
- **`multiprocessing.freeze_support()`:** Indispensável no Windows para evitar o fenômeno de *fork bomb* ou loop recursivo infinito ao disparar baterias de experimentos em paralelo via `multiprocessing` / `ProcessPoolExecutor`.

---

## 🛠️ 3. Processo de Empacotamento com PyInstaller

### Pré-requisitos
No ambiente de desenvolvimento com o ambiente virtual ativado:
```powershell
pip install pyinstaller
```

### Opção A — Distribuição em Diretório (Recomendada: `--onedir`)
Oferece inicialização imediata da janela Pygame, sem atraso de extração temporária a cada execução:
```powershell
pyinstaller --noconfirm --onedir --console `
    --name "Mirage" `
    --add-data "mirage;mirage" `
    run_mirage.py
```
O pacote resultante residirá em `dist/Mirage/` contendo `Mirage.exe` e as bibliotecas dinâmicas essenciais (`.dll`).

### Opção B — Executável Único Portável (`--onefile`)
Gera um único binário autocontido para envio simplificado:
```powershell
pyinstaller --noconfirm --onefile --console `
    --name "Mirage" `
    --add-data "mirage;mirage" `
    run_mirage.py
```

---

## 🎮 4. Guia de Execução para o Usuário Final

O usuário final que receber o executável **não precisa de nenhum pré-requisito instalado**.

### Modo Interativo (Duplo Clique)
1. O usuário dá duplo clique em `Mirage.exe`.
2. Um console interativo exibe o banner estético e o menu de opções numeradas de `[1]` a `[7]`:
   - `[1]` Demonstração da IA Campeã no Pygame (Modo Espectador);
   - `[2]` Jogar na Arena Cyberpunk (WASD / Mouse);
   - `[3]` Treinar Novo NPC Campeão via Algoritmo Genético;
   - `[4]` Executar Bateria de Experimentos em Lote;
   - `[5]` Rodar Validação Estatística Formal (ANOVA);
   - `[6]` Gerar Gráficos Científicos (300 DPI);
   - `[7]` Gerar Mídias Visuais (GIFs & Vídeos).

### Modo Linha de Comando (CLI / Automação)
Avaliadores podem executar testes diretos via PowerShell ou Command Prompt:

```powershell
# Iniciar simulação visual autônoma na Dificuldade 2
.\Mirage.exe --demo --diff 2

# Jogar como humano contra projéteis na Dificuldade 3
.\Mirage.exe --play --diff 3

# Treinar um NPC adaptativo em modo texto
.\Mirage.exe --train --diff 2

# Executar bateria de 30 corridas paralelas
.\Mirage.exe --batch --runs 30

# Computar ANOVA One-Way e relatórios estatísticos
.\Mirage.exe --stats

# Renderizar todas as figuras acadêmicas em data/graficos/
.\Mirage.exe --plots
```

---

## ⚠️ 5. Gotchas & Cuidados de Governança
- **Aceleração Gráfica:** Pygame-CE utiliza aceleração por software e SDL2. Em sistemas sem GPU dedicada, o framerate de 50 FPS permanece fluido.
- **Criação de Pastas:** O runtime standalone cria automaticamente o diretório `data/` e subpastas caso não existam no local de execução.
- **Encoding de Console:** O executável força `utf-8` via `sys.stdout.reconfigure()` para compatibilidade com consoles Windows legados (evitando falhas em caracteres matemáticos).

---

## 🔗 Conexões do Cofre
- [[00 - MOC Principal]]
- [[Migracao e Arquitetura Python]]
- [[Guia de Uso & Comandos]]
- [[Estrutura do Projeto & Diretórios]]
- [[Execução Paralela & Análise Comparativa]]
