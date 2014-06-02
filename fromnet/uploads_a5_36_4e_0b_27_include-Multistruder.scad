// MultiStruder Library (http://www.thingiverse.com/thing:325225)
// *********************************************************************************
// Version history:
// Author:			Date: 			Description:
// Whitecoat		2014-02-21		Initial build
// 
// *********************************************************************************
// Included Public Functions:
// DefineBaySize(CentreOffsetY,BearingType=608,TensBoltRadius=2,MinWallThick=3,PrintTolerance=0.25)
// DefineHousingSize(BayDef,Numheads,BowdenClearance,PrintTolerance)
// DefineShifter(Housing,MinThickness,AxelRadius,PrintTolerance)
// DefineLid(HousingDef,BayDef,ShifterDef,PrintTolerance)
// DefineMotorMount(housingDef,BayDef,HousingBoltDef,MotorInset,MotorWidth)
// DefineBowden(height,ThreadRadius,ThreadHeight,PrintTolerance)
// MaxHeads(BedX, BedY,BayDef)		// how many print heads you can fit on your little angel?

// *********************************************************************************
// Included Public Modules:
//
// MultiStruderHousing(heads,BayDef)	
// MultiStruderLid(housingDef,BayDef,ShifterDef);
// MotorMount(MotorMountDef,MotorBoltDef)
// GearShift(ShifterDef);
// SelectionGear(GearBodyStyle,ToothStyle,NumTeeth,ShifterDef,NumHeads)
//	
// *********************************************************************************
// Included Internal Modules:
// Extruder_bay(p_BayDef,p_BaseThickness,HousingInnerThickness)
//
// *********************************************************************************
// Internal Unit tests:
//	HousingTest1();  			//Unit Test 1 - Housing
//	LidUnitTest1();			//Unit Test 1 - Lid
//	ShifterTest1();			//Unit Test 1 - Shifter
//	ExtrusionUnitTest1();	//Unit test 1 - Extrusion Unit
//	MotorMountUnitTest1();	//Unit test 1 = Motor Mount
//
// *********************************************************************************
// Comments:
// The SelectionGear module requires a GearBody and Tooth Definition from Gears include

// Dependant Includes
include <include-gears.scad>
include <include-bearings.scad> 
include <include-nut&bolt.scad>

module HousingTest1()
	{
	l_hobbedBoltDef 	= DefineHobbedBolt(8,11,4,60,21,10,3,PrintTolerance,HEXHEAD);
	l_TensBoltDef		= DefineBolt(4,5,2,10,PrintTolerance,HEXHEAD);
	l_BayDef = DefineBaySize(5,608,l_hobbedBoltDef,l_TensBoltDef,3,5,0.25);	
	l_heads = MaxHeads(150, 140,l_BayDef);
	l_MountBoltStyle	= DefineBolt(8,5,4,10);

	l_housing = DefineHousingSize(l_BayDef,l_heads,0.25);
	
	MultiStruderHousing(l_housing,l_BayDef,l_MountBoltStyle);	

	}

module LidUnitTest1()
	{
	l_hobbedBoltDef = DefineHobbedBolt(8,11,4,60,21,10,3,0.25,HEXHEAD);
	l_TensBoltDef	= DefineBolt(4,5,2,10,0.25,HEXHEAD);
	l_BayDef 		= DefineBaySize(5,608,l_hobbedBoltDef,l_TensBoltDef,3,5,0.25);		
	l_heads 			= MaxHeads(150, 140,l_BayDef);
	l_housing 		= DefineHousingSize(l_BayDef,l_heads,0.25);
	l_ShiftBoltDef	= DefineBolt(4,5,2,10,0.25,HEXHEAD);
	l_shifter 		= DefineShifter(l_housing,l_BayDef,3,(BearingPartNoToDim(608)[0])/2,7,0.25);
	l_toothStyle 	= DefineTooth(Involute,2,5,0,2);
	l_GearBodyStyle = DefineGearBody(SolidBody,62,57,5,0);
	l_Lid				= DefineLid(l_housing,l_BayDef,l_shifter,0.25);


	translate([0,0,37.5])
		{
//		MultiStruderLid(l_Lid);
	
		translate([0,0,10])
			{
			// bearings on lid
			for (i = [1:l_heads])
			rotate([0,0,(180/l_heads)*(1+2*i)])
				{
				translate([	45.75,
								0,
								2])
					color("silver")	
						fake_bearing(BearingPartNoToDim(608));
				}
		
//			// Extruder Drive Gear	
//			translate([0,0,23])
//				rotate([180,0,0])
//					Gear(	l_GearBodyStyle,DefineGearCore(B608,58,3),l_toothStyle,65);

			// Extruder Selection Gear	
			translate([0,0,-3.75])
				rotate([0,0,0])
					SelectionGear(l_GearBodyStyle,l_toothStyle,65,l_shifter,l_heads);
			}
		}
//	translate([0,0,60])
//		LidBrace(l_Lid);
	}

module ShifterTest1()
	{
	l_hobbedBoltDef = DefineHobbedBolt(8,11,4,60,21,10,3,PrintTolerance,HEXHEAD);
	l_TensBoltDef	= DefineBolt(4,5,2,10,PrintTolerance,HEXHEAD);
	l_BayDef 		= DefineBaySize(5,608,l_hobbedBoltDef,l_TensBoltDef,3,5,0.25);			
	l_heads 		= MaxHeads(150, 140,l_BayDef);
	l_housing 	= DefineHousingSize(l_BayDef,l_heads,0.25);
	l_shifter 	= DefineShifter(l_housing,3,(BearingPartNoToDim(608)[0])/2,0.25);

	translate([0,-77,40.5])
		GearShift(l_shifter);

	translate([0,-80,52])
		rotate([225,0,0])
			Gear(	DefineGearBody(SolidBody,22,10,9,3),
					DefineGearCore(CylinderCore,5,3),
					DefineTooth(Involute,2,7,45,0),
					25);	
	}

module ExtrusionUnitTest1()
	{
	l_hobbedBoltDef = DefineHobbedBolt(8,11,4,60,21,10,3,0.25,HEXHEAD);
	l_TensBoltDef	= DefineBolt(4,5,2,10,0.25,HEXHEAD);
	l_BayDef 		= DefineBaySize(5,608,l_hobbedBoltDef,l_TensBoltDef,3,5,0.25);	
	l_bowden			= DefineBowden(22,4.75,8,0.25);	
	// full extruder unit, with bearings (608)

	ExtusionUnit(l_BayDef,l_bowden);
	translate([0,24.5,20.25])
		rotate([0,90,0])
			color("silver")	
				fake_bearing(BearingPartNoToDim(608));
	translate([23.5,24.5,20.25])
		rotate([0,90,0])
			color("silver")	
				fake_bearing(BearingPartNoToDim(608));

	// tensioner
	translate([10.25,41.5,12.5])
		rotate([270,0,0])
		{
		TensionerArm(l_BayDef);
		translate([3,0,20])
				rotate([0,90,0])
					color("silver")	
						fake_bearing(BearingPartNoToDim(608));
		}

	translate([35,26,20])
		rotate([0,90,0])
			Gear(	DefineGearBody(HalfThickBody,20,10,12,3),
					DefineGearCore(NutCore,8,3),
					DefineTooth(Involute,2,12,0,2),
					30);	
	}

