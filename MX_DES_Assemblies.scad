include <MX_DES_Standard.scad>



keyNames = [
    // name,            homeDot
    ["M 1u R2",         false],
    ["M 1u R3 Home",    false],
    ["M 1u R4",         false],
];

for ( i = [0 : len(keyNames)-1] ){
  offset = i*20;

  keyName = keyNames[i][0];
  homeDot = keyNames[i][1] ? 180 : 0;

  keyID = keyIDbyName(keyName);

  translate([0,offset,0]) rotate(flipAngle, 0, 0) keycap(
    keyID  = keyID, //change profile refer to KeyParameters Struct
    homeDot = homeDot //turn on homedots
   );

  // connecting rods for 3d printing
  translate([0,offset+10,0]) rotate([90,90,0]) cylinder(h=2.5, r1=0.2, r2=0.2, center=true);
}
