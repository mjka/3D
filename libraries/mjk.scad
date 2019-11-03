

module tx(x) { translate([x,0,0]) children(); }
module ty(y) { translate([0,y,0]) children(); }
module tz(z) { translate([0,0,z]) children(); }
module rotx(a=90) { rotate([a,0,0]) children(); }
module roty(a=90) { rotate([0,a,0]) children(); }
module rotz(a=90) { rotate([0,0,a]) children(); }
module mx() { mirror([1,0,0]) children(); }
module my() { mirror([0,1,0]) children(); }
module mz() { mirror([0,0,1]) children(); }
module cmx() { children(); mirror([1,0,0]) children(); }
module cmy() { children(); mirror([0,1,0]) children(); }
module cmz() { children(); mirror([0,0,1]) children(); }

module prism(dim)
{
  translate([0,dim.y,0])
  rotate([90,0,0])
  linear_extrude(dim.y) 
  polygon([[0, 0], [dim.x, 0], [0, dim.z]]);
}

module parallelogram(dim, shift_x)
{
  assert(shift_x < dim.x);
  translate([0,dim.y,0])
  rotate([90,0,0])
  linear_extrude(dim.y) 
  polygon([[0, 0], [dim.x-shift_x, 0], [dim.x, dim.z], [shift_x, dim.z]]);  
}

module tower(h, d)
{
  eps = 1.001;
  for (i=[1:len(h)-1])
    tz(h[i-1]) cylinder(h=eps*(h[i]-h[i-1]), d1=d[i-1], d2=d[i]);
}

module cubec(dim, chamfer=[0,0,0], center)
{
    tr = center ? [0,0,0] : [dim[0]/2, dim[1]/2, dim[2]/2];
    
    inn=dim- 2 * chamfer;
    assert(inn[0] > 0);
    assert(inn[1] > 0);
    assert(inn[2] > 0);
    translate(tr) 
    union()
    {
    hull()
        {
            cube([inn[0], inn[1], dim[2]], center=true);
            cube([inn[0], dim[1], inn[2]], center=true);
            cube([dim[0], inn[1], inn[2]], center=true);
        }
    }
}


module cubech2(dim, ch1=0, ch2=0, center=false)
{
    tr = center ? [0,0,0] : [dim[0]/2, dim[1]/2, dim[2]/2];
    
    inn=dim- 2 * [ch1, ch1, ch2];
    inn2=dim- 2 * [ch2, ch2, ch2];
    assert(inn[0] > 0);
    assert(inn[1] > 0);
    assert(inn[2] > 0);
    translate(tr) 
    union()
    {
    hull()
        {
            //cube([inn2[0], inn[1], dim[2]], center=true);
            cube([inn2[0], inn2[1], dim[2]], center=true);
            cube([inn[0], dim[1], inn[2]], center=true);
            cube([dim[0], inn[1], inn[2]], center=true);
        }
    }
}
module cubech(dim, edge=0, top=0, bottom=0, center=false)
{
    tr = center ? [0,0,0] : dim/2;
    
    inn=dim- [2*edge, 2*edge, top+bottom];
    //assert(inn[0] > 0);
    //assert(inn[1] > 0);
    //assert(inn[2] > 0);
    translate(tr) 
    union()
    {
    hull()
        {
            tz((bottom-top)/2) cube([dim.x, inn.y, inn.z], center=true);
            tz((bottom-top)/2) cube([inn.x, dim.y, inn.z], center=true);
            tz(bottom/2) cube([dim.x-2*top, dim.y-2*edge, dim.z-bottom], center=true);
            tz(bottom/2) cube([dim.x-2*edge, dim.y-2*top, dim.z-bottom], center=true);
            tz(-bottom/2) cube([dim.x-2*bottom, dim.y-2*edge, dim.z-top], center=true);
            tz(-bottom/2) cube([dim.x-2*edge, dim.y-2*bottom, dim.z-top], center=true);
        }
    }
}

//cubech2([20, 30, 10], 0, 1);

module cube_fillet(dim, fil=[0,0,0], center)
{
  cubec(dim, fil, center);
}


module cube_round(dim, r, center=false)
{
  tr = center ? [0,0,0] : [dim[0]/2, dim[1]/2, dim[2]/2];  
  inn = dim - [2 * r, 2*r, 0];
  assert(inn[0] > 0);
  assert(inn[1] > 0);
  assert(inn[2] > 0);
  translate(tr) 
  union()
  {
    cube([inn[0], dim[1], dim[2]], center=true);
    cube([dim[0], inn[1], dim[2]], center=true);
    for(x=[-1,1]) 
      for(y=[-1,1])
        translate([x*(dim.x/2-r), y*(dim.y/2-r),0])
          cylinder(dim[2], r, r, center=true);     
  }
}

