//radius of the center of torus
cake_radius = 10;
//cake thickness
c_thick = 10;
//frosting thickness
f_thick = .5;
$fn = 200;
phi_res = $fn;
theta_res = $fn;
t_thick = f_thick+c_thick/2;

color("#a7adf8"){
rotate_extrude(){
    translate([cake_radius,0,0]){circle(d = c_thick);}
}
}

//frosting angle
fangle = 170;

//give frosting bounds with wavy edges
freqfrost = round(rands(3,20,1)[0]);
function infrost(t_angle) = 90+fangle/2 +5*sin((round(freqfrost/2))*t_angle);
function outfrost(t_angle) = 90-fangle/2 +5*sin(freqfrost*t_angle);

//make sprinkles
snum = 25;//number of sprinkles
module sprinkle(sradius = rands(1,3,1)[0],slen = rands(1,3,1)[0],ratio = rands(.1,2,1)[0]){
    sides = round(rands(3,8,1)[0]);
    rotate(rands(0,360,3)){
    color("#43ddde"){
        cylinder(h = slen,r = sradius,center = true,$fn = sides);
        translate([0,0,slen/2]){cylinder(slen*ratio,sradius,0,$fn = sides);}
        translate([0,0,-slen/2-slen*ratio]){cylinder(slen*ratio,0,sradius,$fn = sides);}
    }
    }
}
for (i = [0:snum-1]){
    t = rands(0,360,1)[0];
    p = rands(outfrost(t),infrost(t),1)[0];
    v1 = [cake_radius*cos(t),cake_radius*sin(t),0];//corresponds to theta translation
    v2 = [t_thick*cos(p)*cos(t),t_thick*cos(p)*sin(t),t_thick*sin(p)];//corresponds to phi translation
    vtot = v1+v2;//total translation
    r2 = [0,acos(v2[2]/t_thick),atan2(v2[1],v2[0])];//rotate perpendicular to donut using v2 using inverse functions to find spherical angles
    translate(vtot){rotate(r2){rotate([0,0,rands(0,360,1)[0]]){rotate([0,90,0]){sprinkle();}}}};
}

//make frosting
points = [for (th = [0:360/(theta_res-1):360]) each
    [for (ph = [outfrost(th):((infrost(th)-outfrost(th))/(phi_res-1)):infrost(th)]) [cake_radius*cos(th) + t_thick*cos(ph)*cos(th), cake_radius*sin(th) + t_thick*cos(ph)*sin(th), sin(ph)*t_thick], 
    [cake_radius*cos(th),cake_radius*sin(th),0]], 
];

function j1(n) = (n+1)%(phi_res+1);
function i1(n) = ((n+1)%theta_res)*(phi_res+1);
function i0(n) = n*(phi_res+1);
function j0(n) = n;
faces = [for (i = [0:(theta_res-1)]) for (j = [0:(phi_res)]) each 
    [ [j+i0(i), j+i1(i), j1(j)+i0(i)] ,
    [j1(j)+i0(i), j+i1(i), j1(j)+i1(i)]]];

color("#22314a"){
polyhedron(points,faces);
}