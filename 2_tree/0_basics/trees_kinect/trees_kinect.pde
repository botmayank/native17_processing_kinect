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
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

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
  
  //Kinect init
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
  
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
      if(planes.colorBright(0.008)){
      appear = 2; // appear cleared state
      }      
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


//Kinect events

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  println("Body appeared!");
  appear = 1;
  synchronized(bodies) {
    bodies.add(_s);
  }
}


void disappearEvent(SkeletonData _s) 
{
  println("Body gone!");
  appear = 0;
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }  
}


void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  //println("Body moving!");
  move++;
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}