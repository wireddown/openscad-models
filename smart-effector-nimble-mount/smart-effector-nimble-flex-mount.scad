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

let(
    spirit_lvl_diameter = 20, // measured: 18.7
    spirit_lvl_height = 12,   // measured: 9.9
    mosq_nut_thickness = 6.5, // measured: 5.8
    mosq_nut_diameter = 23,   // measured: 21.25
    high_temp_washer_thickness = 2.0, // measured: 1.4
    high_temp_washer_diameter = 26,   // measured: 23.8
    mosq_nut_path = path2d_regular_ngon(n=6, d=mosq_nut_diameter),
    mosq_bracket_height = mosq_nut_thickness+high_temp_washer_thickness,
    smrteff_x_offset = 14.725, // spec: (29.4 / 2)
    smrteff_y_offset = 8.5,
    smrteff_center_offset = 17,
    m3_bulk_diameter = 6,     // spec: 6
    m3_pass_diameter = 3.5,   // spec: 2.9
    m3_head_diameter = 7,     // measured: 
    ptfe_tube_od = 4.25,      // measured: 3.9
    hole_cut_height = 25
)
difference()
{
    union()
    {
        color("green")
        zrot(90)
        xmove(-0.39) ymove(-0.1) zmove(mosq_bracket_height-0.1)
        import("zesty-flex-basic-mount-ctr.stl", convexity=16);

        // Cover the 'Z' mark
        color("lightgreen")
        xmove(-6) ymove(-28.8) zmove(mosq_bracket_height)
        scale([10, 1, 5.91]) upcube(1);

        color("lightgreen")
        hull()
        {
            // Minimum Smart Effector bracket
            color("magenta")
            {
                // Bottom hole
                ymove(-smrteff_center_offset)
                cyl(d=m3_bulk_diameter, h=mosq_bracket_height, align=V_UP);

                // Left hole
                xmove(-smrteff_x_offset) ymove(smrteff_y_offset)
                cyl(d=m3_bulk_diameter, h=mosq_bracket_height, align=V_UP);

                // Right hole
                xmove(smrteff_x_offset) ymove(smrteff_y_offset)
                cyl(d=m3_bulk_diameter, h=mosq_bracket_height, align=V_UP);

                // Stronger arch
                xmove(5) ymove(12)
                cyl(d=m3_bulk_diameter, h=mosq_bracket_height, align=V_UP);
                xmove(-5) ymove(12)
                cyl(d=m3_bulk_diameter, h=mosq_bracket_height, align=V_UP);
            }

            // Zesty Tech Nimble Flex (V3)
            {
                // Under post with cone loft
                xmove(8.75) ymove(-11)
                {
                    cyl(d=8, h=mosq_bracket_height, align=V_UP);
                    cyl(d1=8, d2=11, h=mosq_bracket_height, align=V_UP);
                }

                // Under square with cone loft
                xmove(-6.25) ymove(-25)
                cyl(d=6, h=mosq_bracket_height, align=V_UP);

                xmove(-4) ymove(-23.5)
                xscale(1.5)
                cyl(d1=6, d2=10, h=mosq_bracket_height, align=V_UP);

                // Under swoop
                xmove(-15.5) ymove(0)
                cyl(d=7, h=mosq_bracket_height, align=V_UP);
            }
        }
    }

    // Remove:
    union()
    {
        // Mosquito mounting nut clearance
        color("orange")
        linear_extrude(mosq_bracket_height)
        {
            polygon(mosq_nut_path);
            zrot(90) polygon(mosq_nut_path);
        }

        // Smart effector bolt pass-throughs
        color("skyblue")
        {
            // Bottom hole with wide clearance for washer+nut+pliers
            ymove(-smrteff_center_offset)
            {
                cyl(d=m3_pass_diameter, h=hole_cut_height, align=V_UP);
                zmove(mosq_bracket_height+2) cyl(d=m3_head_diameter, h=hole_cut_height, align=V_UP);
                xscale(0.5) zmove(mosq_bracket_height+2) cyl(d1=2+m3_head_diameter, d2=14, h=5, align=V_UP);
            }

            // Left hole with clearance for washer+nut
            xmove(-smrteff_x_offset) ymove(smrteff_y_offset)
            {
                cyl(d=m3_pass_diameter, h=hole_cut_height, align=V_UP);
                zmove(mosq_bracket_height+eps) cyl(d=m3_head_diameter, h=hole_cut_height, align=V_UP);
            }

            // Right hole with clearance for washer+nut
            xmove(smrteff_x_offset) ymove(smrteff_y_offset)
            {
                cyl(d=m3_pass_diameter, h=hole_cut_height, align=V_UP);
                zmove(mosq_bracket_height+eps) cyl(d=m3_head_diameter, h=hole_cut_height, align=V_UP);
            }
        }

        // Match the Flex V3 curve
        xmove(-17) ymove(-11) yscale(1.1)
        cyl(d1=10, d2=14, h=mosq_bracket_height, align=V_UP);

        // High-temp washer clearance
        cyl(d=high_temp_washer_diameter, h=high_temp_washer_thickness, align=V_UP);

        // PTFE tube clearance
        cyl(d=ptfe_tube_od, h=hole_cut_height, align=V_UP);
    }
}
