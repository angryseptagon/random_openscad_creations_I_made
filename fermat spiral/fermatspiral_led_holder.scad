//hole diameter for led
diameter_hole = 12;
//number of leds
number_led = 200;
//thickness of disk
height = 3;
//golden angle used in equation, you can also use "360/pow(((1+sqrt(5))/2),2)"
golden_angle = 360/pow(((1+sqrt(5))/2),2);
//scaling factor
c = 14;
//starting led, if 0, there will be an led at center. number must be >= 0
start_led = 0;
//space between edge of the last led hole and edge of plate
outer_gap = 10;
//facenumber for circles
$fn = 50;

difference(){
cylinder( h = height, r = (c*sqrt(number_led+start_led) + diameter_hole/2 + outer_gap));
    
for (i = [0+start_led:number_led+start_led]){
    translate([c*sqrt(i)*cos(i*golden_angle),c*sqrt(i)*sin(i*golden_angle),-.5]){
        cylinder(h = height +1, d = diameter_hole);
    }
}
}