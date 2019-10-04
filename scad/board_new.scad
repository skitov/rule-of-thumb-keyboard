use <lib.scad>
include<mod_dpad.scad>
include<board.scad>

pind=4;
pinh=5;
pinw=2;

fboard_incline=30;
ref_dpad_h=14;
dpad_h=dpad_button_elev + dpad_button_thickness;
ref_mod_h=12.35;
mod_h=mod_button_elev + mod_button_thickness();

$leg_width = 10;

// Part to part rotations

thumb_mod_to_fboard = [shift_mv([0,0,ref_mod_h - mod_h]),
		       rot_mv([70,0,30]),
		       shift_mv([82, -34, -7])];

b2m = inv_move(thumb_mod_to_fboard);

thumb_cherry_to_fboard = [
	shift_mv([0,0,-2]),
	rot_mv([0,90,-30]),
	shift_mv([5,-50,-27])];

b2c = inv_move(thumb_cherry_to_fboard);

dpad_to_fboard = [shift_mv([0,0,ref_dpad_h - dpad_h]),
		  rot_mv([0,0,-fboard_incline]),
		  rot_mv([80,0,-15]),
		  shift_mv([2.5*cell_side,-35,-30])];

b2d = inv_move(dpad_to_fboard);

thumb_cherry_to_dpad=concat(thumb_cherry_to_fboard,
			    inv_move(dpad_to_fboard));

dpad_to_thumb_cherry = concat(dpad_to_fboard,
			      inv_move(thumb_cherry_to_fboard));

dpad_to_mod = concat(dpad_to_fboard, inv_move(thumb_mod_to_fboard));
mod_to_dpad = concat(thumb_mod_to_fboard, inv_move(dpad_to_fboard));

elev=46;
fboard_to_usepos = [rot_mv([0,-fboard_incline,0]),
		    shift_mv([0,0,elev])];
b2u=fboard_to_usepos;
c2b=thumb_cherry_to_fboard;
m2b=thumb_mod_to_fboard;
d2b=dpad_to_fboard;
c2u=concat(c2b, b2u);
d2u=concat(d2b, b2u);
m2u=concat(m2b, b2u);

pinky_to_fboard = [shift_mv([-100,19,16.5 + cell_h/2]),
		   rot_mv([0,fboard_incline,0]),
		   shift_mv([0,0,-50])];
p2u=concat(pinky_to_fboard, fboard_to_usepos);
b2p = inv_move(pinky_to_fboard);
// To finale pos


// Part to part connections


module the_mirr()
{
     mirror([1,0,0]) children();
}

module add_b2p_pins(move, male)
{
	pos=[[0,25,0],
	     [0,0,0],
	     [0,-25,0]];

	mv=[rot_mv([0,120,0]),
	    shift_mv([-53,-2,3.2])];
	add_pins(pos, male, pind,pinh, pinw,male?2:0,concat(mv,move))
		children();
}

module add_b2c_pins(move, male)
{
	pos=[[0,0,0]];
	mv=[rot_mv([0,90,0]),
	    shift_mv([-cell_side-pinh/2,-5.5,0])];
	add_pins(pos,male,pind,pinh, pinw,
		 male?1:3, concat(mv,move)) children();
}

module add_b2d_conn(move,male)
{
	zift = cell_h/2 + pinh/2;
	pos=[[1.5*cell_side, 1.5*cell_side-0.5, zift],[2.5*cell_side, 1.5*cell_side +4.7, zift]];
	add_pins(pos, male, pind, pinh, pinw,male?2:3,
		 concat([rot_mv([180,0,0])],move)) children();
}

mod_board_conn_pos = [for(a = [0,60]) rot_v([0,0,$mod_rot + a],[16,0,2])];

module add_b2m_conn(move,male)
{
	/* pinh=8; */
	/* mv1 = concat([rot_mv([0,90,0])], */
	/* 	     [shift_mv([cell_side/2+pinh/2,-cell_side/2 + pind/2+1,1.3])], */
	/* 	     [board_cell_full_mv(0,5)]); */
	/* mv2 = concat([shift_mv([16,0,2])], */
	/* 	     [rot_mv([0,0,$mod_rot])], */
	/* 	     thumb_mod_to_fboard); */
	/* add_pins([[0,0,0]],male,pind, pinh, 0,0,concat(mv1, move)) */
	avp = average(mod_board_conn_pos);
	inv = [shift_mv(-avp), rot_mv([180,0,0]), shift_mv(avp)];
	add_pins(mod_board_conn_pos,male,pind, 4, pinw, male?.5:0, concat(inv, move))
		children();
}

