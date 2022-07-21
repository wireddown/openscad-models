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
function generate_frames(base_size, top_size, height, thickness) =
    let (
        layer_count=height/thickness,
        base_x=base_size[0],
        base_y=base_size[1],
        top_x=top_size[0],
        top_y=top_size[1],
        x_growth=(top_x-base_x)/layer_count,
        y_growth=(top_y-base_y)/layer_count
    )
    [x_growth, y_growth, layer_count];

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

module stack_frames(thickness, base_thickness, xgrowth, ygrowth, layer_count, base_x, base_y)
    let (
    )
{
    for (i = [0:layer_count])
    let (
        x=base_x + i*xgrowth,
        y=base_y + i*ygrowth,
        height=thickness*i
    )
    {
        if (height <= base_thickness - 0.5*thickness)
        {
            hull()
            zmove(height)
            frame(x=x, y=y, thickness=thickness);

        }
        else
        {
            zmove(height)
            frame(x=x, y=y, thickness=thickness);
        }
    }
}

gframes = generate_frames(base_size=[11,22], top_size=[33,44], height=10, thickness=1);
xgrowth = gframes[0];
ygrowth = gframes[1];
layer_count = gframes[2];
echo(str(gframes))
stack_frames(thickness=1, base_thickness=5, xgrowth=xgrowth, ygrowth=ygrowth, layer_count=layer_count, base_x=11, base_y=22);
