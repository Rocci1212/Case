include <gearLib.scad>


//**********************************Lid***************************************************
module lidBase(x,y,z)
{
//	translate([x,y,z]) cube([106,51,1.5]);
//	translate([x, y-1.5, z+1.5]) cube([106,54,3.5]);
	translate([x, y-1.5, z]) cube([107.5,54,4]);
	translate([x+1.75, y+1.5, z+4]) cube ([1.5,48,36]);
	translate([x, y+3, z+4]) cube ([1.75,45,36]);
}

module lidCutouts(x,y,z)
{
	//Gear hole
	translate([x+53, y+25.5, z+0.5]) cylinder(h = 3.5,r = 18);

	//Top Rail
	translate([x, y+4.5, z+0.5]) cube([104.5,11,3]);
	translate([x+38, y+4.5, z+3]) cube([30,11,1]);

	//Bottom Rail
	translate([x+5, y+49-13.5, z+0.5]) cube([104.5,11,3]);
	translate([x+38, y+49-13.5, z+3]) cube([30,11,1]);

	//Cutout for lip
	translate([x+41, y+ 48, z]) cube([24,4.5,4]);
}

module lid(x,y,z)
{
	difference()
	{
		lidBase(x,y,z);
		lidCutouts(x,y,z);
	}
	translate([x+53,y+25.5,z+0.5]) cylinder(h = 3.5,r = 4);
}



//*****************************Rack and Pinion*******************************************

module drawGear(x,y,z)
{
	difference() 
	{
		translate([x,y,z]) cylinder(h = 0.5,r = 17);
		translate([x,y,z]) cylinder(h = 0.5,r = 5);
	}
	//12.23 radius  -   circular_pitch * number_of_teeth / 360
	translate([x, y, z+0.5]) gear(number_of_teeth=12, circular_pitch=367, hub_thickness=0, bore_diameter=9,rim_thickness=2, gear_thickness=2);
}

module drawLeftRack(x,y,z)
{
	//mm_per_tooth = 2 * Pi * r / gear_teeth
	difference()
	{
		translate([x,y,z+(1.5/2)]) rack(height=9, mm_per_tooth=6.4, number_of_teeth=13, thickness=1.5);
		translate([x-7.5,y-7,z+1.5-4.5]) rotate([0,30,0])  cube ([5,5,5]);
	}

	translate([x+81.6,y-7,z]) cube([16.7,5,1.5]);
	translate([x+98.3,y-8-5,z]) cube([1.5,46,10]);
}

module drawRightRackCap(x,y,z)
{
	translate([x+5,y-49,z]) cube([10,47,1.5]);
	translate([x+5,y-49,z+1.5]) cube([1.5,47,7.5]);
//	translate([x+5+3,y-50,z+1.5]) cube([4,1.5,3]);
//	translate([x+5+3,y-3.5,z+1.5]) cube([4,1.5,3]);
}

module drawRightRack(x,y,z)
{
	difference()
	{
		translate([x+22+77.7,y,z+(1.5/2)]) rotate([0,0,180]) rack(height=9, mm_per_tooth=6.4, number_of_teeth=13, thickness=1.5);
		translate([x+24.5+77.7,y,z]) rotate([0,60,0])  cube ([5,15,5]);
	}


	translate([x+4,y+2,z]) cube([16.7,5,1.5]);
	difference()
	{
		translate([x-5,y-51+11,z]) cube([9,47,10]);
		translate([x-5,y-51+13,z+1.5]) cube([9,43.5,78]);
		translate([x-3.5,y-51+13,z]) cube([7.5,40,8]);
//		translate([x-5,y-51+11,z+3]) cube([3,3,4]);
//		translate([x-5,y+6,z+3]) cube([3,3,4]);
	}

}





//*****************************Case***************************************************


module drawCase(x,y,z)
{
	height=36;
	length=104.5;

	stepsH=(height-11)/6;
	stepsL=(length-12)/12;

	difference()
	{
		//Bottom and screw holes
		translate([x,y+3,z]) cube([106,51,1.5]);
		translate([x+1.5+5,y+3+5,z]) cylinder(h = 1.5,r = 1);
		translate([x+1.5+5,y+51+3-5,z]) cylinder(h = 1.5,r = 1);
		translate([x+1.5+104.5-5,y+3+5,z]) cylinder(h = 1.5,r = 1);
		translate([x+1.5+104.5-5,y+51+3-5,z]) cylinder(h = 1.5,r = 1);

		//Hole for furnace wires
		translate([x+3,y+11,z]) cube([6,35,1.5]);
		translate([x+3+6,y+3,z]) cube([12,51,1.5]);
	}

	//Board catch
	translate([x+21,y+51-10+3,z+1.5]) cube([1.5,10,3]);

	//Side walls
	difference() {
		union(){
			translate([x,y+1.5,z]) cube([106,1.5,height]);
			translate([x,y+54,z]) cube([106,1.5,height]);
		}
		for(iL=[0:stepsL])
		{
			for(iH=[0:stepsH])
			{
				//first wall
				translate([x+6 + iL*12,y,z+3 + iH*6]) cube([3,3,3]);
				translate([x+6 + iL*12 + 6,y,z+6 + iH*6]) cube([3,3,3]);
				//second wall
				translate([x+6 + iL*12,y+54,z+3 + iH*6]) cube([3,3,3]);
				translate([x+6 + iL*12 + 6,y+54,z+6 + iH*6]) cube([3,3,3]);
			}
		}
//		translate([x,y+1.5,z+43]) cube([106,1.5,2.5]);
//		translate([x,y+54,z+43]) cube([106,1.5,2.5]);
	}

	//back wall
	difference()
	{
		translate([x+106,y+1.5,z]) cube([1.5,54,36]);
		translate([x+106,y+23.5,32]) cube([1.5,10,4]);
	}

	//Lip
	translate([x+(length-20)/2,y+1.5,z+height]) cube([20,1.5,10]);
	translate([x+(length-20)/2,y+1.5,z+height+10]) cube([20,3,2]);

	//Grooves
	difference()
	{
		translate([x,y+3,z]) cube([5,3,height]);
		translate([x+1.5,y+3,z]) cube([2,3,height]);
	}
	difference()
	{
		translate([x,y+51,z]) cube([5,3,height]);
		translate([x+1.5,y+51,z]) cube([2,3,height]);
	}
}








//*****************************Combinations**********************************************


module drawAssembled(x,y,z)
{
	drawCase(x,y,z);
	rotate([180,0,0]) drawLidAssembled(x,y-54,-z - 40);
}

module drawLidAssembled(x,y,z)
{
	lid(x,y,z);
	drawGear(x + 53, y+25.5, z+1.5);
	rotate([0,180,0]) drawLeftRack(-x-96, y+14, -z-3.5);
	rotate([0,180,0]) drawRightRack(-x-111, y+37, -z-3.5);
	rotate([0,270,0]) drawRightRackCap(z-13, y+46, -x-120);
}

module drawExploded(x,y,z)
{
	% translate([x,y,z-1]) cube([180,125,1]);
	lid(x,y,z);
	drawLeftRack(x+5, y+70, z);
	drawGear(x + 70, y+90, z);
	drawRightRack(x, y+110, z);
	rotate([0,0,90]) drawRightRackCap(y+80, -x, z);
	rotate([0,0,90]) drawCase(y,-x-170,z);
}

drawAssembled(0, 0, 0);
drawExploded(0, 100, 0);
