from __future__ import annotations

import cadquery as cq

from geometry.utilities import make_ring_solid
from parameters import BadgeParameters


def build_rind(params: BadgeParameters) -> cq.Solid:
    """Create the green outer rind region."""
    return make_ring_solid(
        radius=params.badge_radius - 0.8,
        thickness=params.rind_width,
        height=params.badge_thickness - 0.8,
        edge_radius=params.edge_radius,
    )
