//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

use <bearing.scad>
use <MCAD/regular_shapes.scad>
use <MCAD/metric_fastners.scad>

// Globals

convexity = 4;
number_of_fragments = 0.30 * 360;
eps = 0.001;

$fn = number_of_fragments;

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

module extrusion_bracket(
    metric_size,
    bearing_size,
    thickness,
    height = 60,
    bearing_offset = 0
)
{
    let (
        doublewide_width = 40,
        center_spacing = doublewide_width / 2,
        margin = (doublewide_width-center_spacing) / 2,
        bolt_hole_factor = 1.2,
        bearing_id = bearingInnerDiameter(bearing_size)
    )
    difference()
    {
        color("palegreen")
        union()
        {
            cube([thickness, doublewide_width, height]);
        }

        color("honeydew")
        union()
        {
            // With counter sink:
            translate([5, 0, 0])
            {
                // Cut mounting bolt holes
                for (bolt_y = [
                    margin,
                    doublewide_width-margin,
                ])
                {
                    translate([0, bolt_y, height-margin])
                    rotate([0, 90, 0])
                    scale([bolt_hole_factor, bolt_hole_factor, 1])
                    cap_bolt(dia=metric_size, len=thickness);
                }

                // Cut bearing bolt hole
                translate([thickness-margin, bearing_offset+doublewide_width/2, 1.5*margin])
                rotate([0, -90, 0])
                scale([bolt_hole_factor, bolt_hole_factor, 1])
                cap_bolt(dia=bearing_id, len=thickness);
            }
        }
    }
}

module motor_bracket(
    metric_size,
    bearing_size,
    thickness
)
{
    let (
        bracket_width = 50,
        radius = bracket_width/2,
        bearing_od = bearingOuterDiameter(bearing_size),
        center_spacing = 30,
        bolt_hole_factor = 1.2,
        countersink_correction = -0.25
    )
    difference()
    {
        color("deepskyblue")
        union()
        {
            oval_tube(thickness, rx=radius, ry=radius, wall=(bracket_width-bearing_od)/2);
        }

        color("lightcyan")
        {
            translate([0, 0, 5])
            for (y_pos = [
                    -bracket_width/5,
                    bracket_width/5,
                ],
                x_pos = [
                    -center_spacing/2,
                    center_spacing/2,
                ])
            {
                translate([x_pos, y_pos, -5+countersink_correction])
                {
                    scale([bolt_hole_factor, bolt_hole_factor, 2])
                    bolt(dia=metric_size, len=1+thickness/2);

                    scale([bolt_hole_factor, bolt_hole_factor, 1])
                    flat_nut(dia=metric_size);
                }
            }
        }
    }
}

metric_size=4;
bearing_size=624;

static_thickness=8;
gimble_thickness=13;

translate([-20, 30, static_thickness]) rotate([0, 90, 0])
extrusion_bracket(metric_size, bearing_size, thickness=8, height=60);

translate([0, 0, gimble_thickness]) rotate([180, 0, 0])
motor_bracket(metric_size, bearing_size, thickness=13);

*bolt(dia=4, len=20);