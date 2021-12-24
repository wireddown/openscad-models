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

notch_diameter = 13;
notch_radius   = notch_diameter / 2;
notch_height   = 3.6;
notch_length   = 30;

// Functions

// Modules

module notch(h, d, l)
{
    hull()
    {
        cylinder(h=h, d=d);
        translate([l, 0, 0])
            cylinder(h=h, d=d);
    }
}

// Objects

rotate([0, 180, 0])
union()
{
    difference()
    {
        union()
        {
            translate([0, 0, notch_height])
            notch(h=1.76, d=2*notch_diameter, l=notch_length-notch_radius);

            color("orange")
            notch(notch_height, notch_diameter-0.8, notch_length);
        }

        color("red")
        translate([0, 0, -eps])
        notch(notch_height, 8+1.2, notch_length);

        color("green")
        translate([notch_length-1.81,0, 0])
        cube([notch_length+notch_diameter, 2*(notch_diameter+eps), 12], center=true);
    }

    color("blue")
    {
        // Retaining posts
        translate([notch_radius-0.6, 0, notch_height/2+eps])
        {
            translate([0, notch_radius-2.7, 0])
            cube([1.6, 1.6, notch_height+2*eps], center=true);

            translate([0, -(notch_radius-2.7), 0])
            cube([1.6, 1.6, notch_height+2*eps], center=true);
        }

        // Snuggle nubbins
        translate([2, 0, 0])
        scale([1.2, 1, 1])
        {
            translate([0, notch_radius-0.8, 0])
            cylinder(h=notch_height+2*eps, d=1.6);

            translate([0, -(notch_radius-0.8), 0])
            cylinder(h=notch_height+2*eps, d=1.6);
        }
    }
}
