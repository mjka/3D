include <mjk.scad>

e=0.05;



cylinder(d=20, h=10);
tz(3+2) cube([4, 24, 4], true);



tx(60) difference()
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
    