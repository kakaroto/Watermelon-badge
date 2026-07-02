from __future__ import annotations

import math

import cadquery as cq

from geometry.utilities import make_teardrop_solid
from parameters import BadgeParameters


def build_seeds(params: BadgeParameters) -> list[cq.Solid]:
    """Generate seed solids in two concentric rings."""
    seeds: list[cq.Solid] = []
    outer_radius = params.badge_radius * params.seed_outer_radius_factor
    inner_radius = params.badge_radius * params.seed_inner_radius_factor

    for count, radius in [
        (params.seed_count_outer, outer_radius),
        (params.seed_count_inner, inner_radius),
    ]:
        for i in range(count):
            angle = (2.0 * math.pi * i) / count
            x = radius * math.cos(angle)
            y = radius * math.sin(angle)
            seed = make_teardrop_solid(
                params.seed_length,
                params.seed_width,
                params.seed_height,
                params.seed_rounding,
            ).translate((x, y, params.badge_thickness - params.seed_height - params.seed_protrusion))
            seeds.append(seed)
    return seeds
