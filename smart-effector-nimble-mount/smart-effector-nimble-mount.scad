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
number_of_fragments = 0.30 * 360;
eps = 0.001;
mm_per_inch = 25.4;

$fn = number_of_fragments;

// Functions

// Modules

// Objects

module hexnut_helper()
{
    nut_path = path2d_regular_ngon(n=6, d=7);
    linear_extrude(6)
    {
        polygon(nut_path);
        xmove(3) polygon(nut_path);
        xmove(6) polygon(nut_path);
    }
}

difference()
{
    union()
    {
        color("green")
        import("Nimble_mount_base_v2.4.stl", convexity=12);

        color("magenta", 1)
        zmove(3.475)
        hull()
        let(
            height = 7.78
        )
        {
            xmove(-1.25)
            ymove(-20)
            cyl(d=16, h=height);

            xmove(7)
            ymove(-13.4)
            cyl(d=9, h=height);

            xmove(-14)
            ymove(-3)
            cyl(d=9, h=height);

            xmove(-14.7)
            ymove(8.5)
            cyl(d=6, h=height);

            xmove(14.7)
            ymove(8.5)
            cyl(d=6, h=height);
        }
    }

    union()
    {
        color("orange")
        zmove(-2)
        linear_extrude(height=10)
        let(
            hexagon_path = path2d_regular_ngon(n=6, d=22)
        )
        {
            polygon(hexagon_path);
            zrot(90) polygon(hexagon_path);
        }

        *zmove(0)
        cyl(d=24.0, h=4);

        color("skyblue")
        zmove(3)
        let(
            height = 10
        )
        {
            ymove(-17)
            cyl(d=3.5, h=height);

            xmove(7.07)
            ymove(-13.32)
            cyl(d=3.6, h=height);

            xmove(-13.82)
            ymove(-3)
            cyl(d=3.6, h=height);

            xmove(-14.725)
            ymove(8.5)
            cyl(d=3.5, h=height);

            xmove(14.725)
            ymove(8.5)
            cyl(d=3.5, h=height);
        }

        zmove(2.6)
        {
            zrot(-30)
            xmove(13.1)
            ymove(-8)
            hexnut_helper();

            zrot(42)
            xmove(-18.5)
            ymove(7)
            hexnut_helper();
        }
    }

    cyl(d=28.0, h=5);
}