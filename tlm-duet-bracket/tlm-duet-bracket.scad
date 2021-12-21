//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

include <MCAD/nuts_and_bolts.scad>;

// Globals

convexity = 4;
number_of_fragments = 0.30 * 360;
eps = 0.001;

$fn = number_of_fragments;

// Parameters

bracket_height  = 3;
bracket_width   = 13;

m3_pass_thru    = 3 + 0.75;

m4              = 4;
m4_nut_diameter = 7.5 + 0.6;
m4_inset_depth  = 6;
m4_inset_wall   = 2.7;
m4_inset_facade = 3;

tevo_width  = 87;
tevo_length = 138;

duet_width  = 92;
duet_length = 115;

width_offset = abs(tevo_width-duet_width) / 2;
duet_offset  = 10;

// Functions

// Modules

module notch(height, diameter, length)
{
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

module hex_hole(metric_size, height=-1)
{
    z_size = (height == -1)
        ? METRIC_NUT_THICKNESS[metric_size]
        : height;

    // These are too large for my set
    //let (diameter = METRIC_NUT_AC_WIDTHS[metric_size])
    let (diameter = m4_nut_diameter)
    {
        cylinder(d=diameter, h=z_size, $fn=6);
    }
}

module hexnut_inset(
    metric_size,
    height=-1,
    wall_thickness=2.0,
    facade_thickness=2)
{
    z_size = (height == -1)
        ? METRIC_NUT_THICKNESS[metric_size]
        : height;

    let (diameter = m4_nut_diameter,
         apothemD = METRIC_BOLT_CAP_DIAMETERS[metric_size]-1)
    {
        union()
        {
            translate([0, 0, z_size-facade_thickness])
            tube(outer_diameter=diameter + wall_thickness, inner_diameter=apothemD, length=facade_thickness);

            difference()
            {
                cylinder(d=diameter + wall_thickness, h=z_size);
                translate([0, 0, eps])
                hex_hole(metric_size, z_size);
            }
        }
    }
}

// Objects

difference()
{
    union()
    {
        // Frame
        color("darkblue")
        {
            notch(height=bracket_height, diameter=bracket_width, length=tevo_length);

            translate([0, duet_width, 0])
            notch(height=bracket_height, diameter=bracket_width, length=tevo_length);
            
            rotate([0, 0, 90])
            notch(height=bracket_height, diameter=bracket_width, length=duet_width);

            translate([tevo_length, 0, 0])
            rotate([0, 0, 90])
            notch(height=bracket_height, diameter=bracket_width, length=duet_width);
        }

        // M4 insets
        color("teal")
        translate([duet_offset, 0, bracket_height-eps])
        {
            hexnut_inset(metric_size=m4, height=m4_inset_depth, wall_thickness=m4_inset_wall, facade_thickness=m4_inset_facade);

            translate([0, duet_width, 0])
            hexnut_inset(metric_size=m4, height=m4_inset_depth, wall_thickness=m4_inset_wall, facade_thickness=m4_inset_facade);

            translate([duet_length, duet_width, 0])
            hexnut_inset(metric_size=m4, height=m4_inset_depth, wall_thickness=m4_inset_wall, facade_thickness=m4_inset_facade);

            translate([duet_length, 0, 0])
            hexnut_inset(metric_size=m4, height=m4_inset_depth, wall_thickness=m4_inset_wall, facade_thickness=m4_inset_facade);
        }
    }

    // Tevo through holes
    color("magenta")
    translate([0, width_offset, -15])
    {
        cylinder(d=m3_pass_thru, h=30);

        translate([0, tevo_width, 0])
        cylinder(d=m3_pass_thru, h=30);

        translate([tevo_length, tevo_width, 0])
        cylinder(d=m3_pass_thru, h=30);

        translate([tevo_length, 0, 0])
        cylinder(d=m3_pass_thru, h=30);
    }

    // M4 nut back cuts
    color("magenta")
    translate([duet_offset, 0, -eps])
    {
        hex_hole(metric_size=m4);

        translate([0, duet_width, 0])
        hex_hole(metric_size=m4);

        translate([duet_length, duet_width, 0])
        hex_hole(metric_size=m4);

        translate([duet_length, 0, 0])
        hex_hole(metric_size=m4);
    }
}
