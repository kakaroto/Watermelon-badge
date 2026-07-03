// OpenSCAD recreation of the watermelon badge geometry.
// Render this file in OpenSCAD to export an STL matching the generated badge shape.

include <teardrop.scad>;

$fn = 96;

// Parameters 

// Diameters
badge_diameter = 62.50;
edge_radius = 1.0;
surface_layer_thickness = 6.0;
white_diameter = badge_diameter - surface_layer_thickness;
red_diameter = white_diameter - surface_layer_thickness;
badge_radius = badge_diameter / 2.0;
white_rind_radius = white_diameter / 2.0;
red_flesh_radius = red_diameter / 2.0;
// Layer heights requested for the badge body
green_base_height = 4.5;
white_rind_height = 0.5;
red_flesh_height = 0.5;
badge_thickness = green_base_height + white_rind_height + red_flesh_height;

// Seed parameters
seed_count_outer = 24;
seed_count_inner = 16;
seed_length = 2.0;
seed_width = 1.5;
seed_height = 0.75;
seed_outer_radius_factor = 0.85;
seed_inner_radius_factor = 0.6;
seed_rounding = 0.25;
seed_skip_angles = [0, 180];


// Text parameters
rind_width = 3.5;
white_ring_width = 3.0;
text_depth = 0.8;
text_radius_factor = seed_outer_radius_factor;
text_to_display = "PALESTINE";

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
    white_radius = white_diameter / 2.0;
    red_radius = red_diameter / 2.0;

    color([1,1,1]) 
    translate([0, 0, green_base_height - 0.1]) {
        cylinder(h = white_rind_height + 0.1, r = white_radius);
    }

    color([1,0,0])
    translate([0, 0, green_base_height + white_rind_height - 0.1]) {
        cylinder(h = red_flesh_height + 0.1, r = red_radius);
    }
}

// center text sizing and placement
module center_text_upper(text_str) {
    target_width = red_diameter * text_radius_factor;
    zpos = badge_thickness - 0.1;
    color([0,0,0])
    translate([0, 0, zpos]) {
        linear_extrude(height = text_depth) {
            resize([target_width, 0, text_depth], auto=true) {
                text(text_str, font = "Arial:style=Bold", halign = "center", valign = "center");
            }
        }
    }
}

module build_seeds() {
    seed_z = green_base_height + white_rind_height + red_flesh_height;

    function should_skip_angle(angle, skip_angles) = let(
        n = len(skip_angles)
    ) (n > 0 && ((angle == skip_angles[0]) || (n > 1 && (angle == skip_angles[1]) || (n > 2 && (angle == skip_angles[2]))))) ? true : false;

    color([0,0,0])
    union() {
        for (i = [0 : seed_count_outer - 1]) {
            angle = 360 * i / seed_count_outer;
            if (!should_skip_angle(angle, seed_skip_angles)) {
                x = (red_flesh_radius * seed_outer_radius_factor - seed_length / 2) * cos(angle);
                y = (red_flesh_radius * seed_outer_radius_factor - seed_length / 2) * sin(angle);
                translate([x, y, seed_z]) {
                    rotate([0, 0, angle + 180]) {
                        teardrop(seed_length, seed_width, seed_height, seed_rounding);
                    }
                }
            }
        }

        for (i = [0 : seed_count_inner - 1]) {
            angle = 360 * i / seed_count_inner;
            if (!should_skip_angle(angle, seed_skip_angles)) {
                x = (red_flesh_radius * seed_inner_radius_factor - seed_length / 2) * cos(angle);
                y = (red_flesh_radius * seed_inner_radius_factor - seed_length / 2) * sin(angle);
                translate([x, y, seed_z]) {
                    rotate([0, 0, angle + 180]) {
                        teardrop(seed_length, seed_width, seed_height, seed_rounding);
                    }
                }
            }
        }
    }
}

module build_pin_channel() {
    rect_length = 15.0;
    rect_width = 5.0;
    corner_radius = 2;
    channel_width = 1.2;
    channel_depth = 3.5;
    edge_gap = 4.0;
    center_x = 0.0;
    center_y = 0.0;
    left_x = -badge_radius + edge_gap + rect_length / 2.0;
    right_x = badge_radius - edge_gap - rect_length / 2.0;

    module rounded_rect2d(w, h, r) {
        offset(r = r) {
            square([w - 2 * r, h - 2 * r], center = true);
        }
    }

    union() {
        translate([0, center_y, 0]) {
            linear_extrude(height = channel_depth, center = false, convexity = 10) {
                translate([left_x, 0, 0]) {
                    rounded_rect2d(rect_length, rect_width, corner_radius);
                }
                translate([right_x, 0, 0]) {
                    rounded_rect2d(rect_length, rect_width, corner_radius);
                }
            }
        }
        translate([0, center_y, channel_depth - channel_width]) {
            linear_extrude(height = channel_width, center = false, convexity = 10) {
                translate([center_x, 0, 0]) {
                    square([rect_length * 2 + 8.0, channel_width], center = true);
                }
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
            build_pin_channel();
        }

        center_text_upper(text_to_display);
    }
}

build_badge();
