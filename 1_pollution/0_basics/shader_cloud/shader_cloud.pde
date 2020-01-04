/*
  Random clouds filling up screen like fog based on Shaders Tutorial 10.2
  https://processing.org/tutorials/pshader/
  By: Mayank Joneja
  Date: 03-01-2020
*/

PShader pointShader;
PImage cloud1;
PImage cloud2;
PImage cloud3;

float weight = 100;
int target_x = 0, target_y = 0;
int y_margin = 50;
int frame_counter = 0;

void setup() {
  size(1440, 960, P3D);
  
  pointShader = loadShader("spritefrag.glsl", "spritevert.glsl");
  pointShader.set("weight", weight);
  cloud1 = loadImage("cloud1.png");
  cloud2 = loadImage("cloud2.png");
  cloud3 = loadImage("cloud3.png");
  pointShader.set("sprite", cloud2);
    
  strokeWeight(weight);
  strokeCap(SQUARE);
  stroke(255, 70);
  
  background(0);
}

void draw() {
  
  shader(pointShader, POINTS);
  if(frame_counter <= 300) {
    target_y = int(random(2 * height/3 + 100, height));
  } else {
    target_y = int(random(2 * height/3, height));
  }
  
  //target_x = int(random(width));
  
  target_y = int(random(target_y - y_margin, target_y + y_margin));
  
  target_x += 3;
  if (target_x >= width) target_x = 0;
  if(!mousePressed)
    point(target_x, target_y);
    
  frame_counter++;
}