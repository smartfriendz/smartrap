/**********

Smartrap 

author: serge.vi / smartfriendz
licence : GPL
version: 0.1
date: 11 / 2014

***********/


function getParameterDefinitions() {
  return [ 
  
    { name: '_printableWidth', caption: 'Print width:', type: 'int', initial: 200 },
    { name: '_printableHeight', caption: 'Print height :', type: 'int', initial: 150 },
    { name: '_printableDepth', caption: 'Print depth :', type: 'int', initial: 200 },
    { name: '_XYrodsDiam', caption: 'X Y Rods diameter (6 or 8 ):', type: 'int', initial: 6},
    { name: '_ZrodsDiam', caption: 'Z Rods diameter (6 or 8 ):', type: 'int', initial: 8},
    { 
        name: '_output', 
        caption: 'Show:', 
        type: 'choice', 
        values: [0,1,2,3,4,5,6,7,8,9,10], 
        initial: 0, 
        captions: ["All printer assembly", "printed parts plate","EndX Jhead","","","","","","","",""]},
     { name: '_globalResolution', caption: 'resolution (16, 24, 32 for export)', type: 'int', initial: 8 }
    
  ];
}


// vars
var output=0;
var endxJheadAttachHolesWidth = 32;
var Xaxiswidth = 43.07;
var YaxisWidth = 60;
var ZaxisWidth = 80;
var _XYrodsDiam; // usually 6 or 8 .. or 10? 
var _XYlmDiam; // lm6uu, lm8uu ... will be calculated from rods diam
var _ZrodsDiam; // usually 6 or 8 .. or 10? 
var _ZlmDiam; // lm6uu, lm8uu ... will be calculated from rods diam
var _nemaXYZ;  // nema 14 , nema 17 



// elements

