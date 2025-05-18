include <BOSL/constants.scad>
use <BOSL/threading.scad>
use <BOSL/transforms.scad>

id = 90;
od = 180;
height = 30;
wall_thickness = 3;
thread_overlap = 10;
thread_od = id + 5;
nut_od = thread_od + 5;
led_hole_d = 6;
opening_hole_d = 25;

thread_depth = 1;
thread_angle = 30;
thread_pitch = 10;
thread_slop = 0.5;

$fs=0.5;
$fa=0.5;

*side();
*preview_splode();
preview();
*cutaway();

module preview() {
    zrot(180)
      color("red")
        lower();

    up(height + wall_thickness * 2)
      xrot(180)
        upper();
}


module preview_splode() {
    zrot(180)
      color("red")
        lower();

    up((height + wall_thickness * 2) * 2)
      xrot(180)
        upper();
}

module cutaway() {
  intersection() {
    union() {
    zrot(180)
      color("red")
        lower();

    up(height + wall_thickness * 2)
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
      for (rot = [0: 30: 360]) {
        zrot(rot)
          left((nut_od+ led_hole_d * 2)/2)
            cylinder(d=led_hole_d, h=wall_thickness + smidge * 2);
        }

      opening_h = (od - nut_od)/2 - 16;
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
        cylinder(d1=id + 5, d2=id, h=wall_thickness + smidge);
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
            trapezoidal_threaded_nut(od=nut_od, id=thread_od, h=height - thread_overlap, pitch=thread_pitch, slop=thread_slop, thread_depth=thread_depth, thread_angle=thread_angle, align=V_TOP);
            cylinder(d=nut_od, h=height);
          }
      }
      side();
    }
    translate([0, 0, -smidge])
      cylinder(d=id, h=height + wall_thickness * 2);
    }
}
