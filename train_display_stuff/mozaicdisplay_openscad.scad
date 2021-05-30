height_grid = 20;
//thickness of wall
thickness = 1;

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
module curvedwall (Xu,Yu,degrees = 0){
    translate([Xu*unitsize,Yu*unitsize,0]){
        intersection(){
            difference(){
                cylinder(d=thickness + 4*unitsize, h = height_grid,$fa=1);
                translate([0,0,-0.05]){cylinder(d= 4*unitsize-thickness, h = height_grid + .1,$fa=1);}
            }
            rotate([0,0,degrees]){
                cube([unitsize*2+thickness,unitsize*4+thickness,height_grid]);
            }
        }
}
}

module ledhole(Xv,Yv,rot=0){
    translate([Xv*unitsize,Yv*unitsize,0]){
         circle(d=ledsize);
    }
}

//make rounded edges
translate([-4*unitsize,6*unitsize]){cylinder(d = thickness, h = height_grid);}
translate([4*unitsize,6*unitsize]){cylinder(d = thickness, h = height_grid);}
translate([-4*unitsize,-6*unitsize]){cylinder(d = thickness, h = height_grid);}
translate([4*unitsize,-6*unitsize]){cylinder(d = thickness, h = height_grid);}

//make outside walls
straightwall(-4,-6,-4,6);
straightwall(-4,-6,4,-6);
straightwall(4,6,4,-6);
straightwall(4,6,-4,6);

//middle vertical walls
straightwall(1,6,1,-6);
straightwall(2,6,2,-6);
straightwall(-1,6,-1,-6);
straightwall(-2,6,-2,-6);
//middle vertical wall not all the way through
straightwall(3,6,3,-2);

//middle horizontal walls
straightwall(4,4,-4,4);
straightwall(4,2,-4,2);
straightwall(4,-4,-4,-4);
//horizontal segments 2 unit length
straightwall(4,3,2,3);
straightwall(-4,3,-2,3);
straightwall(4,-3,2,-3);
straightwall(-4,-3,-2,-3);
//horizontal segments 6 units length
straightwall(4,-2,-2,-2);
straightwall(4,0,-2,0);
straightwall(-4,-1,2,-1);
//horizontal segment 4 unitlength
straightwall(-2,1,2,1);

//slantedwalls left
straightwall(-4,2,0,-6);
straightwall(-4,6,2,-6);
straightwall(-2,6,4,-6);
//straightwalls right
straightwall(4,2,0,-6);
straightwall(4,6,-2,-6);
straightwall(2,6,-4,-6);
straightwall(-4,-2,0,6);


//make curvedwalls
//4 corners
curvedwall(2,4,0);
curvedwall(-2,4,90);
curvedwall(-2,-4,180);
curvedwall(2,-4,270);
//middlecurves
curvedwall(-2,-1,90);
curvedwall(-2,1,180);
curvedwall(2,-1,0);
curvedwall(2,1,270);
//curve for "1" character
curvedwall(-3,6,270);


////make ledholes
//ledhole(-2.7,5);
//ledhole(-3.6,4.4);
//ledhole(-3.53,5.7);
//ledhole(-3.8,5.2);
//ledhole(-1.4,5.6);
//ledhole(-1.7,4.9);
//ledhole(-1.5,4.2);
//ledhole(-2.1,4.1);
//ledhole(-1.15,4.8);
//ledhole(-.6,5.5);
//ledhole(.2,5);
//ledhole(1.4,5.5);
//ledhole(1.6,4.5);
//ledhole(2.5,5);
//ledhole(2.9,5.9);
//ledhole(3.5,5.7);
//ledhole(3.3,5.1);
//ledhole(3.85,5.2);
//ledhole(3.6,4.4);







