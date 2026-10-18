"""
=============================================================================
PROJETO MIRAGE — PONTO DE ENTRADA DO EXECUTÁVEL (STANDALONE LAUNCHER)
=============================================================================
Wrapper para compilação PyInstaller. Garante inicialização limpa e redireciona
o diretório de trabalho (CWD) para a pasta raiz onde o executável reside.
=============================================================================
"""

import os
import sys
from pathlib import Path

# Se rodando em modo congelado (PyInstaller .exe), garante que CWD é a pasta do .exe
if getattr(sys, "frozen", False):
    exe_dir = Path(sys.executable).parent.resolve()
    if not (exe_dir / "data").exists() and (exe_dir.parent / "data").exists():
        work_dir = exe_dir.parent
    else:
        work_dir = exe_dir
    os.chdir(work_dir)
    sys.path.insert(0, str(work_dir))
else:
    root_dir = Path(__file__).parent.resolve()
    os.chdir(root_dir)
    sys.path.insert(0, str(root_dir))

import multiprocessing

from mirage.main import main

if __name__ == "__main__":
    multiprocessing.freeze_support()
    main()

