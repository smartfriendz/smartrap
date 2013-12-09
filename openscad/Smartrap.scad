// Smartrap 
// author : serge vieillescaze - smartfriendz
// version 0.4.6 - 12/08/2013

//variabless
base_z = 7;
radius_rods = 4;
radius_M4 = 2.1;
radius_bearing_holder = 7.5;
radius_filament = 0.875;
nema = 17;
linear_system = "fishing_line";


// ---------  MAIN ----------
all();

// draw all
module all()
base_y();
translate([0,50,0])
base_center();
translate([0,100,0])
base_back();

// parts
module base_y()
	difference(){		
		miniround([100,24,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([20,20,-1]) 
		cube([42,10,10]);
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=radius_M4);
	translate([65,28,4]) rotate([90,0,0])
		cylinder(h=20,r=radius_M4);
	}
		
module base_center()
	difference(){
		miniround([85,29,base_z],2);
	}

module base_back()
	difference(){
		miniround([60,10,base_z],2);
	translate([15,12,4]) rotate([90,0,0])
		cylinder(h=20,r=radius_M4);
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