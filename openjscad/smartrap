function main(){
	return difference(
		union(
			cube({80,10,7}),
			translate([0,0,7]),
			cube({16,10,18}),
			translate([80,10,7]),
			rotate([90,0,0]),
			cylinder({h:10,r:7}),
			// two middle cyl for head attach
			
			cylinder({h:10,r:5}).translate[30,10,10]).rotate({90,0,0]),
			cylinder({h:10,r:5}).translate([46,10,10]).rotate({90,0,0]),
			// support top for bowden
			cube({10,8,4}).translate([33,-8,21]) 
				
		),
		union(
			// three cyl for main hole vertical . 38 = 30 + 16/2
			
				cylinder({h:10.1,r:6}).translate([38,0,-1]) ,
			
				cylinder({h:4.1,r:5}).translate([38,0,9]) ,
			
				cylinder({h:8,r:6}).translate([38,0,13]) 
		),
		 // cyl + cube for bowden support hole
		union(
			 
				cylinder({h:10.1,r:2}).translate([38,0,20]),
			
			cube({4,10,5.1}).translate([36,-10,20]) 
		),
		 
				cylinder({h:12,r:1.6}).translate([80,11,7]).rotate([90,0,0])

		
	)
}


function main(){
	return union(
			cube({80,10,7}),
			cube({16,10,18}).translate([0,0,7]),
			cylinder({h:10,r:7}).translate([80,10,7]).rotate([90,0,0])
		)
}
