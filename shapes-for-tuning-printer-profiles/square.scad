long_edge_length = 20;

short_edge_length = long_edge_length / 2;
pad = 0.001;

difference()
{
  cube(size=long_edge_length);

  translate([(-1 * pad),
             short_edge_length,
             short_edge_length])
  {
    cube([long_edge_length + (2 * pad),
          short_edge_length + pad,
          short_edge_length + pad]);
  }
}
