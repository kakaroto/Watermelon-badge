from __future__ import annotations

import cadquery as cq

from parameters import BadgeParameters


def build_flesh(params: BadgeParameters) -> cq.Solid:
    """Create the red flesh region."""
    return (
        cq.Workplane("XY")
        .circle(max(params.flesh_radius - params.flesh_wall_thickness, 0.1))
        .extrude(max(params.badge_thickness - params.flesh_height, 0.1))
        .edges("|Z")
        .fillet(max(params.edge_radius * 0.6, 0.1))
    )
