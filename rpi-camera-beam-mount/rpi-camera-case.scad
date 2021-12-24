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

use <rpi-camera-parts-combined.scad>

// Globals

convexity = 4;
number_of_fragments = 0.08 * 360;
eps = 0.001;

$fn = number_of_fragments;

// Functions

// Parts

// Products

print_part("camera", with_mount_holes=true);

xmove(40)
print_part("lid", with_mount_holes=true);