module add_c2d_conn(move, male)
{
	ypos=[16,2.5,-10];
	pos=[for(y=ypos) [-2,y,-37.5]];
	mv=[rot_mv([0,90,fboard_incline])];
	difference() {
		add_pins(pos, male, pind, 30, 0, 0, concat(mv, move)) children();
		if(male)
		{
			move_play(thumb_cherry_to_dpad)
				half_space_down(-cell_h/2);
		}
	}
}

module add_d2m_conn(move, male)
{
	mod_conn_pos = rot_v([0,0,$mod_rot-90], [0,-16,2]);
	dpad_conn_pos = v_move_play(mod_to_dpad, mod_conn_pos) + [-2.5,-0.35,0.8];
	mv=concat([rot_mv([0,-90,fboard_incline])],[shift_mv(dpad_conn_pos)]);
	/* mv=concat([shift_mv([-16,0,2])],[rot_mv([0,0,30])]); */
	add_pins([[0,0,0]],male, pind, 9, 1.5,male?5:0, concat(mv, move)) {
		children();
		/* if(male) */
		/* 	move_play(concat([shift_mv([0,0,-11.5])], mv, move)) cyl(6,20); */
	}
}

// Part to leg connections

pl_pin_dz = (pinh - cell_h - 1)/2;
pinky_leg_conn_pos = [for(x=[-1,1], y=[-48,5]) [x*(cell_side+3.25), y, pl_pin_dz]];
mod_bot=ref_mod_h - mod_h;
pinky_bot = min(mod_bot, -(cell_h+1)/2);

module add_pl_pins(move, male)
{
	adjust=[shift_mv([0,0,pinky_bot+pinh/2])];
	add_pins(pinky_leg_conn_pos, male, pind,
		 pinh, 0, male?1:0, concat(adjust, move))
		children();
}

module add_cl_conn(move, male)
{
	mv=[rot_mv([0,-90,0]),
	    shift_mv([cell_side+pinh/2, -cell_side/2+4,0])];
	add_pins([[0,0,0]], male, pind, pinh, 0, male?1:0, concat(mv, move)) children();
}

module add_dl_conn(move,male)
{
	xpos=[-26,18];
	pos = [for(x=xpos) [x, -2, -22.5-pinh/2]];
	mv = [rot_mv([-90,0,fboard_incline])];
	add_pins(pos,male,pind,pinh,0,male?2:0,concat(mv,move)) children();
}

module add_ml_conn(move, male)
{
	mv = [rot_mv([-90,0,0]), shift_mv([0,-20-pinh/2,2])];
	add_pins([[0,0,0]], male, pind, pinh, 0, male?1:0, concat(mv, move)) children();
}

bl_zift = -pinh/2 - cell_h/2;
bl_conn_pos = [[-1.5*cell_side,-1.5*cell_side+dy2,0],
	  [-1.5*cell_side,3.5*cell_side+dy1,0],
	  [2.5*cell_side,3.5*cell_side+dy6,0],
	  [3.5*cell_side,2.5*cell_side+dy6,0],
	  [3.5*cell_side,-cell_side/2+dy6,0]];

module add_bl_conn(move, male)
{
	pos=[for(p=bl_conn_pos) [p[0],-p[1],-bl_zift]];
	mv=[rot_mv([180,0,0])];
	add_pins(pos, male, pind, pinh, pinw,male?1:3,concat(mv, move)) children();
}

// Parts


module pinky_section(fast = false) {
	module add_conn_pins()
	{
		add_b2p_pins(move=b2p, male=false)
			add_pl_pins(move=[],male=false)
			children();
	}
	translate([-cell_side/2,0,0]) cell(2, fast, 5);
	translate([cell_side/2,0,0]) cell(0, fast, 5);
	translate([0,-cell_side/2 - 22, mod_bot]) mod_assembled(fast, false);
	if(!fast) {
		w=6.5;
		hh = cell_h/2 - mod_bot;
		elev = cell_h/4 + mod_bot/2;
		translate([0,-cell_side/2-2,elev]) cub([2*cell_side, 4, hh]);
		top = (cell_h+1)/2;
		h=top - pinky_bot;
		add_conn_pins()
		{
			for(i=[-1,1])
				translate([i*(cell_side+w/2),-21,top]) cub([w, 61,h], cub_bottom);
		}
	}
}

module thumb_cherry(fast=false)
{
	module _cells() {
		for(x=[-cell_side/2,cell_side/2])
		{
			translate([x,0,0]) cell(0, fast, 3, true);
		}
	}
	if(fast)
		_cells();
	else
	{
		add_cl_conn([], true) add_b2c_pins([], true) _cells();

		difference() {
			add_c2d_conn(dpad_to_thumb_cherry, false)
				translate([0,1.5*cell_side,0])
				cub([2*cell_side,2*cell_side, cell_h]);
			move_play(dpad_to_thumb_cherry) {
				half_space_down(-2);
			}
		}
	}
}

