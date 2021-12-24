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
number_of_fragments = 0.50 * 360;
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

                color("honeydew")
                union()
                {
                    xmove(0.9 * cyl_move + 1)
                    ymove(0.9 * cyl_move + 1)
                    scale([1.06, 1.3, 1])
                    cyl(
                        h = thickness + 1,
                        d = 2 * cyl_move
                    );
                }
            }
        }

        // Cut mounting holes
        color("lavender")
        union()
        {
            xspread(
                spacing = length / 2,
                n = 2
            )
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

module restraining_rod(
    length,
    width,
    thickness
)
{
    difference()
    {
        color("deepskyblue")
        union()
        {
            cuboid(
                size = [length, width, thickness],
                chamfer = chamfer,
                edges = EDGE_BOT_FR + EDGE_BOT_BK
            );
        }

        color("lightcyan")
        zmove(-thickness * 1/3)
        union()
        {
            tube(
                h = length + 1,
                od = 3   * thickness,
                id = 5/3 * thickness,
                orient = ORIENT_X,
                align = ALIGN_CENTER
            );
        }
    }
}

module joiner(
    width,
    height,
    thickness
)
{
    let(
        joiner_width = width,
        joiner_thickness = thickness,
        joiner_height = height
    )
    difference()
    {
        color("yellow")
        union()
        {
            cuboid(
                size = [joiner_thickness, joiner_width, joiner_height],
                chamfer = chamfer,
                edges = EDGES_X_ALL + EDGES_RIGHT
            );
        }

        color("khaki")
        union()
        {
            zmove(joiner_height / 2)
            ymove(joiner_width / 2)
            scale(1.3 * [1, joiner_width, joiner_height])
            cyl(
                l = joiner_thickness + 1,
                d = 1,
                orient = ORIENT_X,
                align = ALIGN_CENTER
            );
        }
    }
}

module drive_cable_restraint(
    gap,
    travel,
    width,
    thickness,
    bracket_length,
    bracket_width,
    bracket_thickness,
    bracket_metric_size
)
{
    let(
        restraint_ymove = (bracket_width - width) / 2,
        restraint_offset = (gap + thickness) / 2,
        joiner_height = bracket_thickness + gap + 2 * restraint_thickness,
        joiner_thickness = max(4, restraint_thickness),
        bracket_zmove = (joiner_height - bracket_thickness) / 2,
        bracket_offset = (travel + joiner_thickness) / 2
    )
    difference()
    {
        let(
            extra_height = 2.5
        )
        union()
        {
            // Restraints
            ymove(-restraint_ymove)
            zmove(bracket_thickness / 2 - extra_height / 2)
            zflip_copy(offset = -restraint_offset)
            restraining_rod(travel, width, thickness);

            // Joiner-bracket pairs
            xflip_copy(offset = bracket_offset)
            {
                joiner(
                    width = bracket_width,
                    height = joiner_height + extra_height,
                    thickness = joiner_thickness
                );

                zmove(-bracket_zmove - extra_height / 2)
                mounting_bracket(
                    length = bracket_length,
                    width = bracket_width,
                    thickness = bracket_thickness,
                    metric_size = bracket_metric_size
                );
            }
        }

        // Entrance
        let(
            entrance_xmove = travel / 2
        )
        ymove(-restraint_ymove - width/2)
        ymove(2)
        zmove(bracket_thickness)
        zrot(30)
        narrowing_strut(
                        w = 4,
                        l = 1.5 * thickness,
                        wall = 6,
                        ang = 10,
                        align = ALIGN_CENTER,
                        orient = ORIENT_Z_180
                    );

        xmove(-23)
        ymove(4.6)
        zmove(thickness/2 - 0.25)
        zrot(0)
        scale([0.4, 1.4, 1])
        torus(
            id=30,
            od=30 + 2.0*gap);

        ymove(10.5)
        zmove(-bracket_thickness / 2)
        {
            cuboid(
                size = [travel + 20, bracket_width / 2, 20]
            );
            zmove(-bracket_thickness / 2)
            scale([1.282, 1, 1])
            cyl(d = bracket_width, l = 2 * bracket_thickness);
        }
        
        *difference()
        {
            union()
            {
                narrowing_strut(
                        w = 6,
                        l = 20,
                        wall = 4,
                        ang = 60,
                        align = ALIGN_NEG,
                        orient = ORIENT_YNEG_90
                    );

                ymove(2)
                xmove(joiner_thickness / 2 - 1.2)
                scale([0.4, 1.1 * width, 1.1 * thickness])
                cuboid(
                    size=[1, 1, 1],
                    align = ALIGN_CENTER
                );
            }

            xmove(0.5)
            ymove(0.3)
            scale([1, 1, 0.9])
            narrowing_strut(
                    w = 6,
                    l = 6,
                    wall = 4.4,
                    ang = 60,
                    align = ALIGN_NEG,
                    orient = ORIENT_YNEG_90
                );
        }

        *let(
            entrance_xmove = -(travel)/2 + (restraint_thickness + chamfer)
        )
        union()
        {
            xmove(entrance_xmove)
            zmove(gap + thickness)
            ymove(-restraint_ymove)
            intersection()
            {
                cuboid([gap, 2*gap, 2*gap]);

                xrot(120)
                narrowing_strut(
                    w = 2 * gap,
                    l = 1 * (thickness + gap),
                    wall = thickness,
                    ang = 45,
                    align = ALIGN_CENTER
                );

            }
        }
    }
}

bracket_metric_size = 4;
bracket_thickness = 8;
bracket_width = 36;
bracket_length = 36;

// restraint_gap = 9.4;
// restraint_length = 280;
// restraint_thickness = 8;

restraint_gap = 4.0;
restraint_length = 40;
restraint_thickness = 6;

*restraining_rod(
    length = restraint_length,
    thickness = restraint_thickness
);

*mounting_bracket(
    length = bracket_length,
    width = bracket_width,
    thickness = bracket_thickness,
    metric_size = bracket_metric_size
);

*joiner(
    width = bracket_width,
    height = 22,
    thickness = restraint_thickness - 2
);

drive_cable_restraint(
    gap = restraint_gap,
    travel = restraint_length,
    width = restraint_thickness,
    thickness = restraint_thickness,
    bracket_length = bracket_length,
    bracket_width = bracket_width,
    bracket_thickness = bracket_thickness,
    bracket_metric_size = bracket_metric_size
);