module MotorMountUnitTest1()
	{
	l_hobbedBoltDef = DefineHobbedBolt(8,11,4,60,21,10,3,PrintTolerance,HEXHEAD);
	l_TensBoltDef	= DefineBolt(4,5,2,10,PrintTolerance,HEXHEAD);
	l_BayDef 		= DefineBaySize(5,608,l_hobbedBoltDef,l_TensBoltDef);		
	l_heads 				= MaxHeads(150, 140,l_BayDef);
	l_housing 			= DefineHousingSize(l_BayDef,l_heads,5,0.25);
	l_MountBoltStyle	= DefineBolt(8,5,4,10);
	l_MotorMount		= DefineMotorMount(l_housing,l_BayDef,l_MountBoltStyle,5,42);
	l_MotorBoltStyle	= DefineBolt(3,2,1.6,6,0.5,ROUNDHEAD);

	rotate([0,0,180/l_heads])
		translate([66,0,30])
			MotorMount(l_MotorMount,l_MotorBoltStyle);

	rotate([0,0,180/l_heads*3])
		translate([66,0,30])
			MotorMount(l_MotorMount,l_MotorBoltStyle);

	rotate([0,0,180/l_heads*3])
		translate([90,2.5,30])
			MotorGear(l_MotorMount,10,DefineTooth(Involute,2,12,0,2));	
	}

// *********************************************************************************
// Housing functions & Modules
// *********************************************************************************

//-------------------------------------------------------------------------	
// function DefineBaySize
//-------------------------------------------------------------------------	
// This function defines the key dimensions of the extruder and the bay it sits in.
// The purpose of defining the extruder bay in one spot is so that it can be easily moved between modules
// with all the shared information calculated once.
function DefineBaySize( CentreOffsetY,BearingType=608,HobbedBoltDef,
								TensBoltDef,MinWallThick=3,BowdenClearance,PrintTolerance=0.25) =
	[	
	// 0 - Bay height (z) - Bearing height + nut + walls around those two items.
	BearingPartNoToDim(BearingType)[1]+3*MinWallThick+2+2*PrintTolerance,

	// 1 - BayDepth (x) - Three bearings plus min walls & clearance for the tensioner(using print tolerance as  
	// an indication of required clearance)
	3*BearingPartNoToDim(BearingType)[2]+MinWallThick*3+2*PrintTolerance,  

	// 2 - BayWidth (y) - Needs to fit at least the full tensioner bearing and half a centre bearings 
	// on tensioner side of the hobbed bolt.  Other side can be reduced as long as bolt still centred
	// CentreOffsetY is used in both bay and extruder to keep bolt centred.
	2*(BearingPartNoToDim(BearingType)[1]+BearingPartNoToDim(BearingType)[0]/2+2*MinWallThick)-CentreOffsetY, 

	// 3 - LipDepth - don't really want to parameterise externally to keep bays more interchangable.
	5, 

	// 4 -LipWidth - don't really want to parameterise externally to keep bays more interchangable.
	5, 

	// 5 - bearingType - Part number for the type of bearing to be used
	BearingType,

	// 6 - MinWallThick - The minimum thickness of a wall in the extruder (increase to add strength)
	MinWallThick,

	// 7 CentreOffsetY - is used in both bay and extruder to keep bolt centred.
	CentreOffsetY, 

	// 8 - CentreOffsetZ - is used to raise the bolt off centre, allows clearance for pivot bolt
	// at the bottom without adding unnessecary material at the top to keep the bolt centred. 
	// computed assuming shifted up by (thicknes of bolt and a wall) /2
	TensBoltDef[2]	+ MinWallThick/2,
	
	// 9 - PrintTolerance - Used to specify accuracy of printer.  Higher number is less accurate.
	PrintTolerance,
	
	// 10 - TensionerArmDepth (x) - Depth of the tensioner arm is one bearing thickness + a wall
	(BearingPartNoToDim(BearingType)[2]+MinWallThick),

	// 11 - TensionerArmWidth (y) - Width or the tensioner arm is half a bearing + a wall
 	BearingPartNoToDim(BearingType)[1]/2 + MinWallThick/2,

	// 12 - TensBoltRadius - Radius of the bolt that will be used as the Tensioner Pivot
	TensBoltDef[2],
	
	// 13 - TensBoltHeadSize - How long is each side of the bolt head (assuming hex - 6 sides) 
	TensBoltDef[0],
	
	// 14 - TensBoltHeadDepth - Depth to leave as clearance for the bolt head 
	TensBoltDef[1],

	// 15 - Bowden Clerance - Leave clearance for bowden mount
	BowdenClearance
	];

//-------------------------------------------------------------------------	
// function DefineHousingSize
//-------------------------------------------------------------------------	
function DefineHousingSize(BayDef,NumHeads,PrintTolerance=0.25) =
	[	
	// 0 - l_heads - Number of extruder heads
   NumHeads,

	// 1 - l_InnerRadius - Inner radius of Housing
	(BayDef[2]/2-BayDef[7]+BayDef[6])*tan(90-180/NumHeads),

	// 2 - l_OuterRadius - Outer radius of Housing
	(BayDef[2]/2-BayDef[7]+BayDef[6])*tan(90-180/NumHeads)+BayDef[6]+BayDef[1]+BayDef[3],

	// 3 - PrintTolerance - Print Tollerance
	PrintTolerance,

	// 4 - Lid Bolt radius
	2.5
	];

//-------------------------------------------------------------------------	
// function DefineLid
//-------------------------------------------------------------------------	
function DefineLid(HousingDef,BayDef,ShifterDef,PrintTolerance) =
	[	
	// 0 - Heads
	HousingDef[0],
	
	// 1 - Inner Radius
 	HousingDef[1],

	// 2 - Outer Radius
 	HousingDef[2],	

	// 3 - Bay Depth
 	BayDef[1],	

	// 4 - Bay Width
 	BayDef[2],

	// 5 - Clearance Opening Radius - Radius at which hole for top of extruder starts
	//			Inner Radius + 2 minthicknesses + a bearing thickness
 	HousingDef[1]+2*BayDef[6]+BearingPartNoToDim(BayDef[5])[2]-BayDef[6]/2,

	// 6 - Base Thickness
 	BayDef[6],

	// 7 - Min Wall Thickness
 	BayDef[6],
	
	// 8 - Bay Y Offset
 	BayDef[7],

	// 9 - Clearance Depth - depth of lid openning for extruder
	//			Is based on tensioner width
 	BayDef[10],
			
	// 10 - Print Tolerance
 	BayDef[9],

	// 11 - Lid Bearing Style
 	BayDef[5],

	// 12 - Lid Bolt Radius
 	2.5,
	
	// 13 - Shifter Width
 	ShifterDef[1],

	// 14 - Shifter Length
 	ShifterDef[3] + ShifterDef[6],

	// 15 - Gear Inner Radius - Radius at which gear cores starts.
	ShifterDef[8],

	// 16 - Bearing Mount Height - It's basically hook height from shifter
	ShifterDef[7]
	];

