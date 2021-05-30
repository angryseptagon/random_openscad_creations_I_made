//number of sides (theta resolution)
sides = 7;
//total height
total_height = 150;
//maximum radius, center to outer vertex
m_radius = 30;
//thickness (at thickest part)
thickness = 2;
// number of levels (z resolution)
nlevel = 10;
//base thickness, if 0 there is no base.
bthick = 3;
//spacing of Z levels
z_spacing = total_height/nlevel;

//linear phase angle change, determines linear twistiness (degrees/unitlength)
phasediff = 0;
//period of angular wavyness alongz (unitlength), do not make 0
period = 150;
//amplitude of wavyness of phase (degrees), make 0 if you dont want sine component
amplitude = 13;


//slope of vase radius, positive tapers out negative tapers in, 0 is straight (change in radius/change in height) 
rslope = .15;
//amplitude of profile wavyness (unitslength)
ramplitude = 5;
//frequency of profile wavyness (1/units length) 
rfrequency = 0.006666667; 

//phase along z -axis
function PAZ(z,am,pe,lin) = am*sin(z*(360/pe)) +z*lin;

//radius along z - axis
function RAZ(r,z,am,fe,lin) = r + am*sin(z*(360*fe)) + z*lin;

module makepolyhelix(level,side,spacing,radius,phase,amp,per,rphas,ramp,rfeq){// level = # of levels, side = number of sides of polygon, spacing = length between levels, radius = distance from center to vertex of polygon, phase = number of degrees the polygon is rotated on every level, amp is the amplitude of a sin() component, per is the period of that sin component
    points = [for (i = [0:level]) for (j = [0:(side -1)]) 
        [RAZ(radius,i*spacing,ramp,rfeq,rphas)*cos(PAZ(i*spacing,amp,per,phase)+j*(360/side)),
         RAZ(radius,i*spacing,ramp,rfeq,rphas)*sin(PAZ(i*spacing,amp,per,phase)+ j*(360/side)),
         i*spacing] ];
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
    makepolyhelix(nlevel,sides,z_spacing,m_radius,phasediff,amplitude,period,rslope,ramplitude,rfrequency);
    makepolyhelix(nlevel,sides,z_spacing,i_radius,phasediff,amplitude,period,rslope,ramplitude,rfrequency);
}
if (bthick > 0){
mirror([0,0,1]){makepolyhelix(1,sides,bthick,m_radius,-phasediff,-amplitude,period,-rslope,-ramplitude,rfrequency);}
}
