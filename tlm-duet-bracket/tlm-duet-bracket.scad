//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

// Globals

convexity = 4;
number_of_fragments = 0.30 * 360;
eps = 0.001;

$fn = number_of_fragments;

// Parameters

m3_passthru = 3 + eps;

m4_inset_id = 4 - eps;
m4_inset_od = 4 + 2;

tevo_width  = 87;
tevo_length = 138;

duet_width  = 92;
duet_length = 115;

width_offset  = abs(tevo_width-duet_width) / 2;
length_offset = abs(tevo_length-duet_length) / 2;

// Functions

// Modules

module notch(height, diameter, length)
{
    color("orange")
    hull()
    {
        cylinder(h=height, d=diameter);
        translate([length, 0, 0])
            cylinder(h=height, d=diameter);
    }
}

module tube(outer_diameter, inner_diameter, length)
{
    difference()
    {
        color("red")
        union()
        {
            cylinder(d=outer_diameter, h=length);
        }

        color("blue")
        union()
        {
            scale([1, 1, 1.1])
            translate([0, 0, -eps])
            cylinder(d=inner_diameter, h=length);
        }
    }
}

module duct(outer_xsize, outer_ysize,
            inner_xsize, inner_ysize,
            length)
{
    difference()
    {
        color("red")
        union()
        {
            cube([outer_xsize, outer_ysize, length]);
        }

        color("blue")
        scale([1, 1, 1.1])
        translate([
            (outer_xsize-inner_xsize)/2,
            (outer_ysize-inner_ysize)/2,
            -eps
        ])
        union()
        {
            cube([inner_xsize, inner_ysize, length]);
        }
    }
}

// Objects

difference()
{
    union()
    {
        notch(height=2, diameter=m4_inset_od, length=tevo_length);

        translate([0, duet_width, 0])
            notch(height=2, diameter=m4_inset_od, length=tevo_length);
        
        rotate([0, 0, 90])
            notch(height=2, diameter=m4_inset_od, length=tevo_width);

        translate([tevo_length, 0, 0])
        rotate([0, 0, 90])
            notch(height=2, diameter=m4_inset_od, length=tevo_width);

        *duct(outer_xsize=duet_width, outer_ysize=tevo_length,
             inner_xsize=tevo_width, inner_ysize=duet_length,
             length=2);

        color("yellow")
        translate([0, width_offset, 0])
        {
            cylinder(d=3, h=30);

            translate([0, tevo_width, 0])
            cylinder(d=3, h=30);

            translate([tevo_length, tevo_width, 0])
            cylinder(d=3, h=30);

            translate([tevo_length, 0, 0])
            cylinder(d=3, h=30);
        }

        color("teal")
        translate([length_offset, 0, 0])
        {
            tube(outer_diameter=6, inner_diameter=4, length=30);

            translate([0, duet_width, 0])
            tube(outer_diameter=6, inner_diameter=4, length=30);

            translate([duet_length, duet_width, 0])
            tube(outer_diameter=6, inner_diameter=4, length=30);

            translate([duet_length, 0, 0])
            tube(outer_diameter=6, inner_diameter=4, length=30);
        }
    }
}
