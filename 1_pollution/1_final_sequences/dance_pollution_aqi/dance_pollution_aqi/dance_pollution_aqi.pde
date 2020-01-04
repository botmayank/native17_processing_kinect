/*
  Pollution Sequence
  Brief: Pollution is depicted through random circular particles which stick to the human skeleton detected by kinect
         AQI data is pulled from https://waqi.info
  Date:  04-01-2020
  By:    Mayank Joneja - botmayank@gmail.com
         Ameet Singh -  wayward72@gmail.com
*/

Mover[] movers = new Mover[30];

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Text init
String[] headlines = {
  "DANCE TO THE POLLUTION", 
  "A new study shows that pollution is quite democratic.",
  };

PFont text_f;  // Global font variable
float text_x;  // horizontal location of headline
int text_speed = 2;
volatile boolean header = true;

int index = 0;

void setup(){
  size(1920, 1080, P3D);
  background(0);
  smooth();
  float inertia, speed;
  
  for(int i = 0; i < movers.length; i++){
    color col = color(random(50,255), random(10,90), 127);
    float r = random(30.0, 90.0);
    inertia = 15.0;
    speed = 20.0;
    movers[i] = new Mover(col, r, speed, inertia);
  }
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
    
  println("Earthy Colors Pollution sequence by Mayank Joneja, Ameet Singh");
  text_f = createFont("Subway Ticker",30,true);  
  // Initialize headline offscreen to the right 
  text_x = width; 
}

void draw(){
  //If no bodies, show Header 
  if(header == true){
    displayHeader(); 
  } else{
    noStroke();
    fill(0, 20);
    rect(0, 0, width, height);
    SkeletonData body;
    //if body detected    
    if (bodies.size() != 0){
      int bodyIndex = bodies.size() - 1;
      body = bodies.get(bodyIndex);
      updatePositionKinect(body);      
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
  header = false;
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  println("Body gone!");
  //header = false;
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
  randomizeMovers();
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
     PVector body_pos = new PVector(body.position.x*width, body.position.y*height);
     //PVector[] body_part_pos = body.skeletonPositions;
     if(body_pos.mag() > 10){
         for(int i = 0; i < movers.length; i++){
           //PVector pos = new PVector(body_part_pos[i%movers.length].x*width, body_part_pos[i%movers.length].x*height);
           PVector pos = new PVector(body.skeletonPositions[i%body.skeletonPositions.length].x*width, body.skeletonPositions[i%body.skeletonPositions.length].y*height);
           fill(0,0,127);
           ellipse(pos.x, pos.y, 16, 20);
            movers[i].update(pos);
        } 
     }
     else{
       randomizeMovers();
     }
}

void randomizeMovers(){
  for(int i = 0; i< movers.length; i++){
    PVector pos = new PVector(random(width), random(height));
    movers[i].update(pos);
  }
}


void displayHeader(){
    background(0);
    fill(#ff0000);
    
    // Display headline at text_x location
    textFont(text_f, 64);        
    textAlign(LEFT);
    text(headlines[index], text_x,height/2); 
  
    // Decrement x
    text_x = text_x - text_speed;
  
    // If x is less than the negative width, 
    // then it is off the screen
    float w = textWidth(headlines[index]);
    if (text_x < -w) {
      text_x = width; 
      index = (index + 1) % headlines.length;
    }
}