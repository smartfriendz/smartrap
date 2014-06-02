// Multistruder Builder Program
// *********************************************************************************
// Version history:
// Author:			Date: 			Description:
// Whitecoat		2014-04-25		Initial build
// 
// *********************************************************************************
// Purpose:
// This program renders an [N]-Headed extruder that uses two motors to select 
// and operate the various print heads.
// follow the instuctions below to optimise for your conditions
// 
// *********************************************************************************
// presentation mode constants
AssembledView 	= 0;
PrintView		= 1;
PrintPlate1		= 2;
PrintPlate2		= 3;
PrintPlate3		= 4;
PrintPlate4		= 5;
PrintPlate5		= 6;
PrintPlate6		= 7;
PrintPlate7		= 8;

// Instructions 
// *********************************************************************************
// The simple version... lets call it 'level 1'
// 
//
// 1) The primary limitation to N is the size of the print bed, which limits the 
//  	size of the housing and drive gears.
// 
//		Yo dawg... we heard you like extruders, tell us about your print bed so we can put
//		extruders _IN_ your extruders:
	PrintBedXDim = 150;
	PrintBedYDim = 140;

// 2) The program will compute the largest number of print heads that will fit
// 	using the bed dimensions above.  If you want to override with a specific  
//		number of print heads spcify the number of heads here:

	NumberOfHeads = 0;

//		Notes:
//		- A value of 0 means use the bed dimensions
//		- By changing this the resulting design may not fit on your print bed.

//	3)	Specify the Print Tolerance of your printer in millimeters
	PrintTolerance = 0.25;

// 4)	Specify if you want to render an assembled model, or parts layed out for printing
	ViewType = AssembledView;  //[AssembledView|PrintView|PrintPlate1|PrintPlate2
									 // PrintPlate3|PrintPlate4|PrintPlate5|PrintPlate6|PrintPlate7]

// 5) Compile
// 	Note: This can take a fair while to Render because of the complexity of gears.  


// Instructions - level 2
// *********************************************************************************
//
//	Once all the first level instructions are complete, it is possible to further
// define the non-printed components of the multistruder, those defintions can be 
// adjusted here.
//
// First we'll get the function definitions used in the rest of these instructions
// (!! Caution - contains moderate levels of Nerd-jutsu !!)
include <include-Multistruder.scad>

// 
// 1)	Define the key attributes of an extruder bay.  The extruder bay is the space in which a 
// 	single extruder must fit.  It is defined as follows:
//
// DefineBaySize(CentreOffset,bearingModelNumber,BoltRadius,MinimumWallThickness,PrintTolerance)
//
// Variables:
//		- CentreOffset - 	Extruders must be centred so they are tangent to the housing for the gears to
//								operate.  But there is more volume required one side of centre than 
//								the other. The offset moves the centre of a print bay to make the 
//								print modules smaller. 
//								It is already fairly well tuned, you probably won't need to touch this.
//		- bearingModelNumber - Specify what type of bearings you'll be using, just input the model
//								number, like 608 or 624, etc. A lot of the dimensions of the bay are based
//								on the bearing size as each bay has to fit three bearings.
// 	- BoltRadius - 	As with most extruders this makes use of a tensioner arm to keep the 
//								filament pushing against the hobed bolt.  A Nut and bolt are required 
//								at the pivot point of the tensioner arm, specify the radius of that bolt.
//		- MinimumWallThickness - Beyond the bearing dimensions the minimum wall thickness is the other
//								Determining factor in the print bay size.  The smaller this figure the 
//								weaker the overall structure, the bigger the more solid it is, but more space
//								will be required for each bay.
// 	- PrintTolerance - This is just the print tolerance from level 1 instructions.

// We need some details about the bolts in the extruder for that... 
// 	Hobbed bolt is defined as follows:
//
// DefineHobbedBolt(	HeadSize, HeadDepth, BodyRadius, BodyDepth, HobbDistHead, HobbLength,
//							HobbRadius,PrintTolerance,HeadType)
//
	hobbedBoltDef 	= DefineHobbedBolt(8,10,4,60,21,10,3,PrintTolerance,HEXHEAD);

// DefineBolt(HeadSize,HeadDepth,BodyRadius,BodyDepth,PrintTolerance,[HEXHEAD,ROUNDHEAD])
	TensBoltDef		= DefineBolt(4,5,2,10,PrintTolerance,HEXHEAD);