//-------------------------------------------------------------------------	
// function DefineMotorMount
//-------------------------------------------------------------------------	
function DefineMotorMount(HousingDef,p_BayDef,HousingBoltDef,BoltInset,MotorWidth) =
	[	
	// 0 - NumHeads - Number of extruder heads
   HousingDef[0],

	// 1 - HousingRadius - Outer Radius of Hosuing
	HousingDef[2],

	// 2 - HousingHeight - Thickness of base of Housing + Height of Bay
	p_BayDef[6] + p_BayDef[0],

	// 3 - PrintTolerance
	p_BayDef[9],

	// 4 - MountArmWidth
	10,

	// 5 - MountThickness
	p_BayDef[6]*2,

	// 6 - BayYshift
	p_BayDef[7],

	// 7 - Socket Radius on Housing Mount - bolt size + minthickness
	HousingBoltDef[0]+p_BayDef[6]/2,

	// 8 - SocketOffset - Distance from socket Centre to Outer Radius
	p_BayDef[1]/3,

	// 9 - Motor Bolt Inset
	BoltInset,

	// 10 - MotorWidth
	MotorWidth,

	];

//-------------------------------------------------------------------------	
// function DefineShifter
//-------------------------------------------------------------------------	
function DefineShifter(Housing,BayDef,MinThickness,BoltDef,HookLength,PrintTolerance) =
	[	
	// 0 - AxelRadius 
	BoltDef[0],

	// 1 - ShifterWidth - axel Diameter + 2 lots of min thickness
   3*MinThickness + 2*BoltDef[0],

	// 2 - ShifterHeight - derived from width but at 45 degree angle (a^2 + b^2 = c^2)
	sqrt( pow((2*BoltDef[0] + 3*MinThickness),2)/2 ),

	// 3 - ShifterLength
	2*BoltDef[0] + 2*MinThickness,

	// 4 - MinThickness
	MinThickness,

	// 5 - PrintTolerance - Print Tollerance
	PrintTolerance,

	// 6 - HookLength - 
	HookLength,

	// 7 - HookHeight - 
	5,	

	// 8 - Selection Gear Inner Radius = Inner Radius + extruder bay up to tensioner + the hook length
	// plus a few print tolerances that have occured on the way out from the centre
	Housing[1]+2*BayDef[6]+BearingPartNoToDim(BayDef[5])[2]
	+BayDef[10] + HookLength + 3*PrintTolerance,

	// 9 - Nut hole size
	BoltDef[0],

	// 10 - FullLength - Shifter body + hook length
	HookLength+2*BoltDef[0] + 3*MinThickness

	];

//-------------------------------------------------------------------------	
// function DefineBowden - 
//-------------------------------------------------------------------------
// Define the attributes Bowden fitting that will sit at the base of an
// extrusion unit.
	
function DefineBowden(FullHeight,ThreadRadius,ThreadHeight,PrintTolerance,MaxRadius) =
	[	
	// 0 - Height
	FullHeight,
	
	// 1 - Radius at Thread
 	ThreadRadius,

	// 2 - Height of Thread region
	ThreadHeight,

	// 3 - Print Tolerance
	PrintTolerance,

	// 4 - Widest Radius - ensuring clearance on housing
	MaxRadius
	];

//-------------------------------------------------------------------------	
// function MaxHeads
//-------------------------------------------------------------------------	
function MaxHeads(BedX, BedY,BayDef) =
//	angle required for each = atan	( Opposite 						 / Adjacent								)
//											 BayWidth+WallThick				 /	(MaxRadius-bayDepth-MinThickness)/2
	BedX >  BedY ? floor(180/atan((BayDef[2]+BayDef[6]-BayDef[7])/(BedY/2-BayDef[1]-BayDef[6])/2)) :
						floor(180/atan((BayDef[2]+BayDef[6]-BayDef[7])/(BedX/2-BayDef[1]-BayDef[6])/2)) ;


//-------------------------------------------------------------------------	
// Gear Sizing Functions
//-------------------------------------------------------------------------	
// Gears are from a different library, just a few functions to make sizing easier 
// based upon multistruder requirements.

// Shift gear is limited in size by Shifter and lid height, as the bay
// gear reaches up to the base of the lid.
function OutRadiusShiftGear(p_ShifterDef,p_LidDef,p_ToothHeight)	
							=	(p_ShifterDef[2]/2-p_ToothHeight/2)*cos(45);

function OutRadiusDriveGear(p_ShifterDef,p_ToothHeight) =	p_ShifterDef[8]+ p_ShifterDef[6]
																				-p_ToothHeight - p_ShifterDef[5];
function InRadiusDriveGear(p_ShifterDef)				=	p_ShifterDef[8];

function InRadiusSelectGear(p_ShifterDef)				=	p_ShifterDef[8];
function OutRadiusSelectGear(p_ShifterDef)			=	p_ShifterDef[8] + p_ShifterDef[6];

// Bay gear is limited by height of bay as shifter is directly above it on lid
function OutRadiusBayGear(p_BayDef,p_ToothHeight)	=	p_BayDef[0]/2-p_ToothHeight/2;

//-------------------------------------------------------------------------	
// Housing Module
//-------------------------------------------------------------------------	
module MultiStruderHousing(p_Housing,p_BayDef,MountingBoltStyle)	
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.

	//-------------------------------------------------------------------------	
	// Break out housing definition (For ease of readability)	
	l_heads					=  p_Housing[0];
	l_InnerRadius			=  p_Housing[1];
	l_OuterRadius			=  p_Housing[2];
	l_LidBoltRadius		= 	p_Housing[4];

	//-------------------------------------------------------------------------	
	// Break out bay definition (For ease of readability)
	l_BayHeight				=	p_BayDef[0];
	l_BayDepth				=	p_BayDef[1];
	l_BayWidth				=	p_BayDef[2];
	l_LipDepth				= 	p_BayDef[3];
	l_InnerThickness 		=  p_BayDef[6];
	l_CentreOffsetY		=  p_BayDef[7];
	l_BaseThickness 		=  p_BayDef[6];	// Thickness of base of housing
		
	l_BoltClearance		= MountingBoltStyle[0]+l_InnerThickness/2;
	l_LidFastenRadius		= l_LidBoltRadius + l_InnerThickness;

