// What type of stem you want. Most people want Cherry.
$stem_type = "cherry";  // [cherry, alps, rounded_cherry, box_cherry, filled, disable]


/* [Key] */
// Height in units of key. should remain 1 for most uses
$key_height = 1.0;
// Keytop thickness, aka how many millimeters between the inside and outside of the top surface of the key
$keytop_thickness = 1.5;
// Wall thickness, aka the thickness of the sides of the keycap. note this is the total thickness, aka 3 = 1.5mm walls
$wall_thickness = 1.4;
// Width of the very bottom of the key
$bottom_key_width = 18.16;
// Height (from the front) of the very bottom of the key
$bottom_key_height = 18.16;

// How much higher the stem is than the bottom of the keycap.
// Inset stem requires support but is more accurate in some profiles
// can be negative to make outset stems!
$stem_inset = 0.25;
// How many degrees to rotate the stems. useful for sideways keycaps
$stem_rotation = 0;
// How many degrees to rotate the keycap, but _not_ inside features (the stem).
$keycap_rotation = 0;

// Whether or not to render fake keyswitches to check clearances
$clearance_check = true;


// colors
$primary_color = [.2667,.5882,1];
$secondary_color = [.4412, .7, .3784];
$tertiary_color = [1, .6941, .2];
$quaternary_color = [.4078, .3569, .749];
$warning_color = [1,0,0, 0.15];

