/* [Key] */

//length in units of key
/* key_length = 1; */
//height in units of key. should remain 1 for most uses
key_height = 1;
//keycap type, [0:DCS Row 5, 1:DCS Row 1, 2:DCS Row 2, 3:DCS Row 3, 4:DCS Row 4, 5:DSA Row 3, 6:SA Row 1, 7:SA Row 2, 8:SA Row 3, 9:SA Row 4, 10:DCS Row 4 Spacebar, 11: g20 key (faked)]
key_profile_index = 2;

// keytop thickness, aka how many millimeters between the inside and outside of the top surface of the key
keytop_thickness = 1;

// wall thickness, aka the thickness of the sides of the keycap. note this is the total thickness, aka 3 = 1.5mm walls
wall_thickness = 3;

/* [Brim] */
//enable brim for connector
has_brim = 0;
//brim radius. 11 ensconces normal keycap stem in normal keycap
brim_radius = 11;
//brim depth
brim_depth = .3;

/* [Stabilizers] */
//whether stabilizer connectors are enabled
stabilizers = 0;
//stabilizer distance in mm
stabilizer_distance = 50;

/* [Dish] */
// invert dishing. mostly for spacebar
inverted_dish = 0;

/* [Stem] */
// cherry MX or Alps stem, or totally broken circular cherry stem [0..2]
stem_profile = 0;
// how inset the stem is from the bottom of the key. experimental. requires support
stem_inset = 0;
// stem offset in units NOT MM. for stepped caps lock
stem_offset = 0;

/* [Hidden] */
//change to round things better
$fn = 32;
//beginning to use unit instead of baked in 19.05
unit = 19.05;

//minkowski radius. radius of sphere used in minkowski sum for minkowski_key function. 1.75 default for faux G20
minkowski_radius = 1.75;

//profile specific stuff

/*
 Here we have, for lack of a better implementation, an array
 that defines the more intimate aspects of a key.
 order is thus:
 1. Bottom Key Width: width of the immediate bottom of the key
 2. Bottom Key Height: height of the immediate bottom of the key
 3. Top Key Width Difference: mm to subtract from bottom key width to create top key width
 4. Top Key Height Difference: mm to subtract from bottom key height to create top key height
 5. total Depth: how tall the total in the switch is before dishing
 6. Top Tilt: X rotation of the top. Top and dish obj are rotated
 7. Top Skew: Y skew of the top of the key relative to the bottom. DCS has some, DSA has none (its centered)
 8. Dish Type: type of dishing. check out dish function for the options
 9. Dish Depth: how many mm to cut into the key with
 10. Dish Radius: radius of dish obj, the Sphere or Cylinder that cuts into the keycap
*/

