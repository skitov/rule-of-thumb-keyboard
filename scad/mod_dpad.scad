include <lib.scad>

function ray(r, i, n)=[cos(360*i/n)*r, sin(360*i/n)*r, 0];
/* $separate_leaves = false; */
$separate_leaves = true;

mouse_switch_d = [13,6,7.35];
dpad_switch_d = [6.2,6.2,5];

dpad_switch_type=0;
mod_switch_type=1;

mod_bolt_d=7;
mod_bolt_head_d = 10;

dpad_box_bottom_h = 2;

$mod_rot=60;

module dpad_switch_box(hole)
{
	box_d = dpad_switch_d + [7.8,7.8,dpad_box_bottom_h+2.5-dpad_switch_d[2]];
	/* box_side_int = switch_side + 4; */
	if(hole)
	{
		translate ([0,0,dpad_box_bottom_h]) cub(s=dpad_switch_d, pos=cub_top);
		leg_hole_size=4;
		leg_hole_shift=leg_hole_size/2+1.5;
		for(x=[-1,1], y=[-1,1])
			translate([x*leg_hole_shift, y*leg_hole_shift,0])
				cub([leg_hole_size, leg_hole_size,20]);
	}
	else cub(s=box_d, pos=cub_top);
}

function press_pin_h() = $separate_leaves?0:2;
mod_box_bottom_h = 4;
module mod_switch_box(hole)
{
	both = mod_box_bottom_h - press_pin_h();
	if(hole) {
		translate([0,0,both-0.1]) cub(s=mouse_switch_d, pos=cub_top);
		cub([12.9,3,20]);
	}
	else
		cub([15.8, 8.8, both + 4], cub_top);
}

module switch_box(type, hole)
{
	if(type == dpad_switch_type) dpad_switch_box(hole);
	else mod_switch_box(hole);
}

module switch_star(n, r, switch_type, angle)
{
	module _star(hole) {
		rotate(angle) star(n,r) switch_box(switch_type, hole);
	}
	difference()
	{
		union()
		{
			children();
			_star(false);
		}
		_star(true);
	}
}

module leaf_button_conn(hole, height)
{
	_gap = hole?2*gap:0;
	pind = 2+_gap;
	pinh = 1+_gap;
	module pins()
	{
		 rotate(hole?0:30)
		 for(d=[-1,1])
			  right(4*d) up(pinh/2) cyl(pind, pinh, 32);
	}
	if(hole)
	{
		 difference()
		 {
			  children();
			  pins();
		 }
	}
	else
	{
		up(height/2) {
			difference() {
				rotate(15) cyl(10.5, height, 12);
				cyl(2.8, height, 12);
			}
		}
		up(height - 0.05) pins();
	}
}
module swing_button_conn(hole, height)
{
	_gap = hole?2*gap:0;
	swing_but_column_d=5.7+_gap/2;
	ball_d= 6 + _gap;
	/* pin_d= 1.5+ _gap; */
	pin_d = hole ? 1.7 : 1.5;
	pin_hx2 = 1;
	module conn_head() {
		ball(ball_d);
		if(hole) {
			up(pin_d) cub([pin_d,ball_d + pin_hx2+1,7], cub_bottom);
			up(pin_d) cub([ball_d + pin_hx2+1,pin_d,7], cub_bottom);
		}
		else
			for(a=[[90,0,0], [0,90,0]]) rotate(a) cyl(pin_d, ball_d + pin_hx2);
	}
	if(hole)
	{
		difference()
		{
			union() {
				children();
				difference() {
					rotate([0,0,45]) rotate([180,0,0]) pyramid(13, 4, press_pin_h());
					cyl(swing_but_column_d,20);
				}
			}
			conn_head();
		}
	}
	else {
		translate([0,0,height]) conn_head();
		translate([0,0,height/2]) cyl(swing_but_column_d,height);
	}
}

tactile_button_height=5;
mouse_button_height=7.35;
dpad_button_elev=dpad_switch_d[2]+press_pin_h($separate_leaves = false)+dpad_box_bottom_h;
dpad_button_thickness=5;

function dpad_plate_rot(a) = [rot_mv(a)];

module dpad_base(board_angle, fast=false)
{
	if(fast)
	{
		up(2.25) cyl(44,4.5,16);
	}
	else {
		r=15;
		switch_star(4,r, dpad_switch_type)
			move_play(dpad_plate_rot(board_angle)) cub([45,45,4], cub_top);
		/* tactile_cross(); */
		cub([8,8,5], cub_top);
		swing_button_conn(false, dpad_button_elev);
	}
}

module mod_leaves(d, curve_d, h)
{
	base_cyl_h = h + curve_d/2;
	difference() {
		translate([0,0,base_cyl_h/2]) star(3, 0.0001) cyl_sector(d/2, 60, base_cyl_h);
		translate([0,0, base_cyl_h]) ball(curve_d);
	}
}

module spring_place(h = 0, a0 = 0)
{
	pind = 3.2;
	pinh = 3.5;
	pinw = 0.8;
	r = 15;
	pos = [for(a=[0,120,240]) rot_v([0,0,a+a0], [-r,0,0])];
	add_pins(pos, true, pind, pinh, pinw, 0, [shift_mv([0,0,h])])
		children();
}

mod_but_pind = 4;
mod_but_pinh = 4;
module spring_mod_button_leg()
{
	 h = mouse_button_height;
	 l = 15;
	 eps = 0.1;
	 pinh = mod_but_pinh + eps;
	 hull()
	 {
		  up(h) cub([mod_but_pind,mod_but_pind,eps], cub_bottom);
		  left(l) cub([10,6,eps],cub_bottom);
	 }
	 up(h+pinh/2) cyl(mod_but_pind - 0.1, pinh);
}

