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

inner_diameter = 11.80;
middl_diameter = 11.82;
outer_diameter = 15.80;
washer_height =   0.90;
flange_height =   1.30;

flange_width = (middl_diameter - inner_diameter) / 2;
flange_x = max(nozzle_line_width, flange_width) + 0.10;
echo(flange_x);

flange_profile_in_mm = [

    [ inner_diameter / 2, 0 ],

    [ outer_diameter / 2, 0 ], // new X: washer bottom
    [ outer_diameter / 2, washer_height ], // new Y: washer edge

    [ inner_diameter / 2 + flange_x, washer_height ], // new X: washer top
    [ inner_diameter / 2 + flange_x, washer_height + flange_height ], // new Y: flange edge

    [ inner_diameter / 2, washer_height + flange_height ], // new X: flange top
    [ inner_diameter / 2, 0 ] // new Y: close profile
];

color("red")
rotate_extrude(convexity=convexity)
polygon(points=flange_profile_in_mm);
