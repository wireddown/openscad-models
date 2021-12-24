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
}
