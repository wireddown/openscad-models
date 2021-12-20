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
    top_tube_height)
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

                echo(ziptie_bracket_height, depth, width/2, thickness/2);
                oval_tube(
                    height=ziptie_bracket_height,
                    rx=depth,
                    ry=width/2,
                    wall=thickness/2);

                oval_tube(
                    height=top_tube_height,
                    rx=depth,
                    ry=width/2,
                    wall=thickness/2);
            }

            color("palegreen")
            union()
            {
                translate([0, -width/2-r1-thickness, ziptie_bracket_height/2-eps])
                cube([2*r1+thickness, 2*r1, ziptie_bracket_height+1], center=true);

                translate([0, width/2+r2+thickness, ziptie_bracket_height/2-eps])
                cube([2*r2+thickness, 2*r2, ziptie_bracket_height+1], center=true);

                for (y_coord = [
                    -width/2-thickness,
                    -width/2+thickness,
                     width/2-thickness,
                     width/2+thickness])
                {
                    translate([0, y_coord, ziptie_bracket_height/2])
                    cube([2*(max(r2, r1)+1), ziptie_hole_width, ziptie_hole_height], center=true);
                }
            }
        }
    }
}

// Objects

difference()
{
    union()
    {
        for (z_coord = [
            0,
            25/2,
            25])
        {
            translate([0, 0, z_coord])
            ziptie_tube_coupler(
                width=15, thickness=2.4,
                r1=6.5/2, r2=13/2,
                ziptie_height=2.5,
                top_tube_height=13);
        }

    }

    color("magenta")
    {
    }
}
