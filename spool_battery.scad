use <BOSL/transforms.scad>
use <spool.scad>

battery_box = [49, 80, 22.5];

id = 66;
od = id + 25;
width = 22;
cutout_dia = 18;
cutout_in = 11;

// spool side walls
wall_thickness = 2;

$fs=0.5;
$fa=0.5;

smidge = 0.01;

*a_side_battery();
*b_side_battery();
mockup();

*cutaway_ch(id=id, od=od, width=width, wall_thickness=wall_thickness) {
    a_side_battery();
    b_side_battery();
}

module mockup() {
    translate([0, width/2 + wall_thickness, 0])
        rotate([90, 0, 0]) {
            preview_ch(id = id, od=od, wall_thickness, width=width) {
                a_side_battery();
                b_side_battery();
            }
            translate([0, 0, -wall_thickness * 2])
                cover();
        }
    battery_box_mockup();
}

module cover() {
    cover_thickness = 1.5;
    cover_width = width + wall_thickness * 2;
    side_wall = 1;
    lip = 5;
    // shrink the diameter so it's springy when in its default state
    od = od - 5;

    light_hole = 5;

    angle_extra = 3;

    total_width = cover_width + side_wall + angle_extra * 2 + side_wall;

    difference() {
        // outer perimeter
        union() {
        rotate_extrude(360, 1)
        zrot(90)
        translate([0, od/2 + 0.5])
        translate([0, cover_thickness])
        mirror([0, 1])
        polygon([
            [0, 0],
            [0, lip],
            [side_wall, lip],
            [side_wall + angle_extra, cover_thickness],
            [cover_width + side_wall + angle_extra, cover_thickness],
            [cover_width + side_wall + angle_extra * 2 , lip],
            [total_width, lip],
            [total_width, 0],
        ]);
        // ribs to reduce friction
            for (rot=[0:30:360])
                zrot(rot + 45)
                    translate([od/2 + 0.5, 0, 0])
                        cylinder(h=cover_width + side_wall*2 + angle_extra*2, d=1, $fn=16);
        }

        // cut for opening
        right(od/2 - lip * 2)
            down(smidge)
                cube([lip * 5, 1, 100]);

        // hole for lights
        #up(total_width/2)
            left(od/2 + cover_thickness + 1)
                yrot(90)
                    cylinder(d1=light_hole, d2=light_hole*3, h=cover_thickness * 2 + 0.5);
    }
}

module b_side_battery() {
    b_side(id=id, od=od, width=width, wall_thickness=wall_thickness, side_holes=false);
    // remove the chamfer as it's not needed and can cause print defects
    difference() {
        cylinder(d=id+3, h=wall_thickness);
        down(smidge)
        cylinder(d=id, h=wall_thickness+ smidge * 2);
    }
}

module a_side_battery() {
    battery_cutout = battery_box + [18, 0, 1];
    difference() {
        union() {
            a_side(id=id, od=od, width=width, wall_thickness=wall_thickness, side_holes=false);
            cylinder(d=id + 3, h=width);
            cylinder(d=id, h=width + wall_thickness*2);
        }

        // cutouts to save material
        cutout_wall = 3;
        intersection() {
            translate([0, 0, -1])
                cylinder(d=id , h=width + 10);
            
            union() {
                translate([-battery_cutout.x/2, battery_box.z/2 + cutout_wall, 0])
                    down(smidge)
                        cube([battery_cutout.x, id, width + 10]);

                yflip()
                    translate([-battery_cutout.x/2, battery_box.z/2 + cutout_wall, 0])
                        down(smidge)
                            cube([battery_cutout.x - 25, id, width + 10]);
            }
        }

        // holes for tucking the fairy lights into
        for (rot = [0 : 90 : 360])
            rotate([0, 0, rot + 45])
            translate([0, od/2 - 4, -smidge])
                cylinder(d=5, h=8 + smidge*2);
        //wire cutout
        wire_cutout = [6, 2, width * 2];
        translate([-id/2 - wire_cutout.x + 1, 4, 0])
            up(wall_thickness)
                cube(wire_cutout);
        intersection() {
            difference() {
                union() {
                    rotate([90, 0, 0])
                        translate(-battery_cutout/2)
                            cube(battery_cutout);

                    // cutout for latch
                    translate([32, -11, 0])
                        rotate([0, 0, -45])
                            down(1)
                                rotate([0, 0, 180])
                                cube([10, 20, width * 2]);
                }
                // right bump
                right_bump = [8, 8];
                translate([battery_cutout.x/2 - right_bump.x, battery_cutout.z/2 - right_bump.y, 0])
                    cube([right_bump.x, right_bump.y, width*2]);
                // bump 
                left_bump = [8, 5];
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
    //latch_actuate = 0;
    latch_actuate = 180 + 45;

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