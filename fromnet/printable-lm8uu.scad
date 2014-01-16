$fn=32;

lm8uu_length = 24;
lm8uu_id=7.2;
lm8uu_od=15.0;

id_clearance = 1;

n = 5;

layer_height = 0.2;

difference() {
	cylinder(r=lm8uu_od / 2, h=lm8uu_length - layer_height);
	difference() {
		cylinder(r=lm8uu_id / 2 + id_clearance, h=lm8uu_length - layer_height);
		linear_extrude(height = lm8uu_length - layer_height, twist = 540 / n, slices = (lm8uu_length - layer_height))
			for (i=[0:360/n]) {
				rotate(360 / n * i)
					translate([lm8uu_id / 2 / sqrt(2), lm8uu_id / 2 / sqrt(2)])
						square([lm8uu_id, lm8uu_id]);
			}
	}
	translate([0, 0, -1 + layer_height])
		cylinder(r1=lm8uu_id / 2 + id_clearance + 1, r2=0, h=lm8uu_id / 2 + id_clearance + 1);
	translate([0, 0, lm8uu_length - layer_height * 2 - (lm8uu_id / 2 + id_clearance)])
		cylinder(r2=lm8uu_id / 2 + id_clearance + 1, r1=0, h=lm8uu_id / 2 + id_clearance + 1);
	translate([0, 0, -1])
		cylinder(r=4.0, h=lm8uu_length + 2);
}