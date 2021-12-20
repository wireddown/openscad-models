long_edge_length = 20;

short_edge_length = long_edge_length / 2;
mini_edge_length = long_edge_length / 4;
pad = 0.001;

difference()
{
  cube(size=long_edge_length);

  color("#0000FF")
  {
  translate([(-1 * pad),
             short_edge_length,
             short_edge_length])
  {
    cube([long_edge_length + (2 * pad),
          short_edge_length + pad,
          short_edge_length + pad]);
  }

  translate([(-1 * pad),
             long_edge_length - mini_edge_length,
             mini_edge_length])
  {
  cube([long_edge_length + (2 * pad),
        mini_edge_length + pad,
        mini_edge_length + pad]);
  }
  }

  color("#FF6600")
  {
    rotate([0,
            0,
            -90])
  {
    translate([(-1 * pad) - long_edge_length,
               short_edge_length,
               short_edge_length])
    {
      cube([long_edge_length + (2 * pad),
            short_edge_length + pad,
            short_edge_length + pad]);
    }

    translate([(-1 * pad) - long_edge_length,
               long_edge_length - mini_edge_length,
               mini_edge_length])
    {
      cube([long_edge_length + (2 * pad),
            mini_edge_length + pad,
            mini_edge_length + pad]);
    }
  }
  }
}