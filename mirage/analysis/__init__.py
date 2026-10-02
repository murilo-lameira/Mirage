"""
Subpacote de Análise Estatística e Geração de Gráficos Científicos do Mirage.
"""

from mirage.analysis.stats import run_statistical_analysis, export_statistical_report
from mirage.analysis.plotting import generate_all_academic_plots

__all__ = [
    "run_statistical_analysis",
    "export_statistical_report",
    "generate_all_academic_plots",
]