function xend_jhead(){
    var width=Xaxiswidth;
    var height = 30;
    var depth = 10;
    var spaceZstopHoles = 19;

    return difference(
        union(
            //main low
            cube([width,depth,height/2]),
            // support for gt2 holder
            cube([10,depth,5]).translate([35,0,height/2]),
            // main high
            cube([width-15,depth/2+2,height-15]).translate([7,depth/2-2,height/2]),
            // support arm
            cube([10,5,5]).translate([-5,-5,0]),
            //rods form
            cylinder({r:_XYrodsDiam+2,h:depth,fn:_globalResolution}).rotateX(-90).translate([0,0,6]),
            cylinder({r:_XYrodsDiam+2,h:depth,fn:_globalResolution}).rotateX(-90).translate([width,0,6]),
            //arm support
             cylinder({r:8,h:depth+1,fn:_globalResolution}).rotateX(-90).translate([width+5,-1,13]),
             // support for endstopX
             slottedHole(5,15,4).rotateX(-90).translate([width,depth-4,0])
             
            
        ),
        //rods
        cylinder({r:_XYrodsDiam/2+0.1,h:depth,fn:_globalResolution}).rotateX(-90).translate([0,3,6]),
        cylinder({r:_XYrodsDiam/2+0.1,h:depth,fn:_globalResolution}).rotateX(-90).translate([width,3,6]),
        cylinder({r:_XYrodsDiam/2-1,h:5,fn:_globalResolution}).rotateX(-90).translate([0,0,6]),
        cylinder({r:_XYrodsDiam/2-1,h:5,fn:_globalResolution}).rotateX(-90).translate([width,-1,6]),
        //zstop holes with slotted 
        //cylinder({r:1.4,h:depth,fn:_globalResolution}).rotateX(-90).translate([12,0,height/2+height-18]),
        //cylinder({r:1.4,h:depth,fn:_globalResolution}).rotateX(-90).translate([12+spaceZstopHoles,0,height/2+height-18]),
        //zstop holes with slotted 
        slottedHole(3.2,6,depth).rotateX(-90).translate([12,0,height/2+height-18]),
        slottedHole(3.2,6,depth).rotateX(-90).translate([12+spaceZstopHoles,0,height/2+height-18]),
        //arm support hle
        cylinder({r:1.4,h:depth+1,fn:_globalResolution}).rotateX(-90).translate([width+5,-1,13]),
        // gt2 attach
        Gt2HolderBool().rotateZ(-90).translate([42,10,10]),
        //hole middle - save material
        cylinder({r:18,h:depth,fn:_globalResolution}).rotateX(-90).translate([width/2,0,-5])

    );

}
function xend_Jhead_arm(){
    var extDiam=16;
    var intDiam=12;
    var intDiamHeight=5;
    var depth = 10;
    var width = 75;
    var barHeight = 6;

	return difference(
		union(
            //main
			cube([width-16,depth,barHeight]).translate([16,0,0]),
            // round extremity.. just more cool :)
            //cylinder({r:depth/2,h:barHeight}).translate([width-depth/2,depth/2,0]),
            //right cyl
			cylinder({r:8,h:depth,fn:_globalResolution}).rotateX(-90).translate([width,0,8]),
            //middle form
            cube([endxJheadAttachHolesWidth-5,depth,8]).translate([width/2-((endxJheadAttachHolesWidth-5)/2),0,barHeight]),
            // top form
            //cube([extDiam+6,5,5]).translate([width/2-((extDiam+6)/2),-5,barHeight+20-5]),
            //for 2 screws attach
            tube(2.8,10,depth).rotateX(-90).translate([width/2-endxJheadAttachHolesWidth/2,0,barHeight+4]),
            tube(2.8,10,depth).rotateX(-90).translate([width/2+endxJheadAttachHolesWidth/2,0,barHeight+4])
            // integrated attach
            //cube([extDiam+6,7,8]).translate([width/2-((extDiam+6)/2),-8,barHeight]),
            //tube(3.2,10,7).rotateX(-90).translate([width/2-endxJheadAttachHolesWidth/2,-8,barHeight+4]),
            //tube(3.2,10,7).rotateX(-90).translate([width/2+endxJheadAttachHolesWidth/2,-8,barHeight+4])
		),
        // screw hole right
		cylinder({r:1.6,h:depth,fn:_globalResolution}).rotateX(-90).translate([width,0,8]),
        // hole switch side, vertical
        //cylinder({r:1.4,h:15}).translate([width-5,depth/2,0]),
        // jhead holes *3
         cylinder({r:extDiam/2,h:10,fn:_globalResolution}).translate([width/2,0,0]),
         cylinder({r:intDiam/2,h:intDiamHeight,fn:_globalResolution}).translate([width/2,0,10]),
         cylinder({r:extDiam/2,h:8,fn:_globalResolution}).translate([width/2,0,10+intDiamHeight])
         //slotted hole on top for bowden
         //slottedHole(4,15,10).translate([width/2,-5,barHeight+20-5])
	);	
	
}

function xend_Jhead_attach(){
	var extDiam=16;
    var intDiam=12;
    var intDiamHeight=5;
    var depth = 12;
    var width = 75;
    var barHeight = 6;

    return difference(
        union(
            cube([endxJheadAttachHolesWidth-5,8,8]).translate([width/2-((endxJheadAttachHolesWidth-5)/2),-10,barHeight]),
            tube(3.2,10,8).rotateX(-90).translate([width/2-endxJheadAttachHolesWidth/2,-10,barHeight+4]),
            tube(3.2,10,8).rotateX(-90).translate([width/2+endxJheadAttachHolesWidth/2,-10,barHeight+4])
        ),
         cylinder({r:extDiam/2,h:10,fn:_globalResolution}).translate([width/2,0,0]),
         cylinder({r:intDiam/2,h:intDiamHeight,fn:_globalResolution}).translate([width/2,0,10]),
         cylinder({r:extDiam/2,h:8,fn:_globalResolution}).translate([width/2,0,10+intDiamHeight])

    );  
    
}

function plateX(){

}

function endXBack(){

}

function plateBase(){

}

function plateY(){

}

function endY(){

}

function extruder_dd(){

}


// lib

function tube(dint,dext,length){
    return difference(
            cylinder({r:dext/2,h:length,fn:_globalResolution}),
            cylinder({r:dint/2,h:length,fn:_globalResolution})
        );
}

