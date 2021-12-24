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
use <BOSL/paths.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

// Globals

convexity = 4;
number_of_fragments = 0.4 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

// Functions

// Modules

// Objects

m3_pass_diameter = 4;

base_width = 40;
base_length = 48;
base_thickness = 1.5;

sm_hole_id = 2;
sm_hole_offset = 2 + sm_hole_id/2;
sm_hole_spread = 33.5;

hole_id = 2.5;
hole_offset = base_length - 7.5;

usb_size = [17.4, 16, 17];
usb_offset = 37;

top_size = [28, 37, 15];
top_offset = 8;

cnxr_size = [7, 30, 11.5];
cnxr_offset = 1;

bottom_size = [42, 38, 2.5];
bottom_offset = 2;

module circuit_board_holes(diameter1, diameter2, height)
{
    color("yellow", 0.1)
    {
        xmove(sm_hole_offset)
        yspread(sm_hole_spread)
        cyl(d = diameter1, h = height);

        xmove(hole_offset)
        cyl(d = diameter2, h = height);
    }
}

//difference()
{
    union()
    {
        color("red")
        cuboid(
            size = [base_length, base_width, base_thickness],
            fillet = 1.2,
            edges = EDGES_Z_ALL,
            align = V_RIGHT + V_UP
        );

        color("black")
        {
            zmove(base_thickness)
            {
            xmove(usb_offset)
            yspread(20)
            cuboid(usb_size, align = V_RIGHT + V_UP);

            xmove(top_offset)
            cuboid(top_size, align = V_RIGHT + V_UP);

            xmove(cnxr_offset)
            cuboid(cnxr_size, align = V_RIGHT + V_UP);
            }

            xmove(bottom_offset)
            cuboid(bottom_size, align = V_RIGHT + V_DOWN);
        }
    }

    circuit_board_holes(diameter1 = sm_hole_id, diameter2 = hole_id, height = 25);
}

let(
    case_thickness = 4 * 0.6,
    case_height = 0 + usb_size[2]+base_thickness+bottom_size[2],
    case_length = base_length+10
)
zmove((usb_size[2]+base_thickness-bottom_size[2])/2)
xmove(base_length/2-4)
{
    xspread(case_length)
    cuboid(size=[case_thickness, base_width, case_height]);

    yspread(base_width)
    cuboid(size=[case_length, case_thickness, case_height]);
}
