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

module harness_riser_with_pcb_brackets(
    height,
    length,
    width,
    thickness,
    metric_size,
    center_distance,
    bracket_length,
    bracket_width,
    bracket_thickness,
    bracket_metric_size,
    bracket_center_distance,
    bracket_count,
    bracket_angle
)
{
    let (
        bolt_factor = 1.1,
        hole_size = metric_size * bolt_factor,
        no_head = 0,
        hole_shoulder = 2.8 + thickness,
        hole_margin = hole_size + 3,
        hole_count = 2,
        chamfer = 0.5,
        bracket_spacing = 25,
        bracket_offset = 10
    )
    difference()
    {
        union()
        {
            // Main body
            color("yellowgreen")
            difference()
            {
                union()
                {
                    // Frame
                    cuboid(
                        size = [width, length, height],
                        chamfer = chamfer
                    );

                    // Brackets
                    yspread(
                        spacing = bracket_spacing,
                        n = bracket_count
                    )
                    up((height + bracket_length) / 2 - abs(sin(bracket_angle)) - thickness - chamfer)
                    ymove(bracket_offset)
                    xrot(bracket_angle)
                    smoother_bracket(
                        bracket_length,
                        bracket_width,
                        bracket_thickness,
                        bracket_metric_size,
                        bracket_center_distance
                    );
                }

                color("honeydew")
                union()
                {
                    // Cut the main hole
                    cuboid(
                        size = [
                            width + 1,
                            length - 2 * thickness,
                            height - 2 * thickness],
                        chamfer = chamfer
                    );

                    // Cut the bottom side
                    down((height-thickness)/2)
                    cuboid(
                        size = [
                            width + 1,
                            center_distance - hole_margin,
                            thickness + 1]
                    );
                }
            }

            // Add supporting struts
            color("aquamarine")
            {
                // Beneath
                up(height/2 - thickness)
                zflip()
                narrowing_strut(
                    w = width - 0 * chamfer,
                    l = length - 2 * thickness,
                    wall = 0,
                    ang = 60
                );

                // Above
                up(height/2)
                narrowing_strut(
                    w = width - 2 * chamfer,
                    l = length - 2 * chamfer,
                    wall = 0,
                    ang = 70
                );

                // Sides
                for (y_pos = [
                    -length/2 + thickness,
                    length/2 - thickness,
                ])
                {
                    ymove(y_pos)
                        xrot(sign(y_pos)*90)
                        narrowing_strut(
                            w = width,
                            l = height - 2 * thickness,
                            wall = 0,
                            ang = 60
                        );
                }
            }

            // Add hole sholders
            color("greenyellow")
            down(height/2 + thickness + chamfer - hole_shoulder)
            yspread(
                spacing = center_distance,
                n = hole_count
            )
            {
                cuboid(
                    size = [width, width, hole_shoulder],
                    chamfer = chamfer
                );
            }
        }

        color("lavender")
        union()
        {
            // Cut the mounting holes
            down(height/2 - hole_shoulder)
            yspread(
                spacing = center_distance,
                n = hole_count
            )
            screw(
                screwsize = hole_size,
                screwlen = thickness + hole_shoulder,
                headlen = no_head
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
        chamfer = 0.5,
        bolt_factor = 1.1,
        hole_size = metric_size * bolt_factor,
        hole_shoulder = 2.8 + thickness,
        hole_count = 2,
        no_head = 0,
        spacing = center_distance,
        starting_point = [0, -length/2 + hole_size, 0]
    )
    difference()
    {
        color("deepskyblue")
        union()
        {
            // Bracket
            cuboid(
                size = [width, length, thickness],
                chamfer = chamfer
            );

            // Hole shoulder
            up((hole_shoulder - thickness) / 2)
            yspread(
                spacing,
                n = hole_count,
                sp = starting_point
            )
            cuboid(
                size = [width, width, hole_shoulder],
                chamfer = chamfer
            );
        }

        color("lightcyan")
        union()
        {
            // Holes
            up(hole_shoulder)
            yspread(
                spacing,
                n = hole_count,
                sp = starting_point
            )
            screw(
                screwsize = hole_size,
                screwlen = thickness + hole_shoulder,
                headlen = no_head
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

pt100_center_distance = 20;
pt100_metric_size = 2.5;
pt100_length = 31;
pt100_width = riser_width;
pt100_thickness = riser_thickness;

harness_riser_with_pcb_brackets(
    riser_height,
    riser_length,
    riser_width,
    riser_thickness,
    riser_metric_size,
    riser_center_distance,
    smoother_length,
    smoother_width,
    smoother_thickness,
    smoother_metric_size,
    smoother_center_distance,
    bracket_count = 4,
    bracket_angle = -60
);

xmove(90)
harness_riser_with_pcb_brackets(
    riser_height,
    riser_length,
    riser_width,
    riser_thickness,
    riser_metric_size,
    riser_center_distance,
    pt100_length,
    pt100_width,
    pt100_thickness,
    pt100_metric_size,
    pt100_center_distance,
    bracket_count = 1,
    bracket_angle = -60
);


*smoother_bracket(
    smoother_length,
    smoother_width,
    smoother_thickness,
    smoother_metric_size,
    smoother_center_distance
);
