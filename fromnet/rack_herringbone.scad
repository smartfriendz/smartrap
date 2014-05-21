// Parametric Modular Rack Mark "Ckaos" Moissette
//Based on the work of MattMoses and Fdavies :
//http://forums.reprap.org/read.php?1,51452,52099#msg-52099
//and Forrest Higgs:
// http://technocraticanarchist.blogspot.com/2010/01/high-speed-alternative-to-belts.html
//It is licensed under the Creative Commons - GNU GPL license.
// © 2011 by Mark "Ckaos" Moissette
//more info at :www.kaosat.net and
//http://www.thingiverse.com/thing:6011



pi=3.1415926535897932384626433832795;
innerRadius=2.6;//shaft radius, in mm
borders=2;//how thick should the borders around the central "shaft" be, in mm
diametralPitch=12;
numberOfTeeth=29;
pressureAngle=20*pi/180;
centerAngle=25;//angle at center of teeth


//example usage
rack(innerRadius,borders,diametralPitch,numberOfTeeth,pressureAngle,centerAngle);



module rack(innerRadius,borders,P,N,PA,CA)
{
	// P = diametral pitch
	// N = number of teeth
	// PA = pressure angle in radians
	// x, y = linear offset distances
	a = 1/P; // addendum (also known as "module")
	d = 1.25/P; // dedendum (this is set by a standard)
	multiplier=20;//20
	height=(d+a)*multiplier;
	
	
	// find the tangent of pressure angle once
	tanPA = tan(PA*(180/pi));
	// length of bottom and top horizontal segments of tooth profile
	botL = (pi/P/2 - 2*d*tanPA)*multiplier;
	topL =( pi/P/2 - 2*a*tanPA)*multiplier;

	slantLng=tanPA*height;
	realBase=2*slantLng+topL;
	
	
	offset=topL+botL+2*slantLng;
	length=(realBase+botL)*N;

	supportSize=(innerRadius+borders)*2;

	//calculate tooth params
	basesegmentL=realBase/2;
	basesegmentW=supportSize/2;

	topsegmentL=topL/2;
	topsegmentW=supportSize/2;

	baseoffsetY=tan(CA)*basesegmentW;
	topoffsetY=tan(CA)*topsegmentW;
	
	//calculate support params

	totalSupportLength=(N)*(offset);
	supportL=totalSupportLength/2;
	supportW=supportSize/1.99;
	
	echo("Total length",totalSupportLength+baseoffsetY);
	echo("Total height",supportSize);

	
	rotate([90,90,0])
	{
	translate([-supportSize/2,supportSize/2,0])
	{
	union()
	{
		difference()
		{
			support(supportL,supportW,supportSize,baseoffsetY);
			rotate([90,90,0]) 
			{cylinder(h=length+10,r=innerRadius,center=true,$fn=100);}
		}

	
		for (i = [0:N-1]) 
		{
			translate([0,i*offset-length/2+realBase/2,supportSize/2+height/2]) 
			{	
				
				tooth(basesegmentL,basesegmentW,topsegmentL,topsegmentW,height,baseoffsetY,topoffsetY);
				
			}
		}
	}
	
	}
	}
}

module support(supportL,supportW,height,offsetY)
{
	 tooth(supportL,supportW,supportL,supportW,height,offsetY,offsetY);
}



module tooth(basesegmentL,basesegmentW,topsegmentL,topsegmentW,height,baseoffsetY,topoffsetY)//top : width*length, same for base
{
	
	////////////////
	basePT1=[
	-basesegmentW,
	basesegmentL-baseoffsetY,
	-height/2];

	basePT2=[
	0,
	basesegmentL,
	-height/2];

	basePT3=[
	basesegmentW,
	basesegmentL-baseoffsetY,
	-height/2];

	basePT4=[
	basesegmentW,
	basesegmentL-(baseoffsetY+basesegmentL*2),
	-height/2];
	
	basePT5=[
	0,
	-basesegmentL,
	-height/2];

	basePT6=[
	-basesegmentW,
	basesegmentL-(baseoffsetY+basesegmentL*2),
	-height/2];
	//////////////////////////
	topPT1=[
	-topsegmentW,
	topsegmentL-topoffsetY,
	height/2];

	topPT2=[
	0,
	topsegmentL,
	height/2];

	topPT3=[
	topsegmentW,
	topsegmentL-topoffsetY,
	height/2];

	topPT4=[
	topsegmentW,
	topsegmentL-(topoffsetY+topsegmentL*2),
	height/2];
	
	topPT5=[
	0,
	-topsegmentL,
	height/2];

	topPT6=[
	-topsegmentW,
	topsegmentL-(topoffsetY+topsegmentL*2),
	height/2];
	//////////////////////////

	//////////////////////////

	polyhedron(
	points=[
		basePT1,
		basePT2,
		basePT3,
		basePT4,
		basePT5,
		basePT6,
		topPT1,
		topPT2,
		topPT3,
		topPT4,
		topPT5,
		topPT6],
	triangles=[
	//base
	[5,1,0],
	[4,1,5],
	[4,2,1],
	[3,2,4],	

	//front
	[1,6,0],
	[7,6,1],
	[2,7,1],
	[8,7,2],
	//back
	[11,10,5],
	[5,10,4],
	[10,9,4],
	[4,9,3],	
	//side 1
	[0,11,5],
	[6,11,0],
	//side 2
	[3,8,2],
	[9,8,3],
	//top
	[9,10,8],
	[10,7,8],
	[11,7,10],
	[6,7,11],
	]
	);
}

module demo_gear(position,diametralPitch)
{
	wheelSize=12;
rotate([0,90,180])
translate(position)

{
gear (
	number_of_teeth=8,
	circular_pitch=300, 
	pressure_angle=19.34,
	gear_thickness=wheelSize/2,
	rim_thickness=wheelSize/2,
	hub_thickness=0,
	bore_diameter=2,
	backlash=0,twist=centerAngle,involute_facets=15);

translate([0,0,wheelSize/2])
rotate([0,0,-centerAngle])
gear (
	number_of_teeth=8,
	circular_pitch=300, 
	pressure_angle=19.34,
	gear_thickness=wheelSize/2,
	rim_thickness=wheelSize/2,
	hub_thickness=0,
	bore_diameter=2,
	backlash=0,twist=-centerAngle,involute_facets=15);

}

}


