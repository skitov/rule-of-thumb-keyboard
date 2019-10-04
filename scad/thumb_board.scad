include<column.scad>
include<mod_dpad.scad>

dz5=1;
dz6=dz5+1;

dy3 = 0;
dy2 =dy3 -2;
dy1 = dy2-10;
dy4=dy3-4;
dy5=dy4-1;
dy6=dy5-1;

col_dz=[0,0,0,0,dz5,dz6];
col_dy=[dy1, dy2, dy3, dy4, dy5, dy6];

pin_h=3;
pin_d = 3;

fast=true;
/* fast=false; */

function vec_from_to(v1, v2, l) = [ (1-l)*v1[0]+l*v2[0],
				    (1-l)*v1[1]+l*v2[1],
				    (1-l)*v1[2]+l*v2[2] ];

function rot_v(v,a) = [v[0]*cos(a)-v[1]*sin(a), v[0]*sin(a)+v[1]*cos(a)];

function vec_sum(v1, v2) = [ v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2] ];

function v3_diff(v1, v2) = [v1[0]-v2[0], v1[1]-v2[1], v1[2]-v2[2]];

function v3_len(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);

module rot_cyl(v) {
	lat = acos(v[2]/v3_len(v));
	lon = atan2(v[1], v[0]);
	rotate([0,0,lon]) rotate([0,lat,0]) children();
}

x_step=24;
x_leftmost=0;

module side_from(r, lat, lon)
{
	inf = 1000;
	difference()
	{
		children();
		rotate([0,0,lon]) rotate([0,lat,0])
			translate([r+inf/2,0,0]) cub([inf,inf,inf]);
	}
}

module rotate_around(center, angles)
{
	translate(center)
		rotate(angles)
		translate(-center)
		children();
}

module beam(start, end, d=3) {
	dir=v3_diff(end,start);
	l = v3_len(dir);
	translate(start) rot_cyl(dir) translate([0,0,l/2]) cylinder(d=d, h=l, center=true);
}

module leg_connector(from, to) {
	l = sqrt((to[0]-from[0])*(to[0]-from[0]) + (to[1]-from[1])*(to[1]-from[1]));
	translate([from[0], from[1],0]) rotate([0,0,atan2(to[1] - from[1], to[0] - from[0])]) translate([l/2,0,1]) cube([l,7,2],center = true);
}

module base_board()
{
	for(i=[0:5])
	{
		translate([cell_side*(i-2), col_dy[i], 0]) column(col_dz[i], fast);	
	}
}

module hand_rest_pins(male=false) {
	w = 20;
	pos = [[0,0,0],[w,0,0],[w,0,w/sqrt(3)]];
	for(p = pos)
		translate(p) rotate([90,0,0]) cyl_with_sex(pin_d, pin_h, male);
}

module side_pins(male=false, detach=false) {
	w=y1 - y0 -10 - pin_d -6;
	h=15;
	pin_shift = 1.5*pin_d+pin_h/2-1;
	if(detach) {
		translate([0,0,pin_h/2]) {
			for(x=[0:w:w], y = [0:h:h])
				translate([x,y,0]) {
					cyl_with_sex(pin_d, pin_h, male);
					translate([x==0?-pin_shift:pin_shift,0,0])
						rotate([0,90,0]) cyl_with_sex(pin_d, pin_h+2, true);
				}
			beam([1.8,0,0],[w-1.8,h,0]);
			beam([w-1.8,0,0],[1.8,h,0]);
		}
	}
	else {
		for(y=[0:w:w], z = [0:h:h])
			translate([0,y,z]) rotate([0,90,0]) cyl_with_sex(pin_d, pin_h, male);
	}
}

module connect_space_row_cells(pos1, pos2, a1, a2) {
	xstep = pos2[0] - pos1[0];
	conn_len = xstep-cell_side;
	from=vec_sum(pos1, [cell_side/2,0,0]);
	to=vec_sum(pos2, [-cell_side/2,0,0]);
	if(conn_len > 0)
		for(l=[0.025:0.05:1]) {
			translate(vec_from_to(from, to, l))
				rotate([(1-l)*a1 + l*a2, 0, 0])
				cube([conn_len/20, cell_side, cell_h], center=true);
		}
}

module space_row() {
	a1= 10;
	a2= 10;
	a3= 30;
	a=[a1,a2,a3];
	dz = [0,0,0];
	
	for(i=[0:2]) {
		d=(2-i);
		translate([x_leftmost + i*x_step, 0, dz[i]]) rotate([a[i], 0, 0]) {
			cell(0,fast);
			translate([0, (cell_side + d)/2,0]) cube([cell_side, d, cell_h], center=true);
		}
	}
	connect_space_row_cells( [x_leftmost, 0, dz[0]], [x_leftmost + x_step, 0, dz[1]], a1, a2);
	connect_space_row_cells( [x_leftmost + x_step, 0, dz[1]], [x_leftmost + 2*x_step, 0, dz[2]], a2, a3);
}

