/*
  Pollution Sequence
  Brief: Pollution is depicted through random circular particles which stick to the human skeleton detected by kinect
         AQI data is pulled from https://waqi.info
  Date:  04-01-2020
  By:    Mayank Joneja - botmayank@gmail.com
         Ameet Singh -  wayward72@gmail.com
*/

import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import http.requests.*;

// Config
private static boolean mode_kinect = false; // true: Control with Kinect, false: Control with mouse

//Kinect globals
Kinect kinect;
ArrayList <SkeletonData> bodies;

//Text globals
String[] headlines = {
  "DANCE TO THE POLLUTION", 
  "A new study shows that pollution is quite democratic.",
  };

PFont text_f;  // Global font variable
float text_x;  // horizontal location of headline
int text_speed = 2;
volatile boolean header = true;
int headline_index = 0;

//AQI globals
String AQI_TOKEN = "ENTER-TOKEN-HERE"; // Token generated from waqi.info
int POLLING_INTERVAL = 2; // Seconds
//String city = "delhi"; //city name or @station-id
String city = "@2556"; //R.K. Puram

//Particle globals
ArrayList<Mover> movers, pm25_particles, pm10_particles; //movers are all other gases
int MAX_MOVERS = 150;
int MAX_PM_25 = 50;
int MAX_PM_10 = 50;
int AQI_MAX = 600;

