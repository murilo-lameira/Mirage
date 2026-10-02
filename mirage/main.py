"""
=============================================================================
PROJETO MIRAGE — PONTO DE ENTRADA PRINCIPAL (CLI & LAUNCHER)
=============================================================================
Orquestrador unificado de simulação física, evolução genética,
coleta de dados experimentais, auditoria estatística e renderização gráfica.
=============================================================================
"""

import argparse
import sys
import numpy as np

# Garante suporte a UTF-8 no console do Windows sem erros de charmap
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

from mirage.config import DIFFICULTY_SETTINGS
from mirage.core.ga import train_genetic_algorithm
from mirage.core.batch_runner import run_batch_experiments
from mirage.analysis.stats import run_statistical_analysis, export_statistical_report
from mirage.analysis.plotting import generate_all_academic_plots
from mirage.analysis.media_generator import generate_all_media
from mirage.gui.game_app import run_spectator_mode, run_playable_human_mode


BANNER = r"""
  __  __ _____ _____            _____ ______ 
 |  \/  |_   _|  __ \   /\     / ____|  ____|
 | \  / | | | | |__) | /  \   | |  __| |__   
 | |\/| | | | |  _  / / /\ \  | | |_ |  __|  
 | |  | |_| |_| | \ \/ ____ \ | |__| | |____ 
 |_|  |_|_____|_|  \/_/    \_\ \_____|______|
       Adaptative NPC Evolutionary AI v2.0
"""


def interactive_menu():
    """Menu interativo no terminal quando nenhum argumento de linha de comando é fornecido."""
    while True:
        print(BANNER)
        print(" [1] Visualizar Demonstração da IA Campeã (Modo Espectador - Pygame)")
        print(" [2] Jogar na Arena Cyberpunk (Modo Humano - WASD / Mouse)")
        print(" [3] Treinar Novo NPC Campeão (Algoritmo Genético)")
        print(" [4] Executar Bateria de Experimentos em Lote (Paralelo)")
        print(" [5] Rodar Validação Estatística Formal (ANOVA & Relatório)")
        print(" [6] Gerar Gráficos Científicos de Alta Resolução (300 DPI)")
        print(" [7] Gerar Mídias Visuais (GIFs Animados & Vídeo MP4)")
        print(" [0] Sair")
        print("-" * 55)

        try:
            choice = input("Escolha uma opção [0-7]: ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\nEncerrando Mirage.")
            break

        if choice == "1":
            print("\nSelecione a Dificuldade:")
            print("1 - Fácil (D1) | 2 - Médio (D2) | 3 - Difícil (D3)")
            d_choice = input("Opção [padrão: 2]: ").strip() or "2"
            diff = int(d_choice) if d_choice in ("1", "2", "3") else 2
            print(f"Iniciando Modo Espectador (Dificuldade {diff})...")
            run_spectator_mode(difficulty=diff)

        elif choice == "2":
            print("\nSelecione a Dificuldade:")
            print("1 - Fácil (D1) | 2 - Médio (D2) | 3 - Difícil (D3)")
            d_choice = input("Opção [padrão: 2]: ").strip() or "2"
            diff = int(d_choice) if d_choice in ("1", "2", "3") else 2
            print(f"Iniciando Modo Humano (WASD para mover, Mouse para atirar)...")
            run_playable_human_mode(difficulty=diff)

        elif choice == "3":
            print("\nSelecione a Dificuldade:")
            print("1 - Fácil (D1) | 2 - Médio (D2) | 3 - Difícil (D3)")
            d_choice = input("Opção [padrão: 2]: ").strip() or "2"
            diff = int(d_choice) if d_choice in ("1", "2", "3") else 2
            print(f"Treinando NPC para Dificuldade {diff}...")
            champion = train_genetic_algorithm(difficulty=diff, verbose=True)
            print("\nCampeão Encontrado!")
            print(f"Cromossomo: {np.round(champion.best_chromosome, 3)}")
            surv_str = f"{champion.best_result.survival_time:.1f}s" if champion.best_result else "N/A"
            print(f"Aptidão: {champion.best_fitness:.2f} | Sobrevivência: {surv_str}")
            ver = input("\nDeseja visualizar o campeão na arena? (s/N): ").strip().lower()
            if ver == "s":
                run_spectator_mode(chromosome=champion.best_chromosome, difficulty=diff)

        elif choice == "4":
            runs_in = input("Número de repetições por dificuldade [padrão: 10]: ").strip() or "10"
            n_runs = int(runs_in) if runs_in.isdigit() else 10
            print(f"Iniciando bateria com {n_runs} corridas por dificuldade...")
            run_batch_experiments(num_runs_per_diff=n_runs)

        elif choice == "5":
            print("\nExecutando Análise de Variância (One-Way ANOVA) e Testes t...")
            stats_res = run_statistical_analysis()
            report = export_statistical_report(stats_res)
            print("\n" + report)
            input("\nPressione Enter para continuar...")

        elif choice == "6":
            print("\nGerando gráficos científicos a 300 DPI...")
            generate_all_academic_plots()
            print("Gráficos salvos com sucesso em data/graficos/!")
            input("\nPressione Enter para continuar...")

        elif choice == "7":
            print("\nGerando mídias visuais automatizadas (GIFs e Vídeo MP4)...")
            generate_all_media()
            input("\nPressione Enter para continuar...")

        elif choice == "0":
            print("Encerrando Mirage. Até breve!")
            break
        else:
            print("[Aviso] Opção inválida. Digite um número de 0 a 7.")


