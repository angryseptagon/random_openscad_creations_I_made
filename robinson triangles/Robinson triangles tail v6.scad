//http://tilings.math.uni-bielefeld.de/substitution/robinson-triangle/
//diagram:https://tilings.math.uni-bielefeld.de/img/substitution/robinson-triangle/rule.gif
//location refers to location of rightmost vertex in diagram
//orientation refers to orientation rotated in degrees compared to diagram about the rightmost corner
//level refers to how deep the substitutions go
// size refers to size of largest edge

phi = (1+pow(5,0.5))/2;
height =1;
maxLevel = 3;

orange = [255,165,0]/255;
gold = [255,215,0]/255;
darkblue = [0,0,139]/255;
lightblue = [173,216,230]/255;


function lerp (a,b,t) = a+((b-a)*t);
// Smoothstep function
function smoothStep(edge0,edge1,x) = let(y = clamp((x-edge0)/(edge1-edge0))) y*y*(3-2*y);
function clamp(x,lowerLimit=0,upperLimit=1) = (x<lowerLimit) ? lowerLimit : ((x>upperLimit) ? upperLimit : x);
function getCentroid (triangle) = (triangle[0]+triangle[1]+triangle[2])/3;
function sumElem(a) = [for (sum=a[0],i=1; i<=len(a); newsum=sum+a[i], nexti=i+1, sum=newsum, i=nexti) sum];
//left fat triangle refers to dark blue triangle in diagram
module leftfatTriangleDeflation (triangleList,Level,colorList,heightList){
colorListOut = concat([darkblue],colorList);
  if (Level == 0) {
    renderPyramid(triangleList,colorListOut,heightList);
  } else {
    heightListOut = concat([heightList[0]/phi],heightList);
    point0 = triangleList[0][0];
    point1 = lerp(triangleList[0][0],triangleList[0][1],1/phi);
    point2 = triangleList[0][1];
    point3 = triangleList[0][2];
    point4 = lerp(triangleList[0][0],triangleList[0][2],1/phi);
    leftFatList = concat([[point3,point4,point2]],triangleList);
    rightFatList = concat([[point4,point0,point1]],triangleList);
    rightSkinnyList = concat([[point1,point2,point4]],triangleList);
    leftfatTriangleDeflation(leftFatList,Level-1,colorListOut,heightListOut);
    rightfatTriangleDeflation(rightFatList,Level-1,colorListOut,heightListOut);
    rightskinnyTriangleDeflation(rightSkinnyList,Level-1,colorListOut,heightListOut);
  }
}
//left skinny triangle refers to light orange triangle in diagram
module leftskinnyTriangleDeflation (triangleList,Level,colorList,heightList){
  colorListOut = concat([gold],colorList);
  if (Level == 0) {
    renderPyramid(triangleList,colorListOut,heightList);
  } else {
    heightListOut = concat([heightList[0]/phi],heightList);
    point0 = triangleList[0][0];
    point1 = lerp(triangleList[0][1],triangleList[0][0],1/phi);
    point2 = triangleList[0][1];
    point3 = triangleList[0][2];
    LeftSkinnyList = concat([[point1,point3,point0]],triangleList);
    LeftFatList = concat([[point3,point1,point2]],triangleList);
    leftskinnyTriangleDeflation(LeftSkinnyList,Level-1,colorListOut,heightListOut);
    leftfatTriangleDeflation(LeftFatList,Level-1,colorListOut,heightListOut);
  }
}
//right fat triangle refers to light blue triangle in diagram
module rightfatTriangleDeflation (triangleList,Level,colorList,heightList){
    colorListOut = concat([lightblue],colorList);
    if (Level == 0) {
    renderPyramid(triangleList,colorListOut,heightList);
  } else {
    heightListOut = concat([heightList[0]/phi],heightList);
    point0 = triangleList[0][0];
    point1 = lerp(triangleList[0][0],triangleList[0][1],1/phi);
    point2 = triangleList[0][1];
    point3 = triangleList[0][2];
    point4 = lerp(triangleList[0][0],triangleList[0][2],1/phi);
    leftFatList = concat([[point1,point4,point0]],triangleList);
    rightFatList = concat([[point2,point3,point1]],triangleList);
    leftSkinnyList = concat([[point4,point1,point3]],triangleList);
    leftfatTriangleDeflation(leftFatList,Level-1,colorListOut,heightListOut);
    rightfatTriangleDeflation(rightFatList,Level-1,colorListOut,heightListOut);
    leftskinnyTriangleDeflation(leftSkinnyList,Level-1,colorListOut,heightListOut);
  }
}
//right skinny triangle refers to dark orange triangle in diagram
module rightskinnyTriangleDeflation (triangleList,Level,colorList,heightList){
    colorListOut = concat([orange],colorList);
    if (Level == 0) {
    renderPyramid(triangleList,colorListOut,heightList);
  } else {
    heightListOut = concat([heightList[0]/phi],heightList);
    point0 = triangleList[0][0];
    point1 = triangleList[0][1];
    point2 = triangleList[0][2];
    point3 = lerp(triangleList[0][2],triangleList[0][0],1/phi);
    rightSkinnyList = concat([[point3,point0,point1]],triangleList);
    rightFatList =  concat([[point1,point2,point3]],triangleList);
    rightskinnyTriangleDeflation(rightSkinnyList,Level-1,colorListOut,heightListOut);
    rightfatTriangleDeflation(rightFatList,Level-1,colorListOut,heightListOut);
  }
}

module renderPyramid (triangleList,colorList,heightList){
  renderLinearAnimatedPyramid(triangleList,colorList,heightList);
}
function nomute(i,t,l=maxLevel) = i/l<=t && (i+l) >t;
function getlinearLookup (itemlist,t,i) = lerp(itemlist[i],itemlist[i+1],clamp((len(itemlist)-1)*t-i));
module renderLinearAnimatedPyramid (triangleList,colorList,heightList) {
  points = triangleList[0];
  centroidList = [ for (i = [0:len(triangleList)-1]) [getCentroid(triangleList[i])[0],getCentroid(triangleList[i])[1],heightList[i]]];
  centroid = getlinearLookup(centroidList,$t,floor($t*maxLevel));
  points3d = concat(points,[centroid]);
  faces = [[0,1,2],[0,3,1],[1,3,2],[2,3,0]];
  animatedColor =getlinearLookup(colorList,$t,floor($t*maxLevel));
  color(animatedColor)polyhedron(points3d,faces);
}
module renderStaticPyramid (triangleList,colorList){
  points = triangleList[0];
  centroid = [getCentroid(points)[0],getCentroid(points)[1],1];
  points3d = concat(points,[centroid]);
  faces = [[0,1,2],[0,3,1],[1,3,2],[2,3,0]];
  color(colorList[0])polyhedron(points3d,faces,1);
}


translate([0,0,0])leftfatTriangleDeflation([[[0,0,0],[-5,sin(36)*10/phi,0],[-10,0,0]]],maxLevel,[],[height]);
translate([10,0,0])rightfatTriangleDeflation([[[0,0,0],[-10,0,0],[-5,-sin(36)*10/phi,0]]],maxLevel,[],[height]);
//translate([20,0,0])leftskinnyTriangleDeflation(maxLevel);
//translate([30,0,0])rightskinnyTriangleDeflation(maxLevel);















