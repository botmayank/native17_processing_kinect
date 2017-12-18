/*
  Pollution Sequence
  Brief: Pollution is depicted through random circular particles which stick to the human skeleton detected by kinect
  Date:  28-10-2017
  By:    Mayank Joneja - botmayank@gmail.com
         Ameet Singh -  wayward72@gmail.com
         
  Note: Install the TTF font in the data folder for the Subway Ticker font from http://www.1001fonts.com/subway-ticker-font.html
        before running the sketch
*/

Mover[] movers = new Mover[40];

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Text init
String[] headlines = {
  "DANCE TO THE POLLUTION", 
  "new study shows that pollution is quite democratic.",
  };

PFont f;  // Global font variable
float x;  // horizontal location of headline
int index = 0;
int text_speed = 2;
volatile boolean disperse = false;

volatile boolean header = true;
  
void setup(){
  size(1920, 1080, P3D);
  background(0);
  smooth();  
  for(int i = 0; i < movers.length; i++){
    movers[i] = new Mover();
  }
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
    
  println("Earthy Colors Pollution sequence by Mayank Joneja, Ameet Singh");
  f = createFont("Subway Ticker",30,true);  
  // Initialize headline offscreen to the right 
  x = width; 
}

void draw(){
  //If no bodies, show Header 
  if(header == true){
    background(0);
    fill(#ff0000);
    displayHeader(); 
  }
  else{
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
  header = false;
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
  disperse = true;
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
     int disappear_threshold = 20;     
     PVector body_pos = new PVector(body.position.x*width, body.position.y*height);
     //PVector[] body_part_pos = body.skeletonPositions;     
     if(body_pos.mag() > disappear_threshold){       
       for(int i = 0; i < movers.length; i++){
         //PVector pos = new PVector(body_part_pos[i%movers.length].x*width, body_part_pos[i%movers.length].x*height);
         PVector pos = new PVector(body.skeletonPositions[i%body.skeletonPositions.length].x*width, body.skeletonPositions[i%body.skeletonPositions.length].y*height);
         fill(0,0,127);
         ellipse(pos.x, pos.y, 16, 20);
          movers[i].topspeed = 3; //Slow down movers
          movers[i].update(pos);
          movers[i].checkEdges();
          movers[i].display();
      } 
     }
     else{
       randomizeMovers();
     }
}

void displayHeader(){  
  // Display headline at x  location
    textFont(f, 64);        
    textAlign(LEFT);
    text(headlines[index],x,height/2);   
    // Decrement x
    x = x - text_speed;  
    // If x is less than the negative width, 
    // then it is off the screen
    float w = textWidth(headlines[index]);
    if (x < -w) {
      x = width; 
      index = (index + 1) % headlines.length;
    }
}

void randomizeMovers(){  
  for(int i = 0; i< movers.length; i++){
      if(disperse == true){
        movers[i].rand_width = random(random(0, width/3), random(2*width/3, width));
        movers[i].rand_height = random(random(0, height/3), random(2*height/3, height));            
      }
      float r_w = movers[i].rand_width;
      float r_h = movers[i].rand_height;
      PVector pos = new PVector(random(r_w - 10, r_w),random(r_h - 10, r_h));    
      movers[i].topspeed = 5;
      movers[i].offshoot = 2;
      movers[i].update(pos);
      movers[i].checkEdges();
      movers[i].display();
  }
  disperse = false;
}