// We also need some details about the Bowden Fitting... 
// 	Bowden Fitting is defined as follows:
// 
// DefineBowden(height,ThreadRadius,ThreadHeight,PrintTolerance,MaxRadius)
//
// Variables:
//		- MaxRadius - 	Defines how much room should be left to allow a bowden through the housing

	BowdenDef		= DefineBowden(22,4.75,8,PrintTolerance,7);

// Now we can do the Bay Definition
	BayDef 		= DefineBaySize(5,608,hobbedBoltDef,TensBoltDef,3,BowdenDef[4],PrintTolerance);


// 2)	Define the key attributes of the extruder housing.  It is defined as follows:
//
// DefineHousingSize(BayDefinition,NumHeads,PrintTolerance)
//
// Variables:
//		- BayDefinition -	You just defined it... see step 1.
//		- NumHeads		 - Number of Print Heads you want in the extruder. This was defined in 
//								level 1 using either the bed dimensions or direct entry.
//								There is a helper functon MaxHeads(PrintBedXDim,PrintBedYDim,BayDefinition)
//								which will work out how big an extruder will fit on the bed.
//		- PrintTolerance - This is just the print tolerance from level 1 instructions.

	// work out number of heads from level 1
	l_heads = (NumberOfHeads>0)?NumberOfHeads:MaxHeads(PrintBedXDim,PrintBedYDim,BayDef);

	HousingDef 	= DefineHousingSize(BayDef,l_heads,PrintTolerance);

// Bolts are used to mount the housing on a surface.  The bolt definition must also be provided.
// a style of bolt is defined as follows:
//
// DefineBolt(HeadSize,HeadDepth,BodyRadius,BodyDepth,PrintTolerance,[HEXHEAD,ROUNDHEAD])
//
// Variables:
//		- HeadSize 		- 	For a bolt with a round head this is radius, for a bolt with a hex head 
//								this is length of one side.
//		- HeadDepth 	- 	How deep should the lock space be for head of this bolt
//		- BodyRadius 	-	The radius of the body of the bolt
//		- BodyDepth		- 	Length of the body of the bolt
//		- PrintTolerance - This is just the print tolerance from level 1 instructions
//		- HeadType 		- A value of either HEXHEAD or ROUNDHEAD. 

	HousingBoltStyle	= DefineBolt(8,5,4,10,PrintTolerance,HEXHEAD);


// 3)	Define the Shifter.  Whats that? Well its the mechanism that gets moved in and out to
// 	engage an individual extruders.  It's also the piece that will get the most wear & tear.
//  	(Which is why it has its own minimum thickness settings, and may require a stronger 
//     material.  But... we'll see how we go.)
// 	It is defined as follows:
//
// DefineShifter(HousingDefinition,MinimumWallThickness,BoltDef,HookLength,PrintTolerance)
//
// Variables:
//		- HousingDefinition - You just defined it... see step 2.
//		- MinimumWallThickness - This states how thick the thinnest walls should be.  
//								The smaller this figure the weaker the overall structure.
//								The bigger the more solid it is, but more space it will
//								take up.
//		- BoltDef	 - 	Defines the bolt that will make the axel of the Shifter gear.
//		- HookLength - 	Just says how long the hook will be on the fhifter
//								It should be just longer than the width of the SelectionGear
//								(defined later) which is what the hook is meant to catch.
//		- PrintTolerance - Print tolerance again from level 1 instructions.

// first the bolts used in the shifter
	ShiftBoltDef	= DefineBolt(4,5,2,10,PrintTolerance,HEXHEAD);
	ShiftAxelRadius= (BearingPartNoToDim(608)[0])/2;  //we'll use a bearing in the gear

// now the shifter
	ShifterDef		= DefineShifter(HousingDef,BayDef,3,ShiftBoltDef,7,PrintTolerance);


// 4)	Define the Motor Mounts, there will be two of these, but a single definition should
//		cover both.  
// 	They are defined as follows:
//
// DefineMotorMount(housingDefinition,BayDefinition,HousingBoltDefinition,MotorInset,MotorWidth);
//
// Variables:
//		- HousingDefinition - You just defined it... see step 2.
// 	- BayDefinition -	You just defined it... see step 1.
// 	- HousingBoltDefinition -	You just defined it... see step 3.  This is needed as it 
//							defines a locking recess to attach the mount to the housing.
//		- MotorInset - How far in from the edge of the motor do the bolt holes sit?
//		- MotorWidth - Width of the motor. Note, this currently assumes square motors
//							because all the steppers I've seen up till now on printers are square.

	MotorMountDef	= DefineMotorMount(HousingDef,BayDef,HousingBoltStyle,5,42);

