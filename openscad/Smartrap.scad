// Smartrap 
// author : serge vieillescaze - smartfriendz
// version 0.4.6 - 12/08/2013

//variabless
base_z = 7; // height of all plates
rods_r = 4; // the radius of rods. we use diam 8 but ready to use d=6
M4_bool_r = 2.1; // we can adjust the diam of holes for different printers
bearing_holder_r = 7.5; // the holes for bearings on t=plates
filament_r = 0.875; // 1,75  ready for 3mm
nema = 17; // will be used to pass all with nema14
nema_size = [42,42,42]; // 
linear_system = "fishing_line"; // future option for belt, fishing,printed rail
space_holes_electronics = 84; // adapt to different controlers. 



// ---------  MAIN ----------
all();

// draw all
module all()
base_y();
translate([0,50,0])
base_center();
translate([0,100,0])
base_back();
translate([0,100,42])
plate_base();
translate([0,0,42])
plate_y();
translate([0,100,100])
plate_x();
translate([0,0,100])
xend_jhead();

// parts
module base_y()
	difference(){		
		miniround([100,24,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([20,20,-1]) 
		cube([42,10,10]);
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	translate([65,28,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	}
		
module base_center()
	difference(){
		miniround([85,29,base_z],2);
	}

module base_back()
	difference(){
		miniround([60,10,base_z],2);
	translate([15,12,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	}

module plate_base()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module plate_x()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module plate_y()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module xend_jhead()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module xend_back()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module yend_front()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module yend_back()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_x()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_base_front()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_base_back()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module fishingline_tensioner()
	difference(){
		miniround([100,60,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}




// lib -----------------------------

module miniround(size, radius)
{
$fn=8;
x = size[0]-radius/2;
y = size[1]-radius/2;

minkowski()
{
cube(size=[x,y,size[2]]);
cylinder(r=radius);
// Using a sphere is possible, but will kill performance
//sphere(r=radius);
}
}