key_profiles = [

	//DCS Profile

	[ //DCS ROW 5
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		11.5, // total Depth
		-6,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 1
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		8.5, // total Depth
		-1,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 2
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6.2,   // Top Key Width Difference
		4,   // Top Key Height Difference
		7.5, // total Depth
		3,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 3
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		6.2, // total Depth
		7,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 4
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		6.2, // total Depth
		16,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],

	//DSA Profile

	[ //DSA ROW 3
	  18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  7.4, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  0,   // Dish Skew X
	  0    // DIsh Skew Y
	],

	//SA Proile

	[ //SA ROW 1
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  13.73, // total Depth, fudged
	  -14,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  0,   // Dish Skew X
	  0    // DIsh Skew Y
	],
	[ //SA ROW 2
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  -7,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  0,   // Dish Skew X
	  0    // DIsh Skew Y
	],
	[ //SA ROW 3
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  0,   // Dish Skew X
	  0    // DIsh Skew Y
	],
	[ //SA ROW 4
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  7,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  0,   // Dish Skew X
	  0    // DIsh Skew Y
	],
	[ //DCS ROW 4 SPACEBAR
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		6.2, // total Depth
		16,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		2,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //G20 AKA DCS Row 2 with no dish and shorter
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		2,   // Top Key Width Difference
		2,   // Top Key Height Difference
		6, // total Depth
		2.5,  // Top Tilt
		0.75,// Top Skew

		//Dish Profile

		3,   // Dish Type
		0,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //NONWORKING fake ISO enter
		18.16 * 1.5,  // Bottom Key Width
		18.16 * 2,  // Bottom Key Height
		4,   // Top Key Width Difference
		4,   // Top Key Height Difference
		7, // total Depth
		0,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
];

// derived variables
//key profile selected
key_profile = key_profiles[key_profile_index];
module set_profile(profile) {
	profile_idxs=[10,1,2,3,4,0];
	key_profile_index = profile_idxs[profile];
	key_profile = key_profiles[key_profile_index];
}

//keycap type, [0:DCS Row 5, 1:DCS Row 1, 2:DCS Row 2, 3:DCS Row 3, 4:DCS Row 4, 5:DSA Row 3, 6:SA Row 1, 7:SA Row 2, 8:SA Row 3, 9:SA Row 4, 10:DCS Row 4 Spacebar, 11: g20 key (faked)]
row_profile_idxs=[10,4,3,2,1,1,5,6,7,8,9,11];


// names, so I don't go crazy
function bottom_key_width(row) = key_profiles[row_profile_idxs[row]][0];
function bottom_key_height(row) = key_profiles[row_profile_idxs[row]][1];
function width_difference(row) = key_profiles[row_profile_idxs[row]][2];
function height_difference(row) = key_profiles[row_profile_idxs[row]][3];
function total_depth(row) = key_profiles[row_profile_idxs[row]][4];
function top_tilt(row) = key_profiles[row_profile_idxs[row]][5] / key_height;
function top_skew(row) = key_profiles[row_profile_idxs[row]][6];
function dish_type(row) = key_profiles[row_profile_idxs[row]][7];
function dish_depth(row) = key_profiles[row_profile_idxs[row]][8];
function dish_skew_x(row) = key_profiles[row_profile_idxs[row]][9];
function dish_skew_y(row) = key_profiles[row_profile_idxs[row]][10];

// actual mm key width and height
function total_key_width(row, key_length) = bottom_key_width(row) + (unit * (key_length - 1));
function total_key_height(row) = bottom_key_height(row) + (unit * (key_height - 1));

// actual mm key width and height at the top
function top_total_key_width(row, key_length) = bottom_key_width(row) + (unit * (key_length - 1)) - width_difference(row);
function top_total_key_height(row) = bottom_key_height(row) + (unit * (key_height - 1)) - height_difference(row);

//centered
module roundedRect(size, radius) {
	x = size[0];
	y = size[1];
	z = size[2];

	translate([-x/2,-y/2,0])
	linear_extrude(height=z)
	hull() {
		translate([radius, radius, 0])
		circle(r=radius);

		translate([x - radius, radius, 0])
		circle(r=radius);

		translate([x - radius, y - radius, 0])
		circle(r=radius);

		translate([radius, y - radius, 0])
		circle(r=radius);
	}
}

// stem related stuff

// bottom we can use to anchor the stem, just a big ol cube with the inside of
// the keycap hollowed out
module inside(){
	difference(){
		translate([0,0,50]) cube([100000,100000,100000],center=true);
		// NOTE: you're saying hey, if this is the inside why aren't we doing
		// wall_thickness, keytop_thickness? well first off congratulations for
		// figuring that out cuz it's a rat's nest in here. second off
		// due to how the minkowski_key function works that isn't working out right
		// now. it's a simple change if is_minkowski is implemented though
		shape(0, 0);
	}
}

module cherry_stem(){
	// cross length
	cross_length = 4.4;
  //extra vertical cross length - the extra length of the up/down bar of the cross
  extra_vertical_cross_length = 1.1;
	//dimensions of connector
	// outer cross extra length in x
	extra_outer_cross_width = 2.10;
	// outer cross extra length in y
	extra_outer_cross_height = 1.0;
	// dimensions of cross
	// horizontal cross bar width
	horizontal_cross_width = 1.4;
	// vertical cross bar width
	vertical_cross_width = 1.3;
	// cross depth, stem height is 3.4mm
	cross_depth = 4;

	difference(){
		union(){
            if (stem_profile != 2){
                translate([
                    -(cross_length+extra_outer_cross_width)/2,
                    -(cross_length+extra_outer_cross_height)/2,
                    stem_inset
                ])
    			cube([ // the base of the stem, the part the cruciform digs into
					cross_length+extra_outer_cross_width,
					cross_length+extra_outer_cross_height,
					50
    			]);
            } else {
                cylinder(
                    d = cross_length+extra_outer_cross_height,
                    h = 50
                );
            }
			if (has_brim == 1){ cylinder(r=brim_radius,h=brim_depth); }
		}
		//the cross part of the steam
		translate([0,0,(cross_depth)/2 + stem_inset]){
	        cube([vertical_cross_width,cross_length+extra_vertical_cross_length,cross_depth], center=true );
	        cube([cross_length,horizontal_cross_width,cross_depth], center=true );
	    }
	}
}

module alps_stem(){
	cross_depth = 40;
	width = 4.45;
	height = 2.25;

	base_width = 12;
	base_height = 15;

	translate([0,0,cross_depth/2 + stem_inset]){
		cube([width,height,cross_depth], center = true);
	}
}

//whole connector, alps or cherry, trimmed to fit
module connector(has_brim){
	difference(){
		//TODO can I really not do an array index here?
		translate([-unit * stem_offset, 0, 0])
		union(){
			if(stem_profile == 0 || stem_profile == 2) cherry_stem();
			if(stem_profile == 1) alps_stem();
		}
		inside();
	}
}

//stabilizer connectors
module stabilizer_connectors(has_brim){
	translate([stabilizer_distance,0,0]) connector(has_brim);
	translate([-stabilizer_distance,0,0]) connector(has_brim);
}



//shape related stuff




//general shape of key. used for inside and outside
module shape(thickness_difference, depth_difference, row, key_length){
  if (inverted_dish == 1){
		difference(){
			union(){
				shape_hull(thickness_difference, depth_difference, 1, row, key_length);
				dish(depth_difference, row, key_length);
			}
			outside(thickness_difference, row, key_length);
		}
	} else{
		difference(){
			shape_hull(thickness_difference, depth_difference, 1, row, key_length);
			dish(depth_difference, row, key_length);
		}
	}
}

// conicalish clipping shape to trim things off the outside of the keycap
// literally just a key with height of 2 to make sure nothing goes awry with dishing etc
module outside(thickness_difference, row, key_length){
	difference(){
		cube([100000,100000,100000],center = true);
		shape_hull(thickness_difference, 0, 2, row, key_length);
	}
}

// super basic hull shape without dish
// modifier multiplies the height and top differences of the shape,
// which is only used for dishing to cut the dish off correctly
// height_difference(row) used for keytop thickness
module shape_hull(thickness_difference, depth_difference, modifier, row, key_length){
	hull(){
		// bottom_key_width + (key_length -1) * unit is the correct length of the
		// key. only 1u of the key should be bottom_key_width long; all others
		// should be 1u
		roundedRect([total_key_width(row, key_length) - thickness_difference, total_key_height(row) - thickness_difference, .001],1.5);

		//height_difference(row) outside of modifier because that doesnt make sense
		translate([0,top_skew(row),total_depth(row) * modifier - depth_difference])
		rotate([-top_tilt(row),0,0])
		roundedRect([total_key_width(row, key_length) - thickness_difference - width_difference(row) * modifier, total_key_height(row) - thickness_difference - height_difference(row) * modifier, .001],1.5);
	}
}



//dish related stuff



//dish selector
module dish(depth_difference, row, key_length){
	if(dish_type(row) == 0){ // cylindrical dish
		cylindrical_dish(depth_difference, row, key_length);
	}
	else if (dish_type(row) == 1) { // spherical dish
		spherical_dish(depth_difference, row, key_length);
	}
	else if (dish_type(row) == 2){ // SIDEWAYS cylindrical dish - used for spacebar
		sideways_cylindrical_dish(depth_difference, row, key_length);
	}
	else if (dish_type(row) == 3){
  	// no dish
	}
}

module cylindrical_dish(depth_difference, row, key_length){
	/* we do some funky math here
	 * basically you want to have the dish "dig in" to the keycap x millimeters
	 * in order to do that you have to solve a small (2d) system of equations
	 * where the chord of the spherical cross section of the dish is
	 * the width of the keycap.
	 */
	// the distance you have to move the dish up so it digs in dish_depth millimeters
	chord_length = (pow(top_total_key_width(row, key_length), 2) - 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));
	//the radius of the dish
	rad = (pow(top_total_key_width(row, key_length), 2) + 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));

	if (inverted_dish == 1){
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([90-top_tilt(row),0,0])
		translate([0,-chord_length,0])
		cylinder(h=100,r=rad, $fn=1024, center=true);
	}
	else{
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([90-top_tilt(row),0,0])
		translate([0,chord_length,0])
		cylinder(h=100,r=rad, $fn=1024, center=true);
	}

}