// We'll also need a nut in the motor gears, we'll define that while we are talking motors.
// Defined as follows:
// DefineNut(EdgeLength,Thickness,InnerRadius)
	MotorGearNut = DefineNut(5,2.8,1.75);

// The motor mounts need bolt holes to attach the mount to the motor. 
// A bolt definition is  required to describe these bolts.
// DefineBolt(HeadSize,HeadDepth,BodyRadius,BodyDepth,PrintTolerance,[HEXHEAD,ROUNDHEAD])
//
// Variables:
//		- HeadSize 		- 	For a bolt with a round head this is radius, for a bolt with a hex head 
//								this is length of one side.
//		- HeadDepth 	- 	How deep should the lock space be for head of this bolt
//		- BodyRadius 	-	The radius of the body of the bolt
//		- BodyDepth		- 	Length of the body of the bolt
//		- PrintTolerance - This is just the print tolerance from level 1 instructions
//		- HeadType 		- A value of either HEXHEAD or ROUNDHEAD. 

	MotorBoltDef = DefineBolt(3,3,1.5,6,PrintTolerance,ROUNDHEAD);

// 5)	Define the Housing Lid.  This is computed based on other components
//		you shouldn't need to adjust this, but just in case. 
// 	Defined as follows:
//
// DefineLid(HousingDefinition,BayDefinition,ShifterDefinition,PrintTolerance)
//
// Variables:
//		- HousingDefinition - You just defined it... see step 2.
// 	- BayDefinition -	You just defined it... see step 1.
//		- ShifterDefinition - You just defined it... see step 3.
//		- PrintTolerance - This is just the print tolerance from level 1 instructions.

	LidDef			= DefineLid(HousingDef,BayDef,ShifterDef,PrintTolerance);

// For presentation adjustments you can jump to the end, but if you want to mess with gears...

// Instructions - level 3
// *********************************************************************************
// Really just continuing on with more definitions, but its gets more complicated
// defining the gears, unless you are radically changing the above sections 
// you shouldn't need to mess with these.

// 6)	We are using a few gears in this build.  Defining a shared style of teeth for those gears. 
// 	Defined as follows:
//
// DefineTooth([SawTooth|HerringBone|Involute|InvoluteHerring],Height,Length,Pitch,Gap);
//
// Variables:
//		- ToothType 	- a type of tooth, one of the following values:
//							  [SawTooth|HerringBone|Involute|InvoluteHerring]
//		- Height			- Height from the base that tooth extends
//		- Length			- Length of tooth perpendicular to base gear (I.e. influenced by pitch)
//		- Pitch 			- Angle of tooth 0 = perpendicular to base of gear, positive value is tapered
//						     in at specified angle.
//		- Gap				- Tooth gap, Ya know for whistling through, or... it might have been used to 
//							  allow extra space for wider teeth like herringbones.
 
   // first some calculations
	ToothHeight				= 2;
	GearHeight				= 10;
	// The bay gear teeth height depends largely on the radius of the shifter gear.
	BayGearToothHeight 	= sqrt(pow(OutRadiusShiftGear(BayDef,LidDef,ToothHeight),2)/2)+GearHeight;
	
	// drive gear sits on bearings at core, must be tall enough to have rims to lock bearings in place.
	DriveGearHeight	= 12;	

	SelectGearHeight 	= 5;

	// ok... Tooth definitions
	GearToothStyle 		= DefineTooth(Involute,ToothHeight,GearHeight,0,2);
	BayGearToothStyle		= DefineTooth(Involute,ToothHeight,BayGearToothHeight,0,8);  //same same, but taller
	ShiftGearToothStyle	= DefineTooth(Involute,ToothHeight,7,45,0);  // same, but with 45 degree pitch
	SelectGearToothStyle = DefineTooth(Involute,ToothHeight,SelectGearHeight,0,8);	// short teeth
	DriveGearToothStyle	= DefineTooth(Involute,ToothHeight,DriveGearHeight,0,8);