// diagnostic - Print out outer radius - used to validate MaxHeads function
	echo("Outer Radius of Housing: ",l_OuterRadius, "mm");

	// Draw
	//-------------------------------------------------------------------------
	// housing is basiclly a cylinder, subtracting anything we don't need
   difference()
		{
		cylinder(h=l_BayHeight+l_BaseThickness,r=l_OuterRadius,$fn=100);
		union()
			{
			//	subtract inner circumfrence, shifting to make it slightly larger than housing
			// so that difference is clean
			translate([0,0,-l_tolerance])
			cylinder(h=l_BayHeight+l_BaseThickness+l_tolerance*2,
						r=l_InnerRadius,
						$fn=100);

			// subtract extruder bays
			// circle round to each bay
			for (i = [0:l_heads-1])
				{
				rotate([0,0,(360/l_heads)*i])
					// lift bays to retain a base, & start at inner radius
					translate([	l_InnerRadius+l_InnerThickness,
									-l_BayWidth/2+l_CentreOffsetY,
									l_BaseThickness])
						{
						Extruder_bay(p_BayDef,l_BaseThickness,l_InnerThickness*2);
						}
				}
			// Create mounting holes to secure housing
			for (i = [1:l_heads])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_OuterRadius-l_BayDepth/3,
								l_CentreOffsetY/2,
								l_BaseThickness+l_BayHeight/4])
							rotate([180,0,0])
								BoltHole(MountingBoltStyle,l_BoltClearance,l_BayHeight);
					}

			// create sockets for the two Motor Mounts
			for (i = [0:1])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_OuterRadius-l_BayDepth/3,
								l_CentreOffsetY/2,
								l_BaseThickness+l_BayHeight-2*l_InnerThickness])
							rotate([0,0,-45])
								cube([l_BayDepth,l_BayDepth,2*l_InnerThickness+l_tolerance]);
					}
			}
		}
	// add on Lid fasteners
	for (i = [1:l_heads])
		rotate([0,0,(180/l_heads)*(1+2*i)])
			{
			difference()
				{
				translate([	l_InnerRadius-l_LidBoltRadius,
								-l_LidFastenRadius/2+l_CentreOffsetY/2,
								0])
					cylinder(h=l_BayHeight+l_InnerThickness,r=l_LidFastenRadius);
				translate([	l_InnerRadius-l_LidBoltRadius,
								-l_LidFastenRadius/2+l_CentreOffsetY/2,
								-l_tolerance])
					cylinder(h=l_BayHeight+l_InnerThickness+2*l_tolerance,r=l_LidBoltRadius);
				}
			}
	}

module Extruder_bay(p_BayDef,p_BaseThickness,HousingInnerThickness)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 	= 0.1;
	HobbedChannelBase		= 15;

	//-------------------------------------------------------------------------	
	// Break out bay definition (For ease of readability)
	l_BayHeight				=	p_BayDef[0];
	l_BayDepth				=	p_BayDef[1];
	l_BayWidth				=	p_BayDef[2];
	l_LipDepth				= 	p_BayDef[3];
	l_LipWidth 				= 	p_BayDef[4];
	l_BearingThickness	=  BearingPartNoToDim(p_BayDef[5])[2];
	l_MinWallThinkness 	= 	p_BayDef[6];
	l_CentreOffsetY		=  p_BayDef[7];
	l_CentreOffsetZ		=  p_BayDef[8];
	l_PrintTolerance 		=  p_BayDef[9];
	HobbedChannelWidth 	=  2*p_BayDef[13]+2*l_MinWallThinkness;
	l_BowdenRadius 		=  p_BayDef[15];

	// computations
	//-------------------------------------------------------------------------
	bowden_x_calbration 	= 1.5*l_BearingThickness + 2*l_MinWallThinkness;
	bowden_y_calbration 	= 0;

	// Draw
	//-------------------------------------------------------------------------	
	//primary bay dimensions
	translate([-l_PrintTolerance,0,-l_PrintTolerance])
	cube([l_BayDepth-l_LipWidth+2*l_PrintTolerance,
			l_BayWidth-l_CentreOffsetY+2*l_PrintTolerance,
			l_BayHeight+l_tolerance+l_PrintTolerance]);

	// add a lip at bay outside edge to help secure extruder in place
	translate([	l_BayDepth-l_LipWidth-l_tolerance,
					(l_BayWidth/2)-(l_BayWidth-l_LipDepth)/2-l_PrintTolerance,
					0])
		{
		cube([l_LipWidth*3,
				l_BayWidth-l_LipDepth-l_CentreOffsetY+2*+2*l_PrintTolerance,
				l_BayHeight+2*l_tolerance]);
		}

	// filament passage to bowden 
	translate([	bowden_x_calbration,
					(l_BayWidth/2)+bowden_y_calbration,
					-p_BaseThickness-l_tolerance]
				)
		{
		cylinder(h=p_BaseThickness+l_tolerance*2,r=l_BowdenRadius);
		}

	// hobbed bolt channel
	translate([	l_tolerance,(l_BayWidth/2)-l_CentreOffsetY,HobbedChannelBase])
		{
		rotate([0,-90,0])
			{
			union()
				{
				cylinder(h=HousingInnerThickness,r=HobbedChannelWidth/2);
				translate([0,-HobbedChannelWidth/2,0])
				cube([l_BayHeight-HobbedChannelBase+l_tolerance,HobbedChannelWidth,HousingInnerThickness]);
				}
			}
		}

	}


module MultiStruderLid(p_LidDef)	
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.

	//-------------------------------------------------------------------------	
	// Break out lid definition (For ease of readability)	
	l_heads					=  p_LidDef[0];
	l_InnerRadius			=  p_LidDef[1];
	l_OuterRadius			=  p_LidDef[2];
	l_BayDepth				=	p_LidDef[3];
	l_BayWidth				=	p_LidDef[4];
	l_ClearanceRadius		=  p_LidDef[5];
	l_BaseThickness 		=  p_LidDef[6];
	l_MinWallThinkness	=  p_LidDef[7];
	l_CentreOffsetY		=  p_LidDef[8];
	l_TensionerDepth		=  p_LidDef[9];
	l_PrintTolerance 		=  p_LidDef[10];
	l_BearingSize			=  BearingPartNoToDim(p_LidDef[11]);
	l_LidBoltRadius		= 	p_LidDef[12];
	l_shifterWidth			= 	p_LidDef[13];
	l_ShifterLength		= 	p_LidDef[14];
	l_GearInRadius			= 	p_LidDef[15];
	l_BearingHeight		=  p_LidDef[16];
	l_BearingBoltRadius	=  1.5;

	//-------------------------------------------------------------------------	
	// Computations
	l_BearingRadius 	 	=  l_BearingSize[1]/2;
	l_BearingInRaidus		=  l_BearingSize[0]/2;
	l_BearingWidth			= 	l_BearingSize[2];
	l_LidFastenRadius		= l_LidBoltRadius + l_MinWallThinkness;

	// Draw
	//-------------------------------------------------------------------------
	// lid is primarily a cylinder, subtracting anything we don't need
   difference()
		{
		union()
			{
			cylinder($fn=100,h=2*l_MinWallThinkness,r=l_OuterRadius);
			// Create raised washer for bearings
			// circle round to each bay
			for (i = [1:l_heads])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_GearInRadius-l_BearingRadius,
									0,
									2*l_MinWallThinkness])
							{
							cylinder(h=l_BearingHeight+l_PrintTolerance,
										r=l_BearingInRaidus+l_MinWallThinkness);
							cylinder(h=l_BearingHeight+l_BearingWidth+2*l_PrintTolerance,
										r=l_BearingInRaidus-l_PrintTolerance);
							}
					}
			}
		union()
			{		
			// subtract inner radius
			translate([0,0,-l_tolerance])
				cylinder($fn=100,h=2*l_MinWallThinkness+l_tolerance*2,r=l_InnerRadius);

			// Create a clearance over extruder bays
			// circle round to each bay
			for (i = [1:l_heads])
				rotate([0,0,(360/l_heads)*i])
					{
					translate([	l_ClearanceRadius,-l_BayWidth/2+l_CentreOffsetY,-l_tolerance])
						cube([	l_TensionerDepth+l_MinWallThinkness,
									l_BayWidth-l_CentreOffsetY,
									2*l_MinWallThinkness+2*l_tolerance]);

					// add hole & rails for shifter
					translate([	l_ClearanceRadius+l_TensionerDepth,
									-l_shifterWidth/2-l_PrintTolerance,
									l_MinWallThinkness-l_PrintTolerance])
						difference()
							{
							cube([	l_ShifterLength,
										l_shifterWidth+2*l_PrintTolerance,
										l_MinWallThinkness+l_tolerance+l_PrintTolerance]);
							union()
								{
								translate([	0,0,l_MinWallThinkness/2+l_PrintTolerance])
									rotate([ 0,90,0])
										cylinder($fn=100,h=l_ShifterLength,
													r=l_MinWallThinkness/2-l_PrintTolerance);
								translate([	0,l_shifterWidth,l_MinWallThinkness/2+l_PrintTolerance])
									rotate([ 0,90,0])
										cylinder($fn=100,h=l_ShifterLength,
													r=l_MinWallThinkness/2-l_PrintTolerance);
								}
							}				
					}

			// Create mounting holes for bearings
			// circle round to each bay
			for (i = [1:l_heads])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_GearInRadius-l_BearingRadius,
									0,
									-l_tolerance])
							cylinder(h=4*l_MinWallThinkness+l_BearingWidth,
										r=l_BearingBoltRadius+l_PrintTolerance);
					}
			}
		}
	// add on Lid fasteners
	for (i = [1:l_heads])
		rotate([0,0,(180/l_heads)*(1+2*i)])
			{
			difference()
				{
				translate([	l_InnerRadius-l_LidBoltRadius,
								-l_LidFastenRadius/2+l_CentreOffsetY/2,
								0])
					cylinder(h=2*l_MinWallThinkness,r=l_LidFastenRadius);
				translate([	l_InnerRadius-l_LidBoltRadius,
								-l_LidFastenRadius/2+l_CentreOffsetY/2,
								-l_tolerance])
					cylinder(h=2*l_MinWallThinkness+2*l_tolerance,r=l_LidBoltRadius);
				}
			}
	}

