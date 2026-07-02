// OpenSCAD recreation of the watermelon badge geometry.
// Render this file in OpenSCAD to export an STL matching the generated badge shape.

include <teardrop.scad>;

$fn = 96;

// Parameters matching src/parameters.py.
badge_diameter = 50.0;
badge_thickness = 6.0;
dome_height = 0.35;
edge_radius = 0.8;
shell_thickness = 1.2;
shell_cut_depth = 0.35;

rind_width = 10.0;
white_ring_width = 8.0;
flesh_wall_thickness = 1.4;
flesh_height = 1.6;

seed_count_outer = 12;
seed_count_inner = 8;
seed_length = 2.0;
seed_width = 1.5;
seed_height = 0.8;
seed_protrusion = 0.4;
seed_outer_radius_factor = 0.55;
seed_inner_radius_factor = 0.3;
seed_rounding = 0.25;

pin_diameter = 2.2;
clearance = 0.15;
channel_width = 2.6;
pin_entry_radius_extra = 0.35;
pin_exit_radius_extra = 0.35;
pin_center_radius_extra = 0.15;
pin_retention_length = 2.2;
retention_bump_diameter = 0.45;
retention_bump_count = 4;

reinforcement_thickness = 1.2;
reinforcement_width = 2.4;

badge_radius = badge_diameter / 2.0;
rind_inner_radius = badge_radius - rind_width;
white_inner_radius = rind_inner_radius - white_ring_width;
flesh_radius = white_inner_radius;
pin_radius = (pin_diameter / 2.0) + clearance;
retention_radius = (channel_width / 2.0) + clearance;

// using teardrop module from teardrop.scad

module build_dome() {
    difference() {
        union() {
            cylinder(h = badge_thickness, r = badge_radius);
            translate([0, 0, badge_thickness - dome_height]) {
                cylinder(h = dome_height, r = max(badge_radius - edge_radius * 0.5, 0.1));
            }
        }

        translate([0, 0, shell_thickness]) {
            cylinder(h = badge_thickness, r = max(badge_radius - shell_thickness, 0.1));
        }

        translate([0, 0, badge_thickness - shell_cut_depth]) {
            cylinder(h = shell_cut_depth + 0.01, r = max(badge_radius - edge_radius, 0.1));
        }
    }
}

module build_rind() {
    difference() {
        cylinder(h = badge_thickness - 0.8, r = badge_radius - 0.8);
        translate([0, 0, 0.4]) {
            cylinder(h = badge_thickness, r = max(rind_inner_radius, 0.1));
        }
    }
}

module build_flesh() {
    cylinder(h = max(badge_thickness - flesh_height, 0.1), r = max(flesh_radius - flesh_wall_thickness, 0.1));
}

module build_seeds() {
    union() {
        for (i = [0 : seed_count_outer - 1]) {
            angle = 360 * i / seed_count_outer;
            x = (badge_radius * seed_outer_radius_factor) * cos(angle);
            y = (badge_radius * seed_outer_radius_factor) * sin(angle);
            translate([x, y, badge_thickness - seed_height - seed_protrusion]) {
                teardrop(seed_length, seed_width, seed_height, seed_rounding);
            }
        }

        for (i = [0 : seed_count_inner - 1]) {
            angle = 360 * i / seed_count_inner;
            x = (badge_radius * seed_inner_radius_factor) * cos(angle);
            y = (badge_radius * seed_inner_radius_factor) * sin(angle);
            translate([x, y, badge_thickness - seed_height - seed_protrusion]) {
                teardrop(seed_length, seed_width, seed_height, seed_rounding);
            }
        }
    }
}

module build_pin_channel() {
    entry_radius = pin_radius + pin_entry_radius_extra;
    center_radius = max(pin_radius - pin_center_radius_extra, 0.2);
    exit_radius = pin_radius + pin_exit_radius_extra;

    union() {
        rotate([0, 90, 0]) {
            cylinder(h = badge_thickness + 2.0, r = entry_radius);
        }
        rotate([0, 90, 0]) {
            cylinder(h = pin_retention_length, r = center_radius);
        }
        rotate([0, 90, 0]) {
            cylinder(h = badge_thickness + 2.0, r = exit_radius);
        }

        for (offset = [-pin_retention_length / 2.0, pin_retention_length / 2.0]) {
            translate([offset, 0, 0]) {
                rotate([0, 90, 0]) {
                    cylinder(h = 0.6, r = retention_bump_diameter / 2.0);
                }
            }
        }
    }
}

module build_reinforcement() {
    rotate([0, 90, 0]) {
        difference() {
            translate([0, 0, 0]) {
                cube([reinforcement_thickness, reinforcement_width, max(badge_thickness - 1.0, 1.2)], center = true);
            }
            translate([0, 0, 0]) {
                cylinder(h = reinforcement_thickness + 0.2, r = 0.35, center = true);
            }
        }
    }
}

module build_badge() {
    difference() {
        union() {
            build_dome();
            build_rind();
            build_flesh();
            build_seeds();
        }
        build_pin_channel();
    }
    build_reinforcement();
}

build_badge();
