from __future__ import annotations

from pathlib import Path

import cadquery as cq

from geometry.badge import build_badge
from parameters import BadgeParameters


def export_model(badge: cq.Solid, params: BadgeParameters, output_dir: Path | None = None) -> None:
    """Export STEP and STL files for the badge."""
    if output_dir is None:
        output_dir = Path(__file__).resolve().parent / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    step_path = output_dir / f"watermelon_badge_{params.badge_diameter:.0f}mm.step"
    stl_path = output_dir / f"watermelon_badge_{params.badge_diameter:.0f}mm.stl"

    cq.exporters.export(badge, str(step_path))
    cq.exporters.export(badge, str(stl_path))

    print(f"Exported STEP to {step_path}")
    print(f"Exported STL to {stl_path}")


if __name__ == "__main__":
    export_model(build_badge(BadgeParameters()), BadgeParameters())