// 7)	Gears, Gears, Gears. 
// 	Defined as follows:
//
// DefineGearBody([SolidBody|HalfThickBody|HollowBody],OuterRadius,InnerRadius,Height,Spokes);
//
// Variables:
//		- BodyType		- Defines what will make up the body of the gear, of the following types:
//							  [SolidBody|HalfThickBody|HollowBody]
//		- OuterRadius	- Outer Radius of gear body (excluding teeth)
//		- InnerRadius	- Point at which body gives way to core definition(Controls spoke depth)
//		- Height			- Height of the gear, independant of teeth.
//		- Spokes			- To concserve material, the core can be connected to the gear wheel 
//							  with a number of spokes.  Specify the number of spokes, 0 is solid.

	// Lets set a base gear height for simplicity
	// (as with the Teeth, the bay gear will be an exception as it has to reach out far enough
	// from the hobbed bolt to mesh with the shifter gear)
	GearHeight 			= 10; //mm
	
	// Drive gear
	// derive gear dimensions from lid
	DriveOutRadius		= OutRadiusDriveGear(ShifterDef,ToothHeight);
	DriveInRadius		= InRadiusDriveGear(ShifterDef);

	DriveGearBody 		= DefineGearBody(SolidBody,DriveOutRadius,DriveInRadius,DriveGearHeight,0);
	DriveGearTeeth 	= MaxToothNum(DriveGearBody,SelectGearToothStyle);
	DriveGearCore		= DefineGearCore(B608,DriveInRadius,2);

	// Selection Gear
	SelectOutRadius	= OutRadiusSelectGear(ShifterDef);
	SelectInRadius		= InRadiusSelectGear(ShifterDef);
	SelectionGearBody = DefineGearBody(SolidBody,SelectOutRadius,SelectInRadius,SelectGearHeight,0);
	SelectionGearTeeth= MaxToothNum(SelectionGearBody,DriveGearToothStyle);

	// Shifter Gear
	ShiftGearRadius 	= OutRadiusShiftGear(BayDef,LidDef,ToothHeight);
	ShifterGearBody 	= DefineGearBody(SolidBody,ShiftGearRadius,10,GearHeight,0);
	ShifterGearTeeth 	= MaxToothNum(ShifterGearBody,ShiftGearToothStyle,8);
	ShifterGearCore 	= DefineGearCore(B608,BearingPartNoToDim(608)[1]/2+PrintTolerance,0);

	//Bay Gear
	BayGearRadius		= OutRadiusBayGear(BayDef,ToothHeight);
	BayGearBody 		= DefineGearBody(HalfThickBody,BayGearRadius,hobbedBoltDef[0]+2,BayGearToothHeight,3);
	BayGearTeeth		= MaxToothNum(BayGearBody,BayGearToothStyle);
	BayGearCore 		= DefineGearCore(NutCore,hobbedBoltDef[0],3);

	// Selector Motor gear
	//						  Mot Mount thickness + Lid thickness	+ hook height
	SelMotGearHeight	= MotorMountDef[5] 	 + 2*LidDef[7]		+ ShifterDef[7];
	DrvMotGearHeight	= SelMotGearHeight + BearingPartNoToDim(608)[2] + +ShifterDef[4] + 2*PrintTolerance;


// Presentation of defined extruder
// *********************************************************************************
include <include-ExtruderCodePresentation.scad>

// AssembledView or PrintView
	if (ViewType == AssembledView) 		
		AssembledExtruder();
   if (ViewType == PrintView) 		
		PrintableExtruder();
	if (ViewType == PrintPlate1) 		
		PrintableExtruder(1);
	if (ViewType == PrintPlate2) 		
		PrintableExtruder(2);
	if (ViewType == PrintPlate3) 		
		PrintableExtruder(3);
	if (ViewType == PrintPlate4) 		
		PrintableExtruder(4);
	if (ViewType == PrintPlate5) 		
		PrintableExtruder(5);
	if (ViewType == PrintPlate6) 		
		PrintableExtruder(6);
	if (ViewType == PrintPlate7) 		
		PrintableExtruder(7);
	
