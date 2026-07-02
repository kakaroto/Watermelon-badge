from __future__ import annotations

from dataclasses import dataclass


@dataclass
class BadgeParameters:
    badge_diameter: float = 50.0
    badge_thickness: float = 6.0
    dome_height: float = 0.35
    edge_radius: float = 0.8
    shell_thickness: float = 1.2
    shell_cut_depth: float = 0.35

    rind_width: float = 10.0
    white_ring_width: float = 8.0
    flesh_wall_thickness: float = 1.4
    flesh_height: float = 1.6

    seed_count_outer: int = 12
    seed_count_inner: int = 8
    seed_length: float = 3.0
    seed_width: float = 1.5
    seed_height: float = 0.8
    seed_protrusion: float = 0.4
    seed_outer_radius_factor: float = 0.55
    seed_inner_radius_factor: float = 0.3
    seed_rounding: float = 0.25

    pin_diameter: float = 2.2
    clearance: float = 0.15
    channel_width: float = 2.6
    pin_entry_radius_extra: float = 0.35
    pin_exit_radius_extra: float = 0.35
    pin_center_radius_extra: float = 0.15
    pin_retention_length: float = 2.2
    retention_bump_diameter: float = 0.45
    retention_bump_count: int = 4

    reinforcement_thickness: float = 1.2
    reinforcement_width: float = 2.4

    use_magnets: bool = False
    magnet_diameter: float = 6.0
    magnet_thickness: float = 2.0

    back_text: str = ""
    back_text_depth: float = 0.35
    back_text_recessed: bool = False
    back_text_scale: float = 2.2
    back_text_font: str = "Arial"

    rear_pocket_depth: float = 1.0
    rear_pocket_diameter: float = 10.0
    rear_pocket_count: int = 2

    @property
    def badge_radius(self) -> float:
        return self.badge_diameter / 2.0

    @property
    def rind_inner_radius(self) -> float:
        return self.badge_radius - self.rind_width

    @property
    def white_inner_radius(self) -> float:
        return self.rind_inner_radius - self.white_ring_width

    @property
    def flesh_radius(self) -> float:
        return self.white_inner_radius

    @property
    def pin_radius(self) -> float:
        return (self.pin_diameter / 2.0) + self.clearance

    @property
    def retention_radius(self) -> float:
        return (self.channel_width / 2.0) + self.clearance
