use <scad-utils/morphology.scad> //for cheaper minwoski
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <sweep.scad>
use <skin.scad>
//use <z-butt.scad>

/*DES (Distorted Elliptical Saddle) Sculpted Profile for 6x3 and corne thumb
Version 2: Eliptical Rectangle

*/
mirror([0,0,0])keycap(
  keyID  = 0, //change profile refer to KeyParameters Struct
  cutLen = 0, //Don't change. for chopped caps
  Stem   = true, //tusn on shell and stems
  Dish   = true, //turn on dish cut
  Stab   = 0,
  visualizeDish = false, // turn on debug visual of Dish
  crossSection  = false, // center cut to check internal
  homeDot = true, //turn on homedots
  Legends = false
 );

//#translate([0,38,13])cube([18-5.7, 18-5.7,1],center = true);
//Parameters
wallthickness = 1.4; // 1.5 for norm, 1.25 for cast master
topthickness  = 2.7;   // 3 for norm, 2.5 for cast master
stepsize      = 40;  //resolution of Trajectory
step          = 6;   //resolution of ellipes
fn            = 16;  //resolution of Rounded Rectangles: 60 for output
layers        = 40;  //resolution of vertical Sweep: 50 for output
dotRadius     = 0.6;   //home dot size
//---Stem param
Tol    = 0.05;
stemRot = 0;
stemWid = 7.55;
stemLen = 5.55 ;
stemCrossHeight = 4;
extra_vertical  = 0.6;
StemBrimDep     = 0.25;
stemLayers      = 50; //resolution of stem to cap top transition

bottom_width = 18.2;
top_width_difference = 8;
key_height = 7.5;
exponent = 1.9;
cap_round_fin = 3;

bw = bottom_width;
twd = top_width_difference;
kh = key_height;
ex = exponent;
crf = cap_round_fin;

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//Column high sculpt 3 row system
    //0~5
    [bw,  bw, twd, twd, kh, 0, 0, 0, 0, 0, ex, ex, 0, crf, 0, crf, ex, ex], //dsa thumb
    [bw,  bw, twd, twd, kh, 0, 0, 0, 0, 0, ex, ex, 0, crf, 0, crf, ex, ex], //dsa norm
    [bw,  bw, twd, twd, kh+1.5, 0, 0, 0, 0, 0, ex, ex, 0, crf, 0, crf, ex, ex], //dsa thumb tall
    [bw,  bw, twd, twd, kh+1.5, 0, 0, 0, 0, 0, ex, ex, 0, crf, 0, crf, ex, ex], //dsa norm tall
];

forward = 6;
pitch1 = 10;
thumb_pitch1 = -5;
tpitch1 = thumb_pitch1;
thumb_pitch2 = -55;
tpitch2 = thumb_pitch2;
pitch2 = -70;
arch_init = 13;
arch_fin = 15;

dishParameters = //dishParameter[keyID][ParameteID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDep DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  // low pro 3 row system
  [forward, 2, pitch1, pitch2, 4,    1.8, arch_init, arch_fin,     2, forward,  3, tpitch1, tpitch2, arch_init, arch_fin,     2], //dsa thumb
  [forward, 2, pitch1, pitch2, 4,    1.8, arch_init, arch_fin,     2, forward,  2,  pitch1,  pitch2, arch_init, arch_fin,     2], //dsa norm
  [forward-0.2, 2, pitch1, pitch2, 4,    1.8, arch_init, arch_fin,     2, forward-0.2,  3, tpitch1, tpitch2, arch_init, arch_fin,     2], //dsa thumb
  [forward, 2, pitch1, pitch2, 4,    1.8, arch_init, arch_fin,     2, forward,  2,  pitch1,  pitch2, arch_init, arch_fin,     2], //dsa norm
];