module LidBrace(p_LidDef)	
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.

	//-------------------------------------------------------------------------	
	// Break out lid definition (For ease of readability)	
	l_heads					=  p_LidDef[0];
	l_InnerRadius			=  p_LidDef[1];
	l_OuterRadius			=  p_LidDef[2];
	l_BayDepth				=	p_LidDef[3];
	l_BayWidth				=	p_LidDef[4];
	l_ClearanceRadius		=  p_LidDef[5];
	l_BaseThickness 		=  p_LidDef[6];
	l_MinWallThinkness	=  p_LidDef[7];
	l_CentreOffsetY		=  p_LidDef[8];
	l_TensionerDepth		=  p_LidDef[9];
	l_PrintTolerance 		=  p_LidDef[10];
	l_BearingSize			=  BearingPartNoToDim(p_LidDef[11]);
	l_LidBoltRadius		= 	p_LidDef[12];
	l_shifterWidth			= 	p_LidDef[13];
	l_ShifterLength		= 	p_LidDef[14];
	l_GearInRadius			= 	p_LidDef[15];
	l_BearingHeight		=  p_LidDef[16];
	l_BearingBoltRadius	=  1.5;

	//-------------------------------------------------------------------------	
	// Computations
	l_BearingRadius 	 	=  l_BearingSize[1]/2;
	l_BearingInRaidus		=  l_BearingSize[0]/2;
	l_BearingWidth			= 	l_BearingSize[2];
	l_LidFastenRadius		= l_LidBoltRadius + l_MinWallThinkness;

	// Draw
	//-------------------------------------------------------------------------
	// lid is primarily a cylinder, subtracting anything we don't need
	difference()
		{
		union()
			{
			cylinder($fn=100,h=l_MinWallThinkness,r=l_GearInRadius-0.5*l_BearingRadius);
			// Create raised washer for bearings
			// circle round to each bay
			for (i = [1:l_heads])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_GearInRadius-l_BearingRadius,
									0,
									l_MinWallThinkness])
							{
							cylinder(h=l_MinWallThinkness,
										r=l_BearingInRaidus+l_MinWallThinkness/2);
							cylinder(h=l_MinWallThinkness+l_BearingWidth/2+l_PrintTolerance,
										r=l_BearingInRaidus-l_PrintTolerance);
							}
					}
			}
		union()
			{
			translate([0,0,-l_tolerance])
				cylinder($fn=100,h=l_MinWallThinkness+2*l_tolerance,
							r=l_GearInRadius-1.5*l_BearingRadius);
			// Create mounting holes for bearings
			// circle round to each bay
			for (i = [1:l_heads])
				rotate([0,0,(180/l_heads)*(1+2*i)])
					{
					translate([	l_GearInRadius-l_BearingRadius,
									0,
									-l_tolerance])
							cylinder(h=4*l_MinWallThinkness+l_BearingWidth,
										r=l_BearingBoltRadius+l_PrintTolerance);
					}
			}
		}
	}

