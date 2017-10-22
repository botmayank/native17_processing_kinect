//Ring buffer of 50 samples for mouse/kinect samples, show trail of circles of green color fading with position

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
ArrayList <SkeletonData> bodies;

//Init for ring buffer

int num = 50;
int [] g_x = new int[num];
int [] g_y = new int[num];

int [] b_x = new int[num];
int [] b_y = new int[num];


int g_indexPosition = 0;
int b_indexPosition = 0;

void setup(){
  size(1280, 720, P3D);
  smooth();
  noStroke();
  println("Blue and Green trail Kinect");
    
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
}

void draw(){
 background(0);
 drawGrid(30); //draw grid of gray circles, radius 30, gap r+10
 
 SkeletonData body;
 
 if (bodies.size() != 0){
   int bodyIndex = bodies.size() - 1;
   body = bodies.get(bodyIndex);
   
   //Kinect body center
   println("Body x, y:");
   println(body.position.x);
   println(body.position.y);
   
   println("Wrist left x, y:");
   float l_wrist_x = body.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].x;
   float l_wrist_y = body.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_LEFT].y;
   
   float r_wrist_x = body.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].x;
   float r_wrist_y = body.skeletonPositions[Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT].y;
   
   //println(wrist_x, wrist_y);
      
   if(body.position.x != 0.0 || body.position.y != 0.0){
     //Body position
     //x[indexPosition] = int(body.position.x*width/2);
     //y[indexPosition] = int(body.position.y*height/2);
     
     //Wrist position
     g_x[g_indexPosition] = int(l_wrist_x*width/2);
     g_y[g_indexPosition] = int(l_wrist_y*height/2);
     
     b_x[b_indexPosition] = int(r_wrist_x*width/2);
     b_y[b_indexPosition] = int(r_wrist_y*height/2);
     
     drawGreenTrail();
     drawBlueTrail();
   }
   else{
     noStroke();
     noFill();
     background(0);
   }
   
 } 
 //Mouse
 
 //x[indexPosition] = mouseX;
 //y[indexPosition] = mouseY;
 
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

 void drawGreenTrail(){   
   
 g_indexPosition = (g_indexPosition + 1) % num;
 int green_shade = 20;
 
   for(int i = 0; i < num; i++){
     int pos = (g_indexPosition+i)%num;
     float radius = ((num - i) /2.0)*5;
     
     if(green_shade > 255){
       green_shade = 100;
     }
       
     fill(0, green_shade, 0);
     ellipse(g_x[pos], g_y[pos], radius, radius);
     
     green_shade = green_shade+5;
   } 
 }
 

 void drawBlueTrail(){
   
 b_indexPosition = (b_indexPosition + 1) % num;
 int blue_shade = 20;
 
   for(int i = 0; i < num; i++){
     int pos = (b_indexPosition+i)%num;
     float radius = ((num - i) /2.0)*5;
     
     if(blue_shade > 255){
       blue_shade = 100;
     }
       
     fill(0, 0, blue_shade);
     ellipse(b_x[pos], b_y[pos], radius, radius);
     
     blue_shade+=5;
   } 
 }
 void drawGrid(int r_bg){
   
   
   fill(100, 100, 100, 127);
   for(int i = 10; i < width;){
     //int r_e = int(random(r_bg - 10, r_bg + 10));     
     int r_e = r_bg+50;
     int gap = r_bg+80;
     for(int j = 10; j < height; )
     {
       ellipse(i, j, r_e, r_e);
       j+=gap;
       //j+=random(gap-5, gap+5);
     }
     i+=gap;
     //i+=random(gap-5, gap+5);
   }
}