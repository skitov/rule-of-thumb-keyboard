include <lib.scad>

mouse_switch_d = [12.7,5.8,7.35];

module nice_cube()
{
	module nice_text()
	{
		linear_extrude(height=1, center=true)
			text(str($height), size=4, halign="center", valign = "center");
	}
	/* difference() */
	{
		color("white") translate([0,0,$height/2]) cube([10,10,$height], center = true);
		color("blue") translate([0,0,$height]) nice_text();
	}
}

module nice_cylinder()
{
	translate([0,0,$height/2]) cylinder(d=10,h=$height, center = true);
}

    
module nice_grid()
{
	for(i=[0:9], j=[0:9])
	{
		$height=(i+1)*(j+1);
		x=10*i;
		y=10*j;
		translate([x,y,0]) children();
		/* let($height=(i+1)*(j+1)) {children();} */
	}
}

module tst(a)
{
	module x()
	{
		rotate([0,0,a]) cube(10, center=true);
	}
	x();
}

module fractal(s, factor=0.5)
{
	f = 0.5*(factor+1);
	cube(s,center=true);
	if(s > 0.5)
	{
		for(dir=[[s,0,0],[0,s,0],[0,0,s]], r=[-1,1])
			translate(f*r*dir) fractal(s*factor);
	}
}

module grid() {
	for(x=[0,25], y=[0,25])
		translate([x,y,0]) children();
}

module heart()
{
	linear_extrude(height=1)
	{
		rotate(45)
		{
			square(10, center=true);
			translate([5,0]) circle(d=10, center=true);
			translate([0,5]) circle(d=10, center=true);
		}
	}
}

module hexahead()
{
	module c()
	{
		rotate([0,90,0]) cyl(20,30,180);
	}
	intersection_for(a=[0,60,120])
	{
		rotate([0,0,a]) c();
	}
}

module nut()
{
	module t()
	{
		cyl(12,15,180);
	}
	r = 16;
	rotate([0,0,30])
	star(6, -r)
		t();
}

module but()
{
	echo(cub_top);
	color("grey") left(8.35 - mouse_switch_d[0]/2) cub(mouse_switch_d, cub_top);
	color("red") up(mouse_switch_d[2]) cub([1,4,1], cub_top);
}

module star2()
{
	r = 15;
	module double_but()
	{
		push(mouse_switch_d[1]/2+0.05) but();
		pull(mouse_switch_d[1]/2+0.05) but();
	}
	star(3,r) but();
	rotate(60) star(3,r) double_but();
	color("green") down(0.5) cyl(40,0.1,64);
}

module but_star()
{
	r = 16;
	a = 15;
	star(9,r) rotate(a) but();
	color("green") down(0.5) cyl(40,0.1,64);
}

/* but(); */
/* but_star(); */
/* star2(); */

/* intersection() { */
/* 	rotate([10,0,0]) nut(); */
/* 	hexahead(); */
/* } */
	/* rotate([10,0,0]) nut(); */
	/* hexahead(); */

/* echo(atan2(3,1)); */
/* rotate(atan2(1,3)) */
/* color("pink") heart(); */
/* translate([1,1,1]) heart(); */
/* translate([-45,-45,-20]) nice_grid() nice_cube(); */
/* grid() cube(10, center=true); */

/* fractal(16, 0.5); */

/* tst(60); */
/* translate([30, 0 , 0]) cube([20, 10, 5], center=true); */
/* rotate([30, 50, 68]) rotate([-30, -50, -68]) cube([20, 10, 5], center=true); */
echo([1,2,3]*[1,1,1]*[1,0,0]);