module AssembledExtruder()
	{
	// computes for positioning:
	l_LidHeight 		= BayDef[0]+BayDef[6]+PrintTolerance;
	l_ShifterHeight 	= l_LidHeight+LidDef[7];
	l_ShifterRadius	= LidDef[5]+LidDef[9]+LidDef[7]+ShifterDef[10];
	l_SelectorHeight 	= l_LidHeight+LidDef[7]*2+PrintTolerance;
	l_SelectBeringRad	= SelectInRadius-BearingPartNoToDim(608)[1/2]-LidDef[7];
	l_driveGearHeight	= l_SelectorHeight+ShifterDef[7]+BearingPartNoToDim(608)[2]
								+ShifterDef[4]+DriveGearHeight+2*PrintTolerance;
	l_shiftGearHeight = l_ShifterHeight+ShifterDef[2]+ShifterDef[4];
	l_ShiftGearRadius = l_ShifterRadius+ShifterDef[4];

	l_ExtrusionRadius  = HousingDef[1]+3*BayDef[6]+2*BearingPartNoToDim(BayDef[5])[2];
	l_HobbedRadius		= l_ExtrusionRadius+hobbedBoltDef[6]+hobbedBoltDef[1];
	l_hobbedHeight		= BayDef[0]/2+BayDef[8];  // half a bay + z-offset
	l_BayGearRadius	= l_HobbedRadius - hobbedBoltDef[1]-BayGearCore[2];

	// position everything
	HousingPos 	= DefinePosition([0,0,0],[0,0,0]);
	MotorPos		= DefinePosition([HousingDef[2],0,BayDef[0]-LidDef[7]],[0,0,0]);
	MotorGearPos= DefinePosition([HousingDef[2]+MotorMountDef[10]/2,2.5,BayDef[0]-LidDef[7]],[0,0,0]);
	LidPos		= DefinePosition([0,0,l_LidHeight],[0,0,0]);
	ShifterPos	= DefinePosition([l_ShifterRadius,0,l_ShifterHeight],[0,0,90]);
	ShiftGearPos= DefinePosition([l_ShiftGearRadius,0,l_shiftGearHeight],[225,0,90]);
	SlctGearPos	= DefinePosition([0,0,l_SelectorHeight],[0,0,(180/l_heads)]);
	SlctBearPos	= DefinePosition([l_SelectBeringRad,0,l_SelectorHeight+ShifterDef[7]],[0,0,0]);
	LidBracePos = DefinePosition([0,0,l_SelectorHeight+ShifterDef[7]
												+BearingPartNoToDim(BayDef[5])[2]+2*PrintTolerance],[0,0,0]);
	DriveBearPos= DefinePosition([l_SelectBeringRad,0,l_SelectorHeight+3.7*ShifterDef[7]],[0,0,0]);
	DriveGearPos= DefinePosition([0,0,l_driveGearHeight],[180,0,0]);
	LidBrace2Pos= DefinePosition([0,0,l_driveGearHeight+ShifterDef[7]],[180,0,0]);
	HobbBoltPos	= DefinePosition([l_HobbedRadius,0,l_hobbedHeight],[0,270,0]);
	BayGearPos 	= DefinePosition([l_BayGearRadius,0,l_hobbedHeight],[0,90,0]);
	ExtruderPos	= DefinePosition([HousingDef[1]+BayDef[6],BayDef[7]-BayDef[2]/2+BayDef[9],BayDef[6]],[0,0,0]);

	// ok, lets go draw something
	Position(HousingPos) 	
		MultiStruderHousing(HousingDef,BayDef,HousingBoltStyle);

	StarBurstPosition(ExtruderPos,l_heads)
		ExtusionUnit(BayDef,BowdenDef);

	StarBurstPosition(MotorPos,l_heads,180/l_heads,l_heads-1)
		MotorMount(MotorMountDef,MotorBoltDef);

	StarBurstPosition(MotorPos,l_heads,-1*(180/l_heads),l_heads-1)
		MotorMount(MotorMountDef,MotorBoltDef);

	Position(LidPos) 			
		MultiStruderLid(LidDef);

	StarBurstPosition(ShifterPos,l_heads) 
		GearShift(ShifterDef);

	StarBurstPosition(HobbBoltPos,l_heads) 
		color("LightGray") 
			HobbedBolt(hobbedBoltDef);

	StarBurstPosition(BayGearPos,l_heads)
		Gear(BayGearBody,BayGearCore,BayGearToothStyle,BayGearTeeth);

	StarBurstPosition(ShiftGearPos,l_heads)
		Gear(ShifterGearBody,ShifterGearCore,ShiftGearToothStyle,ShifterGearTeeth);

	Position(SlctGearPos)
		SelectionGear(SelectionGearBody,SelectGearToothStyle,SelectionGearTeeth,ShifterDef,l_heads);

	// Selection Gear Bearings
	StarBurstPosition(SlctBearPos,l_heads,180/l_heads)
		color("LightGray")	
			fake_bearing(BearingPartNoToDim(608));

	Position(LidBracePos)
		LidBrace(LidDef);

	Position(LidBrace2Pos)
		LidBrace(LidDef);

	// Drive Gear Bearings
	StarBurstPosition(DriveBearPos,l_heads,180/l_heads)
		color("silver")	
			fake_bearing(BearingPartNoToDim(608));

	Position(DriveGearPos)
		Gear(DriveGearBody,DriveGearCore,DriveGearToothStyle,DriveGearTeeth);

	StarBurstPosition(MotorGearPos,l_heads,180/l_heads,l_heads-1)
		MotorGear(MotorMountDef,SelMotGearHeight,SelectGearToothStyle,MotorGearNut);

	StarBurstPosition(MotorGearPos,l_heads,-1*(180/l_heads),l_heads-1)
		MotorGear(MotorMountDef,DrvMotGearHeight,DriveGearToothStyle,MotorGearNut);	
	}

