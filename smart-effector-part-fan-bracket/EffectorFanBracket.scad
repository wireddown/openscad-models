use <MCAD/metric_fastners.scad>

MosquitoCorrection = 5.6;
OtherMosquitoCorrection = MosquitoCorrection;

// Print cooling fan holder

FanWidth = 40;
FanSideLength = 6;
FanHoleSpacing = 32;
EffectorSideLength = 5.5;
EffectorHoleSpacing = 12;
EffectorHolePadRadius = 5.5;
JoinWidth = 12;
FanSideThickness = 2;
EffectorSideThickness = 3;
M3Radius = 1.7;
Angle = 74;

FanHoleInset = (FanWidth-FanHoleSpacing)/2;

// Cube centred in X and Y but not Z
module cubeC(x,y,z) {
	translate([-x/2,-y/2,0]) cube([x,y,z]);
}

module FanMount() {
	difference() {
		linear_extrude(height=FanSideThickness) {
			hull() {
				translate([-FanWidth/2,FanSideLength - FanHoleInset,0])
					square([FanWidth,2 * FanHoleInset]);
				translate([-JoinWidth/2,-MosquitoCorrection,0])
					square([JoinWidth,0.1]);
			}
		}
		translate([FanHoleSpacing/2, FanSideLength, -1])
			cylinder(r=M3Radius, h=FanSideThickness+2, $fn=16);
		translate([-FanHoleSpacing/2, FanSideLength, -1])
			cylinder(r=M3Radius, h=FanSideThickness+2, $fn=16);
		translate([0, FanSideLength + FanWidth/2 - FanHoleInset, -1])
			cylinder(r=FanWidth/2 - 1, h=FanSideThickness+2, $fn=128);
	}
}

module EffectorMount() {
	difference() {
		linear_extrude(height = EffectorSideThickness) {
			hull() {
				translate([-EffectorHoleSpacing/2,EffectorSideLength])
					circle(r=EffectorHolePadRadius, $fn=32);
				translate([EffectorHoleSpacing/2,EffectorSideLength])
					circle(r=EffectorHolePadRadius, $fn=32);
				translate([-JoinWidth/2,0]) square([JoinWidth,EffectorSideLength]);
			}
		}
		translate([EffectorHoleSpacing/2, EffectorSideLength, -1])
			cylinder(r=M3Radius, h=EffectorSideThickness+2, $fn=16);
		translate([-EffectorHoleSpacing/2, EffectorSideLength, -1])
			cylinder(r=M3Radius, h=EffectorSideThickness+2, $fn=16);
		translate([0,EffectorSideLength + 8, -1])
			cylinder(r=5,h=EffectorSideThickness+2, $fn=6);
	}
}

module Thing() {
	difference() {
		union() {
			FanMount();
			translate([0,EffectorSideThickness-OtherMosquitoCorrection,-1]) rotate([Angle,0,0]) EffectorMount();
		}
		translate([-FanWidth/2-1,-OtherMosquitoCorrection-0.4,-1])
			rotate([Angle,0,0])
				cube([FanWidth+2,EffectorSideLength + 50,FanSideThickness+1]);
		translate([-25, -25, -3])
			cube([50, 50, 3]);

		for (x_pos=[-6, 6])
		{
			translate([x_pos, -1, 4.25])
			rotate([180+Angle,0,0])
			scale([1.4, 1.4, 1])
			cylinder(r=1.8*3/2, h=10, $fn=6);
		}
	}
}

Thing();