def main():
    parser = argparse.ArgumentParser(
        description="Projeto Mirage — Simulação e Algoritmo Genético para NPCs Adaptativos"
    )
    parser.add_argument("--demo", action="store_true", help="Executa o Modo Espectador (IA Autônoma no Pygame)")
    parser.add_argument("--play", action="store_true", help="Executa o Modo Jogador Humano (WASD/Mouse)")
    parser.add_argument("--train", action="store_true", help="Treina um novo NPC via Algoritmo Genético")
    parser.add_argument("--batch", action="store_true", help="Executa bateria paralela de experimentos em lote")
    parser.add_argument("--stats", action="store_true", help="Gera o relatório estatístico formal (ANOVA)")
    parser.add_argument("--plots", action="store_true", help="Gera todos os gráficos científicos em data/graficos/")
    parser.add_argument("--media", action="store_true", help="Gera todas as mídias (GIFs e Vídeo MP4) em data/graficos/")
    parser.add_argument("--diff", type=int, default=2, choices=[1, 2, 3], help="Dificuldade (1: Fácil, 2: Médio, 3: Difícil)")
    parser.add_argument("--runs", type=int, default=10, help="Número de repetições por dificuldade na bateria")

    args = parser.parse_args()

    # Se nenhum argumento foi passado, abre o menu interativo
    if len(sys.argv) == 1:
        interactive_menu()
        return

    if args.stats:
        print("[Mirage] Executando Análise Estatística Formal...")
        res = run_statistical_analysis()
        rep = export_statistical_report(res)
        print(rep)

    if args.plots:
        print("[Mirage] Gerando Gráficos Científicos (300 DPI)...")
        generate_all_academic_plots()

    if args.media:
        print("[Mirage] Gerando Mídias Visuais Automatizadas...")
        generate_all_media()

    if args.train:
        print(f"[Mirage] Iniciando Treinamento do AG (Dificuldade {args.diff})...")
        champ = train_genetic_algorithm(difficulty=args.diff, verbose=True)
        print(f"[Sucesso] Campeão: {np.round(champ.best_chromosome, 3)}, Fitness: {champ.best_fitness:.2f}")

    if args.batch:
        print(f"[Mirage] Executando Bateria com {args.runs} repetições por dificuldade...")
        run_batch_experiments(num_runs_per_diff=args.runs)

    if args.demo:
        print(f"[Mirage] Abrindo Demonstração Espectador (Dificuldade {args.diff})...")
        run_spectator_mode(difficulty=args.diff)

    if args.play:
        print(f"[Mirage] Iniciando Arena Jogável (Dificuldade {args.diff})...")
        run_playable_human_mode(difficulty=args.diff)


if __name__ == "__main__":
    main()

