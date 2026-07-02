from __future__ import annotations

import cadquery as cq

from geometry.utilities import fillet_edges
from parameters import BadgeParameters


def build_dome(params: BadgeParameters) -> cq.Solid:
    """Create the badge body with a gently domed top and rounded perimeter."""
    body = (
        cq.Workplane("XY")
        .circle(params.badge_radius)
        .extrude(params.badge_thickness)
    )
    body = body.faces(">Z").shell(-params.shell_thickness, kind="intersection")
    body = body.faces(">Z").workplane().circle(params.badge_radius - params.edge_radius).cutBlind(-(params.badge_thickness - params.shell_cut_depth))
    body = body.faces(">Z").shell(-0.25, kind="intersection")
    body = body.faces(">Z").workplane(centerOption="CenterOfBoundBox").circle(params.badge_radius - params.edge_radius * 0.5).cutBlind(-(params.badge_thickness - params.dome_height))
    return fillet_edges(body, params.edge_radius)
