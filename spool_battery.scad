use <BOSL/transforms.scad>
use <spool.scad>

battery_box = [53, 80, 22.5];

id = 69; // nice
od = id + 30;
width = 20;

$fs=0.5;
$fa=0.5;

smidge = 0.01;

a_side_battery();
*b_side_battery();


module mockup() {
    translate([0, width/2 + 3 /* wall thickness? */, 0])
        rotate([90, 0, 0])
            preview_ch(id = id, od=od, width=width) {
                a_side_battery();
                b_side_battery();
            }
    battery_box_mockup();
}

module b_side_battery() {
    b_side(id=id, od=od, width=width, side_holes=false);
}

module a_side_battery() {
    battery_cutout = battery_box + [18, 0, 1];
    difference() {
        union() {
            a_side(id=id, od=od, width=width, side_holes=false);
            cylinder(d=id + 3, h=width + 3);
            cylinder(d=id, h=width + 6);
        }
        cutout_in = 11;
        for (y = [-id/2 + cutout_in, id/2 - cutout_in])
            translate([0, y, -smidge])
                cylinder(d=20, h=width * 2);

        for (rot = [0 : 90 : 360])
            rotate([0, 0, rot])
            translate([0, id/2 + 4, -smidge])
                cylinder(d=5, h=8 + smidge*2);
        intersection() {
            difference() {
                union() {
                    rotate([90, 0, 0])
                        translate(-battery_cutout/2)
                            cube(battery_cutout);

                    translate([13, -18, 0])
                        rotate([0, 0, -45])
                            down(1)
                                cube([10, 20, width * 2]);
                }
                translate([battery_box.x/2, -battery_cutout.z/2 + 10, 0])
                    cube([10, battery_cutout.z - 10, width*2]);
                left_bump = [7, 5];
                translate([-battery_cutout.x/2, battery_cutout.z/2 - left_bump.y, 0])
                    cube([left_bump.x, left_bump.y, width*2]);
            }
            translate([0, 0, -1])
            cylinder(d=id, h=width + 10);
        }
    }
}

module battery_box_mockup() {
    hinge_middle_spacing = 16;
    hinge = [10, 24, 14];
    translate(-battery_box/2)
    cube(battery_box);
    latch_actuate = 0;
    //latch_actuate = 180 + 45;

    // Latch
    latch = [6, 24, 7];
    latch_middle_spacing = 16;
    latch_handle = [5, 12, 16];
    for (m = [0, 1])
        mirror([0, m, 0])
            translate([-battery_box.x/2, latch_middle_spacing/2, 0]) {
                translate([-latch.x, 0, battery_box.z/2 - latch.z])
                    cube(latch);
               
                translate([-latch_handle.x/2, latch.y /2 - latch_handle.y/2 , battery_box.z/2 - latch_handle.x/2]) 
                rotate([0, latch_actuate, 0])
                translate([-latch_handle.x/2, 0, -latch_handle.z + latch_handle.x /2 ])
                union() {
                    cube(latch_handle);
                    translate([2, 0, 0])
                    rotate([0, 180 + 45, 0])
                        cube([2, latch_handle.y, 4]);
                }
            }

    // Hinge
    for (m = [0, 1])
        mirror([0, m, 0])
            translate([battery_box.x/2, hinge_middle_spacing/2, -hinge.z/2 + 1])
                rotate([0, -40, 0])
                cube(hinge);
}