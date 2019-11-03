include <mjk.scad>

ZigZack(n=28);


module ZigZack(w=2, ri=30, ro=40, n=40, h=10)
{
    
    pi=3.1415926;
    r1 = ri+w;
    r2 = ro-w;
    intersection() 
    {
        union()
        {        
            cylinder(r=r1+w/4, h=h);
            for(i=[1:n]) rotz(i*360/n) 
            hull() {
                x = r1 * cos(180/n);
                y = 2* r1 * sin(180/n);
                tx(r2) cylinder(r=w, h=h, $fn=12);
                tx(x) ty(-y/2) cube([w/100, y, h]);
            }
        }
        union()
        {
            difference()
            {
                cylinder(r=ro+w, h=h);
                tz(-1) cylinder(r=r2-w/4, h=h+2);
            }
            for(i=[1:n]) rotz((i-0.5)*360/n) 
            hull() {
                x = r2 * cos(180/n);
                y = 2* r2 * sin(180/n);
                tx(r1) cylinder(r=w, h=h, $fn=12);
                tx(x) ty(-y/2) cube([w, y, h]);
            }
        }
    }
}