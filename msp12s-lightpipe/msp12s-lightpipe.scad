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

chamfer = 0.8;

// Functions

// Objects

rod_thickness = 3;
esp12s_width = 15;
esp12s_length = 17;

union()
{
    color("DeepSkyBlue")
    difference()
    {
        union()
        {
            cuboid(
                size = [2 * esp12s_width, 2 * esp12s_length, 2],
                chamfer = chamfer,
                edges = EDGES_BOTTOM
            );
        }

        union()
        {
            zmove(0.5 * rod_thickness)
            {
                cuboid(
                    size = 1.05 * [esp12s_width + 2*rod_thickness, esp12s_length + 2*rod_thickness, rod_thickness]
                );
            }
        }
    }

    zmove((rod_thickness - 2)/2)
    cuboid(
        size = [esp12s_width, esp12s_length, rod_thickness]
    );
}
