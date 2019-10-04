// children_indexed.scad - Usage of indexed children()

// children() with a parameter allows access to a specific child
// object with children(0) being the first one. In addition the
// $children variable is automatically set to the number of child
// objects.

use<key.scad>

function in_mm(inches) = 25.4*inches;

grid=in_mm(0.05);

plate_thickness=in_mm(0.06);
side_thickness=1;
plates_dist=5;
cell_h=plates_dist+plate_thickness;
cell_side=19;
central_hole_d=in_mm(0.157);
contact_hole_d=in_mm(0.059);
contact_hole_x1=3*grid;
contact_hole_x2=2*grid;
contact_hole_y1=2*grid;
contact_hole_y2=4*grid;
square_hole_side=14;

module cell_hole() {
	square(cell_side - 2*side_thickness, cell_h - 2*plate_thickness);
	translate([0,0,-0.5*plates_dist]) cylinder(h=plate_thickness+1, d=central_hole_d, $fn=60,center=true);
	translate([0,0,0.5*plates_dist]) square(square_hole_side, plate_thickness+1);
	for(x=[-cell_side/4:cell_side/2:cell_side/4])
		for(y=[-cell_side/4:cell_side/2:cell_side/4])
			translate([x,y,-0.5*plates_dist]) rounded_square(cell_side/3,plate_thickness+1);
}

module cell(dz=0, fast=false, row, with_cap=false)
{
	if(fast) {
		translate([0,0,dz/2]) square(cell_side, cell_h+dz);
		if(with_cap)
			translate([0,0,dz + cell_h/2 + 6]) key(row, row == 0?1.25:1);
	}
	else {
		translate([0, 0, dz]) {
			difference() {
			square(cell_side, cell_h);
			cell_hole();
			}
		}
		if(dz > 0)
		{
			translate([0,0,-0.5*(cell_h-dz)])
			difference() {
				square(cell_side, dz);
				square(cell_side - 2*side_thickness, dz+1);
			}
		}
	}
}

/* cell(); */
