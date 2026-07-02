from __future__ import annotations
from pathlib import Path

from geometry.badge import build_badge
from export import export_model
from parameters import BadgeParameters


def main(params: BadgeParameters | None = None) -> None:
    params = params or BadgeParameters()
    badge = build_badge(params)
    output_dir = Path(__file__).resolve().parent / "output"
    export_model(badge, params, output_dir=output_dir)


if __name__ == "__main__":
    main()
