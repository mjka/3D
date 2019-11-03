include <mjk.scad>

mgap = 0.5;
l = 40; lr = 10;
m1 = 1; // Metall-Dicke an der Halterung
m2 = 1; // Metall-Dicke an der Handyhuelle
p1 = 0.5; // platic thicknes against the phone (scratch protection)
e=0.01;

x = 65; y = 100; z=3;

difference()
{
  tz(0.25) hull() // base body
  {
    cube_round([x, y, 0.5], 10, center=true);
    tz(z-0.5) cube_round([x-8, y-10, 0.5], 10, center=true);
  }  
  rr = sqrt(2)*(l-2*lr)+2*lr;
  // place for the holder plate to rotate
  tz(p1-e) cylinder(d=mgap+rr, h=m1+2*e);  
  // the phone plate
  color("grey") tz(p1+m1) cube([x-15, y-25, m2], center=true);
  // cutout to slide holder in
  tz(5+0.5) cube_round([l+mgap, l+mgap, 10], lr, true);
  tz(-e) cube(50); // DEGUB
}


// the phone plate
tx(60) color("grey") difference()
{
  cube([x-15, y-25, m2], center=true);
  tz(-1) cube_round([l+mgap, l+mgap, 10], lr, true);
}

tx(60) ty(70) difference()
{
  color("grey") rotz(45) tz(m1/2) cube_round([l-mgap, l-mgap, m1], lr, true);
  for(a=[0:90:360]) rotz(a) tx(10) tz(-e) cylinder(h=m1+2*e, d1=4, d2=7);
}



tx(-80) 
{
  difference()
  {
    tz(10) union() 
    {
      // holder plate 
      *color("grey") rotz(45) tz(hh+m1/2) cube_round([l-mgap, l-mgap, m1], lr, true);
      hh = z-p1-m1;
      cylinder(d=l-mgap, h=hh); // round standoff
    
      tz(-5) cube_round([1.6*l, 1.6*l, 10], 15, center=true);
    }
    for(a=[0:90:360]) rotz(a) tx(10) tower([-1, 10, 13], [3, 3, 8]); // screw holes
    // magnets
    color("silver") tz(10-3) for(a=[45:90:360]) rotz(a) cmx() ty(6+l/2) tx(6) cylinder(d=10, h=3+e);
  }
}
