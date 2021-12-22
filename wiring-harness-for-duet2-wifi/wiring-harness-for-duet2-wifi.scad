//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

use <BOSL/masks.scad>
use <BOSL/math.scad>
use <BOSL/metric_screws.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

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

// Objects

module harness_riser(
    height,
    length,
    width,
    thickness,
    metric_size,
    center_distance,
    smoother_count,
    bracket_angle
)
{
    let (
        bolt_factor = 1.25,
        hole_size = metric_size * bolt_factor,
        hole_margin = hole_size+3
    )
    difference()
    {
        color("yellowgreen")
        union()
        {
            cuboid(
                size = [width, length, height],
                chamfer = 0.5
            );

            yspread(
                spacing = 25,
                n = smoother_count
            )
            up(height/2 + smoother_length/2 - abs(sin(bracket_angle)) - thickness - 0.5)
            ymove(10)
            xrot(bracket_angle)
            smoother_bracket(
                smoother_length,
                smoother_width,
                smoother_thickness,
                smoother_metric_size,
                smoother_center_distance
            );
        }

        color("honeydew")
        union()
        {
            // Cut the main hole
            cuboid(
                size = [width+1, length-2*thickness, height-2*thickness],
                chamfer = 0.5
            );

            // Cut the bottom side
            down((height-thickness)/2)
            cuboid(
                size = [width+1, center_distance-hole_margin, thickness+1]
            );

            // Cut the mounting holes
            down(height/2 - thickness)
            yspread(
                spacing = center_distance,
                n = 2
            )
            screw(
                screwsize = hole_size,
                screwlen = 2*thickness,
                headlen = 0
            );
        }
    }
}

module smoother_bracket(
    length,
    width,
    thickness,
    metric_size,
    center_distance
)
{
    let (
        bolt_factor = 1.25,
        hole_size = metric_size * bolt_factor
    )
    difference()
    {
        color("deepskyblue")
        union()
        {
            cuboid(
                size = [width, length, thickness],
                chamfer = 0.5
            );
        }

        color("lightcyan")
        union()
        {
            up(thickness)
            yspread(
                spacing = center_distance,
                n = 2,
                sp = [0, -length/2 + hole_size, 0]
            )
            screw(
                screwsize = hole_size,
                screwlen = 2*thickness,
                headlen = 0
            );
        }
    }
}


riser_center_distance = 115;
riser_metric_size = 4;
riser_length = riser_center_distance + 20;
riser_width = 8;
riser_thickness = 2;
riser_height = 18;

smoother_center_distance = 22;
smoother_metric_size = 3;
smoother_length = 33;
smoother_width = riser_width;
smoother_thickness = riser_thickness;

harness_riser(
    riser_height,
    riser_length,
    riser_width,
    riser_thickness,
    riser_metric_size,
    riser_center_distance,
    smoother_count = 4,
    bracket_angle=-60
);

*smoother_bracket(
    smoother_length,
    smoother_width,
    smoother_thickness,
    smoother_metric_size,
    smoother_center_distance
);
