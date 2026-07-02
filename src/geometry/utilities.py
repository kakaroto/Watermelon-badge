from __future__ import annotations

from typing import Iterable

import cadquery as cq


def fillet_edges(workplane: cq.Workplane, radius: float) -> cq.Workplane:
    """Fillet all vertical outside edges of a solid."""
    return workplane.edges("|Z").fillet(radius)


def make_ring_solid(radius: float, thickness: float, height: float, edge_radius: float) -> cq.Solid:
    """Create a circular ring body with rounded perimeter."""
    base = (
        cq.Workplane("XY")
        .circle(radius)
        .extrude(height)
        .faces(">Z")
        .workplane()
        .circle(max(radius - thickness, 0.1))
        .cutBlind(-height)
    )
    return base.edges("|Z").fillet(edge_radius)


def make_teardrop_solid(length: float, width: float, height: float, rounding: float) -> cq.Solid:
    """Create a simple teardrop-shaped solid from a polygon profile."""
    points = [
        (-length / 2.0, 0.0),
        (-width / 2.0, width / 2.0),
        (-width / 4.0, width / 2.0),
        (length / 2.0, 0.0),
        (-width / 4.0, -width / 2.0),
        (-width / 2.0, -width / 2.0),
    ]
    return (
        cq.Workplane("XY")
        .polyline(points)
        .close()
        .extrude(height)
        .edges("|Z")
        .fillet(rounding)
    )


def boolean_union(solids: Iterable[cq.Solid]) -> cq.Solid:
    """Union an iterable of solids."""
    solids = list(solids)
    if not solids:
        raise ValueError("No solids provided")
    result = solids[0]
    for solid in solids[1:]:
        result = result.union(solid)
    return result
