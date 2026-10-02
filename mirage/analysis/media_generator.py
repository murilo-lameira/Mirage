"""
=============================================================================
PROJETO MIRAGE — GERADOR DE MÍDIAS VISUAIS (GIFS ANIMADOS & VÍDEO MP4)
=============================================================================
Renderização headless de alta fidelidade para apresentações, README e slides:
- Simulação física síncrona com telemetria contínua.
- Renderização off-screen dos vetores de Reynolds (CPA), feixe balístico,
  radar holográfico, partículas de projéteis e telemetria HUD.
- Exportação de GIFs otimizados com quantização adaptativa via Pillow.
- Exportação de vídeos MP4 em alta resolução via OpenCV.
=============================================================================
"""

import os
import math
import shutil
from pathlib import Path
from typing import List, Optional, Tuple
import numpy as np
from PIL import Image

# Configura o driver de vídeo para execução headless sem popups indesejados
os.environ["SDL_VIDEODRIVER"] = "dummy"

import pygame
from mirage.config import (
    ARENA_BOUNDS,
    DIFFICULTY_SETTINGS,
    DT_PHYSICS,
    MAX_EPISODE_TIME,
    DifficultyConfig,
)
from mirage.core.simulation import TelemetryFrame, denormalize_chromosome, simulate_episode
from mirage.gui.arena_view import CyberArenaRenderer