function col_idx(x) = floor((x + 2.5*cell_side)/cell_side);
function y_edge(cidx)= cidx < 0?-1000:(cidx > 5?1000:(col_dy[cidx] - 1.5*cell_side));

module base_board_ext(x, last_one = false) {
	x1=x-cell_side/2;
	x2=x+cell_side/2;
	col = col_idx(x1);
	x1_5=cell_side*(col-1.5);
	y0= y_edge(col);
	y1 = y_edge(col+1);
	if(last_one) {
		d4=3;
		d5=2;
		translate([(x1_5+x2)/2,y1-d5/2,zxcv_dz+col_dz[col+1]])
			cube([x2-x1_5, d5, cell_h], center = true);
		translate([(x1_5+x1)/2,y0-d4/2,zxcv_dz+col_dz[col]])
			cube([x1_5-x1, d4, cell_h], center = true);
	}
	else if(y0 < y1) {
		translate([(x1_5+x2)/2,(y0+y1)/2,zxcv_dz+col_dz[col+1]])
			cube([x2-x1_5, y1-y0, cell_h], center = true);
	} else {
		translate([(x1_5+x1)/2,(y0+y1)/2,zxcv_dz+col_dz[col]])
			cube([x1_5-x1, y0-y1, cell_h], center = true);
	}
}

module fboard_pins(male=true, mask = 63) {
	positions = [
		[cell_side *2.5, -cell_side/2 + dy6, -(cell_h+pin_h)/2], //D-Pad pin
		[cell_side/2, -cell_side*1.5, -(cell_h+pin_h)/2], //Thumb double button pin
		[cell_side*3.5-pin_d/2, cell_side*2.5+dy6, -(cell_h+pin_h)/2],
		[cell_side*3.5-pin_d/2, -cell_side/2+dy6, -(cell_h+pin_h)/2],
		[-cell_side*2.5+pin_d/2, cell_side*2.5+dy1, -(cell_h+pin_h)/2],
		[-cell_side*2.5+pin_d/2, -cell_side/2+dy1, -(cell_h+pin_h)/2]
		];
	for(i=[0:5])
	{
		if (floor(mask/pow(2,i)) % 2 == 1) {
			translate(positions[i]) {
				cyl_with_sex(pin_d, pin_h, male);
				if(male)
				{
					translate([0,0,pin_h - 0.1])
						cyl_with_sex(pin_d, pin_h, male);
				}
			}
		}
	}
	/* for(pos = positions) { */
	/* 	echo ("mask: ", m); */
	/* 	m = floor(m/2); */
	/* } */
	/* translate([cell_side*3.5+pin_h/2,-cell_side/2+dy6,0]) */
	/* 	rotate([0,90,0]) cyl_with_sex(pin_d, pin_h, male); */
}

module flat_board_right_col() {
	translate([cell_side*(3), col_dy[5], 0]) column(col_dz[5], true);	
	translate([6.5, -43, 0.5]) translate([x_leftmost + 2*x_step, 0, 0]) rotate([30, 0, 0])
		cell(0,true);
	base_board_ext(x_leftmost + 6.5 + 2*x_step, last_one=true);
}


// "flat" part of the board: symbols, f and space rows. 
module flat_board() {
	base_board();
	fboard_pins();
	translate([6.5, -43, 0.5]) space_row();
	base_board_ext(x_leftmost+6.5);
	base_board_ext(x_leftmost + 6.5 + x_step);
	difference() {
		base_board_ext(x_leftmost + 6.5 + 2*x_step, last_one=true);
		translate([x_leftmost + 2*x_step+6.5, -43, 0.5]) rotate([30, 0, 0]) cell_hole();
	}
}

module dpad_group(cherry_holes = false) {
	k_h=6;
	rotate_around([33,-2,0], [0,0,-15]) {
		rotate([0,0,-45]) rotate([0,90,0])
			for(x=[-9.5,9.5])
				translate([x,-3,-4]) {
					if(cherry_holes) {
						square(cell_side - 2*side_thickness, cell_h - 2*plate_thickness);
					}
					else {
						cell();
					}
					/* translate([0,0,k_h+cell_h/2]) key(); */
				}
		if(cherry_holes == false)
			translate([33,13,0]) rotate([90,0,0]) rotate([0,0,-30]) dpad_assembled();
	}
}