function FrontForward1(keyID) = dishParameters[keyID][0];  //
function FrontForward2(keyID) = dishParameters[keyID][1];  //
function FrontPitch1(keyID)   = dishParameters[keyID][2];  //
function FrontPitch2(keyID)   = dishParameters[keyID][3];  //
function DishDepth(keyID)     = dishParameters[keyID][4];  //
function DishHeightDif(keyID) = dishParameters[keyID][5];  //
function FrontInitArc(keyID)  = dishParameters[keyID][6];
function FrontFinArc(keyID)   = dishParameters[keyID][7];
function FrontArcExpo(keyID)  = dishParameters[keyID][8];
function BackForward1(keyID)  = dishParameters[keyID][9];  //
function BackForward2(keyID)  = dishParameters[keyID][10];  //
function BackPitch1(keyID)    = dishParameters[keyID][11];  //
function BackPitch2(keyID)    = dishParameters[keyID][12];  //
function BackInitArc(keyID)   = dishParameters[keyID][13];
function BackFinArc(keyID)    = dishParameters[keyID][14];
function BackArcExpo(keyID)   = dishParameters[keyID][15];

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4];  //
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function StemExponent(keyID) = keyParameters[keyID][17];

function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID)),
    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID)),
  ];

//------- function defining Dish Shapes

function ellipse(a, b, d = 0, rot1 = 0, rot2 = 360) = [for (t = [rot1:step:rot2]) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]]; //Centered at a apex to avoid inverted face

function DishShape (a,b,c,d) =
  concat(
//   [[c+a,b]],
    ellipse(a, b, d = 0,rot1 = 90, rot2 = 270)
//   [[c+a,-b]]
  );

function oval_path(theta, phi, a, b, c, deform = 0) = [
 a*cos(theta)*cos(phi), //x
 c*sin(theta)*(1+deform*cos(theta)) , //
 b*sin(phi),
];

path_trans2 = [for (t=[0:step:180])   translation(oval_path(t,0,10,15,2,0))*rotation([0,90,0])];


//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*ZAngleSkew(keyID))    //Z shift
  ];

function CapTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];
function CapRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

function CapRadius(t, keyID) = pow(t/layers, ChamExponent(keyID))*ChamfFinRad(keyID) + (1-pow(t/layers, ChamExponent(keyID)))*ChamfInitRad(keyID);

function InnerTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];

function StemTranslation(t, keyID) =
  [
    ((1-t)/stemLayers*TopWidShift(keyID)),   //X shift
    ((1-t)/stemLayers*TopLenShift(keyID)),   //Y shift
    stemCrossHeight+.1+StemBrimDep + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1 -StemBrimDep))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;
  //Stem Exponent


///----- KEY Builder Module
module keycap(keyID = 0, cutLen = 0, visualizeDish = false, rossSection = false, Dish = true, Stem = false, crossSection = true,Legends = false, homeDot = false, Stab = 0) {

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShape(DishDepth(keyID), FrontDishArc(i), 1, d = 0)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShape(DishDepth(keyID),  BackDishArc(i), 1, d = 0)) ];

  //Homing dot
  if(homeDot == true){
    rotate([0,YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-0.45]){
      for (i=[0:1:2]) translate([-1.3+1.3*i,0,0])sphere(r = dotRadius, $fn = 100, $fa = 12, $fs = 2);
    }
  }

  //builds
  difference(){
    union(){
      difference(){
        skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell

        //Cut inner shell
        if(Stem == true){
          translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
        }
      }
      if(Stem == true){
         translate([0,0,StemBrimDep])rotate(stemRot)difference(){
          cylinder(d =5.5,KeyHeight(keyID)-StemBrimDep, $fn= 32);
          skin(StemCurve);
          skin(StemCurve2);
        }
//        translate([0,0,-.001])skin([for (i=[0:stemLayers-1]) transform(translation(StemTranslation(i,keyID))*rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID),fn=fn,r=StemRadius(i, keyID)))]); //Transition Support for taller profile
      }


    }

    //Cuts

    //Fonts
    if(Legends ==  true){
//          #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
      translate([0,0,KeyHeight(keyID)-5])linear_extrude(height =5)text( text = "A", font = "Calibri:style=Bold", size = 4, valign = "center", halign = "center" );
      //  #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }
   //Dish Shape
    if(Dish == true){
     if(visualizeDish == false){
      translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
     } else {
      #translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)]) rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
     }
   }
     if(crossSection == true) {
       translate([0,-15,-.1])cube([15,30,20]);
//      translate([-15.1,-15,-.1])cube([15,30,20]);
     }

  }

}
//------------------stems

