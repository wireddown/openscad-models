//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

include <BOSL/constants.scad>
include <BOSL/paths.scad>
use <BOSL/masks.scad>
use <BOSL/math.scad>
use <BOSL/metric_screws.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <combined.scad>

// Globals

convexity = 4;
number_of_fragments = 0.08 * 360;
eps = 0.001;

$fn = number_of_fragments;

rpi0_x = 30;
rpi0_y = 65;

rpi3_x = 56;
rpi3_y = 85;

m2dot5 = 2.5;
m2dot5_insert_diameter = 4.0;
m2dot5_insert_depth = 6;


hole_factor = 1.1;
no_head = 0;
chamfer = 0.8;

// Functions

// Parts

module rpi0_footprint(thickness)
{
    color("MediumVioletRed")
    let(
        fillet = 3,
        edges = EDGE_FR_LF + EDGE_FR_RT +
                EDGE_BK_LF + EDGE_BK_RT
    )
    {
        cuboid(
            size = [rpi0_x, rpi0_y, thickness],
            fillet = fillet,
            edges = edges
        );
    }
}

*rpi0_footprint(thickness=10);

module rpi0_hole_cuts(diameter, length)
{
    union()
    let(
        y_spacing = 58,
        x_spacing = 23
    )
    {
        yspread(y_spacing)
        {
            xspread(x_spacing)
            screw(
                screwsize = diameter * hole_factor,
                screwlen = length,
                headsize = no_head
            );
        }
    }
}

*rpi0_hole_cuts(diameter=4, length=12);

module rpi3_footprint(thickness)
{
    let(
        fillet = 3,
        edges = EDGES_Z_ALL,
        y_spacing = 58,
        x_spacing = 49
    )
    {
        color("MediumVioletRed")
        cuboid(
            size = [rpi3_x, rpi3_y, thickness],
            fillet = fillet,
            edges = edges
        );

        *color("DarkOrchid")
        ymove((rpi3_y-58)/2 - 3.5)
        zmove(4)
        yspread(y_spacing)
        {
            xspread(x_spacing)
            cyl(
                h = 5,
                d = 7
            );
        }
    }
}

*rpi3_footprint(thickness=10);

module rpi3_hole_cuts(diameter, length)
{
    union()
    let(
        y_spacing = 58,
        x_spacing = 49
    )
    {
        yspread(y_spacing)
        {
            xspread(x_spacing)
            screw(
                screwsize = diameter * hole_factor,
                screwlen = length,
                headsize = no_head
            );
        }
    }
}

*rpi3_hole_cuts(diameter=4, length=12);

module mounting_bracket(
    width,
    length,
    thickness,
    metric_size,
    spacing = 20
)
{
    let (
        hole_size = metric_size * hole_factor,
        alum2020_spacing = spacing
    )
    difference()
    {
        color("yellowgreen")

        cuboid(
            size = [width, length, thickness],
            chamfer = chamfer
        );
        // scale([0.6, 1.1, 1])
        // zrot(22.5)
        // linear_extrude(thickness)
        // polygon(path2d_regular_ngon(
        //     n = 8,
        //     d = length
        // ));

        // Cut mounting holes
        let(
            headsize = get_metric_socket_cap_diam(metric_size + 1),
            headlen = get_metric_socket_cap_height(metric_size),
            mounting_hole_yspread = length - headsize,
            mounting_hole_margin = 5
        )
        union()
        {
            color("orange")
            yspread(mounting_hole_yspread - mounting_hole_margin)
            xspread(alum2020_spacing)
            //zmove(3)
            screw(
                screwsize = hole_size,
                screwlen = thickness,
                headsize = headsize,
                headlen = headlen
            );
        }
    }
}

*mounting_bracket(width=40, length=60, thickness=5, metric_size=4, spacing=20);

module knob_anchor()
{
    difference()
    {
    import("snap-mount.stl");
    
    zmove(14)
    cuboid(size=[29.54, 18, 36]);
    }
}

*knob_anchor();


// Products