function _axis(){
    return union(
        cube({size:[10,1,1]}).setColor(1,0,0),
        cube({size:[1,10,1]}).setColor(0,1,0),
        cube({size:[1,1,10]}).setColor(0,0,1)
        );
}

function nemaHole(){
    var offset = (_nemaXYZ==35)?13:15.5;
        return union(
            cylinder({r:11.1,h:40}),
            cylinder({r:1.6,h:40,fn:_globalResolution}).translate([-offset,-offset,0]),
            cylinder({r:1.6,h:40,fn:_globalResolution}).translate([offset,-offset,0]),
            cylinder({r:1.6,h:40,fn:_globalResolution}).translate([-offset,offset,0]),
            cylinder({r:1.6,h:40,fn:_globalResolution}).translate([offset,offset,0])
        );
}

function slottedHole(diam,length,height){
    return union(
        cylinder({r:diam/2,h:height,fn:_globalResolution}),
        cube([diam,length-diam,height]).translate([-diam/2,0,0]),
        cylinder({r:diam/2,h:height,fn:_globalResolution}).translate([0,length-diam,0])
    );
}

function bearingSupport(baseHeight){
    return difference(
        union(
            cylinder({r:5,h:baseHeight,fn:_globalResolution}),
            cylinder({r:4,h:6,fn:_globalResolution}).translate([0,0,baseHeight])
        ),
        cylinder({r:1.4,h:baseHeight+7,fn:_globalResolution})
    );
}

function bearingTop(hole){
    return difference(
        union(
            cylinder({r:5,h:1,fn:_globalResolution}),
            cylinder({r:12,h:3,fn:_globalResolution}).translate([0,0,1])
        ),
        cylinder({r:hole/2+0.1,h:6,fn:_globalResolution})
    );
}

function bearing608z(){
    return difference(
        cylinder({r:11,h:7,fn:_globalResolution}),
        cylinder({r:4,h:7,fn:_globalResolution})
    );
}

function Gt2Holder(boolOffset){
    return difference(
        cube([10,10,10]),
        union(
            cube([10,1,7]).translate([0,boolOffset,3]),
            cube([1,1,7]).translate([1,boolOffset+1,3]),
            cube([1,1,7]).translate([3,boolOffset+1,3]),
            cube([1,1,7]).translate([5,boolOffset+1,3]),
            cube([1,1,7]).translate([7,boolOffset+1,3]),
            cube([1,1,7]).translate([9,boolOffset+1,3])

        )
    )
}
function Gt2HolderBool(){
    return union(
            cube([10,1,7]).translate([0,0,3]),
            cube([1,1,7]).translate([1,1,3]),
            cube([1,1,7]).translate([3,1,3]),
            cube([1,1,7]).translate([5,1,3]),
            cube([1,1,7]).translate([7,1,3]),
            cube([1,1,7]).translate([9,1,3])
    )
}


function main(params){

    output = parseInt(params._output);

    _ZrodsDiam = params._ZrodsDiam;
    _globalResolution = params._globalResolution;
    _nemaXYZ=parseInt(params._nemaXYZ);
    _XYrodsDiam = params._XYrodsDiam;
    _ZrodsDiam = params._ZrodsDiam;
    _globalResolution = params._globalResolution;

    // update calculated values 
    if(_XYrodsDiam==6){ _XYlmDiam = 12;}
    if(_XYrodsDiam==8){ _XYlmDiam = 15;}
    if(_ZrodsDiam==6){ _ZlmDiam = 12;}
    if(_ZrodsDiam==8){ _ZlmDiam = 15;}


    var res=null;

    switch(output){
        case 0:
            res = [
                xend_Jhead_arm().translate([0,0,5]),
                xend_Jhead_attach().translate([0,0,5]),
                xend_jhead().translate([27,20,0])
            ];
        break;
        case 1:

        break;
        case 2:
            //res = xend_Jhead_arm();
        break;
        case 3:

        break;
        case 4:

        break;
        case 5:

        break;
        case 6:

        break;
        case 7:

        break;
        case 8:

        break;
        case 9:

        break;
        case 10:

        break;
        default:

        break;
    }

    return res;


}