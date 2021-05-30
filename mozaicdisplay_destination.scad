height_grid = 20;
//thickness of wall
thickness = 2;

//unitsize is 1/12 the hight-wall thickness or 1/8 the width -wall thickness
unitsize = 25.4;

//led diameter
ledsize = 5;
$fn = 50;

//make a straight wall with rounded endpoints (x1,y1), (x2,y2), this could be done in fewer lines with hull() but this seems to render faster
module straightwall(x1, y1, x2,y2){
    distance = unitsize*norm([x2-x1,y2-y1]);
    angle = atan2(y2-y1,x2-x1);
    //echo(angle);
    //echo(distance);
    translate([unitsize*x1,unitsize*y1,0]){
        rotate(angle){
            translate([0,-thickness/2,0]){
                cube([distance,thickness,height_grid]);
            }
        }
    }
} 

//make one quarter curved wall curvedwall(Xccoordinate of center,Ycoordinate of center,rotation about center) units are in "unitsize"
module curvedwall (Xu,Yu,degrees = 0,diam = 4*unitsize){
    translate([Xu*unitsize,Yu*unitsize,0]){
        intersection(){
            difference(){
                cylinder(d=thickness + diam, h = height_grid,$fa=1);
                translate([0,0,-0.05]){cylinder(d= diam-thickness, h = height_grid + .1,$fa=1);}
            }
            rotate([0,0,degrees]){
                cube([unitsize*2+thickness,unitsize*4+thickness,height_grid]);
            }
        }
}
}

//projection(){

//make square edges
translate([-4*unitsize,8*unitsize,height_grid/2]){cube([thickness,thickness,height_grid],center=true);}
translate([4*unitsize,8*unitsize,height_grid/2]){cube([thickness,thickness,height_grid],center=true);}
translate([-4*unitsize,-8*unitsize,height_grid/2]){cube([thickness,thickness,height_grid],center=true);}
translate([4*unitsize,8*unitsize,height_grid/2]){cube([thickness,thickness,height_grid],center=true);}

//make outside walls
straightwall(-4,-8,-4,8);
straightwall(-4,-8,4,-8);
straightwall(4,8,4,-8);
straightwall(4,8,-4,8);

//make vertical walls
straightwall(1,8,1,-8);
straightwall(-1,8,-1,-8);
straightwall(2,8,2,-8);
straightwall(-2,8,-2,-8);

//make horizontal walls
straightwall(3,0,-3,0);
straightwall(4,2,-4,2);
straightwall(4,-2,-4,-2);
straightwall(4,4,-4,4);
straightwall(4,-4,-4,-4);
straightwall(4,6,-4,6);
straightwall(4,-6,-4,-6);

//make left slanted walls
straightwall(-1,-8,-4,-2);
straightwall(-1,-4,-3,0);
straightwall(2,-6,-4,6);
straightwall(4,-6,-2,6);

//make right slanted walls ordered right to left
straightwall(1,-8,4,-2);
straightwall(1,-4,3,0);
straightwall(-2,-6,4,6);
straightwall(-4,-6,2,6);
straightwall(-3,0,0,6);

//make curved walls ordered bottom to top
curvedwall(-2,-6,180);
curvedwall(1,-6,180);
curvedwall(2,-6,270);
curvedwall(3,-1,0,2*unitsize);
curvedwall(-3,-1,90,2*unitsize);
curvedwall(-3,1,180,2*unitsize);
curvedwall(3,1,270,2*unitsize);
curvedwall(3,1,0,2*unitsize);
curvedwall(3,3,0,2*unitsize);
curvedwall(-3,3,90,2*unitsize);
curvedwall(2,6,0);
curvedwall(1,6,90);
curvedwall(-2,6,90);
//}








