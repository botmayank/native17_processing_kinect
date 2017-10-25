//Kinect based interaction with water/sunset sequence

/*
TODO:
1. Check if smooth() works
2. Check if frameRate limit also slows down Kinect responsiveness
3. Add another state for text headline to appear, state = -1
4. Implement gestures to replace W/S and I/J 
5. Implement A to I transition (based on timer ? if A done and time since A > 2000 ms then I?)
*/

//Kinect imports
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Text Headline
String[] headlines = {
  "SURFING THE SEA", 
  "You cannot cross the sea merely by standing and staring at the water - Tagore", 
};
PFont f;  // Global font variable
float x;  // horizontal location of headline
int index = 0;
int text_speed = 8;
volatile boolean header = true;

//Sunset and state machine
int state;
Sunset sunset;

void setup()
{
  size(1920, 1080,P3D);
  f = createFont("Subway Ticker",30,true);   
  // Initialize headline offscreen to the right 
  x = width;
  
  background(0);
  smooth(); //TODO doesn't really work
  //TODO: Check if it really works and if it also limits Kinect interaction speed
  frameRate(10); //TODO can be faster
  
  //Kinect init
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
  
  sunset = new Sunset();
  state = -1;  //Text header display  
}
void draw()
{
  switch(state)
  {
    case -1:
          background(0);
          fill(#ff0000);
          displayHeader();
          break;
    case 0: //default state "D"
          sunset.saturate_desaturate(60, 1);//float maxSaturation, float satIncrementRate
          sunset.wiggleSkyRate = 0.2;
          sunset.wiggleSeaRate = 0.2;
          sunset.wiggleSky();//float rate
          sunset.wiggleSea();//float rate
          sunset.display();
          break;
    case 1: //appear state "A"
          sunset.appear(1); // float satIncrementRate
          sunset.display();
          break;
    case 2: //interaction state "I"
          //Make transition to "I" notable
          sunset.wiggleSkyRate = sunset.maxWiggleRate - 2;
          sunset.wiggleSeaRate = sunset.maxWiggleRate - 2;
          
          sunset.wiggleSky();//float rate
          sunset.wiggleSea();//float rate
          sunset.display();
          break;   
  }
}
void mouseClicked(){ //appear state "A"
 state = 0;  
}

void keyPressed() {
  if(key == 'w' || key == 'W') //sky up
    sunset.wiggleSkyRate = constrain(sunset.wiggleSkyRate + 0.1, 0, sunset.maxWiggleRate);
  else if(key == 's' || key == 'S') //sky down
    sunset.wiggleSkyRate = constrain(sunset.wiggleSkyRate - 0.1, 0, sunset.maxWiggleRate);
  else if(key == 'i' || key == 'I') //sea up
    sunset.wiggleSkyRate = constrain(sunset.wiggleSeaRate + 0.1, 0, sunset.maxWiggleRate);
  else if(key == 'j' || key == 'J') //sea down
    sunset.wiggleSkyRate = constrain(sunset.wiggleSeaRate - 0.1, 0, sunset.maxWiggleRate);
  else if(key == 'q' || key == 'Q') //trigger interaction state "I"
    state = 2;
}


//Moved function to act as keypressed to check if gestures triggered. W/S and I/J on gestures which should happen AFTER "I"
//Also think about how to trigger Interaction state, simply once x time has passed after appear?


void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  println("Body appeared!");
  state = 1;
  header = false;
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  println("Body gone!");
  state = -1;
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
  state = 2;
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