// *********************************************************************************
// Extrusion Unit functions & Modules
// *********************************************************************************
module ExtusionUnit(p_BayDef,p_BowdenDef)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;
	l_FilimentThickness	= 2;
	 
	//-------------------------------------------------------------------------	
	// Break out bay definition (For ease of readability)
	l_BayHeight				=	p_BayDef[0];
	l_BayDepth				=	p_BayDef[1];
	l_BayWidth				=	p_BayDef[2];
	l_LipDepth				= 	p_BayDef[3];
	l_LipWidth 				= 	p_BayDef[4];
	l_BearingSize			=  BearingPartNoToDim(p_BayDef[5]);
	l_MinWallThinkness 	=  p_BayDef[6];
	l_CentreOffsetY		=  p_BayDef[7];
	l_CentreOffsetZ		=  p_BayDef[8];
	l_PrintTolerance		=  p_BayDef[9];
	l_TensionerDepth		=  p_BayDef[10];
	l_TensThickness		=  p_BayDef[11];	// Tensioner Arm Thickness at pivot
	l_TensBoltRadius		=  p_BayDef[12];
	l_TensBoltHSize		=  p_BayDef[13];
	l_TensBoltHDepth		=  p_BayDef[14];

	l_BearingRadius 	 	=  l_BearingSize[1]/2;
	l_BearingInRaidus		=  l_BearingSize[0]/2;
	l_BearingThickness 	=  l_BearingSize[2];

	l_BowdenThreadRadius	=  p_BowdenDef[1];
	l_BowdenThreadHeight =  p_BowdenDef[2];
	l_BowdenPrintTol		=  p_BowdenDef[3];

	// Draw
	//-------------------------------------------------------------------------
	difference()
		{
		union()
			{	
			//primary bay dimensions
			cube([l_BayDepth-l_LipWidth,l_BayWidth-l_CentreOffsetY,l_BayHeight]);

			// lip recess
			translate([l_BayDepth-l_LipDepth,(l_BayWidth/2)-(l_BayWidth-l_LipDepth)/2,-l_tolerance])
				{
				cube([l_LipDepth,l_BayWidth-l_LipDepth-l_CentreOffsetY,l_BayHeight+2*l_tolerance]);
				}

			// hook
			translate([l_BearingThickness+l_MinWallThinkness,l_TensThickness/2,l_BayHeight])
				cube([l_TensionerDepth,l_TensThickness,l_MinWallThinkness*2]);
			translate([	l_BearingThickness+l_MinWallThinkness,
							l_TensThickness/2-l_MinWallThinkness,
							l_BayHeight+l_MinWallThinkness])
				cube([l_TensionerDepth,l_MinWallThinkness,l_MinWallThinkness]);
			}
		union()
			{
			// Make holes for the bearings on hobbed bolt
			translate([	l_BayDepth-l_BearingThickness+l_tolerance,
							l_BayWidth/2-l_CentreOffsetY,
							l_BayHeight/2+l_CentreOffsetZ])  
				rotate([0,90,0])
					BearingHole(l_BearingSize,l_PrintTolerance);
			translate([	-l_tolerance,l_BayWidth/2-l_CentreOffsetY,l_BayHeight/2+l_CentreOffsetZ])  
				rotate([0,90,0])
					BearingHole(l_BearingSize,l_PrintTolerance);
			// hole for the hobbed bolt itself
			translate([	-l_tolerance,l_BayWidth/2-l_CentreOffsetY,l_BayHeight/2+l_CentreOffsetZ])
				rotate([0,90,0])
				cylinder(h=l_BayDepth,r=l_BearingInRaidus,$fn=100);

			// make hole for tensioner arm
			// upper half
			translate([	l_BearingThickness+l_MinWallThinkness,
							l_BayWidth/2-l_CentreOffsetY,
							l_BayHeight/2-l_BearingInRaidus+l_CentreOffsetZ])
				cube([l_TensionerDepth+l_PrintTolerance*2,l_BayWidth,l_BayHeight]);

			//lower half - Bit further out to leave room for filimante guide hole to base
			translate([	l_BearingThickness+l_MinWallThinkness,
							l_BayWidth-l_TensThickness-l_CentreOffsetY-l_PrintTolerance,
							-l_tolerance])
				cube([l_TensionerDepth+l_PrintTolerance*2,
						l_TensThickness+l_tolerance+l_PrintTolerance,
						l_BayHeight]);

			// leave room for tensioner bearing to approach hobbed bolt
			translate([	l_BearingThickness+2*l_MinWallThinkness,
							l_BayWidth-l_BearingRadius-2*l_MinWallThinkness,
							l_BayHeight/2+l_CentreOffsetZ])
				rotate([0,90,0])
					cylinder(h=l_BearingThickness+l_PrintTolerance*2,
								r=l_BearingRadius+l_FilimentThickness,$fn=100);
			
			// Filament Guide holes
			translate([	l_BayDepth/2+l_MinWallThinkness/2,
							l_BayWidth/2+l_BearingInRaidus+l_FilimentThickness/2-l_CentreOffsetY,
							-l_tolerance])
				{
				// primary guide hole
				cylinder(h=l_BayHeight+2*l_tolerance,r=l_FilimentThickness+l_PrintTolerance*2);
				// Bowden mount
				cylinder(h=l_BowdenThreadHeight+l_BowdenPrintTol,
							r=l_BowdenThreadRadius-l_BowdenPrintTol);
				}

			// tensioner pivot
			translate([	-l_tolerance,
							l_BayWidth-l_CentreOffsetY-l_TensThickness/2,
							+l_TensThickness/2])
				rotate([0,90,0])
					{
					cylinder($fn=100,h=l_BayWidth+2*l_tolerance,r=l_TensBoltRadius);
					for (i = [1:6])
						{
						rotate([0,0,i*360/6])
							translate([-l_TensBoltHSize/2,0,0])
								cube([l_TensBoltHSize,(l_TensBoltHSize/2)*tan(60),l_TensBoltHDepth+l_tolerance]);
						}
					}
			}	
		}
	}

module TensionerArm(p_BayDef)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 			= 0.1;
	l_FilimentThickness	= 2;
	 
	//-------------------------------------------------------------------------	
	// Break out bay definition (For ease of readability)
	l_BayHeight				=	p_BayDef[0];
	l_BayDepth				=	p_BayDef[1];
	l_BayWidth				=	p_BayDef[2];
	l_LipDepth				= 	p_BayDef[3];
	l_LipWidth 				= 	p_BayDef[4];
	l_BearingSize			=  BearingPartNoToDim(p_BayDef[5]);
	l_MinWallThinkness 	= 	p_BayDef[6];
	l_CentreOffset			=  p_BayDef[7];
	l_CentreOffsetZ		=  p_BayDef[8];
	l_PrintTolerance		=  p_BayDef[9];
	l_TensWidth				=  p_BayDef[10];
	l_TensThickness		=  p_BayDef[11];
	l_TensBoltRadius		=  p_BayDef[12];

	l_BearingRadius 	 	=  l_BearingSize[1]/2;
	l_BearingThickness 	= 	l_BearingSize[2];

	// Draw
	//-------------------------------------------------------------------------
	difference()
		{
		// primary volume
		union()
			{
			translate([0,0,l_TensThickness/2])
				cube([l_TensWidth,l_TensThickness,l_BayHeight-l_TensThickness/2]);
			translate([0,l_TensThickness/2,l_TensThickness/2])
				rotate([0,90,0])
					{
					cylinder(h=l_TensWidth,r=l_TensThickness/2);
					}
			// hook
			translate([0,0,l_BayHeight])
				cube([l_TensWidth,l_TensThickness/2,l_MinWallThinkness*2]);
			translate([0,l_TensThickness/2,l_BayHeight+l_MinWallThinkness])
				cube([l_TensWidth,l_TensThickness/2,l_MinWallThinkness]);
			}
		// subtractions
		union()
			{
			translate([l_MinWallThinkness+l_tolerance,0,l_BayHeight/2+l_CentreOffsetZ])
				rotate([0,90,0])
					scale([1,1,2])
						fake_bearing(l_BearingSize,-l_PrintTolerance);
				}

			// tensioner pivot
			translate([	-l_tolerance,
							l_TensThickness/2,
							+l_TensThickness/2])
				rotate([0,90,0])
					cylinder($fn=100,h=l_TensWidth+2*l_tolerance,r=l_TensBoltRadius);
			}
	}