mod_but_leg_r = 5;

/* Leaf button */
function mod_button_thickness() = $separate_leaves?2.5:5;

/* Use 5 for solid swing button */
/* mod_button_thickness=5; */

module mod_button()
{
	but_d = 42;
	curve_d = 200;
	screw_hole_d=2;
	module button_base()
	{
		difference()
		{
			/* spring_place(0,30) */
			union() {
				thickness = mod_button_thickness();
				if(!$separate_leaves) {
					rotate([0,0,60]) mod_leaves(12, curve_d, thickness);
					star(6,13.65) cub([4,4,press_pin_h()], cub_bottom);
				}
				mod_leaves(but_d, curve_d, thickness);
				rotate([0,0,60]) mod_leaves(but_d, curve_d, thickness-1);
			}
			if($separate_leaves) {
				star(6, 5.25+ but_d/2) cub([but_d, 0.4, 20]);
				screw_hole();
				height_equalizer();
				brim_elev();
			}

			/* rotate(30) */
			/* 	/\* up(mod_but_pinh/2 + 0.05) *\/ */
			/* 	star(3, -mod_but_leg_r) */
			/* 	cyl(mod_but_pind + 0.2, 2*mod_but_pinh + 0.2); */
		}
	}

	module brim_elev()
	{
		elev = 1;
		up(elev/2)
		difference()
		{
			cyl(but_d+1, elev, 64);
			cylinder(r1=14.5,r2 = 16, h=elev, $fn = 64, center = true);
		}
	}
	
	module screw_hole()
	{
		cyl(3,20,12);
		up(2) cyl(8,1,24);
	}
	module height_equalizer()
	{
		up(mod_button_thickness() -1)
		intersection()
		{
			up(1) cylinder(h=2, d1=12, d2=25, center=true, $fn=64);
			up(curve_d/2) ball(curve_d);
		}
	}
	if($separate_leaves)
		leaf_button_conn(true) button_base();
	else
		swing_button_conn(true) button_base();
}

mod_button_elev = mouse_button_height + mod_box_bottom_h;// + press_pin_h();

module mod_base(round_base = true)
{
	star_n = 6;
	star_r = 11.7;
	base_size=40;
	base_h=mod_box_bottom_h;
	module the_base(h=base_h)
	{
		up(base_h/2) {
			if(round_base) {
				cyl(base_size, h);
			}
			else
				cub([base_size, base_size, h]);
		}
	}
	switch_star(star_n, star_r, mod_switch_type, 30)
	{
		/* spring_place(base_h) */
		the_base();
	}
	/* intersection() { */
	/* 	up(base_h) star(star_n, -mod_but_leg_r) spring_mod_button_leg(); */
	/* 	the_base(100); */
	/* } */
	if($separate_leaves)
		leaf_button_conn(false, mod_button_elev);
	else
		swing_button_conn(false, mod_button_elev);
	up(base_h -press_pin_h() + 2) cyl(10, 4, 6);
}

module dpad_button() {
     $separate_leaves = false;
	swing_button_conn(true)
	{
		difference() {
			side_from(0,-90,0) ball(40);
			r=70; translate([0,0,r+dpad_button_thickness]) ball(2*r);
			star(4,0) translate([27.5, 27.5,0]) cub(40);
		}
	}
	module cyl_down(d, h)
	{
	     down(h/2) cyl(d, h, 24);
	}
	/* press_pin_w=3; */
	press_pin_s=4;
	press_pin_r=15;
	star(4, press_pin_r)
	{
	     /* cub([press_pin_s, press_pin_s, press_pin_h()], cub_bottom); */
	     difference()
	     {
		  dh = 0.5;
	     	  cyl_down(8,press_pin_h()+dh);
		  down(press_pin_h())
		       cyl_down(4,dh);
	     }
	}
}

module dpad_assembled(board_angle, with_button=false) {
	/* rotate([0,0,45]) translate([0,0, -2]) mount_plate(44, 4, 3, 13, 4); */
	dpad_base(board_angle, with_button);
	if(with_button)
		translate([0,0,dpad_button_elev]) dpad_button();
}

module mod_assembled(with_button=false, round_base = true) {
	/* translate([0,0,-2]) mount_plate(40,4,3,13,6); */
	mod_base(round_base);
	if(with_button)
		rotate([0,0,30]) translate([0,0, mod_button_elev]) mod_button();
}

module mod_print()
{
translate([2,12,0]) mod_bolt();
translate([-23,0,0]) mod_button();
translate([21,0,3]) mod_base();
}

module buts_print()
{
	for(x=[0], y=[0,45,90])
	/* for(x=[0,45], y=[0,45,90]) */
	{
		translate([x,y,0])
		{
			if(y == 0)
				dpad_button();
			else
				mod_button();
		}
	}
}

/* spring_mod_button_leg(); */
/* dpad_assembled(); */
/* translate ([-25,0,3]) dpad_base(); */
/* translate([25,0,2.5]) dpad_button(); */
/* translate([0,0,-1]) cyl(40,2, 80); */
/* mod_base(true, $separate_leaves = false); */
/* left(22) mod_button(); */
/* mod_button($separate_leaves = true); */

/* dpad_base(30); */
/* buts_print(); */
dpad_button();
/* mod_leaves(42,200,3); */
/* mod_assembled(true, true); */
/* translate([0, -22, 0]) mod_print(); */
/* rotate([0,0,180]) translate([0, -22, 0]) mod_print(); */
/* switch_box(); */
/* dpad_switch_box(true); */
