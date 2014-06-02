// Nuts & Bolts Library (http://www.thingiverse.com/thing:325225)
// *********************************************************************************
// Version history:
// Author:			Date: 			Description:
// Whitecoat		2014-04-14		Initial build
// 
// *********************************************************************************
// Included Public Functions:
//	DefineBolt(HeadSize,HeadDepth,BodyRadius,BodyDepth,PrintTolerance=0)
//	DefineNut(EdgeLength,Thickness,InnerRadius)
//
// *********************************************************************************
// Included Public Modules:
// NutHole	(p_Size,p_depth) 		// Create a volume for a given size of nut
// BoltHole	(p_HeadSize,p_HeadDepth,p_BodyRadius,pBodyDepth) 
// Bolt		(BoltDefinition)
// HobbedBolt(BoltDefinition)
// NutTrapSide(p_Size,p_Thickness,p_ApetureLength)
//
// Parameters:
//	
// *********************************************************************************
// Included Internal Modules:
//
// *********************************************************************************
// Internal Unit tests:
//	BoltHole(DefineBolt(8,5,4,20),20,20);
//	HobbedBolt(DefineHobbedBolt(13,11,7.72,60,21,10,6,0.25,HEXHEAD));
//	NutTrapSide(8,5,15);
// *********************************************************************************
// Comments:
//
// *********************************************************************************
// Constants:
HEXHEAD 		= 0;
ROUNDHEAD 	= 1;
		
function DefineBolt(HeadSize,HeadDepth,BodyRadius,BodyDepth,PrintTolerance=0,HeadType=HEXHEAD) =
	[	
	// 0 - HeadSize 
	HeadSize,

	// 1 - HeadDepth 
   HeadDepth,

	// 2 - BodyRadius 
   BodyRadius,

	// 3 - BodyDepth 
   BodyDepth,	

	// 4 - PrintTolerance 
   PrintTolerance,

	// 5 - HeadType =[HEXHEAD|ROUNDHEAD] 
	HeadType
	];

function DefineNut(EdgeLength,Thickness,InnerRadius) =
	[	
	// 0 - EdgeSize 
	EdgeLength,

	// 1 - Thickness
   Thickness,

	// 2 - InnerRadius 
   InnerRadius
	];

function DefineHobbedBolt(	HeadSize, HeadDepth, BodyRadius, BodyDepth,HobbDistHead,HobbLength,
									HobbRadius,PrintTolerance=0,HeadType=HEXHEAD) =
// Kept all bolt parameters as per bolt def, so we can simulate O.O. inheritance 
	[	
	// 0 - HeadSize 
	HeadSize,

	// 1 - HeadDepth 
   HeadDepth,

	// 2 - BodyRadius 
   BodyRadius,

	// 3 - BodyDepth 
   BodyDepth,	

	// 4 - PrintTolerance 
   PrintTolerance,

	// 5 - HeadType =[HEXHEAD|ROUNDHEAD] 
	HeadType,

	// 6 - HobbDistHead = Hobbed Distance from head  
	HobbDistHead,

	// 7 - HobbLength = Length of Hobbed area  
	HobbLength,

	// 8 - HobbRadius = Radius of Hobbed area 
	HobbRadius,

	// 9 - FullLength  
	BodyDepth + HeadDepth,

	
	];

module Bolt(p_BoltDef)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 	= 0.1;

	//-------------------------------------------------------------------------	
	// Break out bolt definition (For ease of readability)
	l_HeadSize 		= p_BoltDef[0];
	l_HeadDepth 	= p_BoltDef[1];
	l_BodyRadius	= p_BoltDef[2];
	l_BodyDepth		= p_BoltDef[3];
	l_PrintTol		= p_BoltDef[4];
	l_HeadType		= p_BoltDef[5];

	// Draw
	//-------------------------------------------------------------------------
	// head
	if (l_HeadType == HEXHEAD) 		
		{
		NutHole(l_HeadSize-l_PrintTol,l_HeadDepth);
		}
	if (l_HeadType == ROUNDHEAD) 		
		{
		cylinder(h=l_HeadDepth,r=l_HeadSize-l_PrintTol);
		}
	
	// body
	translate([0,0,l_HeadDepth-l_tolerance])
		cylinder($fn=40,h=l_BodyDepth,r=l_BodyRadius-l_PrintTol);
	}

