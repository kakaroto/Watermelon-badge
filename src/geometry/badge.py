from __future__ import annotations

import cadquery as cq

from geometry.dome import build_dome
from geometry.flesh import build_flesh
from geometry.pin_channel import build_pin_channel
from geometry.reinforcement import build_reinforcement
from geometry.rind import build_rind
from geometry.seeds import build_seeds
from geometry.utilities import boolean_union
from parameters import BadgeParameters


def build_badge(params: BadgeParameters) -> cq.Solid:
    """Assemble the full badge as one printable object with separate color regions."""
    base = build_dome(params)
    rind = build_rind(params)
    flesh = build_flesh(params)
    seeds = build_seeds(params)

    badge_body = boolean_union([base, rind, flesh, *seeds])
    channel = build_pin_channel(params)
    reinforcement = build_reinforcement(params)

    badge_body = badge_body.cut(channel)
    badge_body = badge_body.union(reinforcement)
    return badge_body
