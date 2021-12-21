//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

// Globals

$fn = 0.3 * 360;
eps = 0.01;

//base_diameter = 200;
base_diameter = 170;
base_radius   = base_diameter / 2;
base_height   = 10;

post_diameter = 50;
post_height = base_height + 40;

hole_diameter = 32;
hole_height = post_height;

notch_diameter = 13;
notch_radius   = notch_diameter / 2;
notch_height   = 3.6;
notch_zbase    = 0;
notch_length   = 30;
notch_per_rotation = 8;
notch_rotation_angle = 360 / notch_per_rotation;
notch_offset_angle = notch_rotation_angle / 2;
notch_inset = base_radius - notch_radius;

// Functions

// Modules

module notch(h, d, l)
{
    hull()
    {
        cylinder(h=h, d=d);
        translate([l, 0, 0])
        {
            cylinder(h=h, d=d);
        }
    }
}

// Objects

module spinner_top()
{
    difference()
    {
        union()
        {
            cylinder(h=base_height, d=base_diameter);
            cylinder(h=post_height, d1=post_diameter+2, d2=post_diameter-2);
        }

        translate([0, 0, -eps])
        {
            cylinder(h=hole_height+2*eps, d=hole_diameter);
        }

        for(notch_angle = [0:notch_rotation_angle:360])
        {
            rotate(notch_angle)
            translate([notch_inset, 0, notch_zbase-eps])
            notch(notch_height, notch_diameter, notch_length);
        }
    }
}

spinner_top();