module spherical_dish(depth_difference, row, key_length){
	//same thing as the cylindrical dish here, but we need the corners to just touch - so we have to find the hypotenuse of the top
	chord = pow((pow(top_total_key_width(row, key_length),2) + pow(top_total_key_height(row), 2)),0.5); //getting diagonal of the top

	// the distance you have to move the dish up so it digs in dish_depth(row) millimeters
	chord_length = (pow(chord, 2) - 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));
	//the radius of the dish
	rad = (pow(chord, 2) + 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));

	if (inverted_dish == 1){
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([-top_tilt(row),0,0])
		translate([0,0,-chord_length])
		//NOTE: if your dish is long at all you might need to increase this number
		sphere(r=rad, $fn=512);
	}
	else{
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([-top_tilt(row),0,0])
		translate([0,0,chord_length])
		sphere(r=rad, $fn=256);
	}
}

module sideways_cylindrical_dish(depth_difference, row, key_length){
	chord_length = (pow(top_total_key_height(row), 2) - 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));
	rad = (pow(top_total_key_height(row), 2) + 4 * pow(dish_depth(row), 2)) / (8 * dish_depth(row));

	if (inverted_dish == 1){
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([90,top_tilt(row),90])
		translate([0,-chord_length,0])
		cylinder(h=total_key_width(row, key_length) + 20,r=rad, $fn=1024, center=true); // +20 just cuz
	}
	else{
		translate([dish_skew_x(row), top_skew(row) + dish_skew_y(row), total_depth(row) - depth_difference])
		rotate([90,top_tilt(row),90])
		translate([0,chord_length,0])
		cylinder(h=total_key_width(row, key_length) + 20,r=rad, $fn=1024, center=true);
	}
}



