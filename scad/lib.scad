/* Constants */

inf=1000;
gap=0.1;

cub_center=[0,0,0];
cub_top=[0,0,1];
cub_bottom=[0,0,-1];
cub_right=[1,0,0];


/* Custom functions */

function vec_from_to(v1, v2, l) = (1-l)*v1+l*v2;

function is_bool(x)= ((len(x)==undef) && (x+0 == undef));
function is_num(x)= ((len(x)==undef) && (x+0 != undef));
function is_string(x)= ((len(x)!=undef) && (len(x) == 0 || x[0]+0 == undef));
function is_vector(x)= ((len(x)!=undef) && (len(x) == 0 || x[0]+0 != undef));

function len2(x) = sqrt(x[0]*x[0] + x[1]*x[1]);
function dist2(x, y) = len2(x-y);
function z0(x) = [x[0], x[1], 0];
function between(x, y, a=0.5) = x*(1-a)+y*a;

function average_iter(v, idx, s) = let(n = len(v))
     (idx >= n)?s:
     average_iter(v, idx+1, s+v[idx]/n);
function average(v) = average_iter(v, 0, 0*v[0]);

// Basic modules with custom defaults, center=true is more convenient.

module sqr(s, h) cube(size=[s, s, h], center=true);

module rounded_square(s, h) {
	cube(size=[s, s/3, h], center=true);
	cube(size=[s/3, s, h], center=true);
	for(x=[-s/6:s/3:s/6])
		for(y=[-s/6:s/3:s/6])
			translate([x, y, 0]) cylinder(d=2*s/3, h=h, $fn=16, center=true);
}

module cyl(d,h,n=16) cylinder(h=h, d=d,$fn=n, center=true);

module cub(s, pos=cub_center) {
	shift=is_num(s)?s*0.5*pos:
		is_vector(s)?[for(i=[0:2]) s[i]*pos[i]/2]:
		[0,0,0];
	translate(shift) cube(s, center=true);
}

module ball(d) sphere(d=d, $fa=3, $fs=0.05);

module cylball(d, n)
{
	 module c(a)
	 {
		  rotate([0,90,a]) cyl(d, d*2, 64);
	 }
	 if(n > 1)
		  intersection_for(i=[0:n]) c(180*i/n);
}

module hexaball(d) cylball(d, 3);
module quadball(d) cylball(d, 2);

// Custom general purpose modules

module half_space(r=inf) translate([r,0,0]) cub(2*r);

module half_space_down(h=0) translate([0,0,h]) rotate([0,90,0]) half_space();
module half_space_up(h=0) translate([0,0,h]) rotate([0,-90,0]) half_space();

module sector(a,r=inf)
{
	module open() rotate(90) half_space(r);
	module close() rotate(a-90) half_space(r);
	module _sector() {
		if(a < 180) intersection(){open(); close();}
		else union() {open(); close();}
	}
	intersection()
	{
		_sector();
		children();
	}
}

module cyl_sector(r, angle, h) sector(angle,max(r, h/2)) cyl(2*r, h, 128);

module star(n,r)
{
	for(a=[0:360/n:360*(n-1)/n])
		rotate([0,0,a]) translate([r,0,0]) children();
}

/* star(3,0.01) cyl_sector(100,60,4); */

module side_from(r, lat, lon)
{
	difference()
	{
		children();
		rotate([0,-lat,lon]) translate([r,0,0]) half_space();
	}
}

module pyramid(side, h, cut=-1)
{
	cut_h=cut<0?h:cut;
	side_from(cut_h,90,0) {
		polyhedron(
			points=[ [side/2,side/2,0],[side/2,-side/2,0],[-side/2,-side/2,0],[-side/2,side/2,0], // the four points at base
				 [0,0,h]  ],                                 // the apex point 
			faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
				[1,0,3],[2,1,3] ]                         // two triangles for square base
			);
	}
}

module beam(start, end, d=8) {
	hull() {
		translate(start) ball(d);
		translate(end) ball(d);
	}
}

module ground_beam(start, end, d=8, h=2)
{
	linear_extrude(height=h, center=false)
	{
		hull()
		{
			for(p = [start,end])
				translate(p) circle(d);
		}
	}
}

module add_pins(positions, male, pin_d, pin_h, pin_w, root = 0, move = [])
{
	module _cyl(m,t, mv)
	{
		rsgn = m ? 0.5 : -0.5;
		_d = pin_d + (m?0:(2*pin_w)) + (t?(2*gap):0);
		move_play(mv) up(root*rsgn)
			cyl(_d, pin_h+root+(t?gap:0));
	}
	module _cyls(m,t) {
		for(p=positions)
		{
			_cyl(m,t, concat([shift_mv(p)],move));
		}
	}
	if(male) {
		difference()
		{
			children();
			_cyls(m=false, t=true);
		}
		_cyls(m = true, t = false);
	}
	else {
		difference()
		{
			union()
			{
				children();
				_cyls(m = false, t = false);
			}
			_cyls(m = true, t = true);
		}
	}
}

