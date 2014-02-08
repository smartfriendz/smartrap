// Horizontal spool holder

// Generic constants

$fn = 20;
Delta = 0.01;
Big = 100;

// Constants for the UltiMachine 5lb spool

SpoolHoleRadius = 30.5 / 2;
SpoolHolePlay = 0.5;
SpoolHoldDepth = 4;

// Design constants

SpoolHolderThickness = 2;

PlateRadius = 30;
PlateThickness = 2;
PlateRimThickness = 2;

SpokeLength = SpoolHoleRadius + 30;
SpokeWidth = 10;
SpokeBallWidth = SpokeWidth / 2 + 1;

BottomGap = SpokeBallWidth;

// Calculated constants

TotalSpoolHolderHeight = PlateThickness + BottomGap  + PlateThickness + SpoolHoldDepth;

// Spool holder column
union()
{
	difference()
	{
		union()
		{
			// Main column
			cylinder(r = SpoolHoleRadius - SpoolHolePlay, h = TotalSpoolHolderHeight);
			
			// Plate rim
			cylinder(r = SpoolHoleRadius + PlateRimThickness - SpoolHolePlay, h = PlateThickness + BottomGap);
			
			// Plate base
			cylinder(r = PlateRadius, h = PlateRimThickness);

			// Spokes
			for (a = [0, 120, 240])
			rotate([0, 0, a])
			Spoke();

		}
		union()
		{
			// Central hole
			translate([0, 0, -Delta])
			cylinder(r = SpoolHoleRadius - SpoolHolderThickness, h = Big);
		}
	}
}

module Spoke()
{
	difference()
	{
		union()
		{
			translate([0, -SpokeWidth / 2, 0])
			cube(size=[SpokeLength, SpokeWidth, PlateThickness]);

			translate([SpokeLength, 0, 0])
			sphere(r = SpokeBallWidth);
		}
		union()
		{
			translate([0, -Big / 2, -Big])
			cube(size=[Big, Big, Big - Delta]);

			translate([SpokeLength, 0, 0])
			sphere(r = SpokeBallWidth - PlateThickness);
		}
	}
}