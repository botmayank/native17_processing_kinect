private static boolean mode_kinect = true;

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Gestures
int i_l_hand = Kinect.NUI_SKELETON_POSITION_HAND_LEFT;
int i_r_hand = Kinect.NUI_SKELETON_POSITION_HAND_RIGHT;
volatile boolean l_upper = false;
volatile boolean r_upper = false;
int threshold = 10000; //10k, distance between body center and left/right hand i.e. radius for gesture activation

void setup(){
  size(1440, 800, P3D);
  background(0);
  smooth();  
  frameRate(12);
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
    
  println("Gestures");

}

void draw(){
  noStroke();
  fill(0,20);
  rect(0, 0, width, height);  
  
  if(mode_kinect){
    //SkeletonData body;
    //if body detected    
    if (bodies.size() != 0){
     int bodyIndex = bodies.size() - 1;
     //for(SkeletonData body : bodies){
     SkeletonData body = bodies.get(bodyIndex);
     //PVector body_pos = body.position;     
     //println("Body x, y:");
     //println(body.position.x);
     //println(body.position.y);
     
     //PVector l_hand_pos = body.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT];
     //println("Left Hand x,y");
     //println(l_hand_pos.x);
     //println(l_hand_pos.y);
     
     updatePositionKinect(body);
     if(l_upper){
       println("Left triggered");
     }
     if(r_upper){
       println("Right triggered");
     }
     
     //}
   }   
  }  
}

//Kinect events

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  println("Body appeared!");
  synchronized(bodies) {
    bodies.add(_s);
  }
}


void disappearEvent(SkeletonData _s) 
{
  println("Body gone!");
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

//Show left hand and right hand only if more above body center and sufficiently away from body center
void updatePositionKinect(SkeletonData body){    
    PVector l_pos = new PVector(body.skeletonPositions[i_l_hand].x*width, body.skeletonPositions[i_l_hand].y*height);
    PVector r_pos = new PVector(body.skeletonPositions[i_r_hand].x*width, body.skeletonPositions[i_r_hand].y*height);
    l_pos.sub(body.position);
    r_pos.sub(body.position);

    l_upper = (l_pos.y < body.position.y*height/2)? true : false;
    r_upper = (r_pos.y < body.position.y*height/2) ? true : false;
    
    if((l_pos.mag() > threshold) && l_upper){
      //println("Left > thresh");
      fill(0,0,127);
      ellipse(l_pos.x, l_pos.y, 56, 60);
    }
    if((r_pos.mag() > threshold) && r_upper){
      fill(0,127,0);
      ellipse(r_pos.x, r_pos.y, 56, 60);
    }        
}