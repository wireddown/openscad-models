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

// Objects

module fan_4010()
{
    box_fan(side = 40, height = 10, spacing = 32);
}

module box_fan_volume(side, height)
{
    color("lightgreen")
    cuboid(size=[side, side, height],
           fillet=2,
           edges=EDGES_Z_ALL);
}

module box_fan_holes(pass_diameter, spacing, height)
{
    color("orange")
    zscale(1.01)
    xspread(spacing)
    yspread(spacing)
    cyl(d=pass_diameter, h=height);
}

module box_fan(side, height, spacing)
let(
    m3_pass_diameter = 3,
    m4_pass_diameter = 3.5,
    tslot_spacing = 20
)
difference()
{
    box_fan_volume(side, height);
    box_fan_holes(m3_pass_diameter, spacing, height);
}

module fan_adapter()
color("skyblue")
difference()
{
    hull()
    {
        xspread(40)
        cyl(r=3, h=4);

        ymove(45/2-19)
        zmove(10)
        xspread(8)
        yspread(3)
        cyl(r=3, h=1);
    }

    fan_arch();
}

module fan_arch()
{
    zmove(-2)
    ymove(1)
    xscale(1.25)
    ycyl(r=10, h=15);
}

*fan_adapter();

//intersection()
{
    difference()
    {
        zrot_copies([0, 90])
        yflip_copy(offset=20)
        fan_adapter();

        // 4010 box fan clearance
        cyl(r=22, h=10.1, fillet=3);

        // 4010 box fan clearance
        zrot(45)
        zmove(3)
        xscale(1.02)
        yscale(1.02)
        box_fan_volume(side=40, height=10);

        // 4010 box fan mounting holes
        zrot(45)
        box_fan_holes(pass_diameter=3.2,
                      spacing=32,
                      height=40);

        // 5010 box fan mounting holes
        box_fan_holes(pass_diameter=3.2,
                      spacing=40,
                      height=10);

        // Counter-sink
        zmove(4)
        box_fan_holes(pass_diameter=6.2,
                      spacing=40,
                      height=5);
    }
}

// Next steps:
//  - larger m3 pass through ~ 4.0
//  - maybe taller bracket?
//  - 