use <../BOSL/threading.scad>
use <../BOSL/transforms.scad>
include <../BOSL/constants.scad>

id = 70;
od = 190;
height = 40;
wall_thickness = 4;
thread_overlap = 10;
nut_od = id + 15;
thread_od = id + 10;
led_hole_d = 6;
opening_hole_d = 25;

thread_depth = 3;
thread_angle = 30;
thread_pitch = 10;

$fs=0.5;
$fa=0.5;

*side();
*preview_splode();
preview();

module preview() {
    zrot(180)
    color("red")
    lower();

    up(68)
    xrot(180)
    upper();
}


module preview_splode() {
    zrot(180)
    color("red")
    lower();

    up(150)
    xrot(180)
    upper();
}

module cutaway() {
  intersection() {
    union() {
    zrot(180)
    color("red")
    lower();

    up(78)
    xrot(180)
    upper();
    }
    cube([200, 200, 200]);
  }
}

smidge = 0.01;

module side() {
  difference() {
    cylinder(d=od, h=wall_thickness);
    down(smidge) {
      for (rot = [0: 15: 360]) {
        zrot(rot)
          left((nut_od+ led_hole_d * 2)/2)
            cylinder(d=led_hole_d, h=wall_thickness + smidge * 2);
        }

      opening_h = (od - nut_od)/2 - 18;
      opening_w_t = 40;
      opening_w_b = 22;
      for (rot = [0: 30: 360]) {
        zrot(rot)
          left(nut_od/2 + led_hole_d * 2)
            linear_extrude(height=wall_thickness + smidge * 2)
              zrot(90)
                round2d(10) {
                  polygon([[-opening_w_b/2, 0], [-opening_w_t/2, opening_h], [opening_w_t/2, opening_h], [opening_w_b/2, 0]]);
                }
        }
      }
      down(wall_thickness/2)
        cylinder(d1=id + 10, d2=id, h=wall_thickness + smidge);
    }
}

module lower() {
  difference() {
    union() {
      up(wall_thickness) {
        up(thread_overlap)
          trapezoidal_threaded_rod(d=thread_od, l=height - thread_overlap, pitch=thread_pitch, thread_depth=thread_depth, thread_angle=thread_angle, align=V_TOP);
        cylinder(d=nut_od, h=thread_overlap);
      }
      side();
    }
    translate([0, 0, -smidge])
      cylinder(d=id, h=height + wall_thickness * 2);
    }
}

module upper() {
  difference() {
    union() {
      up(wall_thickness) {
          intersection() {
            trapezoidal_threaded_nut(od=nut_od, id=thread_od, h=height - thread_overlap, pitch=thread_pitch, thread_depth=thread_depth, thread_angle=thread_angle, align=V_TOP);
            cylinder(d=nut_od, h=height);
          }
      }
      side();
    }
    translate([0, 0, -smidge])
      cylinder(d=id, h=height + wall_thickness * 2);
    }
}
