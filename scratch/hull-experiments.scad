module pipe(
  length,
  radius)
{
  distance = length - (2*radius);
  hull()
  {
    translate([0,0,0])
    {
      sphere(r=radius);
    }

    translate([0,0,distance])
    {
      sphere(r=radius);
    }
  }
}


module wall2D(thickness)
{
  difference()
  {
    offset(thickness)
    {
      children(0);
    }

    children(0);
  }
}


module elbowinator(
  angle,
  bendRadius,
  clipBounds=1000,
  convexity=4)
{
  intersection(convexity=convexity)
  {
    rotate_extrude(convexity=convexity)
    {
      translate([bendRadius, 0, 0])
      {
        children(0);
      }
    }

    linear_extrude(
      height=clipBounds,
      slices=2,
      center=true)
    {
      wedge2D(angle, clipBounds);
    }
  }
}

module wedge2D(
  angle,
  radius,
  nSides=3)
{
  polygon(
    points=concat(
      [[0,0]],
      [for(i=[0:nSides])
          radius*[cos(i/nSides*angle), sin(i/nSides*angle)]]),
    convexity=4);
}

/*
//   50 mm elbow
translate([0, 0, 25])
{
  elbowinator(
    angle=90,
    bendRadius=50)
  {
    wall2D(thickness=2.4)
    {
      circle(r=22.8);
    }
  }
}
//*/


/*
//   '?' shaped hook
translate([0,60,0])
{
  rotate_extrude(angle=270, convexity=10)
  {
    translate([40, 0])
    {
      circle(10);
    }
  }
}

rotate_extrude(angle=90, convexity=10)
{
  translate([20, 0]) circle(10);
}

translate([20,0,0])
{
  rotate([90,0,0])
  {
    cylinder(r=10,h=80);
  }
}
//*/

/*
//   circle to oval
linear_extrude(
  height = 50,
  center = false,
  convexity = 10,
  scale=[1,5],
  $fn=100)
{
  translate([50, 0, 0])
  {
    circle(r = 10);
  }
}
//*/

/*
//   triangle to 2D line
linear_extrude(
  height=30,
  scale=[1, 0.1],
  slices=20,
  twist=0)
{
  polygon(
    points=[[0,0], [20,10], [20,-10]]);
}
//*/


/*
//   elbow with hemisphere caps
union()
{
  pipe(
    length=20,
    radius=5);

  rotate([90,0,0])
  {
    pipe(
      length=20,
      radius=5);
  }
}
//*/

///*
//   square elbow
$fn=20;
difference()
{
  // Main Cube
  cube (size = [50,50,30]);

  // Small cube for mounting flat
  translate (v=[30,30,5])
  {
    cube (size = [22,22,32]);
  }

  // Mounting hole
  translate (v=[40,40,-2])
  {
    cylinder(h = 10, r=3);
  }

  // Elbow
  translate([45,45,15])
  {
    #rotate_extrude()
    {
      translate([33,0,0])
      {
        circle(r=11);
      }
    }
  }
  
}
//*/

/*
//   elbow
difference()
{
  intersection()
  {
    translate([0,0,0])
    {
      rotate_extrude()
      {
        translate([33,0,0])
        {
          circle(r=11);
        }
      }
    }

    translate([0,0,-25])
    {
      cube ([50,50,50]);
    }
  }

  intersection()
  {
    translate([0,0,0])
    {
      rotate_extrude()
      {
        translate([33,0,0])
        {
          circle(r=8);
        }
      }
    }

    translate([0,0,-25])
    {
      cube ([50,50,50]);
    }
  }
}
//*/

