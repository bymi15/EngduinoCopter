//Default dimensions
BASEWIDTH = 60;
BASELENGTH = 90;
BASEHEIGHT = 5;
USBSOCKETHEIGHT = 15;

//Default height of text
TEXTHEIGHT = 2;

module base(length = BASELENGTH, width = BASEWIDTH, height = BASEHEIGHT){
    difference(){
        
        cube(size = [length, width, height]);
        
        //corners
        translate([0, width-15, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
        translate([length, width-15, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
        translate([length, -width*sqrt(3.2)/4, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
        translate([0, -width*sqrt(3.2)/4, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
        
        //cut-offs    
        translate([length/3, length/2, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
        translate([length - length/3, length/2, 0])
            rotate([0, 0, 45]){
                cube(size = [width/2, width/2, height]);
            }
            
    }
}
module drawText(txt, textFont, textSize, textPos, textRot) {
  translate(textPos)
    rotate(a=textRot){
      linear_extrude(height = TEXTHEIGHT)
      text(text = txt, size = textSize, font = textFont);
    }
}

module baseTopLayer(length = BASELENGTH, width = BASEWIDTH, height = BASEHEIGHT){
    
    difference(){
        translate([length*1/5, width*1/5, height])
            cube(size = [length*3/5, width*3/5-4, height/2]);
        
        //cut-offs
        translate([length*2/7+2, width*3/5-3, height])
            cube(size = [length*3/7-4, width*1/5, height/2]);
        
        translate([length*2/7+2, width*3/5-3, height])
            rotate([0, 0, 45]){
                cube(size = [length/7, width/5+3, height/2]);
            }
        translate([length-27.7, width*3/5-3, height])
            rotate([0, 0, 45]){
                cube(size = [length/7+2, width/5, height/2]);
            }
        translate([length*1/7+1, width*1/7-8, height])
            rotate([0, 0, 45]){
                cube(size = [length/6, width/6, height/2]);
            }
        translate([length*5/7+5, width*1/7-8, height])
            rotate([0, 0, 45]){
                cube(size = [length/6, width/6, height/2]);
            }
        translate([length*2/7+2, width*2/5-1, height])
            cube(size = [length/7-2, width/5-2, height/2]);
            
        translate([length*4/7, width*2/5-1, height])
            cube(size = [length/7-2, width/5-2, height/2]);
    }
    
    
    //draw text
    drawText("ENGDUINO 3", "Liberation Sans:style=Bold", 4, [length*5/7-3, width*2/5-4, height+TEXTHEIGHT], [0, 0, 180]);
    drawText("UCL ENGINEERING", "Century Gothic:style=Bold", 3, [length*5/7-2, width/6-2, height/2+TEXTHEIGHT], [0, 0, 180]);
}

//create a hollowed out cube that a USB plug can fit into.
module USBSocket(height = USBSOCKETHEIGHT) {

      difference() {
         translate([BASELENGTH/2 - 4, BASEWIDTH/2 + 6, BASEHEIGHT])
             cube(size = [8,15,height]);
         translate([BASELENGTH/2 - 4 + 1.25, BASEWIDTH/2 + 6 + 1.5, BASEHEIGHT + (  height - USBSOCKETHEIGHT)])
             cube(size = [5,12.5,USBSOCKETHEIGHT]);
      }
    
}

module USBSocketWithHole(height = USBSOCKETHEIGHT){
    difference() { 
        USBSocket(height);
        translate([BASELENGTH/2 - 4, BASEWIDTH/2 + 6 + 12, BASEHEIGHT + 3])
            rotate(a=[90,0,90])
                cylinder(h = 8, r1 = 1.5, r2 = 1.5, $fn = 30);
    }
}

module renderStand(){
    base();
    baseTopLayer();
    USBSocketWithHole(20);
}

renderStand();