module inclined_board(thumb_half=false, cherry_holes = false)
{
	rotate([0,-30,0]) {
		if(cherry_holes == false) {
			translate([0,0,50]) {
				if(thumb_half) {
					fboard_pins(false, 11);
				}
				else
					fboard_pins(false);
			}
			/* translate([0,0,50]) flat_board(); */
			difference() {
				translate([82,-34,43]) rotate([0,0,30]) rotate([70,0,0]) mod_assembled();
				translate([0,0,50]) flat_board_right_col();
			}
		}
		translate([14, -44, 23]) dpad_group(cherry_holes);
	}
}

module pinky_section() {
	translate([-cell_side/2,0,0]) cell(2);
	translate([cell_side/2,0,0]) cell();
	translate([0,-cell_side/2 - 22, 0]) rotate([0,0,90]) mod_assembled();
}

module leg(h, inclination=false) {
	w_cross=10;
	translate([0,0,1]) cub([20, 20, 2]);
	if(inclination) {
		difference() {
			translate([0,0,(h+5)/2]) {
				cube(size=[2,w_cross,(h+5)], center = true);
				cube(size=[w_cross,2,(h+5)], center = true);
			}
			translate([0,0,h]) {
				rotate([0,-30,0]) {
					translate([0,0,10]) {
						square(20,20);
					}
				}
			}
		}
	}
	else {
		translate([0,0,h/2]) {
			cube(size=[2,w_cross,h], center = true);
			cube(size=[w_cross,2,h], center = true);
		}
	}
}

module base_conn_beams(all=true) {
	beam([-0.5,-30,35], [13,-24,38]); /* dpad mount to thumb cherry high */
	beam([9,-28,17], [24,-24,23]); /* dpad mount to thumb cherry low */
	beam([-15,-31.3,39], [-12,-32,36.5]); /* thumb cherry to fboard mount */
	beam([35.5,-28.5,43], [34.5,-19,44]);/*leg to dpad_mount */
	beam([40,-28.5,34], [34.5,-19,34]);/*leg to dpad_mount */
	beam([32,-26,21], [33,-20,1]);/* dpad_mount to bottom */
	beam([19,-19,58.8], [19,-28,55]); /* dpad_mount to fboard_mount */
	beam([42,-37,68.5], [38,-33,62]); /* mod mount to dpad mount */
	beam([56,-32,69], [47,-34,59]); /* mod_mount to dpad_mount */
	beam([47.5,-28.5,78], [35,-18,67]); /* mod_mount to leg */
	beam([56,-32,69], [35,-18,67]); /* mod_mount to leg */
	if(all) {
		beam([-115,10,13.5], [-115,-1,13.5]);
		beam([-85,10,13.5], [-85,-1,13.5]);
		beam([-100,10,13.5], [-100,6,13.5]);
		beam([34.5,-6,41], [34.5,32,54]);
		beam([34.5,-6,54], [34.5,32,41]);
		translate([34.5,-8,40]) side_pins();
	}
	beam([-12, -27, 41], [15, -17, 56.5]);
	beam([22, -15.5, 60], [32, -15.5, 66]);
	translate([-40,-30,10]) hand_rest_pins();
	beam([-38, -30, 10], [-22, -30, 10]);
	beam([-20, -30, 12], [-20, -30, 18]);
	beam([-38, -30, 11.5], [-22, -30, 20]);
	beam([-42, -30, 9], [-60, -20, 1.5]);
	beam([-19, -30, 24], [-17, -29, 38]);
	beam([0, -35, 1.5], [-18, -29.5, 8]);
}

dx0 = (6*cell_side - 3);
dx = dx0*cos(30);
dz = dx0*sin(30);
y0 = -cell_side/2+dy6;
y1 = cell_side*2.5+dy6;
pos0 = rot_v([-cell_side*2.5+1.5, 50-cell_h/2-3],30);
x0 = pos0[0];
h0 = pos0[1] - 4.5;

module inclegs() {
	translate([x0,y0 + dy1-dy6,0]) leg(h0, true);
	translate([x0,y1 + dy1-dy6,0]) leg(h0, true);
	translate([x0+dx,y0,0]) leg(h0+dz, true);
	translate([x0+dx,y1,0]) leg(h0+dz, true);
	translate([0, -43, 0]) leg(2);
	translate([-120,-20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-120,20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-80,-20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-80,20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-71.5,27.5,1]) cylinder(d=10, h=2, center = true);
	leg_connector([-55,-24],[-5,-41]);
	leg_connector([-62,-17],[-62,30]);
	leg_connector([34,-10],[34,35]);
	leg_connector([5,-40],[30,-20]);
	leg_connector([-58,35],[30,40]);
	leg_connector([-115,-17],[-85,15]);
	leg_connector([-85,-17],[-115,15]);
}

