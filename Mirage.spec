# -*- mode: python ; coding: utf-8 -*-
"""
=============================================================================
PROJETO MIRAGE — ESPECIFICAÇÃO DE COMPILAÇÃO DO PYINSTALLER
=============================================================================
Empacota o sistema autônomo Mirage (IA Evolutiva, Cinemática Numba, Pygame-CE)
em um executável único de alta performance (Mirage.exe).
=============================================================================
"""

import sys
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

block_cipher = None

# 1. Imports Ocultos (Hidden Imports) Críticos
hidden_imports = [
    # Framework Gráfico e Áudio
    'pygame',
    'pygame.font',
    'pygame.display',
    'pygame.draw',
    'pygame.time',
    'pygame.event',
    # Aceleração JIT e Compilação
    'numba',
    'llvmlite',
    # Computação Científica e Estatística
    'scipy',
    'scipy.stats',
    'scipy.special',
    'scipy.spatial.transform._rotation_groups',
    'pandas',
    # Visualização e Visão Computacional
    'matplotlib',
    'matplotlib.pyplot',
    'matplotlib.backends.backend_agg',
    'seaborn',
    'cv2',
    'PIL',
    'PIL.Image',
]

# Inclui todos os submódulos da biblioteca própria Mirage
hidden_imports += collect_submodules('mirage')
hidden_imports += collect_submodules('numba')
hidden_imports += collect_submodules('llvmlite')

# 2. Arquivos de Dados e Recursos Auxiliares
datas = [
    ('data', 'data'),
]
datas += collect_data_files('numba')
datas += collect_data_files('llvmlite')
datas += collect_data_files('pygame')
datas += collect_data_files('matplotlib')
datas += collect_data_files('scipy')

# 3. Análise Estática de Código e Dependências
a = Analysis(
    ['run_mirage.py'],
    pathex=['.'],
    binaries=[],
    datas=datas,
    hiddenimports=hidden_imports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'PyQt5',
        'PyQt6',
        'IPython',
        'notebook',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(
    a.pure,
    a.zipped_data,
    cipher=block_cipher,
)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='Mirage',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
