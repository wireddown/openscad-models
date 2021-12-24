//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

use <MCAD/regular_shapes.scad>

// Globals

$fn = 8 * 12;
eps = 0.01;

base_diameter = 170;
base_radius   = base_diameter / 2;
base_height   = 10;

post_diameter = 60;
post_height = 40 - base_height;
post_zbase = -post_height;

hole_diameter = 32;
hole_height = base_height + post_height;
hole_zbase = -post_height;

recess_diameter = 70;
recess_height = 30;
recess_zbase = base_height - recess_height;

notch_diameter = 13;
notch_radius   = notch_diameter / 2;
notch_height   = 3.6;
notch_zbase    = base_height - notch_height;
notch_length   = 30;
notch_per_rotation = 8;
notch_rotation_angle = 360 / notch_per_rotation;
notch_offset_angle = notch_rotation_angle / 2;
notch_inset = base_radius - notch_radius;

// Functions

// Modules

module notch(h, d, l)
{
    hull()
    {
        cylinder(h=h, d=d);
        translate([l, 0, 0])
            cylinder(h=h, d=d);
    }
}

module spiral2d(r, thickness, height, loops, skip_first=true)
{
    if (skip_first)
    {
        //   BUGGY AF   //
        translate([-0.5*r, 0.5*r, 0])
            cylinder(h=height, r=3.6*r);
    }

    linear_extrude(height=height)
    polygon(
        points=concat(
            [for(t = [90:360*loops]) 
                [(r-thickness+t/90)*sin(t),(r-thickness+t/90)*cos(t)]],
            [for(t = [360*loops:-1:90]) 
                [(r+t/90)*sin(t),(r+t/90)*cos(t)]]
        )
    );
}

module half_torus(r, thickness)
{
    difference()
    {
        oval_torus(r, thickness);

        translate([0, -max(thickness)-r, -max(thickness)/2-0.5])
        cube([r+max(thickness)+1, 2*(r+max(thickness))+1, max(thickness)+1]);
    }
}

// Objects

union()
{
    difference()
    {
        // Create
        union()
        {
            color("orange")
            {
                // Arm
                translate([0, 0, -4.7])
                notch(10, 10, 36);

                // Riser
                translate([27, -5, 0])
                cube([14, 10, 30]);
            }

            // Reference measurements
            *color("green")
            {
                translate([6.6, 0, 5.2])
                cube([20, 2, 2]);

                translate([26.6, 0, 5.2])
                cube([2, 2, 20]);
            }
        }

        // Cut
        {
            color("red")
            translate([0, 0, 1.70])
            {
                // Anchor stand-in
                *translate([0.1, 0, 0])
                scale([0.99, 0.98, 1])
                import("hook-anchor.stl");

                // Bracket stand-in
                translate([-33.1, 0, 0])
                {
                    translate([0, 0, notch_height-0])
                        cylinder(h=10, d=80);
                    translate([0, 0, -10+0.4])
                        cylinder(h=10, d=80);
                }
            }

            color("brown")
            {
                // Bounds
                translate([6, 3.3, -50])
                    cube([100,4,100]);
                translate([6, -7.3, -50])
                    cube([100,4,100]);

                // Arm cutaways
                translate([18, -1.6, -6])
                rotate([90, 0, 2])
                    notch(h=3, d=16, l=40);
                translate([18, 4.6, -6])
                rotate([90, 0, -2])
                    notch(h=3, d=16, l=40);
                translate([23, 3, -10])
                rotate([90, 0, 0])
                    notch(h=6, d=16, l=20);

                // Riser cutaways
                translate([40, 1, 3])
                rotate([0, 91, 88])
                    notch(h=3, d=20, l=40);
                translate([40, -4, 3])
                rotate([0, 89, 92])
                    notch(h=3, d=20, l=40);
                translate([46, -4, 2])
                rotate([0, 90, 90])
                    notch(h=8, d=24, l=40);
            }

            translate([35, 0, 0])
            {
                // Hook
                color("blue")
                translate([-2, -6, 21])
                rotate([90, -165, 180])
                {
                    spiral2d(r=1, thickness=2, height=12, loops=1.72);
                    spiral2d(r=11, thickness=4, height=12, loops=0.62, skip_first=false);
                }

                // Saddles
                color("purple")
                translate([0, 0, 10])
                rotate([0, 90, 0])
                {
                    translate([-2.1, 0, -1.0])
                    scale([1, 1, 1.5])
                    half_torus(r=3.25, thickness=[5, 5]);

                    translate([-16, 0, -3.6])
                    rotate([0, -195, 0])
                    half_torus(r=3.5, thickness=[4, 6]);
                }
            }
        }
    }
}
