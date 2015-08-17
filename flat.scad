Sprinkler();

module Sprinkler($fn=100) {
    raspiPos = [-10, -38, 1];
    relayPos = [0, 20, 1];
    
    difference() {
        union() {
            Box();
            RaspiStandoffs(raspiPos);
            RelayStandoffs(relayPos);
            Magnets();
        }
        RelayCutout();
        RaspiCutout(raspiPos);
        Top();
    }
    
    //RaspiStandoffs(raspiPos);
    *RaspiCutout(raspiPos);
    *Relay(relayPos);
}

module Box() {
    width = 140;
    height = 140;
    depth = 21;
    thickness = 2.5;
    
    outsideWidth = width + thickness*2;
    outsideHeight = height + thickness * 2;
    outsideDepth = depth + thickness * 2;
    
    difference() {
        RoundCube([outsideWidth, outsideHeight, outsideDepth], center=true);
        RoundCube([width, height, depth], center=false);
        translate([60, 60, 0]) cylinder(d=5, 80, center=true);
        translate([60, -60, 0]) cylinder(d=5, 80, center=true);
        translate([-60, 60, 0]) cylinder(d=5, 80, center=true);
        translate([-60, -60, 0]) cylinder(d=5, 80, center=true);
    }
}
module Top() {
    translate([0, 0, 16])
        cube([150, 150, 10], center=true);
}

module Magnets() {
    ho = 70.9;
    vo = -1;
    union() {
        translate([-ho, -ho, vo]) rotate([0,0,45]) MagnetHolder();
        translate([-ho, ho, vo]) rotate([0,0,-45]) MagnetHolder();
        translate([ho, ho, vo]) rotate([0,0,-135]) MagnetHolder();
        translate([ho, -ho, vo]) rotate([0,0,135]) MagnetHolder();
    }
}

module MagnetHolder() {
    difference() {
        union() {
            linear_extrude(height = 10, center = true, convexity = 10, scale=7, $fn=100)
            translate([1, 0, 0])
            circle(r = 1);
            
            translate([7, 0, 7.5])
            cylinder(h=5, d=14, center=true);
        }
        
        translate([7, 0, 7.46])
        cylinder(h=5.1, d=10.1, center=true);
    }
}

module RaspiStandoffs(center=[0,0,0]) {
    width = 85;
    height = 56;
    
    translate(center) union() { 
        translate([-width/2+3.5, -height/2+3.5, -11]) Standoff(2, 5, 5);
        translate([-width/2+3.5+58, -height/2+3.5, -11]) Standoff(2, 5, 5);
        translate([-width/2+3.5, height/2-3.5, -11]) Standoff(2, 5, 5);
        translate([-width/2+3.5+58, height/2-3.5, -11]) Standoff(2, 5, 5);
    }
}

module RaspiCutout(center=[0,0,0]) {
    width = 85;
    height = 56;
    depth = 18;
    cutoutWidth = 10.5;
    cutoutDepth = 8.5;
    
    xoffset = 10.6 - width/2;
    yoffset = -height/2-15;
    zoffset = -depth/2 + 1.5 + 2.6/2;
    
    color("Green", 0.8)
    translate(center) {
        union() {
            cube([width, height, depth], center=true);
            translate([xoffset, yoffset, zoffset])
            cube([cutoutWidth, 30, cutoutDepth], center=true);
        }
    }
}

module Relay(center=[0,0,0]) {
    width = 136;
    depth = 53;
    height = 18;
    
    color("Yellow", 0.8)
    translate(center) 
    cube([width, depth, height], center=true);

    pegDiameter = 3;
    pegDepth = 3;
    standDiameter = 5;
    standDepth = 3;
}

module RelayStandoffs(center=[0,0,0]) {
    width = 136;
    depth = 53;
    
    topOffset = 2.3; // 3.5  3.1
    
    pegDiameter = 3;
    pegDepth = 3;
    standDiameter = 5;
    standDepth = 3;
    
    translate(center) union() {
        translate([-width/2+2.3, depth/2-2.3, -11]) Peg(2, 5, 7, 4);
        translate([width/2-2.3, depth/2-2.3, -11]) Peg(2, 5, 7, 4);
        translate([-width/2+3.5, -depth/2+3.1, -11]) Standoff(2, 5, 4);
        translate([width/2-3.5, -depth/2+3.1, -11]) Standoff(2, 5, 4);
    }
}
    
    
module RelayCutout(center=[0,0,0]) {
    translate([0, 60, 0]) {
        cube([16, 50, 8], center=true);
    }
}

module Standoff(id, od, h) {
    difference() {
        cylinder(h=h, d=od, center=true);
        cylinder(h=h+2, d=id, center=true);
    }
}

module Peg(id, od, h1, h2) {
    union() {
        translate([0, 0, (h1-h2)/2]) cylinder(h=h1, d=id, center=true);
        cylinder(h=h2, d=od, center=true);
    }
} 


module RoundCube(dim, center=false) {
    oldfn = $fn;
    $fn = 20;
    minkowski() {
        cube(dim, center=true);
        sphere(1);
    }
    $fn = oldfn;
} 
