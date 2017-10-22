//Planes, v_lines, d_lines,interaction

//Planes
Planes planes;
float plane_width;
boolean done;

//Lines
Lines lines;

//Leaves
Leaf leaf_l, leaf_r;

//Kinect variables
int move = 0;

// 0 - not yet appeared/disappeared, 1- appeared, 2-appear cleared and in frame
int appear = 0; //when body appears, on mouse click/kinect

int n_left_hand = 0; //number of times left hand moved
int n_right_hand = 0;

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
    if(appear == 0){      
    planes.grayFade();
    }
    
    //Appear
    //Planes turn to bright green
    if(appear == 1){      
      //lerp transition value = 0.008
      //if(planes.colorBright(0.008)){
      //appear = 2; // appear cleared state
      //planes.colorBright(0.008);
      //delay(100);
      lines.baseLinesShow();
      lines.growLineL(5);
      lines.growLineR();
      //}      
    }    
    
    //Interaction
    //Lines grow
    //if(move == 100){
    //  lines.baseLinesShow();
    //  lines.growLineL(5);
      
    //}
    
    //Post Interaction (Disappear)
    //Transition to BI
    //Back to gray planes oscillating
}

void mouseClicked(){
 appear = 1;  
}