MXWid = 4.03/2+Tol; //horizontal lenght
MXLen = 4.23/2+Tol; //vertical length

MXWidT = 1.15/2+Tol; //horizontal thickness
MXLenT = 1.25/2+Tol; //vertical thickness

function stem_internal(sc=1) = sc*[
[MXLenT, MXLen],[MXLenT, MXWidT],[MXWid, MXWidT],
[MXWid, -MXWidT],[MXLenT, -MXWidT],[MXLenT, -MXLen],
[-MXLenT, -MXLen],[-MXLenT, -MXWidT],[-MXWid, -MXWidT],
[-MXWid,MXWidT],[-MXLenT, MXWidT],[-MXLenT, MXLen]
];  //2D stem cross with tolance offset and additonal transformation via jog
//trajectory();
function StemTrajectory() =
  [ trajectory(forward = 5.25) ];

  StemPath  = quantize_trajectories(StemTrajectory(),  steps = 1 , loop=false, start_position= $t*4);
  StemCurve  = [ for(i=[0:len(StemPath)-1])  transform(StemPath[i],  stem_internal()) ];


function StemTrajectory2() =
  [trajectory(forward = .5)];

StemPath2  = quantize_trajectories(StemTrajectory2(),  steps = 10, loop=false, start_position= $t*4);
StemCurve2  = [for(i=[0:len(StemPath2)-1])  transform(StemPath2[i]*scaling([(1.1-.1*i/(len(StemPath2)-1)),(1.1-.1*i/(len(StemPath2)-1)),1]), stem_internal())];


module choc_stem() {

    translate([5.7/2,0,-3.4/2+2])difference(){
    cube([1.25,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }
  translate([-5.7/2,0,-3.4/2+2])difference(){
    cube([1.25,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }

}
/// ----- helper functions
function rounded_rectangle_profile(size=[1,1],r=1,fn=32) = [
	for (index = [0:fn-1])
		let(a = index/fn*360)
			r * [cos(a), sin(a)]
			+ sign_x(index, fn) * [size[0]/2-r,0]
			+ sign_y(index, fn) * [0,size[1]/2-r]
];

function elliptical_rectangle(a = [1,1], b =[1,1], fn=32) = [
    for (index = [0:fn-1]) // section right
     let(theta1 = -atan(a[1]/b[1])+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta1), a[1]*sin(theta1)]
    + [a[0]*cos(atan(b[0]/a[0])) , 0]
    - [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    - [0, b[0]*sin(atan(b[0]/a[0]))]
    + [0, a[1]*sin(atan(a[1]/b[1]))],

    for(index = [0:fn-1]) // section left
     let(theta2 = -atan(a[1]/b[1])+180+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta2), a[1]*sin(theta2)]
    - [a[0]*cos(atan(b[0]/a[0])) , 0]
    + [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + 180 + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    + [0, b[0]*sin(atan(b[0]/a[0]))]
    - [0, a[1]*sin(atan(a[1]/b[1]))]
]/2;

function sign_x(i,n) =
	i < n/4 || i > n-n/4  ?  1 :
	i > n/4 && i < n-n/4  ? -1 :
	0;

function sign_y(i,n) =
	i > 0 && i < n/2  ?  1 :
	i > n/2 ? -1 :
	0;

//#square([18.16, 18.16], center = true);
//#square([41.3, 19.05], center = true);
//scale(1.03)difference(){// assume 1% from infill and 2% for easy removal
//translate([0,0,13/2+.1])cube([21,21,13], center = true);
//
// projection()
// translate([0,28,0])rotate([0,-90,0]){
//translate([0,0,0])mx_master_base(xu = 7, yu = 1 );
