include <MX_DES_Standard.scad>

keyNames = [
    // name,            flip
    ["M 1u R2",         true],
    ["M 1u R3 Home",    true],
    ["M 1u R4",         true],
];

for ( i = [0 : len(keyNames)-1] ){
  offset = i*19.05;
  keyName = keyNames[i][0];
  flipAngle = keyNames[i][1] ? 180 : 0;

  keyID = keyIDbyName(keyName);

  translate([0,offset,0]) rotate(flipAngle, 0, 0) keycap(
    keyID  = keyID, //change profile refer to KeyParameters Struct
    homeDot = false //turn on homedots
   );

 }

