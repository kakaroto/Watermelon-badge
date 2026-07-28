// Badge module

// Build the green base with rounded edges
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
    translate([0, 0, green_base_height - white_rind_recess]) {
        cylinder(h = white_rind_recess + white_rind_height, r = white_diameter / 2.0);
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

module teardrop(length, width, height, rounding) {
    $fn = 96;

    linear_extrude(height = height) {
        offset(r = rounding) {
            hull() {
                translate([-length / 2.0 + rounding + width * 0.25, 0]) circle(r = width * 0.25);
                translate([length / 2.0 - rounding - width * 0.02, 0]) circle(r = width * 0.02);
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
                x = (seed_outer_radius - seed_length / 2) * cos(angle);
                y = (seed_outer_radius - seed_length / 2) * sin(angle);
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
                x = (seed_inner_radius - seed_length / 2) * cos(angle);
                y = (seed_inner_radius - seed_length / 2) * sin(angle);
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
    pin_channel_depth = green_base_height - white_rind_recess;
    left_x = -badge_radius + pin_rect_edge_gap + pin_rect_length / 2.0;
    right_x = badge_radius - pin_rect_edge_gap - pin_rect_length / 2.0;
    taper = 0.5;

    module rounded_rect2d(w, h, r) {
        offset(r = r) {
            square([w - 2 * r, h - 2 * r], center = true);
        }
    }

    union() {
        linear_extrude(height = pin_channel_depth, center = false, convexity = 10) {
            translate([left_x, 0, 0]) {
                rounded_rect2d(pin_rect_length, pin_rect_width, pin_corner_radius);
            }
            translate([right_x, 0, 0]) {
                rounded_rect2d(pin_rect_length, pin_rect_width2, pin_corner_radius);
            }
        }
       
        union() {
            translate([-pin_channel_length /2 - pin_clasp_length/2, -pin_channel_width /2, pin_channel_depth - pin_depth]) 
            cube([pin_channel_length + pin_clasp_length, pin_channel_width, pin_depth]);
        
            if (pin_channel_rounded) {
                translate([-pin_channel_length /2 - 0.1, 0, pin_channel_depth - pin_channel_width/2])
                rotate([0, 90, 0])
                    cylinder(h = pin_channel_length + 0.2, r = pin_channel_width / 2.0);
            }
        }
    }
}


module build_bottom_part() {
    difference() {
        build_rounded_base();
        translate([0, 0, green_base_height - white_rind_recess]) {
            cylinder(h = white_rind_recess + white_rind_height, r = white_diameter / 2.0);
        }
        build_pin_channel();
    }
}

module build_top_part() {
    union() {
        build_surface_layers();
        build_seeds();
        center_text_upper(text_to_display);
    }
}

// Set mode to "top", "bottom" or "assembled" to respectively only render 
// the top part, only the bottom part of the badge, or an assembled badge
module build_badge(mode) {
	if (mode == "bottom") {
		build_bottom_part();
	} else if (mode == "top") {
		build_top_part();
	} else if (mode == "assembled") {
		union() {
			build_bottom_part();
			build_top_part();
		}
	} else {
		build_bottom_part();
		translate([badge_diameter + 5, 0, - green_base_height + white_rind_recess]) build_top_part();
	}
}