module rpi0_cover()
{
    let(
        stl_offset = [-5.7, -36.15, 0],
        svg_offset = [-9,   -10,    0],
        svg_scale = 1.7 / 100,
        emboss_height = 1.75,
        m2dot5_cut_length = 10
    )
    difference()
    {
        union()
        {
            color("purple")
            move(stl_offset)
            zspread(spacing = 0.1, n = 13)
            zrot(-90)
            import("rpi0-top.stl");

            move(svg_offset)
            zmove(-emboss_height)
            {
                color("darkviolet")
                linear_extrude(emboss_height)
                scale([svg_scale, svg_scale, 1])
                import("celeste.svg");
            }
        }

        union()
        {
            color("red")
            move(svg_offset)
            zmove(-m2dot5_cut_length / 2)
            linear_extrude(m2dot5_cut_length)
            scale([svg_scale, svg_scale, 1])
            import("celeste-cuts.svg");

            color("blue")
            zmove(m2dot5_cut_length / 2)
            rpi0_hole_cuts(
                diameter = m2dot5,
                length = m2dot5_cut_length
            );
        }
    }
}

module rpi0_base_plate()
{
    let(
        rpi_base_thickness = 3,
        bracket_thickness = 7,
        length = rpi0_y + 26,
        bracket_width = 36,
        bracket_length = length
    )
    difference()
    {
        union()
        {
            mounting_bracket(
                width = bracket_width,
                length = bracket_length,
                thickness = bracket_thickness,
                metric_size = 4
            );

            zmove((bracket_thickness + rpi_base_thickness) / 2)
            rpi0_footprint(rpi_base_thickness);
        }

        color("red")
        zmove(bracket_thickness / 2 + rpi_base_thickness)
        rpi0_hole_cuts(
            diameter = m2dot5_insert_diameter,
            length = m2dot5_insert_depth
        );

        for (x_offset = [
            1 *  (bracket_length - 1),
            -1 * (bracket_length - 1)
        ])
        zmove(-bracket_thickness / 2)
        xmove(x_offset)
        scale([1, 1, 1])
        zrot(22.5)
        linear_extrude(bracket_thickness)
        polygon(path2d_regular_ngon(
            n = 8,
            d = 1.8 * bracket_length
        ));
    }
}

module rpi3b_cover()
{
    let(
        svg_offset = [-14,   -40,    0],
        svg_scale = 3 / 100,
        emboss_height = 1.75,
        m2dot5_cut_length = 10
    )
    difference()
    {
        union()
        {
            // Fill ASIC holes, remove edge guides
            zscale(1.0)
            difference()
            {
                union()
                {
                    xflip()
                    {
                        color("Violet")
                        import("rpi3b-mini-case.stl");

                        xmove(0.5)
                        ymove(12)
                        cube([10.5, 10.5, 2]);

                        xmove(-4.25)
                        ymove(-23.25)
                        cube([15.5, 15.5, 2]);
                    }
                }

                union()
                {
                    color("DarkOrange")
                    zmove(2)
                    ccube([rpi3_x + 10, rpi3_y + 10, 3]);
                }
            }

            move(svg_offset)
            zmove(emboss_height)
            {
                color("darkviolet")
                linear_extrude(emboss_height)
                scale([svg_scale, svg_scale, -1])
                import("celeste.svg");
            }
        }

        union()
        {
            color("red")
            move(svg_offset)
            zmove(-m2dot5_cut_length / 2)
            linear_extrude(m2dot5_cut_length)
            scale([svg_scale, svg_scale, 1])
            import("celeste-cuts.svg");

            color("red")
            ymove(-1 * ((rpi3_y-58)/2 - 3.5))
            zmove(m2dot5_cut_length / 2)
            rpi3_hole_cuts(
                diameter = m2dot5,
                length = m2dot5_cut_length
            );
        }
    }
    
}

module rpi3_base_plate()
{
    difference()
    {
        union()
        {
            rpi3_footprint(thickness=3);

            zmove(-5)
            {
                mounting_bracket(
                    width = 40,
                    length = rpi3_y + 26,
                    thickness = 7,
                    metric_size = 4,
                    spacing = 20
                );

                cuboid(
                    size = [rpi3_x, rpi3_y, 7],
                    fillet = 3,
                    edges = EDGES_BOTTOM + EDGES_Z_ALL
                );
            }
        }

        zmove(7)
        ymove((rpi3_y-58)/2 - 3.5)
        rpi3_hole_cuts(diameter = m2dot5_insert_diameter, length = 14);
    }
}

module picam_back()
{
    print_part("lid");

    zmove(6.26)
    difference()
    {
        color("dodgerblue")
        ymove(5)
        zmove(-18.25)
        import("camera-mount.stl");

        downcube(size = [40, 40, 6.25]);
    }
}

*rpi3_base_plate();
*rpi3b_cover();

*rpi0_base_plate();
*yrot(180) rpi0_cover();


print_part("camera");
ymove(40) print_part("lid");
