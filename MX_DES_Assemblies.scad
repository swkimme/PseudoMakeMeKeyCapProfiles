include <MX_DES_Standard.scad> // use를 쓰면 crash



keyNames = [
    // name,            homeDot
    ["DSA",         false],
    ["DSA Thumb",    false],
    ["DSA tall",         false],
    ["DSA tall Thumb",         false],
    ["DSA Thin",         false],
    ["DSA Thumb Thin",    false],
    ["DSA tall Thin",         false],
    ["DSA tall Thumb Thin",         false],
    ["DSA",         true],
    ["DSA Thumb",         true],

];

for ( i = [0 : len(keyNames)-1] ){
  offset = i*20;

  keyName = keyNames[i][0];
  homeDot = keyNames[i][1];

  keyID = keyIDbyName(keyName);

  translate([0,offset,0]) rotate(flipAngle, 0, 0) keycap(
    keyID  = keyID, //change profile refer to KeyParameters Struct
    homeDot = homeDot //turn on homedots
   );

  // connecting rods for 3d printing
  translate([0,offset+10,0]) rotate([90,90,0]) cylinder(h=2.5, r1=0.7, r2=0.7, center=true);
}
