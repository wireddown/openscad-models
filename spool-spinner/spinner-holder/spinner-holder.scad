//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

// Globals

$fn = 8 * 12;
eps = 0.01;

base_diameter = 170;
base_height   = 10;

post_diameter = 60;
post_height = 40 - base_height;
post_zbase = -post_height;

hole_diameter = 32;
hole_height = base_height + post_height;
hole_zbase = -post_height;

recess_diameter = 70;
recess_height = 30;
recess_zbase = base_height - recess_height;

notch_diameter = 13;
notch_height   = 3.6;
notch_zbase    = base_height - notch_height;
notch_length   = 30;
notch_per_rotation = 8;
notch_rotation_angle = 360 / notch_per_rotation;
notch_offset_angle = notch_rotation_angle / 2;

notch_inset = base_diameter/2 - notch_diameter/2;

// Functions

// Modules

module notch(h, d, l)
{
    hull()
    {
        cylinder(h=h, d=d);
        translate([l, 0, 0]) cylinder(h=h, d=d);
    }
}

// Objects

*rotate(45) translate([50, 0, 0 ]) notch(notch_height, notch_diameter, notch_length);

difference()
{
    union()
    {
        cylinder(h=base_height, d=base_diameter);
        translate([0, 0, post_zbase])
        {
            hull()
            {
                translate([0, 0, post_height])
                {
                    cylinder(h=eps, d=base_diameter);
                }
                cylinder(h=eps, d=post_diameter);
            }
        }
    }

    translate([0, 0, hole_zbase-eps])
    {
        cylinder(h=hole_height+2*eps, d=hole_diameter);
    }

    translate([0, 0, recess_zbase-eps])
    {
        cylinder(h=recess_height+2*eps, d=recess_diameter);
    }

    for(notch_angle = [0:notch_rotation_angle:360])
    {
        rotate(notch_angle)
        translate([notch_inset, 0, notch_zbase+eps])
        notch(notch_height, notch_diameter, notch_length);
    }

    for(notch_angle = [notch_offset_angle:notch_rotation_angle:360+notch_offset_angle])
    {
        rotate(notch_angle)
        translate([notch_inset, 0, -notch_height])
        notch(notch_height, notch_diameter, notch_length/2);
    }
}
