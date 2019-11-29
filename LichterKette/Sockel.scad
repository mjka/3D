include <mjk.scad>

e=0.05;

tx(60) Sockel();
tx(60) ty(100)  Kugel1();

//sphere(60, $fn=10);

AddSockel(24) difference() {Star3d(30); Star3d(29); }
//Star3d(30);

module Star3d(r=30)
{
for (a=[7.5:15:90]) 
{
  step = 360/ (12.6*cos(a)+1) ;
    echo(step);
    for(b=[0:step:360]) rotz(b) rotx(a) 
   hull(){
       cube([.1,2*r,.1], true); 
       rotx(90) cylinder(r=r/3, h=2*(r*0.7), center=true, $fn=6);
       //sphere(r-2); 
   }
}
}

module AddSockel(h=27)
{
    Sockel();
    difference()
    {
        tz(h) children();
        tz(-50) cube(100, true); 
        mz() cylinder(d=25, h=60);

    }

}

module Kugel1()
{
    Sockel();
    tz(27) difference()
    {
        union()
        {
            sphere(d=60);
            color("red") for (a=[0:36]) rotz(a*10) rotx(a*10) roty(a*3) 
            cylinder(d=61, h=1, center=true);
        }
        sphere(d=59);
        mz() cylinder(d=25, h=60);
        tz(-50-27) cube(100, true);
    }
}


tx(100) union()
{
    cylinder(d=10, h=30);
    cylinder(d=20, h=10);
    tz(3+2) cube([4, 24, 4], true);
}



module Sockel()
{
    tz(10) rotx(180) difference()
    {
        cylinder(d=30, h=10);
        tz(-1) cylinder(d=21, h=12);
        tz(5+2) cube([25, 5, 10], true);
        tz(3.5+2) cube([5, 25, 7], true);
        hull() {
            tz(8) cube([25, 5, e], true);
            tz(10) cube([27, 7, e], true);
        }
        
        for (a=[0,180]) rotz(a) tz(2) intersection()
        {
            cube(40); 
            cylinder(d=25, h=5);
        }
    }
}
