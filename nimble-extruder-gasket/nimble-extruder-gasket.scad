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
number_of_fragments = 0.10 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

// Functions

// Modules

// Objects

let(
    m4_pass_diameter = 3.5,
    tslot_spacing = 20,
    gasket_thickness = 2.6,
    gasket_fillet = 1.6,
    gasket_bottom_width = 42,
    gasket_top_width = 25,
    gasket_length = 45,
    slot_y_offset = 20,
    slot_length = 18
)
difference()
{
    union()
    {
        color("lightgreen")
        hull()
        {
            xspread(gasket_bottom_width)
            cyl(r=gasket_fillet,
                h=gasket_thickness);

            ymove(gasket_length)
            xspread(gasket_top_width)
            cyl(r=gasket_fillet,
                h=gasket_thickness);
        }
    }

    union()
    {
        color("orange")
        zscale(1.01)
        ymove(slot_y_offset)
        xspread(tslot_spacing)
        hull()
        {
            yspread(slot_length)
            cyl(r=m4_pass_diameter,
                h=gasket_thickness);
        }
    }
}
