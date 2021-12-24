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
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

// Globals

convexity = 4;
number_of_fragments = 0.06 * 360;
eps = 0.001;

$fn = number_of_fragments;

hole_factor = 1.1;
chamfer = 1.5;

// Functions

// Modules

// Objects

module mounting_bracket(
    length,
    width,
    thickness,
    metric_size
)
{
    let (
        hole_size = metric_size * hole_factor,
        cyl_move = max(length/2, width/2)
    )
    difference()
    {
        union()
        {
            // Main body
            difference()
            {
                color("yellowgreen")
                union()
                {
                    cuboid(
                        size = [length, width, thickness],
                        chamfer = chamfer
                    );
                }
            }
        }

        // Cut mounting holes
        color("lavender")
        union()
        {
            yspread(
                spacing = 20,
                n = 2
            )
            screw(
                screwsize = hole_size,
                screwlen = thickness,
                headsize = get_metric_socket_cap_diam(metric_size + 1),
                headlen = get_metric_socket_cap_height(metric_size + 1)
            );
        }
    }
}

module positioning_slot(
    length,
    width,
    thickness,
    metric_size
)
{
    difference()
    {
        union()
        {
            color("#EE88FF")
            cuboid(
                size = [length, width, thickness],
                chamfer = chamfer / 2,
                edges = EDGES_X_ALL + EDGES_Y_RT
            );
        }

        union()
        {
            slot(
                h = thickness,
                l = length - (3 * metric_size),
                d = metric_size * hole_factor
            );

            xmove(length / 2)
            yspread(width)
            fillet_mask_z(
                l = thickness,
                r = metric_size
            );
        }
    }
}

module rpi_cam_bracket(
    bracket_length,
    bracket_width,
    bracket_thickness,
    bracket_metric_size,
    slot_arm_length,
    slot_arm_width,
    slot_arm_thickness,
    slot_arm_metric_size
)
{
    yrot(90)
    mounting_bracket(
        length = bracket_length,
        width = bracket_width,
        thickness = bracket_thickness,
        metric_size = bracket_metric_size
    );

    xmove((bracket_thickness + slot_arm_length) / 2)
    zmove(-1 * ((bracket_length - slot_arm_thickness) / 2))
    positioning_slot(
        length = slot_arm_length,
        width = slot_arm_width,
        thickness = slot_arm_thickness,
        metric_size = slot_arm_metric_size
    );

    // Fill the chamfer on the bracket where
    // the slot arm touches
    color("#11FFAA")
    xmove((bracket_thickness - chamfer) / 2)
    zmove(-1 * ((bracket_length - slot_arm_thickness) / 2))
    cuboid(
        size = [bracket_thickness / 2, slot_arm_width - 0*chamfer, slot_arm_thickness],
        chamfer = chamfer / 2,
        edges = EDGES_X_ALL
    );
}

bracket_metric_size = 4;
bracket_thickness = 5;
bracket_width = 36;
bracket_length = 12;

*mounting_bracket(
    length = bracket_length,
    width = bracket_width,
    thickness = bracket_thickness,
    metric_size = bracket_metric_size
);

slot_arm_length = 40;
slot_arm_width = 9;
slot_arm_thickness = 4;
slot_arm_metric_size = 3;

*positioning_slot(
    length = slot_arm_length,
    width = slot_arm_width,
    thickness = slot_arm_thickness,
    metric_size = slot_arm_metric_size
);

rpi_cam_bracket(
    bracket_length,
    bracket_width,
    bracket_thickness,
    bracket_metric_size,
    slot_arm_length,
    slot_arm_width,
    slot_arm_thickness,
    slot_arm_metric_size
);