module HobbedBolt(p_HobbedBoltDef)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 	= 0.1;

	//-------------------------------------------------------------------------	
	// Break out bolt definition (For ease of readability)
	l_HeadSize 		= p_HobbedBoltDef[0];
	l_HeadDepth 	= p_HobbedBoltDef[1];
	l_BodyRadius	= p_HobbedBoltDef[2];
	l_BodyDepth		= p_HobbedBoltDef[3];
	l_PrintTol		= p_HobbedBoltDef[4];
	l_HeadType		= p_HobbedBoltDef[5];
	l_HobbDistHead = p_HobbedBoltDef[6];
	l_HobbLength	= p_HobbedBoltDef[7];
	l_HobbRadius	= p_HobbedBoltDef[8];

	// Draw
	//-------------------------------------------------------------------------
	// head
	if (l_HeadType == HEXHEAD) 		
		{
		NutHole(l_HeadSize-l_PrintTol,l_HeadDepth);
		}
	if (l_HeadType == ROUNDHEAD) 		
		{
		cylinder(h=l_HeadDepth,r=l_HeadSize-l_PrintTol);
		}
	
	// body (head to Hobb)
	translate([0,0,l_HeadDepth-l_tolerance])
		cylinder($fn=40,h=l_HobbDistHead,r=l_BodyRadius-l_PrintTol);

	// body (Hobb)
	translate([0,0,l_HeadDepth+l_HobbDistHead-2*l_tolerance])
		cylinder($fn=40,h=l_HobbLength,r=l_HobbRadius-l_PrintTol);

	// body (Hobb to tip)
	translate([0,0,l_HeadDepth+l_HobbDistHead+l_HobbLength-3*l_tolerance])
		cylinder($fn=40,h=l_BodyDepth-l_HobbDistHead-l_HobbLength,r=l_BodyRadius-l_PrintTol);
	}

module BoltHole(p_BoltDef,p_ClearanceRad=0,p_ClearanceHgt=0)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 	= 0.1;

	//-------------------------------------------------------------------------	
	// Break out bolt definition (For ease of readability)
	l_HeadSize 		= p_BoltDef[0];
	l_HeadDepth 	= p_BoltDef[1];
	l_BodyRadius	= p_BoltDef[2];
	l_BodyDepth		= p_BoltDef[3];
	l_PrintTol		= p_BoltDef[4];
	l_HeadType		= p_BoltDef[5];

	// Draw
	//-------------------------------------------------------------------------
	// head
	if (l_HeadType == HEXHEAD) 		
		{
		NutHole(l_HeadSize+l_PrintTol,l_HeadDepth);
		}
	if (l_HeadType == ROUNDHEAD) 		
		{
		cylinder(h=l_HeadDepth,r=l_HeadSize+l_PrintTol);
		}
	
	// body
	translate([0,0,l_HeadDepth-l_tolerance])
		cylinder($fn=40,h=l_BodyDepth,r=l_BodyRadius+l_PrintTol);

	// clearance area
	translate([0,0,-p_ClearanceHgt+l_tolerance])
		cylinder($fn=40,h=p_ClearanceHgt,r=p_ClearanceRad+l_PrintTol);
	}

module NutHole(p_Size,p_depth)
	{
	// Draw
	//-------------------------------------------------------------------------
	for (i = [1:6])
			{
			rotate([0,0,i*360/6])
				translate([-p_Size/2,0,0])
					cube([p_Size,(p_Size/2)*tan(60),p_depth]);
			}
	}

module NutTrapSide(p_Size,p_Thickness,p_ApetureLength)
	{
		// Draw
	//-------------------------------------------------------------------------
	for (i = [1:6])
			{
			rotate([0,0,i*360/6])
				translate([-p_Size/2,0,0])
					cube([p_Size,(p_Size/2)*tan(60),p_Thickness]);
			}
	translate([0,-sin(60)*p_Size,0])
		cube([p_ApetureLength,2*sin(60)*p_Size,p_Thickness]);
	}