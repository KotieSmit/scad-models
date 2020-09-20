bx = 41;
by = 41;
bz = 15;
cox = 12;
coy = 6;
coz = 3.5;
track_y = 9;
track_z = 1;
spring_housing_x = 32;
spring_housing_y = 8;
spring_housing_z = 9;
tr_rounding_r = 1.5;
tr_coutout_h = 7;
mount_slot_x = 16;
mount_slot_y = 8;
mount_slot_z = 3.5;
mount_slot_gap = 1;
$fn =50;

debug = true;
module body() {
    color("Red") cube([bx, by,bz ], center=false);
}

module nut_cutout(){
    union() {

        color("Blue") cube([cox, coy,coz], center=false);
        color("Blue") translate([cox/2, 0, 0] ) 
            cylinder(h=coz, r=cox/2, center=false);
        
        color("Blue") translate([cox/2, 0, -12] ) 
            cylinder(h=bz, r=3, center=false);      
        
        
    }
}

    
module spring_housing(){
    translate([(bx-spring_housing_x)/2, 0,0]) 
        cube([spring_housing_x, spring_housing_y, spring_housing_y/2], center=false);
    
    translate([(bx-spring_housing_x)/2, spring_housing_y/2, spring_housing_y/2]) 
        rotate([0,90,0])  
        cylinder(h=spring_housing_x, r=spring_housing_y/2, center=false);
    
    translate([0, spring_housing_y/2,0]) 
        cube([bx, 1, 5]);
    }
    
    
module track(){    
    difference() {
        color("red") 
            cube([bx, track_y ,tr_coutout_h], center=false);
        
        color("green")    
            rotate([0,90,0]) 
            translate([-2.5, track_y - tr_rounding_r, 0] ) 
            cylinder(h=bx, r=tr_rounding_r, center=false);  
        
        color("blue") 
            translate([0, track_y-1.5, track_z] ) 
            cube([bx, tr_rounding_r , tr_coutout_h - track_z], center=false); 
     
         color("grey") 
            translate([0, track_y-3, track_z + tr_rounding_r] ) 
            cube([bx, tr_rounding_r * 2 ,tr_coutout_h - tr_rounding_r - track_z], center=false); 

    }
    
          translate([0, 0, tr_coutout_h] ) 
        cube([bx, 25, 3], center=false);  
}

module track_small(){
    translate([0,0,2]) 
        cube([bx, 5, 6]);
    translate([0, 5,0])   
        cube([bx, 4, 8]);
    translate([0, 9,8])    
        rotate([0,90,0]) 
        Right_Angled_Triangle(a=3, b=6,height=bx,  
            centerXYZ=[false,false,false]);
    }

module Right_Angled_Triangle(
			a, b, height=1, heights=undef,
			center=undef, centerXYZ=[false, false, false])
{
	Triangle(a=a, b=b, angle=90, height=height, heights=heights,
				center=center, centerXYZ=centerXYZ);
}

module corner_cutout(){
    Right_Angled_Triangle(a=17, b=7,height=bz,  centerXYZ=[false,false,false]);
    }
    
module corner_cutout_2(){
    Right_Angled_Triangle(a=15, b=(bx-26)/2,height=bz,  centerXYZ=[false,false,false]);
    }
    
module Triangle(
			a, b, angle, height=1, heights=undef,
			center=undef, centerXYZ=[false,false,false])
{
	// Calculate Heights at each point
	heightAB = ((heights==undef) ? height : heights[0])/2;
	heightBC = ((heights==undef) ? height : heights[1])/2;
	heightCA = ((heights==undef) ? height : heights[2])/2;
	centerZ = (center || (center==undef && centerXYZ[2]))?0:max(heightAB,heightBC,heightCA);

	// Calculate Offsets for centering
	offsetX = (center || (center==undef && centerXYZ[0]))?((cos(angle)*a)+b)/3:0;
	offsetY = (center || (center==undef && centerXYZ[1]))?(sin(angle)*a)/3:0;
	
	pointAB1 = [-offsetX,-offsetY, centerZ-heightAB];
	pointAB2 = [-offsetX,-offsetY, centerZ+heightAB];
	pointBC1 = [b-offsetX,-offsetY, centerZ-heightBC];
	pointBC2 = [b-offsetX,-offsetY, centerZ+heightBC];
	pointCA1 = [(cos(angle)*a)-offsetX,(sin(angle)*a)-offsetY, centerZ-heightCA];
	pointCA2 = [(cos(angle)*a)-offsetX,(sin(angle)*a)-offsetY, centerZ+heightCA];

	polyhedron(
		points=[	pointAB1, pointBC1, pointCA1,
					pointAB2, pointBC2, pointCA2 ],
		faces=[	
			[0, 1, 2],
			[3, 5, 4],
			[0, 3, 1],
			[1, 3, 4],
			[1, 4, 2],
			[2, 4, 5],
			[2, 5, 0],
			[0, 5, 3] ] );
}



module screwholes(){  
    translate([bx/4,0,0])
    cylinder(h=bz, r=1.5, center=false);
            
    translate([(bx/4)*3,0,0])
        cylinder(h=bz, r=1.5, center=false);  
    }
    
module mount_slot(){
    cube([mount_slot_x, mount_slot_y-3, mount_slot_z]);
    translate([0,0,-mount_slot_gap])
    cube([mount_slot_x, mount_slot_y, mount_slot_z - mount_slot_gap]);

    }
module main(){    
    
    difference() {

        body();
        translate([(bx-cox)/2, by-coy, bz-coz]) nut_cutout();
        translate([0, 21, 7]) track();
        translate([0, 0, bz-8]) track_small();
        translate([bx, bx,0]) mirror ([1,1,0]) corner_cutout();
        translate([0, bx,0]) rotate([180,180,90]) corner_cutout();
        translate([0, 12, 0]) spring_housing();
        
        translate([bx, 0,0]) mirror ([1,0,0]) corner_cutout_2();
                translate([0, 0,0]) mirror ([0,0,0]) corner_cutout_2();
        translate([0, 2.5])
            screwholes();
    }
    translate([(bx - mount_slot_x)/2, 0, -mount_slot_z]) mount_slot();
};
//track_small();
main();
//        translate([0, 0,0]) mirror ([0,0,0]) corner_cutout_2();

