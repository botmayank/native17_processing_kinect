//Planes, v_lines, d_lines,interaction

//Planes
Planes planes;
float plane_width;

//Lines
Lines lines;

//Leaves
Leaf leaf_l, leaf_r;

//Kinect variables

boolean appear = false; //when body appears, on mouse click/kinect

void setup(){
  size(1920, 1080,P2D);
  background(0);
  smooth();
  println("Trees 01 Sequence");
  //Load background planes
  planes = new Planes();
  plane_width = planes.pl[0].width;
  planes.init();
  
  //Load Lines
  lines = new Lines();
  lines.line_height = height;
  
  //Load leaf
  leaf_l = new Leaf(true);
  leaf_r = new Leaf(false);
}

void draw(){    
    //Default
    //Planes dark to light moving
    if(!appear){      
    planes.grayFade();
    }
    
    //Appear
    //Planes turn to bright green
    if(appear){      
      //planes.colorBright(0.008); //lerp transition value
      lines.baseLinesShow();
      lines.growLineL();
    }    
    //Interaction
    //Lines grow
    
    //Post Interaction (Disappear)
    //Transition to BI
    //Back to gray planes oscillating
}

void mouseClicked(){
 appear = true;  
}