module part_conn(male = true) {
	if(male) {
		translate([-1, 0, 5]) cub([2, 20, 10]);
		translate([2, 0, 5]) rotate([0,90,0]) cyl(3, 4);
	}
	else {
		difference() {
			translate([1, 0, 5]) cub([2, 20, 10]);
			translate([2, 0, 5]) rotate([0,90,0]) cyl(3, 4);
		}
	}
}

module pinky_board()
{
	x_shift = 50;
	translate([-100 + x_shift,19,12+cell_h/2]) pinky_section();
	translate([-120 + x_shift,-20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-120 + x_shift,20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-80 + x_shift,-20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([-80 + x_shift,20,0]) {leg(13);translate([0,0,12.5]) cyl(d=10,h=2);}
	translate([x0+x_shift,y0 + dy1-dy6,0]) {
		leg(h0, true);
		translate([10,0,0]) part_conn();
	}
	translate([x0+x_shift,y1 + dy1-dy6,0]) {
		leg(h0, true);
		/* translate([10,0,0]) part_conn(); */
	}
	leg_connector([-115 + x_shift,-17],[-85 + x_shift,15]);
	leg_connector([-85 + x_shift,-17],[-115 + x_shift,15]);
	leg_connector([-62 + x_shift,-17],[-62 + x_shift,30]);
	beam([-115 + x_shift,10,13.5], [-115 + x_shift,-1,13.5]);
	beam([-85 + x_shift,10,13.5], [-85 + x_shift,-1,13.5]);
	beam([-100 + x_shift,10,13.5], [-100 + x_shift,6,13.5]);
	translate([x_shift, 0, -4.5]) rotate([0,-30,0]) {
		translate([0,0,50]) {
			fboard_pins(male = false, mask = 52);
		}
	}
	leg_connector([-58 + x_shift,35],[30 + x_shift,40]);
	translate([x0+dx + x_shift,y1,0]) {
		difference() {
			leg(h0+dz, true);
			translate([0, -5+pin_h/2, 40]) rotate([90,0,0]) union() {
				translate([0,15,0]) cyl_with_sex(pin_d+0.1, pin_h+0.2, true);
				cyl_with_sex(pin_d, pin_h, true);
			}
		}
		translate([0, -5+pin_h/2, 40]) rotate([90,0,0]) union() {
			translate([0,15,0]) cyl_with_sex(pin_d, pin_h, false);
			cyl_with_sex(pin_d, pin_h, false);
		}
		translate([0,-10,0]) rotate([0,0,-90]) part_conn();
	}
	side_pins(false, true);
}

module thumb_board()
{
	side_from(0,90,0) translate([0,0,-4.5]) inclined_board(thumb_half=true);
	translate([x0+dx,y0,0]) leg(h0+dz, true);
	translate([x0 + dx,y1-10,0]) rotate([0,0,-90]) part_conn(false);
	leg_connector([5,-40],[30,-20]);
	difference() {
		translate([0, -43, 0]) leg(2);
		translate([0,0,-4.5]) inclined_board(cherry_holes=true);
		/* translate([0,0,-4.5]) rotate([0,-30,0]) */
		/* 	rotate([0,-30,0]) */
		/* 	translate([14, -44, 23]) */
		/* 	rotate_around([33,-2,0], [0,0,-15]) */
		/* 	rotate([0,0,-45]) */
		/* 	rotate([0,90,0]) { */
		/* 	translate([9.5,-3,-4]) { */
		/* 		square(cell_side - 2*side_thickness, cell_h - 2*plate_thickness); */
		/* 		cell(fast=true); */
		/* 	} */
		/* 	translate([-9.5,-3,-4]) { */
		/* 		square(cell_side - 2*side_thickness, cell_h - 2*plate_thickness); */
		/* 		cell(fast=true); */
		/* 	} */
		/* } */
	}
	translate([x0,y0 + dy1-dy6,0]) {
		translate([10,0,0]) part_conn(false);
	}
	side_from(-x0-10, 0, 180) {
		leg_connector([-55,-24],[-5,-41]);
		base_conn_beams(false);
	}
	side_from(y1-10, 0, 90)
		leg_connector([34,-10],[34,35]);
}

module whole_kb() {
	translate([0,0,-4.5]) inclined_board();
	translate([-100,19,12 + cell_h/2]) pinky_section();
	inclegs();
	base_conn_beams();
}

module test() {
	x=[16, 1, 1];
	echo(x);
	echo(-x);
	/* x = floor(x/2); */
	/* echo(x); */
	/* x = floor(x/2); */
	/* echo(x); */
	/* for(i=[0:1:4]) { */
	/* } */
}

/* test(); */
/* whole_kb(); */
/* inclined_board(); */
thumb_board();
/* pinky_board(); */
/* mirror() flat_board(); */
/* dpad_group(); */
