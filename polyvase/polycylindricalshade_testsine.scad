//number of sides
sides = 7;
//spacing of Z levels
z_spacing = 10;
//maximum radius, center to outer vertex
m_radius = 30;
//thickness (at thickest part)
thickness = 3;
// number of levels 
nlevel = 15;
//phase angle change, determines twistiness
phasediff = 10;
//base thickness, if 0 there is no base.
bthick = 3;
module makepolyhelix(level,side,spacing,radius,phase){// level = # of levels, side = number of sides of polygon, spacing = length between levels, radius = distance from center to vertex of polygon, phase = number of degrees the polygon is rotated on every level 
    points = [for (i = [0:level]) for (j = [0:(side -1)]) [radius*cos(13*sin(i*spacing*75) + j*(360/side)),radius*sin(13*sin(i*spacing*75) + j*(360/side)),i*spacing] ];
    //generate two triangular faces for each generation of nested for loop, not sure how to make this more readable
    faces = [for (i = [0:(level-1)]) for (j = [0:(side -1)]) each 
        [ [j+(i*side), j+side*(i+1), (j+1)%side+i*side],
        [(j+1)%side+(i*side), j+side*(i+1), ((j+1)%side)+(i+1)*side]]];
    
    bottomface = [for (i = [0:side-1]) i];
    topface = [for (i = [1:side]) side*(level+1)-i];
    
    faces2 = concat(faces,[bottomface],[topface]);
    
    polyhedron(points,faces2);
}
            
difference(){
    makepolyhelix(nlevel,sides,z_spacing,m_radius,phasediff);
    makepolyhelix(nlevel,sides,z_spacing,m_radius-thickness,phasediff);
}
if (bthick > 0){
translate([0,0,-bthick]){makepolyhelix(1,sides,bthick,m_radius,0);}
}