module PrintableExtruder(Plate=0)
	{
	// position everything
	HousingPos    = DefinePosition([0,0,0],[0,0,0]);
	LidPos		  = DefinePosition([2.1*HousingDef[2],0,0],[0,0,0]);
	Motor1Pos	  = DefinePosition([0,1.5*HousingDef[2],MotorMountDef[9]],[180,0,0]);
	Motor2Pos	  = DefinePosition([0,1.5*HousingDef[2]+1.5*MotorMountDef[10],MotorMountDef[9]],[180,0,0]);
	SelectGearPos = DefinePosition([2.1*HousingDef[2],2.1*HousingDef[2],0],[0,0,0]);
	DriveGearPos  = DefinePosition([2.1*HousingDef[2],4.2*HousingDef[2],0],[0,0,0]);
 	Brace2Pos	  = DefinePosition([0,4.2*HousingDef[2],0],[0,0,0]);
	MotGear1		  = DefinePosition([0,4.2*HousingDef[2],SelMotGearHeight+SelectGearHeight],[180,0,0]);
	MotGear2		  = DefinePosition([2.1*HousingDef[2],4.2*HousingDef[2],DrvMotGearHeight+GearHeight],[180,0,0]);

	// Plate 7
	Shifter1Pos	  = DefinePosition([4.7*HousingDef[2],0,ShifterDef[1]/2],[0,90,270]);
	BayGearPos	  = DefinePosition([4.3*HousingDef[2]-1.2*MotorMountDef[10],0,0],[0,0,0]);
	ShifGearPos   = DefinePosition([4.3*HousingDef[2]-1.2*MotorMountDef[10],1.5*MotorMountDef[10],0],[0,0,0]);
	ExtruderPos	  = DefinePosition([4.5*HousingDef[2],0,0],[0,270,0]);
	TensionerPos  = DefinePosition([4.5*HousingDef[2],-BayDef[2]/2,0],[0,270,0]);

	// ok, lets go draw something
	if (Plate==0 || Plate==1)
		{
		Position(HousingPos) 	MultiStruderHousing(HousingDef,BayDef,HousingBoltStyle);
		}
	if (Plate==0 || Plate==2)
		{
		Position(LidPos) 			MultiStruderLid(LidDef);
		}
	if (Plate==0 || Plate==3)
		{
		Position(Motor1Pos) 		MotorMount(MotorMountDef,MotorBoltDef);
	 	Position(Motor2Pos)		MotorMount(MotorMountDef,MotorBoltDef);
		}
	if (Plate==0 || Plate==4)
		{
		Position(SelectGearPos)	
				SelectionGear(SelectionGearBody,SelectGearToothStyle,SelectionGearTeeth,ShifterDef,l_heads);
		Position(SelectGearPos)	LidBrace(LidDef);
		}
	if (Plate==0 || Plate==5)
		{
		Position(Brace2Pos) 		LidBrace(LidDef);
		Position(MotGear1)		MotorGear(MotorMountDef,SelMotGearHeight,SelectGearToothStyle,MotorGearNut);
		}
	if (Plate==0 || Plate==6)
		{
		Position(DriveGearPos)  Gear(DriveGearBody,DriveGearCore,DriveGearToothStyle,DriveGearTeeth);
		Position(MotGear2)		MotorGear(MotorMountDef,DrvMotGearHeight,DriveGearToothStyle,MotorGearNut);	
		}
	if (Plate==0 || Plate==7)
		{
		Position(ExtruderPos)	ExtusionUnit(BayDef,BowdenDef);
		Position(TensionerPos)	TensionerArm(BayDef);
		Position(Shifter1Pos)	GearShift(ShifterDef);
		Position(BayGearPos)		Gear(BayGearBody,BayGearCore,BayGearToothStyle,BayGearTeeth);
		Position(ShifGearPos)	Gear(ShifterGearBody,ShifterGearCore,ShiftGearToothStyle,ShifterGearTeeth);
		}
	}