// OpenSCAD recreation of the watermelon badge geometry.
// Render this file in OpenSCAD to export an STL matching the generated badge shape.

include <teardrop.scad>;

$fn = 96;

// Parameters matching src/parameters.py.
badge_diameter = 62.50;
dome_height = 0.3;
edge_radius = 3.2;
shell_thickness = 1.2;
shell_cut_depth = 0.35;

rind_width = 3.5;
white_ring_width = 3.0;
flesh_wall_thickness = 1.4;
flesh_height = 1.6;

seed_count_outer = 24;
seed_count_inner = 16;
seed_length = 2.0;
seed_width = 1.5;
seed_height = 0.8;
seed_protrusion = 1.0;
seed_outer_radius_factor = 0.7;
seed_inner_radius_factor = 0.5;
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

// Layer heights requested for the badge body.
green_base_height = 4.5;
white_rind_offset = 0.5;
white_rind_height = 0.5;
red_flesh_offset = 0.5;
red_flesh_height = 0.5;
badge_thickness = green_base_height + white_rind_offset + white_rind_height + red_flesh_offset + red_flesh_height;

pin_radius = (pin_diameter / 2.0) + clearance;
retention_radius = (channel_width / 2.0) + clearance;

// Build the green base with rounded edges, not a tapered profile.
module build_rounded_base() {
    rounded_edge_radius = min(edge_radius, green_base_height / 2.0);
    base_height = max(green_base_height - (rounded_edge_radius * 2), 0.01);
    color([0,1,0]) 
    translate([0, 0, rounded_edge_radius]) {
        minkowski() {
            cylinder(h = base_height, r = max(badge_radius - rounded_edge_radius, 0.01));
            sphere(r = rounded_edge_radius);
        }
    }
}

module build_surface_layers() {
    white_diameter = badge_diameter - 6.0;
    red_diameter = white_diameter - 7.0;
    white_radius = white_diameter / 2.0;
    red_radius = red_diameter / 2.0;

    color([1,1,1]) 
    translate([0, 0, green_base_height + white_rind_offset]) {
        cylinder(h = white_rind_height, r = white_radius);
    }

    color([1,0,0])
    translate([0, 0, green_base_height + white_rind_offset + white_rind_height + red_flesh_offset]) {
        cylinder(h = red_flesh_height, r = red_radius);
    }
}

// center text sizing and placement
module center_text_upper(text_str) {
    target_width = (badge_radius - white_ring_width - rind_width) * 2 * 0.95;
    text_depth = 0.8;
    zpos = badge_thickness - text_depth - 0.1;
    translate([0, 0, zpos]) {
        linear_extrude(height = text_depth) {
            resize([target_width, 999, 0]) {
                text(text_str, font = "Arial:style=Bold", halign = "center", valign = "center");
            }
        }
    }
}

module build_seeds() {
    red_top_z = green_base_height + white_rind_offset + white_rind_height + red_flesh_offset + red_flesh_height;
    seed_z = red_top_z + seed_protrusion - seed_height;

    color([0,0,0])
    union() {
        for (i = [0 : seed_count_outer - 1]) {
            angle = 360 * i / seed_count_outer;
            x = (badge_radius * seed_outer_radius_factor) * cos(angle);
            y = (badge_radius * seed_outer_radius_factor) * sin(angle);
            translate([x, y, seed_z]) {
                rotate([0, 0, angle + 180]) {
                    teardrop(seed_length, seed_width, seed_height, seed_rounding);
                }
            }
        }

        for (i = [0 : seed_count_inner - 1]) {
            angle = 360 * i / seed_count_inner;
            x = (badge_radius * seed_inner_radius_factor) * cos(angle);
            y = (badge_radius * seed_inner_radius_factor) * sin(angle);
            translate([x, y, seed_z]) {
                rotate([0, 0, angle + 180]) {
                    teardrop(seed_length, seed_width, seed_height, seed_rounding);
                }
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
    union() {
        difference() {
            union() {
                build_rounded_base();
                build_surface_layers();
                build_seeds();
            }
           # build_pin_channel();
        }

        build_reinforcement();
        // center_text_upper("PALESTINE");
    }
}

build_badge();
