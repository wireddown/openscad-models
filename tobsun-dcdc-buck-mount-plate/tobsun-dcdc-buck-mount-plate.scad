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
number_of_fragments = 0.20 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

// Functions

// Modules

module hexnut_helper(height, length, diameter)
let(
    nut_path = path2d_regular_ngon(n=6, d=diameter)
)
{
    hull()
    {
        linear_extrude(height) polygon(nut_path);
        xmove(length) linear_extrude(height) polygon(nut_path);
    }
}

// Objects

m3_pass_diameter = 4;

base_width = 53;
base_length = 64;
base_tickness = 1.2;

post_height = 5;
post_radius = 3.5;

fin_offset = 19;
fin_spread = 57;

corner_offset = 45;
corner_spread = 42;

difference()
{
    color("skyblue")
    union()
    {
        hull()
        xmove(base_width/2)
        place_copies(0.5 * [
            [base_width-2*1.2, base_length-2*1.2-15, 0], [base_width-2*1.2, -(base_length-2*1.2-15), 0],
            [-(base_width-2*1.2), base_length-2*1.2, 0], [-(base_width-2*1.2), -(base_length-2*1.2), 0],
            [base_width-2*1.2-55, base_length-2*1.2, 0], [base_width-2*1.2-55, -(base_length-2*1.2), 0]
        ])
        cyl(r=1.2, h=base_tickness, align=V_UP);

        xmove(fin_offset)
        yspread(fin_spread - 2)
        cyl(r = post_radius + 1, h = post_height + base_tickness, align = V_UP);

        xmove(corner_offset)
        yspread(corner_spread - 2)
        hull()
        xspread(4)
        cyl(r = post_radius + 1, h = post_height + base_tickness, align = V_UP);

        xmove((base_width/2))
        yspread(12, n=3)
        hull()
        xspread(40)
        cyl(r = 2, h = post_height - base_tickness, align = V_UP);

        xmove(base_width/2)
        xspread(20)
        hull()
        yspread(30)
        cyl(r = 2, h = post_height - base_tickness, align = V_UP);
    }

    zmove(-eps)
    {
        color("orange")
        {
            xmove(fin_offset)
            yflip_copy(fin_spread / 2)
            zrot(90) hexnut_helper(height = 3.2, length = 10, diameter = 7);

            xmove(corner_offset)
            yflip_copy(corner_spread / 2)
            zrot(90) hexnut_helper(height = 3.2, length = 10, diameter = 7);
        }

        zscale(1.01)
        color("red")
        {
            xmove(fin_offset)
            yspread(fin_spread)
            cyl(d = m3_pass_diameter, h = post_height + base_tickness, align = V_UP);

            xmove(corner_offset)
            yspread(corner_spread)
            cyl(d = m3_pass_diameter, h = post_height + base_tickness, align = V_UP);
        }
    }
}
