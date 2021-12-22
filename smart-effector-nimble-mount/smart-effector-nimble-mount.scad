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

        // Fill Nimble nut countersinks
        color("lightgreen")
        zmove(7)
        let(
            diameter = 7,
            height = 6.2
        )
        {
            // Nimble mount 1
            xmove(7)
            ymove(-13.4)
            cyl(d=diameter, h=height, align=V_UP);

            // Nimble mount 2
            xmove(-14)
            ymove(-3)
            cyl(d=diameter, h=height, align=V_UP);

        }

        // Fill under loft
        color("magenta", 1)
        zmove(-0.4)
        hull()
        let(
            height = 7.625
        )
        {
            // Big lobe
            xmove(-1.25)
            ymove(-20)
            cyl(d=16, h=height, align=V_UP);

            // Nimble mount 1
            xmove(7)
            ymove(-13.4)
            cyl(d=9, h=height, align=V_UP);

            // Nimble mount 2
            xmove(-14)
            ymove(-3)
            cyl(d=9, h=height, align=V_UP);

            // Right-angle corner
            xmove(-14.7)
            ymove(8.5)
            cyl(d=6, h=height, align=V_UP);

            // Acute corner
            xmove(14.7)
            ymove(8.5)
            cyl(d=6, h=height, align=V_UP);
        }
    }

    union()
    {
        // Mosquito mounting nut clearance
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

        // Smart effector bolt pass-throughs
        color("skyblue")
        zmove(-1)
        let(
            height = 12,
            diameter = 3.5
        )
        {
            ymove(-17)
            cyl(d=diameter, h=height, align=V_UP);

            xmove(-14.725)
            ymove(8.5)
            cyl(d=diameter, h=height, align=V_UP);

            xmove(14.725)
            ymove(8.5)
            cyl(d=diameter, h=height, align=V_UP);
        }
    }

    // High-temp washer clearance
    zmove(-0.5)
    cyl(d=28.0, h=3, align=V_UP);

    // PTFE tube clearance
    zmove(10)
    cyl(d=4.25, h=10, align=V_UP);
}
