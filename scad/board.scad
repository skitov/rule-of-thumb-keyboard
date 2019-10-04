use<lib.scad>
use<key.scad>

sr_x_step=24;
x_leftmost=0;

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
	sqr(cell_side - 2*side_thickness, cell_h - 2*plate_thickness);
	translate([0,0,-0.5*plates_dist]) cylinder(h=plate_thickness+1, d=central_hole_d, $fn=60,center=true);
	translate([0,0,0.5*plates_dist]) sqr(square_hole_side, plate_thickness+1);
	for(x=[-cell_side/4:cell_side/2:cell_side/4])
		for(y=[-cell_side/4:cell_side/2:cell_side/4])
			translate([x,y,-0.5*plates_dist]) rounded_square(cell_side/3,plate_thickness+1);
}

module cell(dz=0, fast=false, row, with_cap=false)
{
	if(fast) {
		up(dz/2) sqr(cell_side, cell_h+dz);
		if(with_cap)
			up(dz + cell_h/2 + 6) key(row, row == 0?1.25:1);
	}
	else {
		up(dz) {
			difference() {
			sqr(cell_side, cell_h);
			cell_hole();
			}
		}
		if(dz > 0)
		{
			down(0.5*(cell_h-dz))
			difference() {
				sqr(cell_side, dz);
				sqr(cell_side - 2*side_thickness, dz+1);
			}
		}
	}
}


dz5=1;
dz6=dz5+1;

dy3 = 0;
dy2 =dy3 -2;
dy1 = dy2-10;
dy4=dy3-4;
dy5=dy4-1;
dy6=dy5-1;


zxcv_dz=2.5;
qwer_dz=1;
1234_dz=qwer_dz+1;
f_dz=1234_dz+3.5;

function even_pos(first,last,step)=[for(i=[first:last]) i*step];

row_dz=[zxcv_dz, 0, qwer_dz, 1234_dz, f_dz];
row_dy=even_pos(-1,3,cell_side);

col_dx=even_pos(-2,3,cell_side);
col_dy=[dy1, dy2, dy3, dy4, dy5, dy6];
col_dz=[0,0,0,0,dz5,dz6];

function board_cell_mv(row, col) = shift_mv([col_dx[col],
					     row_dy[row] + col_dy[col],
					     0]);
function board_cell_dz(row,col) = row_dz[row]+col_dz[col];
function board_cell_full_mv(row, col) = shift_mv([col_dx[col],
						  row_dy[row] + col_dy[col],
						  board_cell_dz(row,col)]);

space_row_move=shift_mv([6.5,-43,0.5]);
sr_cell_angle = [10,10,30];
function sr_cell_mv(i) = [rot_mv([sr_cell_angle[i],0,0]),
			  shift_mv([i*sr_x_step,0,0])];

function full_sr_cell_mv(i) = concat(sr_cell_mv(i), [space_row_move]);

module base_board(fast=false)
{
	for(col=[0:5],row=[0:4])
		move_play([board_cell_mv(row,col)]) cell(board_cell_dz(row,col), fast, row);
}

module connect_space_row_cells(i) {
	module _conn(a)
	{
		translate([cell_side/2,0,0])
			rotate([0,90,0])
			linear_extrude(height=sr_x_step-cell_side, center=false,twist=-a, slices=30)
			square(size=[cell_h, cell_side], center=true);
	}
	move_play(sr_cell_mv(i)) _conn(sr_cell_angle[i+1] - sr_cell_angle[i]);
}

module space_row(fast=false) {
	for(i=[0:2]) {
		d=(2-i);
		/* Z-Rotate by 180, for visualizing keycaps backwards, like will be used */
		move_play(sr_cell_mv(i)) rotate([0,0,i==0?0:180]) cell(0,fast,row=0);
	}
	if(!fast)
		for(i=[0,1]) connect_space_row_cells(i);
}

function col_idx(x) = floor((x + 2.5*cell_side)/cell_side);

module cell_ext(back, boundary=false)
{
	s=100;
	y_shift=(s+cell_side)/2;
	h=boundary?100:cell_h;
	shift=[0,
	       back?(-y_shift):y_shift,
	       cell_h/2-h/2];
	translate(shift) cub([cell_side,s,h]);
}

module space_zxcv_conn(i)
{
	sr_move=concat(sr_cell_mv(i), [space_row_move]);
	clmn_idx=[for(x=[-cell_side/2,cell_side/2])
			col_idx(v_move_play(sr_move,[x,0,0])[0])];
	moves=[[1,[board_cell_full_mv(0,clmn_idx[0])]],
	       [1,[board_cell_full_mv(0,clmn_idx[1])]],
	       [0,sr_move]];
	module zxcv_ext(boundary)
	{
		for(c=clmn_idx)
			move_play([board_cell_full_mv(0,c)]) cell_ext(true, boundary);
	}
	
	intersection()
	{
		union()
		{
			zxcv_ext(false);
			move_play(sr_move)cell_ext(false,false);
		}
		zxcv_ext(true);
		move_play(sr_move)cell_ext(false,true);
	}
}

/* module flat_board_right_col() { */
/* 	translate([cell_side*(3), col_dy[5], 0]) column(col_dz[5], true);	 */
/* 	translate([6.5, -43, 0.5]) translate([x_leftmost + 2*sr_x_step, 0, 0]) rotate([30, 0, 0]) */
/* 		cell(0,true); */
/* 	base_board_ext(x_leftmost + 6.5 + 2*sr_x_step, last_one=true); */
/* } */


// "flat" part of the board: symbols, f and space rows. 
module flat_board(fast=false) {
	base_board(fast);
	move_play([space_row_move]) space_row(fast=fast);
	if(!fast) {
		for(i=[0:2]) space_zxcv_conn(i);
	}
}

/* flat_board(); */
/* base_board(); */
