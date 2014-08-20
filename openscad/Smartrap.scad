// Smartrap 
// author : serge vieillescaze - smartfriendz
// version 0.4.6 - 12/08/2013

//variabless
plate_height = 7; // height of all plates
border = 5; // borders around holes for plates
rods_r = 3; // the radius of rods. we use diam 8 but ready to use d=6
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

// ---------  MAIN **************************************

//all();

// testing
//jhead_arm();

//xend_jhead();
//translate([0,-12,22.5])
//jhead_arm();

xend_jhead_proxy();


//plate_1();

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


module plate_1(){
	translate([0,0,0]) rotate([-90,0,0])
	xend_jhead();
	translate([90,0,0]) rotate([-90,0,0])
	jhead_arm();

}

// parts  ****************************************************




module bottom()
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
		


// plate base   ---------------------------------------------

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

// plate x  -------------------------------------------------

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

// plate y --------------------------------------------------

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



// xend - jhead type  ----------------------------------------

xend_width = 60;
xend_pushfit = false;

//xrods_spaceX

module xend_jhead()
	difference(){
		union(){
			cube([xend_width,10,30]); //main
			translate([5,-10,30]) 
				cube([5,20,16]); // switch support
			translate([xend_width,10,30]) rotate([90,0,0])
				cylinder(h=10,r=7); 
		}
			translate([xend_width,11,30])  rotate([90,0,0]) 
					cylinder(h=12,r=1.6);  // hole righ
			translate([xend_width/2-3,11,0])  rotate([90,0,0]) 
					cylinder(h=12,r=15);  // hole middle
			
			translate([10,11,10])  rotate([90,0,0]) 
					cylinder(h=12,r=rods_r); // rods hole
			translate([10+xrods_spaceX,11,10])  rotate([90,0,0]) 
					cylinder(h=12,r=rods_r); // rods hole
			translate([0,-10,30])  rotate([0,90,0]) 
					cylinder(h=12,r=10); // switch support form


	}

// xend_jhead_proxy  : new end with proxymity sensor.

proxy_d = 18;


module xend_jhead_proxy(){
	difference(){
		union(){
			cube([xend_width,10,30]); //main
			
			translate([22,-10,20]) 
				cube([16,10,18]); // head support

			// support top for bowden
			if(!xend_pushfit){
				translate([33,-8,21]) 
				cube([10,8,4]);
			}

			// two middle cyl for head attach
			translate([30,10,10]) rotate([90,0,0])
				cylinder(h=10,r=5); 
			translate([46,10,10]) rotate([90,0,0])
				cylinder(h=10,r=5);
			
			
		}
			
		translate([xend_width/2-3,11,0])  rotate([90,0,0]) 
				cylinder(h=12,r=15);  // hole middle
		
		translate([10,11,10])  rotate([90,0,0]) 
				cylinder(h=12,r=rods_r); // rods hole
		translate([10+xrods_spaceX,11,10])  rotate([90,0,0]) 
				cylinder(h=12,r=rods_r); // rods hole


	}
}


// jhead arm   ----------------------------------------------

jha_height = 7;


module jhead_arm()
	difference(){
		union(){
			cube([xend_width,10,jha_height]); //main
			translate([30,0,jha_height]) 
				cube([16,10,18]); // head support
			translate([xend_width,10,jha_height]) rotate([90,0,0])
				cylinder(h=10,r=7); // right cyl form
			// two middle cyl for head attach
			translate([30,10,10]) rotate([90,0,0])
				cylinder(h=10,r=5); 
			translate([46,10,10]) rotate([90,0,0])
				cylinder(h=10,r=5);
			// support top for bowden
			if(!xend_pushfit){
				translate([33,-8,21]) 
				cube([10,8,4]);
			}
			
				
		}
		// three cyl for main hole vertical . 38 = 30 + 16/2
		union() {
			translate([38,0,-1]) 
				cylinder(h=10.1,r=6);
			translate([38,0,9]) 
				cylinder(h=4.1,r=5);
			translate([38,0,13]) 
				cylinder(h=8,r=6);
		}
		 // cyl + cube for bowden support hole
		union() {
			translate([38,0,20]) 
				cylinder(h=10.1,r=2);
			translate([36,-10,20]) 
			cube([4,10,5.1]);
		}
		translate([xend_width,11,7])  rotate([90,0,0]) 
				cylinder(h=12,r=1.6);  // hole righ
	}

// jhead attach  -------------------------------------------------------

module jhead_attach()
	{

	}


//   xend  back -------------------------------------------------------

module xend_back()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

//   yend front-------------------------------------------------------

module yend_front()
	difference(){
		miniround([100,60,plate_height],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	}

//   tend  back -------------------------------------------------------

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
$fn=6;
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