module GearShift(p_ShifterDef)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 			= 0.1;
	l_FilimentThickness	= 2;
	 
	//-------------------------------------------------------------------------	
	// Break out Shifter definition (For ease of readability)	
	l_AxelRadius 			= p_ShifterDef[0];
	l_ShifterWidth			= p_ShifterDef[1];
	l_ShifterHeight		= p_ShifterDef[2];
	l_ShifterLength		= p_ShifterDef[3];
	l_MinWallThinkness	= p_ShifterDef[4];
	l_PrintTolerance		= p_ShifterDef[5];
	l_HookLength			= p_ShifterDef[6];
	l_HookHeight			= p_ShifterDef[7];
	l_GearCoreRadius		= p_ShifterDef[8];
	l_BoltSize				= p_ShifterDef[9];	
	
	l_BearingHeight		= sqrt(pow(l_AxelRadius*2+l_MinWallThinkness*2,2)/2);

	//Centre the shifter
	translate([-l_ShifterWidth/2,0,0])

	// Draw
	//-------------------------------------------------------------------------
	difference()
		{
		// primary volume
		union()
			{
			// body
			cube([l_ShifterWidth,l_ShifterLength,l_ShifterHeight]);

			// hook
			translate([0,l_ShifterLength,0])
				cube([l_ShifterWidth,l_HookLength+l_MinWallThinkness,l_MinWallThinkness]);
			translate([0,l_ShifterLength+l_HookLength,0])
				intersection()
					{
					cube([l_ShifterWidth,l_MinWallThinkness,l_HookHeight]);
					// taper hook to contour to gear
					translate([l_ShifterWidth/2,l_GearCoreRadius,l_MinWallThinkness])
						cylinder(r=l_GearCoreRadius,h=l_HookHeight);
					}

			rotate([45,0,0])
				translate([	l_ShifterWidth/2,
								l_AxelRadius+l_MinWallThinkness,
								l_tolerance])
						cylinder(	$fn=100,
										h=l_MinWallThinkness,
										r=l_AxelRadius+l_MinWallThinkness);
			}
		// subtractions
		union()
			{
			// sheer off outside volume at bearing, but leave a raised area
			// that would retain contact with the inner part of the bearing
			translate([-l_tolerance,0,0])
				rotate([45,0,0])
					{
					difference()
						{
						cube([	l_ShifterWidth+2*l_tolerance,
									l_AxelRadius*2+l_MinWallThinkness*3,
									l_ShifterHeight]);
						translate([	l_ShifterWidth/2,
										l_AxelRadius+l_MinWallThinkness,
										l_tolerance])
							cylinder(	$fn=100,
											h=l_MinWallThinkness,
											r=l_AxelRadius+l_MinWallThinkness);
						}

					// Hole for Axel
					translate([	l_ShifterWidth/2,
									l_AxelRadius+l_MinWallThinkness,
									2*l_tolerance+l_MinWallThinkness])
						rotate([180,0,0])
							union()
								{
								cylinder(	$fn=100,
												h=2*l_ShifterHeight,
												r=l_AxelRadius+2*l_PrintTolerance);
								translate([	0,0,2*l_MinWallThinkness])
									NutHole(l_BoltSize,l_ShifterHeight);
								}
									
					}				
			
			// create a clearance on body at hook height to ensure gear tooth clearance
			translate([	-l_tolerance,
							l_ShifterLength-l_MinWallThinkness-2*l_PrintTolerance,
							l_HookHeight+l_MinWallThinkness-l_PrintTolerance])	
						cube([	l_ShifterWidth+l_tolerance*2,
									l_MinWallThinkness+l_tolerance+2*l_PrintTolerance,
									l_ShifterHeight]);	

			// rails
			translate([0,0,l_MinWallThinkness/2+l_PrintTolerance])
				rotate([270,0,0])
					cylinder($fn=100,h=2*l_ShifterLength,r=l_MinWallThinkness/2);
			translate([l_ShifterWidth,0,l_MinWallThinkness/2+l_PrintTolerance])
				rotate([270,0,0])
					cylinder($fn=100,h=2*l_ShifterLength,r=l_MinWallThinkness/2);
			}
		}
	}

module SelectionGear(p_GearBodyStyle,p_toothStyle,p_Teeth,p_Shifter,p_heads)
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.
	l_WaveSteps 		= 60;		// equivilent to $f in this function.

	//-------------------------------------------------------------------------	
	// Break out key definitions (For ease of readability)
	l_GearInRadius		= p_GearBodyStyle[2];
	l_gearHeight		= p_GearBodyStyle[3];
	l_MinThickness		= p_Shifter[4];
	l_PrintTolerance 	= p_Shifter[5];
	l_ShiftDist			= p_Shifter[6];
	l_shiftHeight		= p_Shifter[7];
	l_NumHeads			= p_heads;
	l_bearingHgt		= BearingPartNoToDim(608)[2];
	
	// this thing is meant to be spun on bearings, so core style is fixed
	l_CoreStyle			= DefineGearCore(CylinderCore,l_GearInRadius,0);

	// Some computations
	//-------------------------------------------------------------------------
	l_StepAngle		= (360/l_NumHeads)/l_WaveSteps;
	l_SideLength 	= tan(360/l_WaveSteps)*l_GearInRadius;
	l_WaveBaseRadius = l_GearInRadius-l_PrintTolerance;

	// re-build gear
	// Outer radius needs to include teeth
	l_GearBodyStyle = [	p_GearBodyStyle[0],
								p_GearBodyStyle[1]-p_toothStyle[1],
								p_GearBodyStyle[2],
								p_GearBodyStyle[3],
								p_GearBodyStyle[4]	];
	
	// Draw
	//-------------------------------------------------------------------------
	// start with a gear then subtract waveform shaped step to for one head only 	
	difference()
		{
		union()
			{
			translate([0,0,l_shiftHeight])
				Gear(	l_GearBodyStyle,l_CoreStyle,p_toothStyle,p_Teeth);
			
			//default state guide for shifter
			difference()
				{
				cylinder(h=l_shiftHeight+l_tolerance,r=l_GearInRadius+l_ShiftDist-l_PrintTolerance);
				union()
					{
					translate([0,0,-l_tolerance])
						cube([l_GearInRadius+l_ShiftDist,l_GearInRadius+l_ShiftDist,l_shiftHeight+3*l_tolerance]);

					// hollow gear base
					translate([0,0,-l_tolerance])
						cylinder(h=l_shiftHeight+3*l_tolerance,r=l_GearInRadius);
					}
				}

			//Waveform section of guide
			for (i = [1:l_WaveSteps])
				rotate([0,0,l_StepAngle*i])
					translate([	l_WaveBaseRadius-(sin(180/l_WaveSteps*i))*l_ShiftDist/2,
									-l_SideLength/2,
									0])
						cube([l_ShiftDist,l_SideLength,l_shiftHeight]);

			// Top of Gear
			translate([0,0,l_shiftHeight-l_tolerance])
				cylinder(h=l_bearingHgt+l_MinThickness+l_tolerance,r=l_GearInRadius+l_MinThickness);			
			
			// printable trap at top of bearing
			translate([0,0,l_shiftHeight+l_bearingHgt])
				cylinder(h=l_MinThickness,r=l_GearInRadius+3*l_tolerance);
			}
		union()
			{
			// Ensure full clearance at bearing level
			translate([0,0,l_shiftHeight+l_MinThickness/2-l_tolerance])
				{
				cylinder($fn=100,h=l_bearingHgt+l_tolerance,r=l_GearInRadius);
				}
			// subtractions to form a printable trap at bottom of bearing
			translate([0,0,l_shiftHeight-l_MinThickness/2*l_tolerance])
				{
				cylinder($fn=100,h=l_MinThickness/2+l_tolerance,
								r1=l_GearInRadius,
								r2=l_GearInRadius-l_MinThickness/2);
				}
			// subtractions to form a printable trap at top of bearing
			translate([0,0,l_shiftHeight+l_bearingHgt+l_MinThickness/2-l_tolerance])
				cylinder(	h=l_MinThickness/2+2*l_tolerance,
								r1=l_GearInRadius,
								r2=l_GearInRadius-l_MinThickness/2);
						
			}
		}
	}

