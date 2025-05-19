include <BOSL/constants.scad>
use <BOSL/threading.scad>
use <BOSL/transforms.scad>

// Spool inner diameter (mm)
id = 90;
// Spool outer diameter (mm)
od = 180;
// Space between the two sides (mm)
width = 30;
// Thickness of the sides (mm)
wall_thickness = 3;

// LED hole diameter (mm)
led_hole_d = 6;
// The arc size of the opening in the sides (degrees)
opening_arc = 30;

// Blank area before the threading starts (mm)
thread_margin = 10;

/* [Hidden] */
thread_od = id + 5;
nut_od = thread_od + 5;

opening_top = od/2 - 4;
opening_bottom = nut_od/2 + led_hole_d * 2;
opening_h = opening_top - opening_bottom;
opening_rounding = min(10, opening_h / 4);
opening_w_t = 2 * opening_top * abs(sin((opening_arc - 2)/2));
opening_w_b = 2 * opening_bottom * abs(sin((opening_arc - 4)/2));

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

    up(width + wall_thickness * 2)
      xrot(180)
        upper();
}


module preview_splode() {
    zrot(180)
      color("red")
        lower();

    up((width + wall_thickness * 2) * 2)
      xrot(180)
        upper();
}

module cutaway() {
  intersection() {
    union() {
    zrot(180)
      color("red")
        lower();

    up(width + wall_thickness * 2)
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
      for (rot = [0: opening_arc : 360]) {
        zrot(rot)
          left((nut_od + led_hole_d * 2)/2)
            cylinder(d=led_hole_d, h=wall_thickness + smidge * 2);
        }

      for (rot = [0: opening_arc : 360]) {
        zrot(rot)
          left(nut_od/2 + led_hole_d * 2)
            linear_extrude(height=wall_thickness + smidge * 2)
              zrot(90)
                round2d(opening_rounding) {
                  polygon([[-opening_w_b/2, 0], [-opening_w_t/2, opening_h], [opening_w_t/2, opening_h], [opening_w_b/2, 0]]);
                }
        }
      }
      // bevel the inner edge for comfort
      down(wall_thickness/2)
        cylinder(d1=id + 5, d2=id, h=wall_thickness + smidge);
    }
}

module lower() {
  difference() {
    union() {
      up(wall_thickness) {
        up(thread_margin)
          trapezoidal_threaded_rod(d=thread_od, l=width - thread_margin, pitch=thread_pitch, thread_depth=thread_depth, thread_angle=thread_angle, align=V_TOP);
        cylinder(d=nut_od, h=thread_margin);
      }
      side();
    }
    translate([0, 0, -smidge])
      cylinder(d=id, h=width + wall_thickness * 2);
    }
}

module upper() {
  difference() {
    union() {
      up(wall_thickness) {
          intersection() {
            trapezoidal_threaded_nut(od=nut_od, id=thread_od, h=width - thread_margin, pitch=thread_pitch, slop=thread_slop, thread_depth=thread_depth, thread_angle=thread_angle, align=V_TOP);
            cylinder(d=nut_od, h=width);
          }
      }
      side();
    }
    translate([0, 0, -smidge])
      cylinder(d=id, h=width + wall_thickness * 2);
    }
}
