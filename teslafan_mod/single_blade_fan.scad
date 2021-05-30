//thickness of the blade, this is thickness along z axis.
blade_thickness = 1.65;
//blade radius*
blade_radius = 55;
//number of twists, change sign if motor spins opposite way.
ntwists = -5;
//face number, resolution, I would stay around 100 or less for thingiverse customizer
$fn = 200;
//height of the fan
hfan = 16.5;
//innetmost diammeter, outer diameter of motor*
inner_diameter = 37.25;
//thickness of supporting wall
wall_thickness = 2;
//outside gap ; distance between exhaust gap to blade edge
outgap = 8;
//inside gap ; distance between intake gap to hub.
ingap = 12;
//fan housing height (use for hyper extruded shroud)
fhouseheight=16.5;
//make wall outside fan , this is very difficult to print
makewallout = true;


//make blade
//this angle determines thickness
anglethick= blade_thickness*(360*abs(ntwists)/hfan);
if(anglethick>=360){
    echo("ERROR: blade is too thick!");
}
difference(){
intersection(){
    linear_extrude(height = hfan,twist = 360*ntwists,convexity = 5){
            polygon([[0,0],
            [blade_radius*cos(anglethick/2),blade_radius*sin(anglethick/2)],
            [blade_radius*cos(anglethick/4),blade_radius*sin(anglethick/4)],
            [blade_radius,0],
            [blade_radius*cos(-anglethick/4),blade_radius*sin(-anglethick/4)],
            [blade_radius*cos(-anglethick/2),blade_radius*sin(-anglethick/2)]]*2);
    }

    cylinder(h = hfan, r1 = blade_radius -outgap, r2= blade_radius);
    }

cylinder(h = hfan,r1 = 0+ inner_diameter/2, r2 = ingap + inner_diameter/2);
}


//thickness of wall around hub.
hubwallthick= 2;
//make hub
linear_extrude(hfan){
    difference(){
        circle(r = inner_diameter/2+hubwallthick);
        circle(d = inner_diameter);
    }
}



//make supports
//support thickness
s_thick = 2;
//support number
s_num = 5;
//bite of support into blade
sbite = 1;
intersection(){
    cylinder(h = hfan,r1 = sbite + inner_diameter/2, r2 = sbite + ingap + inner_diameter/2);
    union(){
        for(i = [0:s_num]){
            rotate([0,0,(360/s_num)*i]){
                translate([inner_diameter/2,-s_thick/2,0]){
                    cube([blade_radius,s_thick,hfan+1]);
                }
            }
        }
    }
}

//make hubcap

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

//thickness of the wall that sticks out
ext_hous_thick = 2;
if ((hfan>fhouseheight) && makewallout){
    translate([0,0,fhouseheight]){
        linear_extrude(hfan-fhouseheight){
            difference(){
                circle(r = blade_radius);
                circle(r = blade_radius - ext_hous_thick);
            }
        }
    }
    difference(){
        union(){
            for(i = [0:s_num]){
                rotate([0,0,(360/s_num)*i]){
                    translate([0,-s_thick/2,fhouseheight]){
                        cube([blade_radius,s_thick,hfan-fhouseheight]);
                    }
                }
            }
        }
        cylinder(h = hfan,r1 = blade_radius-outgap-sbite,r2= blade_radius-sbite);
    }    
}
//all units in mm    




