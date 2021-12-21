//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             enable alpha channel
// http://www.openscad.org/cheatsheet/index.html

include <BOSL/constants.scad>    // https://github.com/revarbat/BOSL/wiki/constants.scad
include <MCAD/materials.scad>    // https://github.com/openscad/MCAD/blob/master/materials.scad#L8
use <BOSL/masks.scad>
use <BOSL/math.scad>
use <BOSL/metric_screws.scad>
use <BOSL/shapes.scad>           // https://github.com/revarbat/BOSL/wiki/shapes.scad
use <BOSL/transforms.scad>       // https://github.com/revarbat/BOSL/wiki/transforms.scad

// Globals

convexity = 4;
number_of_fragments = 0.5 * 360;
eps = 0.0002;

$fn = number_of_fragments;

hole_factor = 1.06;
no_head = 0;
chamfer = 1.5;

m3              = 3;
m4              = 4;


// Functions

// Modules

module notch(height, diameter, length, fn=$fn)
{
    hull()
    {
        cylinder(h=height, d=diameter, $fn=fn, center=true);

        translate([length, 0, 0])
        cylinder(h=height, d=diameter, $fn=fn, center=true);
    }
}

module hex_notch(height, diameter, length)
{
    notch(height, diameter, length, fn=6);
}

module duet2_loft_for_smoothieboard_holes(
    frame_width = 10,
    loft_thickness = 5,
    duet2_ymove = 0,
    duet2_standoff_height = 5
)
let(
    smoothie_hole_xspan   =  87,
    smoothie_hole_yspan   = 138,
    duet2_hole_xspan      =  92,
    duet2_hole_yspan      = 115,
    loft_x = max(smoothie_hole_xspan, duet2_hole_xspan),
    loft_y = max(smoothie_hole_yspan, duet2_hole_yspan),
    frame_edges = EDGES_BOTTOM + EDGES_Z_ALL,
    smoothie_hole         = m3,
    smoothie_hole_cut     = 2 * loft_thickness,
    duet2_hole            = m4,
    duet2_standoff_length = 12,
    duet2_standoff_width  = min(max(2 * duet2_hole, 8), frame_width),
    m4_nut_height         = 4,
    m4_nut_minor          = 6.7
)
difference()
{
    // Frame
    color("LawnGreen")
    union()
    {
        xspread(loft_x)
        cuboid(
            size = [frame_width, loft_y + frame_width, loft_thickness],
            chamfer = chamfer,
            edges = frame_edges
        );

        yspread(loft_y)
        cuboid(
            size = [loft_x + frame_width, frame_width, loft_thickness],
            chamfer = chamfer,
            edges = frame_edges
        );

        // Standoff
        xspread(duet2_hole_xspan)
        yspread(duet2_hole_yspan)
        zmove(0.5 * loft_thickness)
        cuboid(
            size = [duet2_standoff_width,
                    duet2_standoff_length,
                    duet2_standoff_height],
            fillet = 1,
            edges = EDGES_TOP + EDGES_Z_ALL,
            align = V_UP);
    }

    // Round corners
    color("Fuchsia")
    xspread(loft_x + frame_width)
    yspread(loft_y + frame_width)
    fillet_mask_z(
        l = loft_thickness,
        r = 0.5 * frame_width,
        align = ALIGN_CENTER
    );

    // Smoothieboard holes
    color(Brass)
    xspread(smoothie_hole_xspan)
    yspread(smoothie_hole_yspan)
    cyl(
        h = smoothie_hole_cut,
        d = smoothie_hole);

    // Duet2 WiFi holes
    ymove(duet2_ymove)
    xflip_copy(offset = -0.5 * duet2_hole_xspan)
    yspread(duet2_hole_yspan)
    {
        color(Steel)
        cyl(
            h = 2 * (loft_thickness + duet2_standoff_height),
            d = duet2_hole);

        // Hex nut slide-in slots
        color("Fuchsia")
        yscale(1.1)
        zmove(0.5 * abs(m4_nut_height - loft_thickness))
        hex_notch(
            height = m4_nut_height,
            diameter = m4_nut_minor,
            length = frame_width);
    }
}

// Objects

//projection(cut=true) translate([0, 0, -1])
//zrot($t * 90)
let(
    bracket_width       = 13,
    bracket_thickness   = 3,
    svg_scale           = 0.07,
    signature_thickness = 1.0
)
union()
{
    duet2_loft_for_smoothieboard_holes(
        frame_width     = bracket_width,
        loft_thickness  = bracket_thickness
    );

    // Signature
    color("yellow")
    xscale(svg_scale)
    yscale(svg_scale)
    zmove(0.5 * signature_thickness)
    linear_extrude(
        height = bracket_thickness + signature_thickness,
        center = true)
    import("hen-on-ringed-planet.svg", center = true);
}