module cube_round3(dim, r, center=false)
{
  tr = center ? [0,0,0] : [dim[0]/2, dim[1]/2, dim[2]/2];  
  inn = dim - 2 * r * [1,1,1];
  assert(inn[0] > 0);
  assert(inn[1] > 0);
  assert(inn[2] > 0);
  translate(tr) 
  hull()
  {
    cube([inn[0], inn[1], dim[2]], center=true);
    cube([inn[0], dim[1], inn[2]], center=true);
    cube([dim[0], inn[1], inn[2]], center=true);
    for(x=[-1,1]) 
      for(y=[-1,1])
        for(z=[-1,1])
          translate([x*(dim.x/2-r), y*(dim.y/2-r),z*(dim.z/2-r)])
            sphere(r);     
  }
}

module hull_tower()
{
  for(i=[1:$children-1])
  {
    hull()
    {
      children(i-1);
      children(i);
    }
  }
}


module hull_loop()
{
  for(i=[1:$children-1])
  {
    hull()
    {
      children(0);
      children(i);
    }
  }
}


module gewinde(h, d, s, slices=500, scale=1)
{
  turns = h / s;
  
  linear_extrude(height=h, center=false, twist=-turns * 360, slices=slices, scale=scale)
  translate([s/4,0,0]) circle(d/2-s/4);
}


module hex(h, w)
{
  translate([0,0,h/2])
  union()
    for (a=[0, 60, 120])
      rotate(a, [0,0,1])  
        cube([w, w*tan(30), h], center=true);
}

module ring_segment(h, r1, r2, a_start, a_stop, $fn=30)
{
  step = (a_stop-a_start-0.01) / $fn;
  l1 = [for (w =[a_start:step:a_stop]) [r1*sin(w), r1*cos(w)]];
  l2 = [for (w =[a_stop:-step:a_start]) [r2*sin(w), r2*cos(w)]];
  l = concat(l1, l2);
  linear_extrude(h, convexity=5)
  {
      polygon(l);
  }
}


module Schraube(m=4, h=30, mutter=5, kopf=5)
{
    //      0  1    2  3    4  5  6   7   8   9   10  11  12
    maul = [0, 2.5, 4, 5.5, 7, 8, 10, 11, 13, 15, 17, 18, 19];
    d_mutter = maul[m];
    r_loch = m  * 0.53;
    r_kopf = maul[m] * 0.54;
    union() 
    {
        translate([0, 0, h- mutter/2]) hex(2*mutter, d_mutter);
        cylinder(h, r_loch, r_loch);
        translate([0, 0, 0]) cylinder(kopf, r_kopf, r_kopf);
    }
}

//ty(20) WSL10();
//WSG10();

module WSG10(add=0, snap=0.6)
{
  color("darkgrey") tz(-9-add) difference()
  {
    tz(4.5+add/2) cube([20.4, 9., 9]+add*[1,1,1], true);
    cmx() tx(17.8/2+1) cube([2, 3.5, 6.4*2]+add*[1,1,1], true);
  }
  color("darkgreen") hull()
  {
    cube([20.4-2*snap+add, 9+add, 0.5], true);
    tz(3) cube([20.4+1+add, 9+add, 0.5], true);
  }
  color("gold") tz(-10) cube([12., 4.5, 4], true);
}

module WSL10(add=0, snap=0.6)
{
  color("lightgrey") tz(-14-add) difference()
  {
    tz(7+add/2) cube([21.4, 8.6, 14]+add*[1,1,1], true);
    ty(-4) cube([13, 2, 5.5]+add*[1,1,1], true);
  }
  color("darkgreen") hull()
  {
    cube([21.4-2*snap+add, 8.6+add, 0.5], true);
    tz(3) cube([21.4+1+add, 8.6+add, 0.5], true);
  }
}


module Getriebemotor()
{
  rotx(-90)
  {
    tx(64/2-11)cube_round([65, 23, 19], 3.5, center=true);
    color("white") cylinder(h=36.5, d=6.5, center=true);
    tx(11) cylinder(19/2+2, 2, 2);
    tx(30) ty(-3) cube([5, 6, 19/2+2]);
    tx(30) ty(-7) tz(-3-19/2) cube([23, 14, 5]);
    tz(-1) cube([32, 5.5, 3], true);
    
    tx(19.8) ty(+17.5/2) tz(-16) Schraube(m=3, h=32, mutter=5, kopf=3);
    tx(19.8) ty(-17.5/2) tz(-16) Schraube(m=3, h=32, mutter=5, kopf=3);
    //tx(60) ty(+11) tz(-16) Schraube(m=3, h=32, mutter=16, kopf=8);
    //tx(60) ty(-10) tz(-16) Schraube(m=3, h=32, mutter=16, kopf=8);  
  }
}