def _get_champion_chromosomes() -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Recupera os cromossomos campeões por dificuldade a partir dos dados experimentais."""
    csv_path = Path("data/resultados_experimentos.csv")
    champions = {
        1: np.array([0.05, 0.95, 0.78, 0.02], dtype=np.float64),
        2: np.array([0.06, 0.91, 0.79, 0.04], dtype=np.float64),
        3: np.array([0.18, 0.67, 0.81, 0.14], dtype=np.float64),
    }

    if csv_path.exists():
        try:
            import pandas as pd
            df = pd.read_csv(csv_path)
            for d in (1, 2, 3):
                sub = df[df["Dificuldade"] == d]
                if not sub.empty:
                    best_row = sub.loc[sub["Fitness_Max"].idxmax()]
                    hp = float(best_row["Elite_HP"])
                    atk = float(best_row["Elite_Atk"])
                    cad = float(best_row["Elite_AtkSpd"])
                    vel = float(best_row["Elite_MovSpd"])
                    # Normaliza de volta para o cromossomo contínuo [0, 1]
                    u0 = np.clip((hp - 10.0) / 190.0, 0.0, 1.0)
                    u1 = np.clip((atk - 5.0) / 45.0, 0.0, 1.0)
                    u2 = np.clip((cad - 0.5) / 4.5, 0.0, 1.0)
                    u3 = np.clip((vel - 1.0) / 7.0, 0.0, 1.0)
                    champions[d] = np.array([u0, u1, u2, u3], dtype=np.float64)
        except Exception:
            pass

    return champions[1], champions[2], champions[3]


def render_telemetry_frames_to_images(
    telemetry: List[TelemetryFrame],
    cfg: DifficultyConfig,
    width: int = 540,
    height: int = 540,
    max_frames: int = 200,
    subsample: int = 1,
) -> List[Image.Image]:
    """Renderiza a sequência de quadros de telemetria em imagens Pillow PIL."""
    renderer = CyberArenaRenderer(width=width, height=height, title="Offscreen Mirage Render")
    images: List[Image.Image] = []

    target_count = min(len(telemetry), max_frames)
    indices = range(0, target_count, subsample)

    for idx in indices:
        f = telemetry[idx]

        # Renderização em camadas
        renderer.draw_background()
        renderer.draw_pillars()
        renderer.draw_projectiles(f.enemy_projectiles, f.npc_projectiles)
        renderer.draw_npc(
            pos=f.npc_pos,
            vel=f.npc_vel,
            hp=f.npc_hp,
            max_hp=f.npc_max_hp,
            evade_force=f.evade_force,
            lead_target=f.lead_target,
        )
        renderer.draw_hud(
            time_curr=f.time,
            time_max=MAX_EPISODE_TIME,
            hp=f.npc_hp,
            max_hp=f.npc_max_hp,
            dodges=f.dodges,
            collisions=f.collisions,
            damage_inflicted=f.damage_inflicted,
            difficulty_name=cfg.name,
            mode_label="SHOWCASE MIRAGE (IA)",
            fps=50.0,
        )

        raw_bytes = pygame.image.tobytes(renderer.screen, "RGB")
        img = Image.frombytes("RGB", (width, height), raw_bytes)
        images.append(img)

    renderer.close()
    return images


def generate_animated_gif(
    chromosome: np.ndarray,
    difficulty: int,
    output_path: Path,
    duration_seconds: float = 8.0,
    fps: int = 20,
    size: Tuple[int, int] = (520, 520),
    seed: int = 42,
) -> Path:
    """Gera um arquivo GIF animado altamente otimizado."""
    cfg = DIFFICULTY_SETTINGS.get(difficulty, DIFFICULTY_SETTINGS[2])
    print(f"  [Simulação] Rodando combate (Dificuldade {cfg.name}, {duration_seconds:.1f}s)...")

    res, telemetry = simulate_episode(
        chromosome=chromosome,
        difficulty=difficulty,
        record_telemetry=True,
        seed=seed,
    )

    steps_needed = int(duration_seconds / DT_PHYSICS)
    telemetry_slice = telemetry[:steps_needed]

    print(f"  [Renderização] Desenhando {len(telemetry_slice)} quadros em {size[0]}x{size[1]}...")
    images = render_telemetry_frames_to_images(
        telemetry_slice,
        cfg=cfg,
        width=size[0],
        height=size[1],
        max_frames=len(telemetry_slice),
        subsample=1,
    )

    if not images:
        raise RuntimeError("Nenhum quadro foi gerado para o GIF.")

    print("  [Otimização] Convertendo paleta e salvando GIF...")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    palette_images: List[Image.Image] = []
    base_palette = images[0].quantize(colors=128, method=Image.Quantize.MEDIANCUT)

    for img in images:
        p_img = img.quantize(colors=128, palette=base_palette)
        palette_images.append(p_img)

    frame_duration_ms = int(1000.0 / fps)
    palette_images[0].save(
        output_path,
        save_all=True,
        append_images=palette_images[1:],
        optimize=True,
        duration=frame_duration_ms,
        loop=0,
    )

    size_kb = output_path.stat().st_size / 1024
    print(f"  -> Concluído: {output_path.name} ({size_kb:.1f} KB)")
    return output_path


def generate_combat_video(
    chromosome: np.ndarray,
    difficulty: int,
    output_path: Path,
    duration_seconds: float = 12.0,
    fps: int = 20,
    size: Tuple[int, int] = (800, 800),
    seed: int = 42,
) -> Optional[Path]:
    """Gera um vídeo MP4 em alta definição com OpenCV."""
    try:
        import cv2
    except ImportError:
        print("  [Aviso] OpenCV não disponível para vídeo MP4.")
        return None

    cfg = DIFFICULTY_SETTINGS.get(difficulty, DIFFICULTY_SETTINGS[2])
    print(f"  [Vídeo MP4] Simulando combate para MP4 ({duration_seconds:.1f}s)...")

    res, telemetry = simulate_episode(
        chromosome=chromosome,
        difficulty=difficulty,
        record_telemetry=True,
        seed=seed,
    )

    steps_needed = int(duration_seconds / DT_PHYSICS)
    telemetry_slice = telemetry[:steps_needed]

    renderer = CyberArenaRenderer(width=size[0], height=size[1], title="Video Render")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    video_writer = cv2.VideoWriter(str(output_path), fourcc, float(fps), size)

    for f in telemetry_slice:
        renderer.draw_background()
        renderer.draw_pillars()
        renderer.draw_projectiles(f.enemy_projectiles, f.npc_projectiles)
        renderer.draw_npc(
            pos=f.npc_pos,
            vel=f.npc_vel,
            hp=f.npc_hp,
            max_hp=f.npc_max_hp,
            evade_force=f.evade_force,
            lead_target=f.lead_target,
        )
        renderer.draw_hud(
            time_curr=f.time,
            time_max=MAX_EPISODE_TIME,
            hp=f.npc_hp,
            max_hp=f.npc_max_hp,
            dodges=f.dodges,
            collisions=f.collisions,
            damage_inflicted=f.damage_inflicted,
            difficulty_name=cfg.name,
            mode_label="SHOWCASE MIRAGE (HD)",
            fps=float(fps),
        )

        raw = pygame.image.tobytes(renderer.screen, "RGB")
        frame_rgb = np.frombuffer(raw, dtype=np.uint8).reshape((size[1], size[0], 3))
        frame_bgr = cv2.cvtColor(frame_rgb, cv2.COLOR_RGB2BGR)
        video_writer.write(frame_bgr)

    video_writer.release()
    renderer.close()

    size_kb = output_path.stat().st_size / 1024
    print(f"  -> Concluído Vídeo: {output_path.name} ({size_kb:.1f} KB)")
    return output_path


def generate_all_media():
    """Gera todo o conjunto multimídia do ecossistema Mirage."""
    print("=" * 80)
    print("PROJETO MIRAGE — GERAÇÃO AUTOMATIZADA DE MÍDIAS VISUAIS")
    print("=" * 80)

    champ_d1, champ_d2, champ_d3 = _get_champion_chromosomes()
    graficos_dir = Path("data/graficos")
    graficos_dir.mkdir(parents=True, exist_ok=True)

    # 1. GIF Principal Showcase (Dificuldade Média / Campeão Global)
    print("\n[1/5] Gerando GIF Principal de Showcase (data/arena_demo.gif)...")
    generate_animated_gif(
        chromosome=champ_d2,
        difficulty=2,
        output_path=Path("data/arena_demo.gif"),
        duration_seconds=8.0,
        fps=20,
        size=(520, 520),
    )
    shutil.copy("data/arena_demo.gif", graficos_dir / "demonstracao_npc.gif")

    # 2. GIF do Arquétipo Fácil (Tanker / Bruiser)
    print("\n[2/5] Gerando GIF do Arquétipo Fácil - Tanker (data/graficos/demo_facil_tanker.gif)...")
    generate_animated_gif(
        chromosome=champ_d1,
        difficulty=1,
        output_path=graficos_dir / "demo_facil_tanker.gif",
        duration_seconds=7.0,
        fps=20,
        size=(480, 480),
    )

    # 3. GIF do Arquétipo Médio (Combatente Balanceado)
    print("\n[3/5] Gerando GIF do Arquétipo Médio - Balanceado (data/graficos/demo_medio_balanceado.gif)...")
    generate_animated_gif(
        chromosome=champ_d2,
        difficulty=2,
        output_path=graficos_dir / "demo_medio_balanceado.gif",
        duration_seconds=7.0,
        fps=20,
        size=(480, 480),
    )

    # 4. GIF do Arquétipo Difícil (Ninja Evasivo / Danmaku Hell)
    print("\n[4/5] Gerando GIF do Arquétipo Difícil - Evasor Danmaku (data/graficos/demo_dificil_ninja.gif)...")
    generate_animated_gif(
        chromosome=champ_d3,
        difficulty=3,
        output_path=graficos_dir / "demo_dificil_ninja.gif",
        duration_seconds=7.0,
        fps=20,
        size=(480, 480),
    )

    # 5. Vídeo MP4 em Alta Resolução (Slides e Apresentações)
    print("\n[5/5] Gerando Vídeo MP4 HD (data/graficos/demonstracao_combate.mp4)...")
    generate_combat_video(
        chromosome=champ_d2,
        difficulty=2,
        output_path=graficos_dir / "demonstracao_combate.mp4",
        duration_seconds=12.0,
        fps=20,
        size=(800, 800),
    )

    print("\n" + "=" * 80)
    print("[SUCESSO] Todas as mídias foram geradas com sucesso!")
    print("  - data/arena_demo.gif (Showcase para README e GitHub)")
    print("  - data/graficos/demonstracao_npc.gif (Demonstração do Artigo)")
    print("  - data/graficos/demo_facil_tanker.gif")
    print("  - data/graficos/demo_medio_balanceado.gif")
    print("  - data/graficos/demo_dificil_ninja.gif")
    print("  - data/graficos/demonstracao_combate.mp4 (Vídeo HD para Apresentação)")
    print("=" * 80)


if __name__ == "__main__":
    generate_all_media()
