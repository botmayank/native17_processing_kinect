/*
  Basic test for moving pollution particles based on processing's PVector tutorial: https://processing.org/tutorials/pvector/
  Date:  02-01-2020
  By:    Mayank Joneja - botmayank@gmail.com
*/


// Config
private static boolean mode_kinect = false; // true: Control with Kinect, false: Control with mouse

// Random movement mode (only used when mode_kinect = false)
//0: No randomness, exactly follows mouse
//1: Follows mouse with some randomness
//2: Disregards mouse, totally random target positions

static int random_mouse_mode = 2;

// types of particles
int NO_2_5_PARTICLES = 40, NO_10_PARTICLES = 10;
Mover[] pm2_5_particles = new Mover[NO_2_5_PARTICLES];
Mover[] pm10_particles = new Mover[NO_10_PARTICLES];

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
  println("Running pollution particle test...");
  
  float inertia, speed;
  // Create new generic movers
  for(int i = 0; i < movers.length; i++){
    color col = color(random(50,255), random(10,90), 127);
    float r = random(30.0, 90.0);
    inertia = 15.0;
    speed = 20.0;
    movers[i] = new Mover(col, r, speed, inertia);
  }
  
  // PM 2.5 particles
  float r_2_5 = 25.0;
  inertia = 10.0; // 10.0 makes particles overshoot target a lot
  speed = 20.0;
  for(int i = 0; i < pm2_5_particles.length; i++){
    color col = color(175, 71, 30);
    pm2_5_particles[i] = new Mover(col, r_2_5, speed, inertia);
  }
  
  // PM 10 particles
  float r_10 = 100.0;
  inertia = 60.0;
  speed = 10.0;
  for(int i = 0; i < pm10_particles.length; i++){
    color col = color(127, 173, 51);
    pm10_particles[i] = new Mover(col, r_10, speed, inertia);
  }
  
  // Other initializations  
  if(mode_kinect) {
    kinect = new Kinect(this);
    bodies = new ArrayList<SkeletonData> ();
    println("======Kinect mode====");
    println("Move around in front of kinect to make particles follow!");
    println("=====================");
  } else {
    println("======Mouse mode====");
    println("Move around mouse to make particles follow!");
    println("=====================");
  }
}

void draw(){
  noStroke();
  fill(0,20);
  rect(0, 0, width, height);  
  
  //Kinect mode
  if(mode_kinect){
    //Body detected
    if (bodies.size() != 0){ 
     int bodyIndex = bodies.size() - 1;
     SkeletonData body = bodies.get(bodyIndex);
     updatePositionKinect(body);
    }
    // body not detected, buzz around
    else{
     int delta = 60;
     for(int i = 0; i < movers.length; i++){
        movers[i].checkEdges();
        movers[i].display();
        movers[i].topspeed = 0.5;
        PVector goal = new PVector(random(movers[i].location.x-delta, movers[i].location.x+delta), random(movers[i].location.y-delta, movers[i].location.y+delta));
        movers[i].update(goal);
    } // for loop
   } // else
  } // mode_kinect  
  
  // Mouse mode
  else{
    int target_x = 0, target_y = 0;
    if(random_mouse_mode == 0){
      // Follow mouse exactly
      target_x = mouseX;
      target_y = mouseY;
    } else if(random_mouse_mode == 1) {
      // Follow mouse with some randomness
      target_x = mouseX + int(random(width/4));
      target_y = mouseY + int(random(height/4));
    } else {
     // Totally random target position
     target_x = int(random(width));
     target_y = int(random(height)); 
    }
    
    PVector mouse_pos = new PVector(target_x, target_y);
    
    // Normal Movers
    //for(int i = 0; i < movers.length; i++){
    //    movers[i].update(mouse_pos);
    //    movers[i].checkEdges();
    //    movers[i].display();
    //}
    
    // PM 2.5 particles
    for(int i = 0; i < pm2_5_particles.length; i++){
        pm2_5_particles[i].update(mouse_pos);
        pm2_5_particles[i].checkEdges();
        pm2_5_particles[i].display();
    }
    
    // PM 10 particles
    for(int i = 0; i < pm10_particles.length; i++){
        pm10_particles[i].update(mouse_pos);
        pm10_particles[i].checkEdges();
        pm10_particles[i].display();
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