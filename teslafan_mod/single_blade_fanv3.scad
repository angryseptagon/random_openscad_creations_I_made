//thickness of the blade, this is thickness along z axis.
blade_thickness = 1.1;
//air gap between blades, used to derive the number of twists
blade_gap= 1.5;
//blade radius*
blade_radius = 55;
//height of the fan blade (can extend beyond the case of the fan, but it will generate a wall).
hfan = 16.5;
//number of twists of fan blade, change sign if motor spins opposite way.
ntwists = -(hfan/(blade_gap+blade_thickness));
//face number for circles, resolution, I would stay around 100 or less for thingiverse customizer
$fn = 200;
//innetmost diammeter, outer diameter of motor*
inner_diameter = 37.25;
//outside gap ; distance between exhaust gap to blade/outermost edge.
outgap = 8;
//inside gap ; distance between intake gap to hub.
ingap = 12;
//fan housing height (use for hyper extruded shroud)
fhouseheight=16.5;
//make wall outside fan with supports , this is very difficult to print, wall is made anyway if the blade height is greater than the fan housing height
makewallout = false;
//degrees to stwist support (0 for straight walls)
s_twist = 0;

//thickness of wall around hub.
hubwallthick= 2;
//thickness of the wall that wraps around the whole fan
ext_hous_thick = 2;
//support thickness
s_thick = 2;
//support number
s_num = 5;
//fillet radius for supports
f_rad = 2;

//make blade
//this angle determines thickness it converts from (R,Z) domain to (R,theta)
anglethick= blade_thickness*(360*abs(ntwists)/hfan);
if(anglethick>=360){
    echo("ERROR: blade is too thick!, decrease blade_thickness");
}
difference(){
intersection(){
    linear_extrude(height = hfan,twist = 360*ntwists,convexity = 5){
            polygon([
            [0,0],
            [blade_radius*cos(anglethick/2),blade_radius*sin(anglethick/2)],
            [blade_radius*cos(anglethick/4),blade_radius*sin(anglethick/4)],
            [blade_radius,0],
            [blade_radius*cos(-anglethick/4),blade_radius*sin(-anglethick/4)],
            [blade_radius*cos(-anglethick/2),blade_radius*sin(-anglethick/2)]
            ]*(1/cos(45)));//approximation of filled arc shape (pizza slice shape) with angle = anglethick
    }

    cylinder(h = hfan, r1 = blade_radius -outgap, r2= blade_radius);
    }

cylinder(h = hfan,r1 = 0+ inner_diameter/2, r2 = ingap + inner_diameter/2);
}

//make support profile with hub walls and outer walls


module sprof(){
difference(){
    circle(blade_radius);
    minkowski(){
        difference(){
            circle(r = blade_radius - ext_hous_thick -f_rad);
            for (i = [0:s_num-1]){
                rotate([0,0,(360/s_num)*i]){translate([0,-s_thick/2-f_rad,0]){square([blade_radius,s_thick+2*f_rad]);}}
            }//make square support shapes with extra thickness to accomadate minkowski
            circle(r = inner_diameter/2+hubwallthick +f_rad); //subtract circle that will become the hub walls, extra radius for fillet
        }//subtract inner hub and support profiles from larger circle which will form outer walls. result is the negative space walls and supports form
        circle(f_rad);//minkowski adds back subtracted fillet radius and adds fillet.
    }
    circle(d = inner_diameter);
}//final difference takes the negative space and a hole for the motor away from a circle the size of the fan to form supports and walls in 2d
}//produces 2d profile to be extruded    

//make supports between hub and inner wall of blade as well as hub wall itself
//bite of support into blade
sbite = 1;
intersection(){
    cylinder(h = hfan,r1 = (hubwallthick>=sbite ? hubwallthick:sbite) + inner_diameter/2, r2 = sbite + ingap + inner_diameter/2);//conditional is there to make sure there is no bevel where the hubwalls meet the motor
    linear_extrude(hfan,twist = s_twist){
        sprof();
    }
}

//make hubcap, it extends from the top surface of hub motor to the height of the fan
//height of hub*
hub_height = 15;
//hubcap thickness in z
hcapthick = hfan - hub_height;
// radius of hubcap cut out
inradcut = 14;
translate([0,0,hfan-hcapthick]){
    linear_extrude(hcapthick){
        difference(){
            circle(r = inner_diameter/2+hubwallthick);
            circle(r = inradcut);
        }
    }
}


//make wall around part of the fan sticking out, with supports


if ((hfan>fhouseheight) || makewallout){
    //make supports for outer wall and outer wall with bevel on top surface from cylinder() cut out
    difference(){
        linear_extrude(hfan,twist = s_twist){
            sprof();
        }
        cylinder(h = hfan,r1 = blade_radius-outgap-sbite,r2= blade_radius-sbite);
    }    
}
//all units in mm    




