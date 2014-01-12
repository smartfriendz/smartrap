// Smartrap 
// author : serge vieillescaze - smartfriendz
// version 0.4.6 - 12/08/2013

//variabless
plate_height = 7; // height of all plates
border = 5; // borders around holes for plates
rods_r = 4; // the radius of rods. we use diam 8 but ready to use d=6
M4_bool_r = 2.1; // we can adjust the diam of holes for different printers
bearing_holder_r = 7.5; // the holes for bearings on plates
bearing_holder_l = 24;
space_bet_holders = 10;
filament_r = 0.875; // 1,75  ready for 3mm
nema = 17; // used everywehere to change plate sizes 
linear_system = "fishing_line"; // future option for belt, fishing,printed rail
space_holes_electronics = 84; // adapt to different controlers. 
zrods_spaceX = 72.88;
yrods_spaceY = 62.04;
xrods_spaceX = 42.825;

// ---------  MAIN ----------
all();

// draw all
module all(){
	base_center();
	translate([0,-50,0])
	base_y();
	translate([0,-30,45])
	plate_base();
	translate([20,-50,nema_size()[2]])
	plate_y();
	translate([0,50,100])
	plate_x();
	translate([0,0,100])
	xend_jhead();
}
// parts
module base_y()
	difference(){		
		miniround([100,24,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([20,20,-1]) 
		cube([nema_size.x,10,10]);
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	translate([65,28,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	}
		
module base_center()
	difference(){
		miniround([110,70,plate_height],2);
		translate([border,border,-1])
		zrod();
		translate([border+zrods_spaceX,border,-1])
		zrod();
		translate([border,border*2,3])
		nema_bool();
		translate([border+42+border,border*2,3])
		nema_bool();
		
	}
/*
module base_back()
	difference(){
		miniround([60,10,plate_height],2);
	translate([15,12,4]) rotate([90,0,0])
		cylinder(h=20,r=M4_bool_r);
	}
*/
module plate_base()
	difference(){
	miniround([100,60,plate_height],2);
	
	translate([10,20,(bearing_holder_r*2)-2]) 
	rotate([0,90,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	translate([bearing_holder_l+space_bet_holders*2,20,(bearing_holder_r*2)-2]) 
	rotate([0,90,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	}

module plate_x()
	difference(){
		miniround([100,80,plate_height],2);
	translate([20,bearing_holder_l+space_bet_holders,(bearing_holder_r*2)-2]) 
	rotate([90,0,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	translate([20,(bearing_holder_l+space_bet_holders)*2,(bearing_holder_r*2)-2]) 
	rotate([90,0,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	translate([70,bearing_holder_l+space_bet_holders,(bearing_holder_r*2)-2]) 
	rotate([90,0,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	translate([70,(bearing_holder_l+space_bet_holders)*2,(bearing_holder_r*2)-2]) 
	rotate([90,0,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	}

module plate_y()
	difference(){
		miniround([60,40,plate_height],2);
	translate([10,10,(bearing_holder_r*2)-2]) 
	rotate([0,90,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	translate([44,10,(bearing_holder_r*2)-2]) 
	rotate([0,90,0])
		cylinder(h=bearing_holder_l,r=bearing_holder_r);
	}

module xend_jhead()
	difference(){
		miniround([60,22,30]);
	translate([15,0,0]) rotate([90,0,0])
		cylinder(h=20,r=rods_r);
	}

module xend_back()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module yend_front()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module yend_back()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_x()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_base_front()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module bearingsholder_base_back()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

module fishingline_tensioner()
	difference(){
		miniround([100,60,plate_height],2);
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

module nema_bool()
{
 if(nema==17){
	
	union(){
		cube(42);
		translate([21,21,40])
		//rotate([0,90,0])
		cylinder(r=11,h=20);
		translate([5.5,5.5,40]) cylinder(r=1.6,h=20);
		translate([36.5,5.5,40]) cylinder(r=1.6,h=20);
		translate([5.5,36.5,40]) cylinder(r=1.6,h=20);
		translate([36.5,36.5,40]) cylinder(r=1.6,h=20);
		}
 }
 if(nema==14){
 cube(35);
 }
}

function nema_size()= (nema==17) ? [42,42,42] : [35,35,35];


module zrod(){
	//rotate([90,0,0])
	cylinder(r=rods_r,h=150);
}