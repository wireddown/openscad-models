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
use <BOSL/paths.scad>

// Globals

convexity = 4;
number_of_fragments = 0.1 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

icosohedron_rotation_angle = 36;
icosohedron_rotation_tilt = 90 - 26.57;

// Functions

// Modules

module spike(side=80, height=150, spacing=0)
    let (
         base = [side, side],
         point = [0, 0]
    )
{
    zflip_copy(offset=spacing)
    hull()
    {
        zmove(height) sphere(r=0.1);
        linear_extrude(height=0.1)
        circle(d=side, $fn=6);
    }
}

module icosohedratify()
{
    //intersection()
    {
        union()
        {
            color("black")
            children(0);

            color("purple")
            zrot(-10 * icosohedron_rotation_angle)
            xrot(-1 * icosohedron_rotation_tilt)
            children(0);

            color("orange")
            zrot(-2 * icosohedron_rotation_angle)
            xrot(-1 * icosohedron_rotation_tilt)
            children(0);

            color("blue")
            zrot(9 * icosohedron_rotation_angle)
            xrot(icosohedron_rotation_tilt)
            children(0);

            color("red")
            zrot(11 * icosohedron_rotation_angle)
            xrot(icosohedron_rotation_tilt)
            children(0);

            color("green")
            zrot(2 * icosohedron_rotation_angle)
            xrot(-1 * icosohedron_rotation_tilt)
            children(0);
        }
    }
}

// Objects
icosohedratify() spike();
