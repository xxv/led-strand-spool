use <BOSL/transforms.scad>

dia = 25;
height = 1.5;
hole_dia = 3;
hole_spacing = 5;

$fs=0.25;
$fa=0.25;

smidge = 0.01;

battery_button();

module battery_button() {
    difference() {
        up(height/2)
        minkowski() {
            cylinder(d=dia - height, h=smidge);
            sphere(d=height);
        }

        cylinder(d=hole_dia, h=height + smidge * 5);

        for (rot=[0:360/3:360])
            down(smidge)
                zrot(rot)
                    left(hole_spacing)
                        cylinder(d=hole_dia, h=height + smidge * 5);
            
    }
}