void setup(){
  size(1920, 1080, P3D);
  background(0);
  smooth();
  
  /* Find out AQI for PM2.5 and PM10 */
  println("Getting AQI Data for station-id: " + city);
  int aqi_num = getAqiVal(city);
  println("AQI single value: " + aqi_num);
  
  FloatList aqivals = getParticleVals(city);
  float aqi_num_25 = aqivals.get(0); // pm 2.5
  float aqi_num_10 = aqivals.get(1); // pm 10
  println("No. of PM2.5 particles: " + aqi_num_25 + " pm10 particles: " + aqi_num_10 );
  
  /* Initialize particles for PM10 and PM2.5 */  
  int num_25 = int(map(aqi_num_25, 0, AQI_MAX, 0, MAX_PM_25));
  int num_10 = int(map(aqi_num_10, 0, AQI_MAX, 0, MAX_PM_10));  
  int num_gases = MAX_MOVERS - (num_25 + num_10);
  
  println("Initializing particles with: ");
  println("#gases = " + num_gases);
  println("#PM2.5 particles = " + num_25);
  println("#PM10 particles = " + num_10);
  println("Assuming MAX_AQI = " + AQI_MAX);
  
  movers = new ArrayList<Mover>();
  pm25_particles = new ArrayList<Mover>();
  pm10_particles = new ArrayList<Mover>();
  
  float inertia, speed;
  for(int i = 0; i < num_gases; i++){
    color col = color(random(50,255), random(10,90), 0);
    float r = random(5.0, 10.0);
    inertia = 15.0;
    speed = 20.0;
    movers.add(new Mover(col, r, speed, inertia));
  }
  
  //PM10
  for(int i = 0; i < num_10; i++){
    color col = color(#B9AE6F);
    float r = 50.0;
    inertia = 40.0;
    speed = 10.0;
    pm10_particles.add(new Mover(col, r, speed, inertia));
  }
  
  //PM2.5
  for(int i = 0; i < num_25; i++){
    color col = color(#B9A113);
    float r = 20.0;
    inertia = 25.0;
    speed = 15.0;
    pm25_particles.add(new Mover(col, r, speed, inertia));
  }
  
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
    
  println("AQI and pollutant data sequence by Mayank Joneja, Ameet Singh");
  text_f = createFont("Subway Ticker",30,true);  
  // Initialize headline offscreen to the right 
  text_x = width;
}

void draw(){
  if(mode_kinect){
    //If no bodies, show Header
    if(header == true){
      displayHeader(); 
    } else {
      showBody();
    }
  } else { //mouse mode
    followMouse(1); 
  }
}

//Mouse mode
void followMouse(int random_mouse_mode) {  
  // Random movement mode (only used when mode_kinect = false)
  //0: No randomness, exactly follows mouse
  //1: Follows mouse with some randomness
  //2: Disregards mouse, totally random target positions

  int target_x = 0, target_y = 0;
  // Clear screen and do alpha blending
  noStroke();
  fill(0,20);
  rect(0, 0, width, height);
  
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
  for(int i = 0; i < movers.size(); i++){
      movers.get(i).update(mouse_pos);
  }
  
  //PM2.5
  for(int i = 0; i < pm25_particles.size(); i++){
      pm25_particles.get(i).update(mouse_pos);
  }
  
  //PM10
  for(int i = 0; i < pm10_particles.size(); i++){
      pm10_particles.get(i).update(mouse_pos);
  }
}

/*******************Kinect Methods*******************/
void showBody() {
  noStroke();
  fill(0, 20); //black, alpha
  rect(0, 0, width, height);
  SkeletonData body;
  //if body detected    
  if (bodies.size() != 0){
    int bodyIndex = bodies.size() - 1;
    body = bodies.get(bodyIndex);
    updatePositionKinect(body);      
  }
}

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
     if(body_pos.mag() > 10){ // not at the edge of the screen/partially out
         for(int i = 0; i < movers.size(); i++){
           //PVector pos = new PVector(body_part_pos[i%movers.length].x*width, body_part_pos[i%movers.length].x*height);
           PVector pos = new PVector(body.skeletonPositions[i%body.skeletonPositions.length].x*width, body.skeletonPositions[i%body.skeletonPositions.length].y*height);
           fill(0,0,127);
           ellipse(pos.x, pos.y, 16, 20);
            movers.get(i).update(pos);
        } 
     }
     else{
       randomizeMovers();
     }
}

void randomizeMovers(){
  for(int i = 0; i< movers.size(); i++){
    PVector pos = new PVector(random(width), random(height));
    movers.get(i).update(pos);
  }
}

/*******************Ticker Header Methods*******************/
void displayHeader(){
    background(0);
    fill(#ff0000);
    
    // Display headline at text_x location
    textFont(text_f, 64);        
    textAlign(LEFT);
    text(headlines[headline_index], text_x,height/2); 
  
    // Decrement x
    text_x = text_x - text_speed;
  
    // If x is less than the negative width, 
    // then it is off the screen
    float w = textWidth(headlines[headline_index]);
    if (text_x < -w) {
      text_x = width; 
      headline_index = (headline_index + 1) % headlines.length;
    }
}

/************************AQI Methods*************************/

JSONObject getAqiData(String city) {
  String AQI_URL = "https://api.waqi.info/feed/" + city + "/?token=" + AQI_TOKEN;
  GetRequest get = new GetRequest(AQI_URL);
  get.send(); // program will wait untill the request is completed

  JSONObject response = parseJSONObject(get.getContent());
  
  String status = response.getString("status");
  if(!status.equals("ok")) {
    println("GET request to " + AQI_URL + " failed! Status: " + status);
    println(response.getString("data"));
    return null;
  }
  
  //println("response: " + get.getContent());
  
  // Parsing of response
  JSONObject aqidata = response.getJSONObject("data");
  return aqidata;
}

int getAqiVal(String city) {
  JSONObject aqidata = getAqiData(city);
  if(aqidata != null){
    return aqidata.getInt("aqi");
  } else {
    return -1;
  }    
}

FloatList getParticleVals(String city) {
  // Returns a float list of particle vals: "pm25", "pm10", "co", "o3"
  
  FloatList vals = new FloatList();  
  JSONObject aqidata = getAqiData(city);
  
  if(aqidata != null){
    JSONObject iaqi = aqidata.getJSONObject("iaqi");  
    String particles[] = {"pm25", "pm10", "co", "o3"};
        
    for (String p : particles) {
      float val = iaqi.getJSONObject(p).getFloat("v");
      vals.append(val);
    }
  }  
  return vals;
}

void printParticleVals(String city) {
  JSONObject aqidata = getAqiData(city);
  if(aqidata != null){
    JSONObject iaqi = aqidata.getJSONObject("iaqi");
    
    String particles[] = {"pm25", "pm10", "co", "o3"};
    
    println("===========AQI Details========");    
    for (String p : particles) {
      float val = iaqi.getJSONObject(p).getFloat("v");
      println(p + " value: " + val);
    }
    println("==============================");
  }
}