from __future__ import annotations

import cadquery as cq

from parameters import BadgeParameters


def build_pin_channel(params: BadgeParameters) -> cq.Solid:
    """Create an enclosed keyhole-style tunnel for a locking pin."""
    entry_radius = params.pin_radius + params.pin_entry_radius_extra
    center_radius = max(params.pin_radius - params.pin_center_radius_extra, 0.2)
    exit_radius = params.pin_radius + params.pin_exit_radius_extra

    entry = (
        cq.Workplane("YZ")
        .center(0, 0)
        .circle(entry_radius)
        .extrude(params.badge_thickness + 2.0, both=True)
    )
    center = (
        cq.Workplane("YZ")
        .center(0, 0)
        .circle(center_radius)
        .extrude(params.pin_retention_length, both=True)
    )
    exit_piece = (
        cq.Workplane("YZ")
        .center(0, 0)
        .circle(exit_radius)
        .extrude(params.badge_thickness + 2.0, both=True)
    )

    tunnel = entry.union(center).union(exit_piece)
    tunnel = tunnel.translate((0, 0, 0))

    for offset in [-(params.pin_retention_length / 2.0), params.pin_retention_length / 2.0]:
        bump = (
            cq.Workplane("YZ")
            .center(0, offset)
            .circle(params.retention_bump_diameter / 2.0)
            .extrude(0.6, both=True)
        )
        tunnel = tunnel.union(bump)

    return tunnel
