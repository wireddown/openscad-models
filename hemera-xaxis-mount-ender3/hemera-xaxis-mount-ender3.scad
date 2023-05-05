// http://www.openscad.org/cheatsheet/index.html
//   Characters    Behavior
//      //            comment rest of line
//      *             disable
//      !             show only
//      #             highlight / debug
//      %             enable alpha channel, eg color("#RRGGBBAA")           https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#color
//      $t            time step, range: [0..1]
//      $vpr          viewport rotation, eg: $vpr = [0, 0, $t * 360];
//      import()      import a 2D or 3D file
//      surface()     treat 2D file with RGB/grayscale as heightmap
//      include <>    the modules and functions and execute commands
//      use <>        only the modules and functions

include <BOSL/constants.scad>    // https://github.com/revarbat/BOSL/wiki/constants.scad
use <BOSL/shapes.scad>           // https://github.com/revarbat/BOSL/wiki/shapes.scad
use <BOSL/transforms.scad>       // https://github.com/revarbat/BOSL/wiki/transforms.scad

// Globals

convexity = 4;
number_of_fragments = 0.1 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

hole_x_ender3_xaxis_bracket = 0;
hole_y_ender3_xaxis_bracket = 0;

thickness = 7;

plug_x = -2;
plug_y = 34.45;
plug_z = -2;
plug_r = 4;

hole_x_delta = -3.5;
hole_y_delta = -3;
hole_r = 1.75;
countersink_r = 3.15;
countersink_h = 3;

// Functions

// Modules
module ender3_xaxis_bracket()
{
    difference()
    {
        color("MediumVioletRed")
        union()
        {
            xmove(plug_x)
            ymove(plug_y)
            zmove(plug_z)
            cylinder(h = thickness, r = plug_r);

            yrot(180)
            import("Ender_3_V2_Part_A.stl", convexity=4);
        }

        union()
        color("Pink")
        {
            xmove(plug_x + hole_x_delta)
            ymove(plug_y + hole_y_delta)
            zmove(plug_z)
            cylinder(h = thickness, r = hole_r);

            xmove(plug_x + hole_x_delta)
            ymove(plug_y + hole_y_delta)
            zmove(plug_z)
            cylinder(h = countersink_h, r = countersink_r);
        }
    }
}

// Objects

ender3_xaxis_bracket();