/* Module movements */

module rotate_around(p,a) translate(p) rotate(a) translate(-p) children();

module translate_hor(p) translate([p[0],p[1],0]) children();

module right(d) translate([d,0,0]) children();
module left(d) right(-d) children();
module push(d) translate([0,d,0]) children();
module pull(d) push(-d) children();
module up(d) translate([0,0,d]) children();
module down(d) up(-d) children();

module zyx_rot(angles)
{
	rotate([angles[0],0,0]) rotate([0,angles[1],0]) rotate([0,0,angles[2]]) children();
}

module move_play(move, i=0)
{
	l = len(move);
	if(i >= l)
		children();
	else
	{
		move_play(move, i+1) {
			type = move[i][0];
			vec = move[i][1];
			if(type == rot_code)
				rotate(vec) children();
			else if(type == rot_zyx_code)
				zyx_rot(vec) children();
			else if(type == shift_code)
				translate(vec) children();
			else
			     mirror(vec) children();
		}
	}
}

/* Vector movements */

function rot_mat_x(a)=[[1,0,0],
		       [0,cos(a), sin(a)],
		       [0,-sin(a), cos(a)]];
function rot_mat_y(a)=[[cos(a), 0, -sin(a)],
		       [0,1,0],
		       [sin(a),0, cos(a)]];
function rot_mat_z(a)=[[cos(a), sin(a), 0],
		       [-sin(a), cos(a), 0],
		       [0,0,1]];

function norm(v) = sqrt(v*v);
function rot_v(a,v)=v*rot_mat_x(a[0])*rot_mat_y(a[1])*rot_mat_z(a[2]);
function zyx_rot_v(a,v)=v*rot_mat_z(a[2])*rot_mat_y(a[1])*rot_mat_x(a[0]);
function mirr_v(n,v) = v-2*((v*n)/(n*n))*n;

function v_move_play(move, v, i=0)=let(l=len(move),
				       type=(i<l)?move[i][0]:0,
				       vect=(i<l)?move[i][1]:0)
	(i>=l)?v:
	v_move_play(move,
		    ((type==rot_code)?rot_v(vect,v):
		     ((type==rot_zyx_code)?(zyx_rot_v(vect,v)):
		      ((type==shift_code)?(v+vect):
			   mirr_v(vect,v)))),
		    i+1);

/* Perform list of translations and rotations on vector
 Format:
 [[op (0-translation, 1-rotation), vec]]
*/
shift_code = 0;
rot_code = 1;
rot_zyx_code = 2;
mirr_code = 3;
function shift_mv(v)=[shift_code,v];
function rot_mv(v)=[rot_code,v];
function rot_zyx_mv(v)=[rot_zyx_code,v];
function mirr_mv(v) = [mirr_code, v];
function mirr_x_mv() = mirr_mv([1,0,0]);
function mirr_y_mv() = mirr_mv([0,1,0]);
function mirr_z_mv() = mirr_mv([0,0,1]);

function inv_move(mv,i=0,tmp_mv=[])=let(l=len(mv),
					type=(i<l)?mv[i][0]:0,
					v=(i<l)?mv[i][1]:0,
					inv_type=(type==rot_code)?
					rot_zyx_code:
					((type==rot_zyx_code)?rot_code:type))
	(i>=l)?tmp_mv:
	inv_move(mv, i+1,concat([[inv_type,-v]],tmp_mv));

module intersect_dbg()
{
     echo($children);
     #intersection_for(c=[0:$children-1]) children(c);
     %children();
}

module lib_test()
{
	pd = 4;
	pw = 2;
	ph = 5;
	/* pos = [[5,-5,0]]; */
	pos = [[5,-5,0],[-5,5,0]];
	module _pin(male, root = 0, move = [])
		add_pins(pos,male, pd, ph, pw, root, move) children();
		/* conn_pin(male, pd, ph, pw, root, move) children(); */
	/* _pin(male=false) cub([20,20,2]); */
	/* _pin(male = true, root = 10); */
	/* _pin(male = false, root = 5); */
	/* mv = [shift_mv([1,2,3]), */
	/*       rot_mv([30,60,90]), */
	/*       shift_mv([10,-10,5]), */
	/*       rot_mv([-90,30,60])]; */
}

/* lib_test(); */
module xxx(do_cub, do_ball) {
	side_from(0,-90,0)
	{
		if(do_cub) left(10) cub(10);
		if(do_ball) right(10) ball(10);
	}
}