module dpad(with_button = false)
{
	module _dpad() dpad_assembled(fboard_incline, with_button);
	module _dpad_truncated() {intersection() {_dpad(); move_play(mod_to_dpad) half_space_down(-0.1);}}
	if(with_button)
		_dpad();
	else {
		side_from(0,-90,0)
			add_b2d_conn(b2d, true)
			add_c2d_conn([],true)
			add_dl_conn([], true)
		{
			add_d2m_conn([], true) {
				_dpad_truncated();
				/* intersection() { */
				/* 	_dpad(); */
				/* 	move_play(mod_to_dpad) half_space_down(-0.1); */
				/* } */
			}
			difference() {
				mv = concat([shift_mv([-32.5,0,0])],
					    dpad_plate_rot(fboard_incline));
				move_play(mv) cub([20,45,4], cub_top);
				/* Remove dpad plate intersection with modificators */
				move_play(thumb_cherry_to_dpad) half_space_down(cell_h/2);
			}
		}
	}
}

module thumb_mod(with_button = false)
{
	module _mod() { mod_assembled(with_button); }
	if(with_button) _mod();
	else {
		side_from(0,-90,0)
		add_ml_conn([], true)
			add_b2m_conn([], false)
			add_d2m_conn(dpad_to_mod,false)
			difference() {
			_mod();
			move_play(concat(full_sr_cell_mv(2), b2m)) cell(fast=true);
			move_play(concat([board_cell_full_mv(0,5)], b2m)) cell(fast=true);
		}
	}
}

module main_board(fast = false)
{
	if(fast)
		flat_board(fast);
	else {
		add_b2d_conn([],false)
		add_bl_conn([], false)
			difference() {
			add_b2c_pins(thumb_cherry_to_fboard,false) {
				size=[7,3,cell_h];
				flat_board(fast);
				translate([x_leftmost+6.5, -43, 0.5]) rotate([10, 0, 0])
					translate([-cell_side/2+size[0]/2,-cell_side/2-size[1]/2, 0]) cub(size);
			}
			translate([x_leftmost+6.5, -43, 0.5])
				rotate([10, 0, 0]) cell_hole();
			
			
		}
		add_b2p_pins([], true) {
			side_from(cell_h/2, -90, 0)
				side_from(-2.5*cell_side, 0, 0)
				translate([-53, -2, 3.2])
				rotate([0,-60,0])
				translate([0, 0, -pinh/2-20]) cub([6, 60, 40]);
		}
		add_b2m_conn(m2b,true)
		difference() {
			side_from(-3.5*cell_side, 0, 180) {

				for(i = [0,1]) {
					point_mod =
						v_move_play(thumb_mod_to_fboard, mod_board_conn_pos[i]);
					point_board = v_move_play([board_cell_full_mv(i,5)], [cell_side/2,0,-1]);
					beam(point_mod, point_board, 8);
				}
				/* rotate_around(ref_point, [0,0,-30]) */
				/* translate([-25,0,0] + ref_point) */
				/* 	rotate([0,90,0]) cyl(8,60,16); */
			}
			move_play(thumb_mod_to_fboard) mirror([0,0,1]) half_space_down(0);
		}
	}
}

// Legs
pl2bl_h=10;

pinky_legp=[for(p=pinky_leg_conn_pos) v_move_play(p2u, p)];
leg_conn_shift = ($leg_width - pinh)/2;
plr_pos=[for(i=[2,3]) [pinky_legp[i][0]+leg_conn_shift, pinky_legp[i][1], pl2bl_h]];
bl_pos=[for(p=bl_conn_pos) v_move_play(b2u, (p-[0,0,cell_h/2+pinh]))];
bll_pos=[for(i=[0,1]) [bl_pos[i][0]-leg_conn_shift, bl_pos[i][1], pl2bl_h]];
module add_pl2bl_pins(male, pos, left)
{
	xz = [pos[0][0], 0,pos[0][2]];
	mv=[shift_mv(-xz),
	    rot_mv([0,left?-90:90,0]),
	    shift_mv(xz)];
	add_pins(pos, male, pind, pinh, pinw, 1, mv) children();
}

cl_pos=v_move_play(c2u, [cell_side, -cell_side/2+4, 0]);
function v_atan(v)=atan2(v[1],v[0]);
wrist_rest_mv=[rot_mv([0,0,v_atan(cl_pos-bl_pos[0])]),
	       shift_mv(z0(bl_pos[0])+[0,-15,pind/2+pinw])];

