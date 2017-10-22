private static boolean mode_kinect = true;

Mover[] movers = new Mover[20];

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

void setup(){
  size(1440, 800, P3D);
  background(0);
  smooth();  
  for(int i = 0; i < movers.length; i++){
    int gray = int(random(255)); 
    movers[i] = new Mover();
    //movers[i].col = color(gray, gray, gray);
    //movers[i].orig_col = movers[i].col;
  }
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
    
  println("Converging PSEQ2");

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
     updatePositionKinect(body);
     //}
   }   
   else{
     int delta = 60;
     for(int i = 0; i < movers.length; i++){
        //movers[i].update(mouse_pos);
        movers[i].checkEdges();
        movers[i].display();
        movers[i].topspeed = 0.5;
        PVector goal = new PVector(random(movers[i].location.x-delta, movers[i].location.x+delta), random(movers[i].location.y-delta, movers[i].location.y+delta));
        movers[i].update(goal);
      }       
       //noStroke();
       //noFill();
       //background(0);     
   }      
  }
  else{ // if mouse and not kinect
   PVector mouse_pos = new PVector(mouseX,mouseY);
     for(int i = 0; i < movers.length; i++){
        movers[i].update(mouse_pos);
        movers[i].checkEdges();
        movers[i].display();
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

void updatePositionKinect(SkeletonData body){
     //PVector body_pos = new PVector(body.position.x*width, body.position.y*height);
     //PVector[] body_part_pos = body.skeletonPositions;
     for(int i = 0; i < movers.length; i++){       
       PVector pos = new PVector(body.skeletonPositions[i%body.skeletonPositions.length].x*width, body.skeletonPositions[i%body.skeletonPositions.length].y*height);
       fill(0,0,127);
       ellipse(pos.x, pos.y, 16, 20);
        //movers[i].setRed();
        movers[i].update(pos);
        movers[i].checkEdges();
        movers[i].display();
    } 
}