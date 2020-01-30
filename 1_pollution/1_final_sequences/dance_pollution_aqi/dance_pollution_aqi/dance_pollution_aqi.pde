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
private static boolean mode_kinect = true; // true: Control with Kinect, false: Control with mouse

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


/*
@2556 : R.K Puram, Delhi, India
@1929 : Aichi, Japan
@5724 : London, UK
@10707: Sri Aurobindo Marg, New Delhi, India
@11278: Knowledge Park - III, Greater Noida, India
@10113: ITI Jahangirpuri, Delhi, Delhi, India
@10119: National Institute of Malaria Research, Dwarka, Delhi, India
*/

StringDict city_list;

//String city = "@2556"; //R.K. Puram
//String city = "@11278"; //Greater Noida
String city = "@1929";

//Particle globals
ArrayList<Mover> movers, pm25_particles, pm10_particles; //movers are all other gases
int MIN_PARTICLES_25 = 3;
int MIN_PARTICLES_10 = 3;
int MAX_MOVERS = 150;
int MAX_PM_25 = 100;
int MAX_PM_10 = 100;
int AQI_MAX = 600;

// common speeds and inertias for particles based on AQI
float[] aqi_speeds = {5.0, 8.0, 10.0, 12.0, 15.0, 20.0};
float[] aqi_inertias = {2.0, 5.0, 10.0, 15.0, 20.0, 25.0};

void setup(){
  println("AQI and pollutant data sequence by Mayank Joneja, Ameet Singh");
  
  fullScreen();
  background(0);
  smooth();
  
  /* City list for text */
  city_list = new StringDict();
  city_list.set("@2556", "R.K Puram, Delhi, India");
  city_list.set("@1929", "Aichi, Japan");
  city_list.set("@5724", "London, UK");
  city_list.set("@10707", "Sri Aurobindo Marg, New Delhi, India");
  city_list.set("@11278", "Knowledge Park - III, Greater Noida, India");
  city_list.set("@10113", "ITI Jahangirpuri, Delhi, Delhi, India");
  city_list.set("@10119", "National Institute of Malaria Research, Dwarka, Delhi, India");
  
  /* Find out AQI for PM2.5 and PM10 */
  println("Getting AQI Data for station-id: " + city);
  int aqi_num = getAqiVal(city);  
  println("AQI single value: " + aqi_num); 
  
  printParticleVals(city);
  FloatList aqivals = getParticleVals(city);
  float aqi_num_25 = aqivals.get(0); // pm 2.5
  float aqi_num_10 = aqivals.get(1); // pm 10
  println("No. of PM2.5 particles: " + aqi_num_25 + " pm10 particles: " + aqi_num_10 );
  
  /* Initialize particles for PM10 and PM2.5 */
  int num_25 = int(map(aqi_num_25, 0, AQI_MAX, MIN_PARTICLES_25, MAX_PM_25));
  int num_10 = int(map(aqi_num_10, 0, AQI_MAX, MIN_PARTICLES_10, MAX_PM_10));
  
  int num_gases = MAX_MOVERS - (num_25 + num_10);
  float num_aqi_gases = aqivals.get(2) + aqivals.get(3);
  num_gases = int(map(num_aqi_gases, 0, 100, 0, num_gases));
  
  println("Initializing particles with: ");
  println("#gases = " + num_gases);
  println("#PM2.5 particles = " + num_25);
  println("#PM10 particles = " + num_10);
  println("Assuming MAX_AQI = " + AQI_MAX);
  
  movers = new ArrayList<Mover>();
  pm25_particles = new ArrayList<Mover>();
  pm10_particles = new ArrayList<Mover>();
  
  // Initialize particles based on AQI
  init_gases(num_gases);
  init_pm10(num_10, int(aqi_num_10));
  init_pm25(num_25, int(aqi_num_25));
  
  // Kinect init
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData> ();
  
  // Ticker text init
  text_f = createFont("Subway Ticker",30,true);
  // Initialize headline offscreen to the right 
  text_x = width;
}

void init_pm25 (int num_25, int aqi) {
    int aqi_cat = getAqiCategory(aqi); //0-5
    //PM2.5
    float[] pm25_radii = {15.0, 20.0, 25.0, 30.0, 40.0, 60.0, 80.0};

    color col = getAqiCategoryColor(aqi);
    float r = pm25_radii[aqi_cat];    
    float speed = aqi_speeds[aqi_cat];
    float inertia = aqi_inertias[aqi_cat];    
  
  for(int i = 0; i < num_25; i++){
    pm25_particles.add(new Mover(col, r, speed, inertia));
  } 
}

void init_pm10 (int num_10, int aqi) {
    int aqi_cat = getAqiCategory(aqi); //0-5
    //PM10
    float[] pm10_radii = {30.0, 40.0, 50.0, 60.0, 80.0, 120.0, 160.0};
    
    color col = getAqiCategoryColorDark(aqi);
    float r = pm10_radii[aqi_cat];    
    float speed = aqi_speeds[aqi_cat];
    float inertia = aqi_inertias[aqi_cat];    
  
  for(int i = 0; i < num_10; i++){
    pm10_particles.add(new Mover(col, r, speed, inertia));
  } 
}

