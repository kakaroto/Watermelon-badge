from __future__ import annotations

import cadquery as cq

from parameters import BadgeParameters


def build_reinforcement(params: BadgeParameters) -> cq.Solid:
    """Create internal ribs around the pin tunnel."""
    rib = (
        cq.Workplane("YZ")
        .center(0, 0)
        .rect(params.reinforcement_width, max(params.badge_thickness - 1.0, 1.2))
        .extrude(params.reinforcement_thickness)
    )
    rib = rib.faces(">X").workplane().circle(0.35).cutBlind(-1.4)
    return rib
