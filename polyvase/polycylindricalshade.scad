//number of sides
sides = 6;
//spacing of Z levels
z_spacing = 20;
//maximum radius, center to outer vertex
m_radius = 30;
//thickness
thickness = 2;
// number of levels 
nlevel = 5;
//phase angle change, determines twistiness
phasediff = 14;
//base thickness, if 0 there is no base.
bthick = 3;

//function twist(level,spacing) = sin(level*spacing*period)*amp + slope*level*spacing

module makepolyhelix(level,side,spacing,radius,phase){// level = # of levels, side = number of sides of polygon, spacing = length between levels, radius = distance from center to vertex of polygon, phase = number of degrees the polygon is rotated on every level 
    points = [for (i = [0:level]) for (j = [0:(side -1)]) [radius*cos(i*phase + j*(360/side)),radius*sin(i*phase + j*(360/side)),i*spacing] ];
    //generate two triangular faces for each generation of nested for loop, not sure how to make this more readable
    faces = [for (i = [0:(level-1)]) for (j = [0:(side -1)]) each 
        [ [j+(i*side), j+side*(i+1), (j+1)%side+i*side],
        [(j+1)%side+(i*side), j+side*(i+1), ((j+1)%side)+(i+1)*side]]];
    
    bottomface = [for (i = [0:side-1]) i];
    topface = [for (i = [1:side]) side*(level+1)-i];
    
    faces2 = concat(faces,[bottomface],[topface]);
    
    polyhedron(points,faces2);
}
            
i_radius = m_radius - thickness/cos((360/sides)/2);// calculates inner radius from thickness and outer radius.
difference(){
    makepolyhelix(nlevel,sides,z_spacing,m_radius,phasediff);
    makepolyhelix(nlevel,sides,z_spacing,i_radius,phasediff);
}
if (bthick > 0){
translate([0,0,-bthick]){makepolyhelix(1,sides,bthick,m_radius,0);}
}
