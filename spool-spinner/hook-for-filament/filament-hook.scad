//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

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

// Objects

union()
{
    difference()
    {
        union()
        {
            color("orange")
            {
                translate([0, 0, -4.7])
                notch(10, 10, 36);

                translate([27, -5, 0])
                cube([14, 10, 30]);
            }

            *color("green")
            {
                translate([6.6, 0, 5.2])
                cube([20, 2, 2]);

                translate([26.6, 0, 5.2])
                cube([2, 2, 20]);
            }
        }

        #color("brown")
        {
            translate([0, 0, -1*eps])
            import("anchor-for-spool-spinner-filament-hook-v1.stl");

            translate([-33.1, 0, -5])
            cylinder(h=5, d=80);

            translate([35, 6, 21])
            rotate([90, -165, 0])
            {
                spiral2d(r=1, thickness=2, height=12, loops=1.72);
                spiral2d(r=11, thickness=4, height=12, loops=0.62, skip_first=false);
            }
        }

    }
}
