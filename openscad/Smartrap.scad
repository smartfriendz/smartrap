// Smartrap 
// author : serge vieillescaze - smartfriendz
// version 0.4.6 - 12/08/2013

//vars
base_z = 7;


// draw objects
base_y();
translate([0,50,0])
base_center();

module base_y()
	
difference(){
			
		miniround([100,24,base_z],2);
	translate([10,-10,-1]) 
		cube([80,25,10]); 
	translate([20,20,-1]) 
		cube([42,10,10]);
	translate([15,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
	translate([65,28,4]) rotate([90,0,0])
		cylinder(h=20,r=2.1);
}
		
module base_center()
	difference(){
		miniround([85,29,base_z],2);
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