module MotorMount(p_MountDef,BoltStyle)	
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.

	//-------------------------------------------------------------------------	
	// Break out mount definition (For ease of readability)	
	l_heads				= p_MountDef[0];
	l_HousingRadius 	= p_MountDef[1];
	l_HousingHeight	= p_MountDef[2];
	l_PrintTolerance 	= p_MountDef[3];
	l_MountArmWidth	= p_MountDef[4];
	l_MountThickness	= p_MountDef[5];
	l_CentreOffsetY	= p_MountDef[6]/2;
	l_SocketRadius		= p_MountDef[7]-l_PrintTolerance;
	l_SocketCentre		= p_MountDef[8];
	l_BoltInset			= p_MountDef[9];
	l_MotorWidth		= p_MountDef[10];

	// computations
	//-------------------------------------------------------------------------
	l_BracketSide		= sqrt(2*pow(l_SocketCentre,2));

	// Draw
	//-------------------------------------------------------------------------
	// 
   difference()
		{
		union()
			{
			// Mount Arms with rounded ends
			translate([-l_MountThickness,-l_MotorWidth/2+l_CentreOffsetY,0])
				cube([l_MountArmWidth+l_MountThickness,l_MotorWidth,l_MountThickness]);
			translate([0,-l_MotorWidth/2+l_CentreOffsetY,0])
				cube([l_MotorWidth-l_MountArmWidth/2,
						l_MountArmWidth,
						l_MountThickness]);
			translate([	l_MotorWidth-l_MountArmWidth/2,
							-l_MotorWidth/2+l_MountArmWidth/2+l_CentreOffsetY,
							0])
				cylinder(h=l_MountThickness,r=l_MountArmWidth/2);
			translate([0,l_MotorWidth/2-l_MountArmWidth+l_CentreOffsetY,0])
				cube([l_MotorWidth-l_MountArmWidth/2,
						l_MountArmWidth,
						l_MountThickness]);
			translate([	l_MotorWidth-l_MountArmWidth/2,
							l_MotorWidth/2-l_MountArmWidth/2+l_CentreOffsetY,
							0])
				cylinder(h=l_MountThickness,r=l_MountArmWidth/2);

			}
		union()
			{
			// conform mount to surface of housing
			translate([	-l_HousingRadius+l_PrintTolerance,0,-l_HousingHeight+l_MountThickness])
					cylinder(h=l_HousingHeight+l_tolerance,r=l_HousingRadius);

			// Bolt Holes
			translate([	l_MotorWidth-l_BoltInset,
							-l_MotorWidth/2+l_BoltInset+l_CentreOffsetY,
							l_MountThickness+l_tolerance])
				rotate([180,0,0]) BoltHole(BoltStyle);
			translate([	l_MotorWidth-l_BoltInset,
							l_MotorWidth/2-l_BoltInset+l_CentreOffsetY,
							l_MountThickness+l_tolerance])
				rotate([180,0,0]) BoltHole(BoltStyle);
			translate([	l_BoltInset,
							l_MotorWidth/2-l_BoltInset+l_CentreOffsetY,
							l_MountThickness+l_tolerance])
				rotate([180,0,0]) BoltHole(BoltStyle);
			translate([	l_BoltInset,
							-l_MotorWidth/2+l_BoltInset+l_CentreOffsetY,
							l_MountThickness+l_tolerance])
				rotate([180,0,0]) BoltHole(BoltStyle);
			}
		}
		// Housing connector
		difference()
			{
			translate([-l_SocketCentre+l_PrintTolerance,l_CentreOffsetY,0])
				rotate([0,0,-45])
					cube([l_BracketSide,l_BracketSide,l_MountThickness]);
			translate([l_MountThickness,-l_MotorWidth/2+l_CentreOffsetY,-l_tolerance])
				cube([l_SocketCentre,l_MotorWidth,l_MountThickness+2*l_tolerance]);
			}
		translate([-l_SocketCentre,l_CentreOffsetY,-l_MountThickness])
				cylinder(h=2*l_MountThickness,r=l_SocketRadius);	
	}

// Gear for on the Motor
// There will be two of these at different heights to push the selection gear or drive gear.
module MotorGear(p_MountDef,p_GearStartHeight,p_ToothStyle,MotorGearNut)	
	{
	// Internal Constants
	//-------------------------------------------------------------------------
	l_tolerance 		= 0.1;  	// added to cover edges so it can be quick rendered.

	//-------------------------------------------------------------------------	
	// Break out mount definition (For ease of readability)	
	l_heads				= p_MountDef[0];
	l_HousingRadius 	= p_MountDef[1];
	l_HousingHeight	= p_MountDef[2];
	l_PrintTolerance 	= p_MountDef[3];
	l_MountArmWidth	= p_MountDef[4];
	l_MountThickness	= p_MountDef[5];
	l_CentreOffsetY	= p_MountDef[6]/2;
	l_SocketRadius		= p_MountDef[7]-l_PrintTolerance;
	l_SocketCentre		= p_MountDef[8];
	l_BoltInset			= p_MountDef[9];
	l_MotorWidth		= p_MountDef[10];	
	l_CoreRadius		= 2;
	l_ToothLength		= p_ToothStyle[2];

	// Gear Details
	l_GearOutRadius	= l_MotorWidth/2;
	l_GearInRadius		= 4;
	l_GearBody 			= DefineGearBody(SolidBody,l_GearOutRadius,l_GearInRadius,l_ToothLength,0);
	l_GearCore 			= DefineGearCore(CylinderCore,l_CoreRadius,0);
	l_GearTeeth			= MaxToothNum(l_GearBody,p_ToothStyle);

	// Nut details
	l_NutSize			= MotorGearNut[0];
	l_NutThickness		= MotorGearNut[1];
	l_BoltRadius		= MotorGearNut[2];
	// Draw
	//-------------------------------------------------------------------------
	// 
   difference()
		{
		union()
			{
			translate([0,0,p_GearStartHeight])
				Gear(l_GearBody,l_GearCore,p_ToothStyle,l_GearTeeth);
			cylinder(h=p_GearStartHeight,r=l_MotorWidth/2-l_MountArmWidth-2*l_PrintTolerance);
			}
		union()
			{
			// Subtract core
			translate([0,0,-l_tolerance])
				cylinder(h=p_GearStartHeight+l_ToothLength,r=l_CoreRadius);
			
			// Make holes for nut & bolt to secure to motor
			translate([l_CoreRadius/2+l_NutThickness/2,0,l_NutSize*2])
				rotate([0,90,0])
					NutTrapSide(l_NutSize+l_PrintTolerance,
									l_NutThickness+l_PrintTolerance,
									l_NutSize*2+l_tolerance);

			translate([0,0,l_NutSize*2-l_PrintTolerance])
				rotate([0,90,0])
					cylinder($fn=30,r=l_BoltRadius+l_PrintTolerance,
								h=l_MotorWidth/2-l_MountArmWidth-2*l_PrintTolerance);
			}
		}
	}