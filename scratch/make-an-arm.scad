//  Characters    Behavior
//     //            ignore, comment
//     $fa           minimum angle
//     *             disable
//     !             show only
//     #             highlight / debug
//     %             transparent / background
// http://www.openscad.org/cheatsheet/index.html

// Globals

// Functions

function get_x(r, in, last_in) =
      r * ( in / last_in );
    //r * ( cos(-90 + in));

function get_y(r, in, last_in) = 
      r * ( in / last_in );
    //r * ( cos(-90 + in));

function get_z(r, in, last_in) =
    r*in/last_in * (1+cos(in*180/last_in+60) + (in/last_in/2));
    //r * (in / last_in) + (1 * (choke(in, last_in, last_in, 0.1)));
    //1;

    //choke_out * (abs(in-choke_in)/90);
function choke(in, last_in, choke_in, choke_out) = 
    //1;
    (in < choke_in) ? 
        (last_in/10)*-sin(in*4) + in/last_in : 
        (last_in/16)*-cos(-90+in*4) + in/last_in;

// Modules

// Objects

*linear_extrude(height = 10, convexity = 10, twist = 90)
translate([5, 0, 0])
square(8);

module line3D(p1, p2, thickness, fn = 24) {
    $fn = fn;

    hull() {
        translate(p1) sphere(thickness / 2);
        translate(p2) sphere(thickness / 2);
    }
}

module polyline3D(points, thickness, fn) {
    module polyline3D_inner(points, index) {
        if(index < len(points)) {
            line3D(points[index - 1], points[index], thickness, fn);
            polyline3D_inner(points, index + 1);
        }
    }

    polyline3D_inner(points, 1);
}

radius = 150;
sweep_degrees = 90;

points = [
    for(degree = [0:sweep_degrees]) 
        [
         get_x(radius, degree, sweep_degrees),
         get_y(radius, degree, sweep_degrees),
         (get_z(40, degree, sweep_degrees)) + 4
        ]
];

first = 1;
last  = 16;
union()
{
for(arm = [0:7])
{
    #rotate(45 * arm) polyline3D(points, 12, 4);
    for(smear = [first:2:last-1])
    {
        rotate(45 * arm+smear) polyline3D(points, 4+(last-abs(smear-(first+last)/2)), 8);
    }
    #rotate(45 * arm+last) polyline3D(points, 12, 4);
}
}