void init_gases(int num_gases) {  
  float inertia, speed;
  for(int i = 0; i < num_gases; i++){
    color col = color(random(50,255), random(10,90), 0);
    float r = random(2.0, 4.0);
    inertia = 15.0;
    speed = 20.0;
    movers.add(new Mover(col, r, speed, inertia));
  }
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
  displayCity();
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
     int target_x = 0, target_y = 0;
     float body_x = 0, body_y = 0;
     if(body_pos.mag() > 10){ // not at the edge of the screen/partially out
         // Draw body ellipses
         for (int i = 0; i < body.skeletonPositions.length; i++) {           
           // update body ellipse
           colorMode(RGB, 255);
           body_x = body.skeletonPositions[i].x*width;
           body_y = body.skeletonPositions[i].y*height;
           
           PVector body_part_pos = new PVector(body_x, body_y);
           fill(0,0,127); //blue ellipse for skeleton body
           ellipse(body_part_pos.x, body_part_pos.y, 16, 20);
         }         
         //PM2.5 stick to human + small amount of randomness
         for(int i = 0; i < pm25_particles.size(); i++){
           body_x = body.skeletonPositions[i%body.skeletonPositions.length].x*width;
           body_y = body.skeletonPositions[i%body.skeletonPositions.length].y*height;
           target_x = int(body_x + random(-width/10, width/10));
           target_y = int(body_y + random(-height/10, height/10));
           PVector pos = new PVector(target_x, target_y);
           pm25_particles.get(i).update(pos);
        }
        //PM 10 stick to human + some more randomness     
        for(int i = 0; i < pm10_particles.size(); i++){
          target_x = int(body.skeletonPositions[i%body.skeletonPositions.length].x*width + random(-width/4, width/4));
          target_y = int(body.skeletonPositions[i%body.skeletonPositions.length].y*height + random(-height/4, height/4));
          PVector pos = new PVector(target_x, target_y);
          pm10_particles.get(i).update(pos);
        }
        // Gases random
        for(int i = 0; i < movers.size(); i++){
          PVector pos = new PVector(random(width), random(height));
          movers.get(i).update(pos);
        }        
     } //if
     else{
       randomizeMovers();
     }
}

void randomizeMovers(){
  for(int i = 0; i< movers.size(); i++){
    PVector pos = new PVector(random(width), random(height));
    movers.get(i).update(pos);
  }
  
  //PM2.5
  for(int i = 0; i < pm25_particles.size(); i++){
    PVector pos = new PVector(random(width), random(height));
    pm25_particles.get(i).update(pos);
  }
  
  //PM10
  for(int i = 0; i < pm10_particles.size(); i++){
    PVector pos = new PVector(random(width), random(height));
    pm10_particles.get(i).update(pos);
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

void displayCity() {
    int padding = 20;
    textFont(text_f, 48);
    textAlign(RIGHT);
    text(city_list.get(city), width - padding, height - padding); // bottom right corner
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

color getAqiCategoryColor(int aqi_num) {
  int aqi_cat = getAqiCategory(aqi_num);
  
  int[] aqi_hues = {121, 59, 24, 357, 333, 331, 0}; // HSV Hue values in 360 deg
  int[] aqi_saturations = {77, 71, 83, 92, 90, 95, 0}; // HSV Sat values in 0-100
  int[] aqi_brightnesses = {88, 100, 99, 99, 59, 29, 50}; // HSV Brightnes values in 0-100
  
  int aqi_hue = int(map(aqi_hues[aqi_cat], 0, 360, 0, 100));
  colorMode(HSB, 100);
  color aqi_color = color(aqi_hue, aqi_saturations[aqi_cat], aqi_brightnesses[aqi_cat]);
  
  return aqi_color;
}

color getAqiCategoryColorDark(int aqi_num) {
  int aqi_cat = getAqiCategory(aqi_num);
  
  int[] aqi_hues = {121, 59, 24, 357, 333, 331, 0}; // HSV Hue values in 360 deg
  int[] aqi_saturations = {77, 71, 83, 92, 90, 95, 0}; // HSV Sat values in 0-100
  int[] aqi_brightnesses = {88, 100, 99, 99, 59, 29, 50}; // HSV Brightnes values in 0-100
  
  int aqi_hue = int(map(aqi_hues[aqi_cat], 0, 360, 0, 100));
  colorMode(HSB, 100);
  color aqi_color = color(aqi_hue, aqi_saturations[aqi_cat], aqi_brightnesses[aqi_cat] - 25);
  
  return aqi_color;
}

int getAqiCategory(int aqi_num) {
  int aqi_cat = 0;
  int[] aqi_level =  {0, 51, 101, 151, 201, 301};
  
  if(aqi_num > aqi_level[0] && aqi_num < aqi_level[1]) {
    aqi_cat = 0; // Good - Green
  } else if(aqi_num > aqi_level[1] && aqi_num < aqi_level[2]) {
    aqi_cat = 1; // Moderate - Yellow
  } else if(aqi_num > aqi_level[2] && aqi_num < aqi_level[3]) {
    aqi_cat = 2; // Unhealthy for sensitive groups - Orange
  } else if(aqi_num > aqi_level[3] && aqi_num < aqi_level[4]) {
    aqi_cat = 3; // Unhealthy - Red
  } else if(aqi_num > aqi_level[4] && aqi_num < aqi_level[5]) {
    aqi_cat = 4; // Very Unhealthy - Purple 
  } else if(aqi_num > aqi_level[5]) {
    aqi_cat = 5; // Hazardous - Maroon
  } else {
    println("Unexpected aqi_num: " + aqi_num);
    aqi_cat = 5;
  }
  return aqi_cat;
}