module add_wrist_rest_pins(male)
{
	pos=[for(x=[0,15,30]) [x,0,0]];
	mrt=5;
	frt=15;
	add_pins(pos, male, pind, pinh, pinw, male?mrt:frt, concat([rot_mv([90,0,0])],wrist_rest_mv)) children();
}

module pl2bl_beam()
{
	xift=[pinh/2,0,0];
	lift=[0,0,pl2bl_h];
	p_lb=z0(plr_pos[1])+lift+xift;
	p_lf=z0(plr_pos[0])+lift+xift;
	p_rb=z0(bll_pos[1])+lift-xift;
	p_rf=z0(bll_pos[0])+lift-xift;
	add_pl2bl_pins(true, bll_pos, true)
	add_pl2bl_pins(true, plr_pos, false)
	side_from(p_rb[0], 0, 0)
		side_from(-p_lb[0],0,180) {
		beam(p_lb, p_rb);
		beam(p_lf, p_rf);
		beam(between(p_lb, p_rb),between(p_lf, p_rf));
	}
}

/* l2r_pin_pos= */

l2r_pos=[for(i=[3,4], z=[17.5, 60]) (z0(bl_pos[i])+[leg_conn_shift, 0, z])];

module add_l2r_conn(male, move=[])
{
	pos=[for(p=l2r_pos) rot_v([0,-90,0], p)];
	add_pins(pos, male, pind, pinh, pinw,male?1:0, concat([rot_mv([0,90,0])], move)) children();
}

module leg(h=200)
{
	_r=1;
	_w=$leg_width/2 - _r;
	linear_extrude(center=false, height=h) hull()
	{
		for(x=[-1,1], y=[-1,1])
		{
			translate([x*_w,y*_w,h/2]) circle(r=_r,$fn=16);
		}
	}
	linear_extrude(center=false, height=2) circle(r=15, $fn=16);
}

module pinky_legs()
{
	dz = min(mod_bot, -(cell_h+1)/2);
	leg_h=v_move_play(p2u, [0,0,dz])[2];
	add_pl2bl_pins(false, plr_pos, false)
		add_pl_pins(p2u, true)
	{
		for(p=pinky_legp)
			translate_hor(p) leg(leg_h);
	}
	ground_beam(pinky_legp[0],pinky_legp[3]);
	ground_beam(pinky_legp[1],pinky_legp[2]);
}

module board_legs()
{
	dpad_pin_r=22.5;
	mod_pin_r=20;
	board_pin_r=-cell_h/2-pinh;
	dpad_ps=[for (p=[[-26,-dpad_pin_r,2],[18,-dpad_pin_r,2]]) v_move_play(d2u, p*rot_mat_z(30))];
	mod_p=v_move_play(m2u, [0,-mod_pin_r,2]);

	pos_up=[rot_mv([0,-90,0])];
	pos_back=[rot_mv([0,0,90])];
	module legs(points, mv, h, pos_mv=[])
	{
		difference() {
			for(p=points)
			{
				translate_hor(p) leg();
			}
			move_play(concat(pos_mv, mv)) translate([h,0,0]) half_space();
		}
	}
	
	add_cl_conn(c2u, false)
		legs([cl_pos], c2u, -cell_side,[rot_mv([0,0,180])]);
	add_dl_conn(d2u, false)
		legs(dpad_ps, concat(dpad_plate_rot(fboard_incline), d2u), -dpad_pin_r, pos_back);
	add_ml_conn(m2u, false)
		legs([mod_p], m2u, -mod_pin_r, pos_back);
	add_l2r_conn(false)
	add_pl2bl_pins(false, bll_pos, true)
	add_bl_conn(b2u, true)
		legs(bl_pos, b2u, -(cell_h/2+pinh), pos_up);
	leg_perim=concat(bl_pos,[mod_p, dpad_ps[1], dpad_ps[0],cl_pos]);
	leg_support = [[20,true,true],
		       [20,true,true],
		       [35,true,false],
		       [35,false,true],
		       [35,true,true],
		       [35,true,false],
		       [20,false,true],
		       [0,false,false],
		       [0,false,false]];
	leg_count=len(leg_perim);
	function leg_sup_pt(i) = [leg_perim[i][0], leg_perim[i][1], leg_support[i][0]];
	add_wrist_rest_pins(false);
	for(i=[0:leg_count-1])
	{
		n=((i<leg_count-1)?i+1:0);
		pr=((i==0)?(leg_count-1):i-1);
		pr_l = leg_perim[pr];
		n_l = leg_perim[n];
		the_l = leg_perim[i];
		ground_beam(the_l, n_l);
		h=leg_support[i][0];
		pr_grnd = z0(between(the_l, pr_l, h/dist2(the_l, pr_l)));
		n_grnd = z0(between(the_l, n_l, h/dist2(the_l, n_l)));
		if(leg_support[i][1])
		{
			side_from(0,-90,0)
				beam(leg_sup_pt(i), pr_grnd, 8);
		}
		if(leg_support[i][2])
		{
			side_from(0,-90,0)
				beam([the_l[0], the_l[1], h], n_grnd, 8);
		}
	}
	beam(leg_sup_pt(2), leg_sup_pt(3), 8);
}


