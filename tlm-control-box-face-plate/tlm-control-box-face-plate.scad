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

no_head = 0;
chamfer = 2.0;

// Functions

// Objects

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
