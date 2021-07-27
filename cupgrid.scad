//inner diameter of cups (outer diamter of cardboard tube)
idiameter = 50.8;
//wall thickness
thickness = 2.5;
//outer diameter of cups
odiameter= idiameter+thickness*2;
//rows of seedling cups
rows =3;
//columns of seedling cups
columns=4;
//height of seedling cups
height = 76.2;
//number of sides for every cup
$fn=40;
//base thickness
basethickness = 2;
//number of drainage holes
number_drain_holes=7;
//diameter of drainage hole
drain_hole_diameter= 5;
 
module pocket(){
    //make walls of cup
    difference(){
        cylinder(d=odiameter, h = height);
        translate([0,0,-.5]){cylinder(d=idiameter, h=height+1);}
        }
    difference(){
    //make base
        translate([0,0,-basethickness]){
        cylinder(d=odiameter*1,h=basethickness);
        }
    //make drain holes
        union(){
            if(number_drain_holes > 0){
            for(k=[0:number_drain_holes-1]){
                doffsetx=(idiameter/4)*cos((360/number_drain_holes)*k);
                doffsety=(idiameter/4)*sin((360/number_drain_holes)*k);
                translate([doffsetx,doffsety,-basethickness-0.5]){cylinder(d=drain_hole_diameter,h=basethickness+1);}
            }
            }
        }
    }
}
//make duplicates of pockets so they link up
for (j = [0:rows-1]){
    offsetx=(idiameter/2+thickness/2)*(j%2);
    offsety=(sqrt(3)/2)*(idiameter+thickness)*j;
    for (i = [0:columns-1]){
        translate([i*(odiameter-thickness)+offsetx,offsety,0]){pocket();}
        }
}