module lr_conn()
{
	a = -22.5;
	w = 35;
	dx = l2r_pos[0][0] + pinh/2;
	dy = l2r_pos[0][1];
	/* dy = (l2r_pos[0][1] + l2r_pos[2][1])/2; */
	center_shft = [-dx, -dy, 0];
	_mv = [rot_mv([0,0,a]), shift_mv([-w/2,0,0])];
	mv = concat([shift_mv(center_shft)],_mv);
	/* total_mv = concat([center_mv], mv); */
	function v_mirr(x) = [-x[0],x[1],x[2]];
	module mirr()
	{
		children();
		the_mirr()
			children();
	}
	module elem()
	{
		mirr()
		move_play(mv)
		{
			move_play(fboard_to_usepos) main_board();
			board_legs();
		}
	}
	module trim()
	{
		intersection()
		{
			children();
			the_mirr()
				move_play(_mv) half_space();
			move_play(_mv) half_space();
		}
	}
	/* elem(); */
	lo_pos = [for(i=[0,2]) v_move_play(mv, l2r_pos[i] + [pinh/2,0,0])];
	hi_pos = [for(i=[1,3]) v_move_play(mv, l2r_pos[i] + [pinh/2,0,0])];
	function middle(p, k = 0.5) = between(p, v_mirr(p), k);
	
	add_l2r_conn(true, mv)
	add_l2r_conn(true, concat(mv, [mirr_x_mv()]))
	trim()
	{
		for(p = lo_pos)
			beam(p, v_mirr(p));
		beam(middle(lo_pos[0]), middle(lo_pos[1]));
		mirr()
		     for(i = [0,1]) beam(hi_pos[i], middle(lo_pos[i], 0.3));
	}
}

module all_assembled(fast=false)
{
	/* main_board(fast); */
	/* move_play(pinky_to_fboard) pinky_section(fast); */
	/* move_play(thumb_cherry_to_fboard) thumb_cherry(fast); */
	move_play(dpad_to_fboard) dpad(fast);
	/* move_play(thumb_mod_to_fboard) thumb_mod(fast); */
	/* intersection() { */
	/* 	/\* main_board(fast); *\/ */
	/* 	move_play(dpad_to_fboard) dpad(fast); */
	/* 	move_play(thumb_mod_to_fboard) thumb_mod(fast); */
	/* } */
}


/* color("red") intersection(){dpad(); move_play(mod_to_dpad) half_space_up();} */
/* color("red") intersection(){dpad(); move_play(mod_to_dpad) thumb_mod();} */
/* move_play(fboard_to_usepos) { */
	/* all_assembled(false); */
/* 	/\* all_assembled(true); *\/ */
/* } */
lr_conn();

/* difference() { */
/* 	board_legs(); */
/* 	#move_play(concat(d2b, fboard_to_usepos)) dpad(); */
/* } */
/* the_mirr() */
/* pinky_legs(); */
/* pl2bl_beam(); */
/* move_play(pinky_to_fboard,true) pinky_section(); */
/* main_board(false); */
/* move_play(thumb_mod_to_fboard) */
/* move_play(mod_to_dpad) { */
/* 	half_space_up(); */
/* } */

/* intersection() { */
/* 	move_play(mod_to_dpad) thumb_mod(); */
	/* dpad(); */
/* } */

/* thumb_mod(); */
/* translate([-16, -22, -4]) intersection() { */
/* 	/\* move_play(mod_to_dpad) half_space_down(); *\/ */
/* } */

/* move_play(dpad_to_fboard,true) */
/* dpad(); */
/* board_legs(); */
/* move_play(thumb_cherry_to_fboard,true) thumb_cherry(); */
/* pinky_section(); */

/* move_play(d2b) */
/* move_play(thumb_cherry_to_dpad) thumb_cherry(); */
/* thumb_cherry(); */
/* move_play(mod_to_dpad) thumb_mod(); */