//actual full key with space carved out and keystem/stabilizer connectors
module key(row, key_length=1){
	shape(0, 0, row, key_length);
	/* union(){ */
	/* 	difference(){ */
	/* 		shape(wall_thickness, keytop_thickness, row, key_length); */
	/* 	} */
	/* } */

	/* connector(has_brim); */

	/* if (stabilizers == 1){ */
	/* 	stabilizer_connectors(has_brim); */
	/* } */
}

/* // ACTUAL OUTPUT */
/* difference(){ */
/* 	key(); */
/* 	// preview cube, for seeing inside the keycap */
/* 	//cube([100,100,100]); */
/* } */

//minkowski_key();




// Experimental stuff


// key rounded with minkowski sum. still supports wall and keytop thickness.
// use in actual output section. takes a long time to render with dishes.
// required for keycap 11, G20 keycap.
module minkowski_key(){
	union(){
		difference(){
			minkowski(){
				shape(minkowski_radius*2, minkowski_radius);
				difference(){
					sphere(r=minkowski_radius, $fn=24);
					translate([0,0,-minkowski_radius])
						cube([2*minkowski_radius,2*minkowski_radius,2*minkowski_radius], center=true);
				}
			}
			shape(wall_thickness, keytop_thickness);
		}
	}

	connector(has_brim);

	if (stabilizers == 1){
		stabilizer_connectors(has_brim);
	}
}


// NOT 3D, NOT CENTERED
// corollary is roundedRect
module fakeISOEnter(thickness_difference){
    z = 0.001;
    radius = 2;
		/*TODO I figured it out. 18.16 is the actual keycap width / height,
		whereas 19.01 is the unit. ISO enter obeys that just like everything else,
		which means that it's height is 18.16 * 2 + (19.01 - 18.16) or, two
		keycap heights plus the space between them, also known as 18.16 +
		(19.01 * (key_height - 1)). this is followed by the width too. should fix
		to make this finally work*/
    unit = 18.16; // TODO probably not

		// t is all modifications to the polygon array
		t = radius + thickness_difference/2;

    pointArray = [
        [0 + t,0 + t],
        [unit*1.25 - t, 0 + t],
        [unit*1.25  - t, unit*2  - t],
        [unit*-.25 + t, unit*2  - t],
        [unit*-.25 + t, unit*1  + t],
        [0 + t, unit*1  + t]
    ];

    minkowski(){
        circle(r=radius, $fn=24);
        polygon(points=pointArray);
    }
}

//corollary is shape_hull
module ISOEnterShapeHull(thickness_difference, depth_difference, modifier){
    unit = 18.16; // TODO probably not
		height = 8 - depth_difference;
		length = 1.5 * unit; // TODO not used. need for dish

    translate([-0.125 * unit, unit*.5]) linear_extrude(height=height*modifier, scale=[.8, .9]){
        translate([-unit*.5, -unit*1.5]) minkowski(){
            fakeISOEnter(thickness_difference);
        }
    }
}


/* for(i=[0:5]) */
/* 	translate([0, i*19, 0]) key(row=i, key_length=1); */
/* for(i=[6:11]) */
/* 	translate([-19, (i-6)*19, 0]) key(row=i, key_length=1); */
