from pathlib import Path
import cadquery as cq
from cadquery import exporters

OUT_DIR = Path(__file__).resolve().parent / "output"
OUT_DIR.mkdir(exist_ok=True)


def make_badge_base() -> cq.Solid:
    base = (
        cq.Workplane("XY")
        .rect(70, 50)
        .extrude(3.0)
        .edges("|Z")
        .fillet(2.2)
    )

    recess = (
        cq.Workplane("XY")
        .rect(54, 34)
        .extrude(1.4)
        .edges("|Z")
        .fillet(1.2)
    )
    base = base.cut(recess.translate((0, 0, 2.0)))

    base = (
        base.faces(">Z")
        .workplane(centerOption="CenterOfBoundBox")
        .circle(2.2)
        .cutBlind(-6.0)
    )
    return base


def make_enamel_insert() -> cq.Solid:
    insert = (
        cq.Workplane("XY")
        .rect(54, 34)
        .extrude(1.4)
        .edges("|Z")
        .fillet(1.2)
    )

    emblem = (
        cq.Workplane("XY")
        .center(0, 0)
        .circle(11)
        .extrude(0.7)
    )
    leaf = (
        cq.Workplane("XY")
        .center(7, 11)
        .ellipse(4, 6)
        .extrude(0.7)
    )

    seeds = [
        cq.Workplane("XY").center(-3, -4).circle(0.9).extrude(0.7),
        cq.Workplane("XY").center(2, -2).circle(0.9).extrude(0.7),
        cq.Workplane("XY").center(4.5, 4).circle(0.9).extrude(0.7),
    ]

    insert = insert.union(emblem.translate((0, 0, 1.4)))
    insert = insert.union(leaf.translate((0, 0, 1.4)))
    for seed in seeds:
        insert = insert.union(seed.translate((0, 0, 1.4)))
    return insert


def export_models() -> None:
    OUT_DIR.mkdir(exist_ok=True)
    base = make_badge_base()
    insert = make_enamel_insert()

    export_paths = [
        (base, str(OUT_DIR / "badge_base.stl")),
        (base, str(OUT_DIR / "badge_base.step")),
        (insert, str(OUT_DIR / "badge_enamel.stl")),
        (insert, str(OUT_DIR / "badge_enamel.step")),
    ]

    for solid, path in export_paths:
        exporters.export(solid, path)
        print(f"Exported: {path}")

    print(f"Exported files to {OUT_DIR}")


if __name__ == "__main__":
    export_models()
