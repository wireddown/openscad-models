//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

include <BOSL/constants.scad>
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

hole_factor = 1.1;
no_head = 0;
chamfer = 2.0;

// Functions

// Objects

module mounting_bracket(
    length,
    width,
    thickness,
    metric_size
)
{
    let (
        hole_size = metric_size * hole_factor,
        hole_margin = hole_size + 3,
        cyl_move = max(length/2, width/2)
    )
    difference()
    {
        union()
        {
            // Main body
            difference()
            {
                color("yellowgreen")
                ymove(-3+chamfer)
                union()
                {
                    cuboid(
                        size = [length, width-3, thickness],
                        chamfer = chamfer
                    );
                }

                color("honeydew")
                union()
                {
                    xmove(0.9 * cyl_move + 1)
                    ymove(0.9 * cyl_move + 1)
                    scale([1, 1.2, 1])
                    cyl(
                        h = thickness + 1,
                        d = 2 * cyl_move
                    );
                }
            }
        }

        // Cut mounting holes
        color("lavender")
        union()
        ymove(-3)
        {
            ymove(-width/4)
            xspread(
                spacing = length / 2,
                n = 2
            )
            screw(
                screwsize = hole_size,
                screwlen = thickness,
                headsize = get_metric_socket_cap_diam(metric_size + 1),
                headlen = get_metric_socket_cap_height(metric_size + 1)
            );

            xmove(-length/4)
            yspread(
                spacing = 20,
                n = 2
            )
            screw(
                screwsize = hole_size,
                screwlen = thickness,
                headsize = get_metric_socket_cap_diam(metric_size + 1),
                headlen = get_metric_socket_cap_height(metric_size + 1)
            );
        }
    }
}

module restraining_rod(
    length,
    width,
    thickness
)
{
    difference()
    {
        color("deepskyblue")
        union()
        {
            cuboid(
                size = [length, width, thickness],
                chamfer = chamfer,
                edges = EDGE_BOT_FR + EDGE_BOT_BK
            );
        }

        color("lightcyan")
        zmove(-thickness * 1/3)
        union()
        {
            tube(
                h = length + 1,
                od = 3   * thickness,
                id = 5/3 * thickness,
                orient = ORIENT_X,
                align = ALIGN_CENTER
            );
        }
    }
}

module joiner(
    width,
    gap,
    thickness,
    restraint_thickness
)
{
    difference()
    {
        color("yellow")
        union()
        {
            ymove(-3/2)
            cuboid(
                size = [thickness, width - 3, gap + 3 * restraint_thickness],
                chamfer = chamfer
            );
        }

        color("khaki")
        union()
        {
            scale([1, 2.3, 1.2])
            zmove(gap + 3 * restraint_thickness - (width - thickness)/2)
            ymove(restraint_thickness + thickness)
            cyl(
                l = thickness + 1,
                d = width - chamfer,
                orient = ORIENT_X,
                align = ALIGN_CENTER
            );
        }
    }
}

module drive_cable_restraint(
    gap,
    travel,
    width,
    thickness,
    bracket_length,
    bracket_width,
    bracket_thickness,
    bracket_metric_size
)
{
    difference()
    {
        union()
        {
            // Inner guide
            restraining_rod(travel, width, thickness);

            // Outer guide
            zmove(gap + thickness)
            zflip()
            restraining_rod(travel, width, thickness);

            // Right bracket
            zmove(-bracket_thickness)
            ymove((bracket_width - width) / 2)
            xmove((travel + bracket_length)/2)
            {
                mounting_bracket(
                    length = bracket_length,
                    width = bracket_width,
                    thickness = bracket_thickness,
                    metric_size = bracket_metric_size
                );

                zmove((gap + 2 * thickness) / 2)
                xmove(-bracket_length / 2)
                joiner(
                    width = bracket_width,
                    gap = restraint_gap,
                    thickness = restraint_thickness - 2,
                    restraint_thickness = restraint_thickness
                );
            }

            // Left bracket
            zmove(-bracket_thickness)
            ymove((bracket_width - width) / 2)
            xmove(-(travel + bracket_length)/2)
            {
                xflip()
                mounting_bracket(
                    length = bracket_length,
                    width = bracket_width,
                    thickness = bracket_thickness,
                    metric_size = bracket_metric_size
                );

                zmove((gap + 2 * thickness) / 2)
                xmove(bracket_length / 2)
                joiner(
                    width = bracket_width,
                    gap = restraint_gap,
                    thickness = restraint_thickness - 2,
                    restraint_thickness = restraint_thickness
                );
            }
        }

        // Entrance
        union()
        {
            xmove(-(travel)/2 + (restraint_thickness + chamfer))
            zmove(gap + 2.2*thickness)
            zmove(-thickness-2) cuboid([gap, 2*gap, 2*gap]);

            zmove(gap + 2*thickness + 3)
            ymove(2)
            xmove(-(travel)/2 + (restraint_thickness + chamfer))
            {
                zflip()
                xrot(30)
                narrowing_strut(
                    w = 2*gap,
                    l = 2*thickness + 1,
                    wall = thickness,
                    ang = 45
                );

            }
        }
    }
}

faceplate_metric_size = 4;

faceplate_width = 6 * 25.4;
faceplate_height = 2.6 * 25.4;
hole_margin = 0.4 * 25.4;

edge_hole_y = faceplate_height / 2;
top_hole_x = faceplate_width / 2;

left_hole_x = hole_margin;
right_hole_x = faceplate_width - hole_margin;
top_hole_y = faceplate_height - hole_margin;

projection(cut = true)
zmove(-5)
{
    difference()
    {
        cuboid(
            size = [faceplate_width, faceplate_height, 10],
            fillet = chamfer,
            edges = EDGES_BACK,
            center = false
        );

        zmove(11)
        {
            ymove(edge_hole_y)
            {
                xmove(left_hole_x)
                screw(
                    screwsize = faceplate_metric_size,
                    screwlen = 12,
                    headsize = no_head
                );

                xmove(right_hole_x)
                screw(
                    screwsize = faceplate_metric_size,
                    screwlen = 12,
                    headsize = no_head
                );
            }

            move([top_hole_x, top_hole_y, 0])
            {
                screw(
                    screwsize = faceplate_metric_size,
                    screwlen = 12,
                    headsize = no_head
                );
            }
        }
    }
}
