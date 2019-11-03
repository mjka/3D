$fn=50;
d=0.05;
eps = 0.05;

ringe = 6;
ring_breite = 3;
ring_kleinster = 10;
ring_groesster = ring_kleinster + ringe * ring_breite;
ring_fundament_pc = 40;
ring_dach_pc = 40;

ring_hoehe = 3;
ring_dach_hoehe = 1;

include <mjk.scad>

*color("lightgreen") tz(ring_hoehe+ring_dach_hoehe) rotate([180, 0, 90]) Pad();
*color("lightblue") Fassung();  
*intersection()
{
  color("purple") Base();
  color("pink") tz(3) Dorn();
  color("red") tz(-5) Feder();
}

tz(5) tx(-70) Fassung();
ty(70) Pad();
tz(17) tx(70) Base();
translate([40, 25, 15]) Dorn();

translate([70, 60, 2]) Feder();

module Pad()
{
  difference()
  {
    union()
    {
      // Pad 
      tz(0.2) cube_round([80,60,0.4], 10, center=true);
      tz(0.6) cube_round([75,58,0.4], 10, center=true);
      
      // Kegel, außen
      difference()
      {
        r1 = 35;
        r2 = ring_groesster+ring_breite * ring_fundament_pc / 100 / 2;
        r3 = ring_groesster-ring_breite * ring_fundament_pc / 100 / 2;    
        cylinder(ring_hoehe-d, r1, r2);
        cylinder(ring_hoehe,r3, r3); 
      }
      
      for (ring_nr = [0:2:ringe])
      {
        ring = ring_kleinster + ring_nr * ring_breite;    
        b = ring_breite * ring_fundament_pc / 100 / 2;
        // Durchgehender Ring
        ring_segment(ring_hoehe, ring-b, ring+b, 0, 360, $fn=50);
        
        // Dächer
        d = ring_breite * (ring_fundament_pc/2+ring_dach_pc) / 100 ;
        r1 = ring_nr == 0 ? ring : ring-d;
        r2 = ring_nr == ringe ? ring : ring+d;
        for (w=[0:90:270]) // 4 Segmente
        {
          for (o=[0:0.25:1]) // Stufen, damit es besser rein geht
          {
            color([o, 1-o, 1])
            tz(ring_hoehe - ring_dach_hoehe + o)
            ring_segment(ring_dach_hoehe-o, r1, r2, w-17-5*o, w+17+5*o, $fn=50);
          }
        }
      }
      cylinder(ring_hoehe, ring_kleinster, ring_kleinster);
    }
    // Zentrierloch
    tz(-eps) cylinder(ring_hoehe+2*eps, 3, 5);
  }
}



module Fassung()
{
//translate([0,0,1])
  difference()
  {
    union()
    {
  //translate([0,0,ring_hoehe])
      tz(-5+eps)
  {
    //ring_segment(5, 10, ring_groesster,90-22, 270+22);
    //ring_segment(5, 10, ring_groesster,-22, +22);
    cylinder(5, ring_groesster,  ring_groesster);
    translate([0,-30,2.5]) cube([2*ring_groesster, 60, 5], center=true);
    //translate([-10,0,2.5]) cube([80, 18, 5], center=true);
    //translate([-20,30,2.5]) cube([50, 8, 5], center=true);
    
  }

    for (ring_nr = [1:2:ringe])
    {
      ring = ring_kleinster + ring_nr * ring_breite;        
      b = ring_breite * ring_fundament_pc / 100 /2;
      // Durchgehender Ring
      ring_segment(ring_hoehe, ring-b, ring+b, 0, 360);
      
      d = ring_breite * (ring_fundament_pc/2+ring_dach_pc) / 100 ;
      r1 = ring_nr == 0 ? ring : ring-d;
      r2 = ring_nr == ringe ? ring : ring+d;
      tz(ring_hoehe - ring_dach_hoehe)
      for (w=[0:90:270])
        ring_segment(ring_dach_hoehe, r1, r2, w-20, w+20, $fn=50);
      }
    }
    tz(-6)
    {
      ring_segment(20, -1+ring_groesster-2*ring_breite, 1+ring_groesster, 20, 90-20);
      ring_segment(20, -1+ring_groesster-2*ring_breite, 1+ring_groesster, 90+20, 180-20);
      cylinder(20, 5.2, 5.2);
    } 
    
  }
}


module Dorn()
{
  difference()
  {
    union()
    {
      tz(-15) cylinder(15, 5,5);
      cylinder(3, 5,3);
      tz(-5-ring_hoehe-1) cylinder(1, 5, 6);
    }
    tz(-30)cylinder(30, 4, 4);
  }
}


module Feder()
{
  r1 = 0.5+ring_groesster-2*ring_breite;
  r2 = ring_groesster-0.5;
  for (a=[0,90])
    tx(-0.5) ring_segment(5+ring_hoehe, r1, r2, a+25, a+90-25); // Stöpsel
  
  
  tz(-2) ring_segment(2, ring_groesster, ring_groesster-5, 0, 360); // Ring
  tz(-2) ty(-10) tx(ring_groesster-6) cube_round([20, 20, 2], 8); //Hebel
  tx(-25) ty(-10) tz(-2) cube([18, 20, 2]); // Befestigung
}

module Base()
{  
  tz(-5) difference()
  {
    union()
    {
      tz(-10) ring_segment(10-eps, 5.2, 15, 0, 360);
      tx(-15) ty(-60) tz(-12) cube([30, 60, 12-eps]);
    }
    // Ausschnitt für den Dorn
    cylinder(100, 5.2, 5.2, true);
    // Ausschnitt für den Stop-Keil    
    tz(-3-1) cylinder(3+1+1, 7.3, 7.3);
    // Ausschnitt für die Feder
    tx(-25) ty(-10) tz(-2.2) cube([18.3, 20.2, 10]);tx(-0.5)
    tz(-4) ring_segment(10, -1+ring_groesster-2*ring_breite, ring_groesster+2, 90, 270);
  }
  // Stöpsel in der Mitte vom Dorn
  tz(-15) ring_segment(10, 3, 3.8, 0, 360);
  // Deckel
  tz(-15-2) cylinder(2+eps, 14, 15);
}

/*module ring_segment(h, r1, r2, a_start, a_stop)
{
    step = (a_stop-a_start-0.05) / ($fn / 180 * abs(a_stop-a_start));
    l1 = [for (w =[a_start:step:a_stop]) [r1*sin(w), r1*cos(w)]];
    l2 = [for (w =[a_stop:-step:a_start]) [r2*sin(w), r2*cos(w)]];
    l = concat(l1, l2);
    linear_extrude(h) 
    {
        polygon(l);
    }
}
*/
