// Parameters 
$fn = 200;

// 54mm clothing safety pins
pin_length =  53.75;
pin_width = 1.0;
pin_depth = 1.0;
pin_clasp_length = 10.0;
pin_clasp_width = 3.0;
pin_clasp_width2 = 3.0;
pin_channel_rounded = true;
surface_layer_thickness = 3.0;

// Pin Parameters
pin_rect_length = pin_clasp_length * 1.5;
pin_rect_width = pin_clasp_width * 1.5;
pin_rect_width2 = pin_clasp_width2 * 1.5;
pin_rect_edge_gap = 1.0 + surface_layer_thickness;
pin_corner_radius = 1;
pin_channel_width = pin_width + 0.25;
pin_channel_length = pin_length - 2 * pin_rect_length;

// Diameters
badge_diameter =  pin_length + 2 * pin_rect_edge_gap;
edge_radius = 1.5;
white_diameter = badge_diameter - surface_layer_thickness * 2;
red_diameter = white_diameter - surface_layer_thickness * 2;
badge_radius = badge_diameter / 2.0;
white_rind_radius = white_diameter / 2.0;
red_flesh_radius = red_diameter / 2.0;

// Layer heights requested for the badge body
green_base_height = 4.5; // Height of the green base
white_rind_recess = 1.0; // Depth of recess the white rind clips into
white_rind_height = 0.5; // white rind height above the green base
red_flesh_height = 0.5; // red flesh height above the white base
badge_thickness = green_base_height + white_rind_height + red_flesh_height;

// Seed parameters
seed_outer_radius_factor = 0.85;
seed_inner_radius_factor = 0.6;
seed_outer_radius = red_flesh_radius * seed_outer_radius_factor;
seed_inner_radius = red_flesh_radius * seed_inner_radius_factor;

//seed_length = 3.5;
//seed_width = 2;
//seed_rounding = 0.5;
seed_count_outer = 24;
seed_count_inner = 16;
seed_length = (seed_outer_radius - seed_inner_radius) / 2;
seed_width = (seed_inner_radius * PI) / seed_count_inner;
seed_height = 0.75;
seed_rounding = 0.25;
seed_skip_angles = [0, 180];


// Text parameters
text_depth = seed_height;
text_radius_factor = seed_outer_radius_factor;
text_to_display = "PALESTINE";
