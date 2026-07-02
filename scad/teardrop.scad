// Reusable teardrop module for the watermelon badge.
module teardrop(length, width, height, rounding) {
    $fn = 96;

    linear_extrude(height = height) {
        offset(r = rounding) {
            hull() {
                translate([-length / 2.0 + width * 0.25, 0]) circle(r = width * 0.28);
                translate([length / 2.0 - width * 0.18, 0]) circle(r = width * 0.12);
                translate([length / 2.0 - width * 0.02, 0]) circle(r = width * 0.02);
            }
        }
    }
}

// Self-contained preview so the file can be rendered directly.
// Uncomment to preview standalone:
// teardrop(2.0, 1.5, 0.8, 0.20);
