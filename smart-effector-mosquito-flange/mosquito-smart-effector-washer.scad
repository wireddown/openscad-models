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

convexity = 4;
number_of_fragments = 0.30 * 360;
eps = 0.001;

$fn = number_of_fragments;

nozzle_line_width = 0.4;

inner_diameter = 12.20;
outer_diameter = 16.20;
washer_height =   0.90;
flange_height =   2.20;

post_diameter = 4.00;


// Modules

module washer(outer_diameter, inner_diameter, washer_height)
{
    difference()
    {
        color("red")
        union()
        {
            cylinder(d=outer_diameter, h=washer_height);
        }

        color("blue")
        union()
        {
            scale([1, 1, 1.1])
            translate([0, 0, -eps])
            cylinder(d=inner_diameter, h=washer_height);
        }
    }
}


// Model

difference()
{
    union()
    {
        washer(outer_diameter, inner_diameter, washer_height);

        color("purple")
        {
            translate([0, inner_diameter/2, 0])
            cylinder(d=post_diameter, h=washer_height+flange_height);

            translate([0, -inner_diameter/2, 0])
            cylinder(d=post_diameter, h=washer_height+flange_height);
        }
    }

    translate([0, 0, washer_height])
    scale([1, 1, 1.1])
    washer(2*outer_diameter, inner_diameter-0.44, flange_height);
}
