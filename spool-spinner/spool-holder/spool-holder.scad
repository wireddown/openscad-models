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

post_diameter = 50;
post_height = base_height + 40;

hole_diameter = 32;
hole_height = post_height;

notch_diameter = 13;
notch_height   = 3.6;
notch_length   = 30;

notch_inset = base_diameter/2 - notch_diameter/2;

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

*notch(notch_height, notch_diameter, notch_length);

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

    translate([notch_inset, 0, -eps])
    {
        notch(notch_height, notch_diameter, notch_length);
    }
    translate([-(notch_inset+notch_length), 0, -eps])
    {
        notch(notch_height, notch_diameter, notch_length);
    }
    translate([0, notch_inset, -eps])
    rotate(90)
    {
        notch(notch_height, notch_diameter, notch_length);
    }
    translate([0, -notch_inset, -eps])
    rotate(-90)
    {
        notch(notch_height, notch_diameter, notch_length);
    }
}
