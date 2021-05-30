//radius of the center of torus
cake_radius = 10;
//cake thickness
c_thick = 10;
//frosting thickness
f_thick = .5;
phi_res = 10;
theta_res = 10;
$fn = 50;
t_thick = f_thick+c_thick/2;

color("tan"){
rotate_extrude(){
    translate([cake_radius,0,0]){circle(d = c_thick);}
}
}


//make frosting with constant edge
//frosting angle
fangle = 360/pow(((1+sqrt(5))/2),2);
steps = fangle/($fn*(fangle/360));
color("pink"){
rotate_extrude(){
    translate([cake_radius,0,0]){
        pointsarc = [for (i=[90-fangle/2:steps:90+fangle/2]) [(t_thick)*cos(i),(t_thick)*sin(i)],[0,0]];
        polygon(pointsarc);
    }
}
}

//make sprinkles
snum = 400;
module sprinkle(sradius = 0.2,slen = 0.8){
    color(rands(0,1,3)){
        cylinder(h = slen,r = sradius,center = true);
    }

}
for (i = [0:snum-1]){
    t = rands(0,360,1)[0];
    p = rands(90-fangle/2,90+fangle/2,1)[0];
    v1 = [cake_radius*cos(t),cake_radius*sin(t),0];//corresponds to theta translation
    v2 = [t_thick*cos(p)*cos(t),t_thick*cos(p)*sin(t),t_thick*sin(p)];//corresponds to phi translation
    vtot = v1+v2;//total translation
    r2 = [0,acos(v2[2]/t_thick),atan2(v2[1],v2[0])];//rotate perpendicular to donut using v2 using inverse functions to find spherical angles
    rf = (cross(v1,v2)/norm(cross(v1,v2)))*90;//rotate so its flat against donut
    rr = (v2/t_thick)*rands(0,360,1)[0];
    translate(vtot){rotate(rr){rotate(rf){rotate(r2){sprinkle();}}}};
}

//points = [for (t = [0:360/(theta_res-1):360]) each
//    [for (p = [45:(90/(phi_res-1)):135]) [cake_radius*cos(t) + t_thick*cos(p)*cos(t), cake_radius*sin(t) + t_thick*cos(p)*sin(t), sin(p)*t_thick], 
//    [cake_radius*cos(t),cake_radius*sin(t),0]], 
//];
//
//faces = [for (i = [0:(theta_res-1)]) for (j = [0:(phi_res)]) each 
//    [ [j+(i*(phi_res+1)), j+phi_res*(i+1), (j+1)%(phi_res+1)+i*(phi_res+1)] ,
//    [(j+1)%(phi_res+1)+(i*(phi_res+1)), j+(phi_res+1)*(i+1), (j+1)%(phi_res+1)+((i+1)*(phi_res+1))]]];
//
//polyhedron(points,faces);
//
//echo((points));
    