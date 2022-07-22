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

// Functions
function framesize_for_layer(layer_number, base_size, top_size, height, thickness) =
    let (
        layer_count=height/thickness,
        base_x=base_size[0],
        base_y=base_size[1],
        top_x=top_size[0],
        top_y=top_size[1],
        x_growth=(top_x-base_x)/layer_count,
        y_growth=(top_y-base_y)/layer_count,
        linear_x=base_x + (layer_number*x_growth),
        linear_y=base_y + (layer_number*y_growth),
        two_pi=6.28,
        x_mod=5*sin(400*two_pi*layer_number/layer_count),
        y_mod=5*sin(400*two_pi*layer_number/layer_count)
    )
    [linear_x+1*x_mod, linear_y+1*y_mod];

// Modules
module frame(x=250, y=400, thickness=20)
{
    echo(str("frame(x=", x, ", y=", y, ", thickness=", thickness, ")"));

    yspread(y)
    hull()
    xspread(x)
    sphere(r=thickness, $fn=8);

    color("blue")
    xspread(x)
    hull()
    yspread(y)
    sphere(r=thickness, $fn=8);
}

module stack_by_layer(base_size, top_size, height, thickness, base_thickness)
    let (
        layer_count=height/thickness
    )
    {
        for (layer = [0 : layer_count])
        let(
            frame_params = framesize_for_layer(layer, base_size, top_size, height, thickness),
            x=frame_params[0],
            y=frame_params[1],
            z=layer*thickness
        )
        {
            zmove(z)
            if (z <= base_thickness - 0.5*thickness)
            {
                color("purple")
                hull() frame(x=x, y=y, thickness=thickness);
            }
            else
            {
                frame(x=x, y=y, thickness=thickness);
            }
        }
    }

// Objects
stack_by_layer(base_size=[127,203.2], top_size=[177.8,254], height=330.2, thickness=2, base_thickness=5);
