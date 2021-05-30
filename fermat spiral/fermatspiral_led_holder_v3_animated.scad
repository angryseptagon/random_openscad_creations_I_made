//hole diameter for led
diameter_hole = 12;
//offset along curve, shifts positions foward or backward along voronoi curve, leave 0 if you don't know what it is
offsetcurve = 50*$t;
//number of holes, corresponds to n in fermat spiral formula
number_led = 50+floor(50*$t);
//thickness of base plate
height = 3;
//golden angle used in equation, you can also use "360/pow(((1+sqrt(5))/2),2)". you get neat effects if you change this number
golden_angle = 360/pow(((1+sqrt(5))/2),2);
//scaling factor (can also be interpreted as space between the center of the first hole to the second)
c = 16;
//starting led, if 0, there will be an led at center. number must be >= 0
start_led = -floor(50*$t);
//space between edge of the last led hole and edge of plate
outer_gap = 5;
//facenumber for circles
$fn = 50;
//total radius 
trad = (c*sqrt(number_led+start_led+offsetcurve) + diameter_hole/2 + outer_gap);
echo("total radius is ", str(trad));
//wall height, this hight is on top of the bast plate
wallh = 15;
//voronoi walls (true means put them in)
voronoiwalls = true;
// outer wall thickness, 0 = no wall. the outer edge of the wall is "trad" calculated by "(c*sqrt(number_led+start_led) + diameter_hole/2 + outer_gap)" inner edge is just that minus this variable
outwall_thick = 3;
//half the thickness of voronoi walls (not sure why the voronoi algorithm takes it like this)
voronoi_thick = 1.5;
//voronoi wall fillet
voronoi_fillet = 3;
//show reference led number, embosses number on bottom of led plate;
show_num = false;


//use Filepe's voronoi algorithm. thanks Felipe Sanchez!

// (c)2013  <juca@members.fsf.org>
// licensed under the terms of the GNU GPL version 3 (or later)

function normalize(v) = v / norm(v);

//
// The voronoi() function generates a 2D surface, which can be provided to
// a) linear_extrude() to produce a 3D object
// b) intersection() to restrict it to a a specified shape -- see voronoi_polygon.scad
//
// Parameters:
//   points (required) ... nuclei coordinates (array of [x, y] pairs)
//   L                 ... the radius of the "world" (the pattern is built within this circle)
//   thickness         ... the thickness of the lines between cells
//   fillet             ... the radius applied to corners (fillet in CAD terms)
//   nuclei (bool)     ... show nuclei sites
//
// These parameters need to be kept more or less in proportion to each other, and to the distance
// apart of points in the point_set. If one or the other parameter is increased or decreased too
// much, you'll get no output.
//
module voronoi(points, L = 200, thickness = 1, fillet = 6, nuclei = true) {
	for (p = points) {
		difference() {
			minkowski() {
				intersection_for(p1 = points){
					if (p != p1) {
						angle = 90 + atan2(p[1] - p1[1], p[0] - p1[0]);

						translate((p + p1) / 2 - normalize(p1 - p) * (thickness + fillet))
						rotate([0, 0, angle])
						translate([-L, -L])
						square([2 * L, L]);
					}
				}
				circle(r = fillet, $fn = 20);
			}
			if (nuclei)
				translate(p) circle(r = 1, $fn = 20);
		}
	}
}

pointsf = [for (i = [start_led+offsetcurve:1:number_led + start_led-1 + offsetcurve]) 
    [c*sqrt(i)*cos((i-offsetcurve)*golden_angle),c*sqrt(i)*sin((i-offsetcurve)*golden_angle)]];

//make holes in main disk in fermat spiral
if (height>0){
translate([0,0,-height]){
    difference(){
        cylinder( h = height, r = trad);
        for (i = [0:len(pointsf)-1]){
            translate([pointsf[i][0],pointsf[i][1],-.5]){
                cylinder(h = height +1, d = diameter_hole);
                if(show_num){
                linear_extrude(height/4){
                    rotate([0,0,(i+start_led)*golden_angle]){
                        mirror([0,1,0]){translate([0,diameter_hole/2,0]){text(str(i+1),size = 8,halign = "center");}}
                    }
                }
                }
            }
        }
    }
}
}

color("green"){
//make voronoi walls
if (voronoiwalls){
    linear_extrude(wallh){
        difference(){
            circle(r = trad);
            voronoi(pointsf,L = trad,thickness = voronoi_thick,fillet = voronoi_fillet,nuclei = false);
        }
    }
}

//make outer wall, if thickness is zero there is no wall.
if (outwall_thick > 0 && voronoiwalls){
    linear_extrude(wallh){
        difference(){
            circle(r = trad);
            circle(r = trad-outwall_thick);
        }
    }
}
}
