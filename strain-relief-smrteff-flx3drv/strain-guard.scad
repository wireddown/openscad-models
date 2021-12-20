//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

use <MCAD/regular_shapes.scad>

// Globals

convexity = 4;
number_of_fragments = 0.30 * 360;
eps = 0.001;

$fn = number_of_fragments;

// Parameters


// Functions

// Modules

module notch(height, diameter, length)
{
    hull()
    {
        cylinder(h=height, d=diameter);
        translate([length, 0, 0])
            cylinder(h=height, d=diameter);
    }
}

/* module tube(outer_diameter, inner_diameter, length)
{
    difference()
    {
        color("red")
        union()
        {
            cylinder(d=outer_diameter, h=length);
        }

        color("blue")
        union()
        {
            scale([1, 1, 1.1])
            translate([0, 0, -eps])
            cylinder(d=inner_diameter, h=length);
        }
    }
} */

module duct(outer_xsize, outer_ysize,
            inner_xsize, inner_ysize,
            length)
{
    difference()
    {
        color("red")
        union()
        {
            cube([outer_xsize, outer_ysize, length]);
        }

        color("blue")
        scale([1, 1, 1.1])
        translate([
            (outer_xsize-inner_xsize)/2,
            (outer_ysize-inner_ysize)/2,
            -eps
        ])
        union()
        {
            cube([inner_xsize, inner_ysize, length]);
        }
    }
}

module hex_hole(metric_size, height=-1)
{
    z_size = (height == -1)
        ? METRIC_NUT_THICKNESS[metric_size]
        : height;

    // These are too large for my set
    //let (diameter = METRIC_NUT_AC_WIDTHS[metric_size])
    let (diameter = m4_nut_diameter)
    {
        cylinder(d=diameter, h=z_size, $fn=6);
    }
}

module hexnut_inset(
    metric_size,
    height=-1,
    wall_thickness=2.0,
    facade_thickness=2)
{
    z_size = (height == -1)
        ? METRIC_NUT_THICKNESS[metric_size]
        : height;

    let (diameter = m4_nut_diameter,
         apothemD = METRIC_BOLT_CAP_DIAMETERS[metric_size]-1)
    {
        union()
        {
            translate([0, 0, z_size-facade_thickness])
            tube(outer_diameter=diameter + wall_thickness, inner_diameter=apothemD, length=facade_thickness);

            difference()
            {
                cylinder(d=diameter + wall_thickness, h=z_size);
                translate([0, 0, eps])
                hex_hole(metric_size, z_size);
            }
        }
    }
}

module ziptie_tube_coupler(
    width,
    thickness,
    r1,
    r2,
    ziptie_height,
    top_tube_height,
    chamfer_lower_edge)
{
    let (depth = min(r1, r2),
         ziptie_hole_height = ziptie_height + 1.2,
         ziptie_bracket_height = ziptie_hole_height + 2.8,
         ziptie_hole_width = 1.4)
    {
        difference()
        {
            color("lime")
            union()
            {
                translate([0, (-width-r1-thickness)/2, 0])
                cylinder_tube(
                    height=ziptie_bracket_height,
                    radius=r1,
                    wall=thickness/2);

                translate([0, (width+2*r2-thickness)/2, 0])
                cylinder_tube(
                    height=ziptie_bracket_height,
                    radius=r2,
                    wall=thickness/2);

                oval_tube(
                    height=ziptie_bracket_height,
                    rx=depth,
                    ry=width/2,
                    wall=thickness/2);

                if (top_tube_height > ziptie_bracket_height)
                {
                    oval_tube(
                        height=top_tube_height,
                        rx=depth,
                        ry=width/2,
                        wall=thickness/2);
                }
            }

            color("palegreen")
            union()
            {
                translate([0, -width/2-r1-thickness, ziptie_bracket_height/2-eps])
                cube([2*r1+thickness, 2*r1, ziptie_bracket_height+1], center=true);

                z_coord = chamfer_lower_edge
                    ? [
                        -0.5*ziptie_bracket_height,
                        1.5*ziptie_bracket_height,
                    ]
                    : [1.5*ziptie_bracket_height];

                for (z = z_coord)
                {
                    translate([-r1, -width/2-r1-thickness, z])
                    rotate([0, 90, 0])
                    hexagon_prism(height=2*r1, radius=ziptie_bracket_height, across_flats=true);

                    translate([-r2, width/2+r2-0.8, z])
                    rotate([0, 90, 0])
                    hexagon_prism(height=2*r2, radius=ziptie_bracket_height+0, across_flats=true);
                }

                translate([0, width/2+r2+thickness, ziptie_bracket_height/2-eps])
                cube([2*r2+thickness, 2*r2, ziptie_bracket_height+1], center=true);

                for (y_coord = [
                        -width/2+1.2*thickness,
                        width/2-1.2*thickness,
                     ])
                {
                    if (top_tube_height > ziptie_bracket_height)
                    let (ziptie_hole_z = (top_tube_height-ziptie_bracket_height)/2+ziptie_bracket_height)
                    {
                        translate([0, y_coord, ziptie_hole_z])
                        cube([2*(max(r2, r1)+1), ziptie_hole_width, ziptie_hole_height], center=true);
                    }
                }
            }
        }
    }
}

// Objects

z_and_heights = [
    [0,    13,  false],
    [25/2, 13,  true ],
    [25,   0,   true ],
];

difference()
{
    union()
    {
        for (z_and_t = z_and_heights)
        let (z = z_and_t[0], t = z_and_t[1], c = z_and_t[2])
        {
            echo(z_and_t);
            translate([0, 0, z])
            ziptie_tube_coupler(
                width=15, thickness=2.4,
                r1=6.5/2, r2=13/2,
                ziptie_height=2.5,
                top_tube_height=t,
                chamfer_lower_edge=c);
        }

    }

    color("magenta")
    {
    }
}
