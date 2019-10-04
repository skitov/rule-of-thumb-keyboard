use<cell.scad>

zxcv_dz=2.5;
qwer_dz=1;
1234_dz=qwer_dz+1;
f_dz=1234_dz+3.5;
dz_vec=[zxcv_dz, 0, qwer_dz, 1234_dz, f_dz];

module column(dz=0, fast = false)
{
	for(i=[0:fast?1:4]) {
		translate([0, cell_side*(i-1), 0]) cell(dz_vec[i]+dz, fast, i+1);
	}
}

/* column(0, true); */
