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

void setup() {
  size(640, 360, P3D);
  
  pointShader = loadShader("spritefrag.glsl", "spritevert.glsl");
  pointShader.set("weight", weight);
  cloud1 = loadImage("cloud1.png");
  cloud2 = loadImage("cloud2.png");
  cloud3 = loadImage("cloud3.png");
  pointShader.set("sprite", cloud1);
    
  strokeWeight(weight);
  strokeCap(SQUARE);
  stroke(255, 70);
  
  background(0);
}

void draw() {
  shader(pointShader, POINTS);
  
  target_x = int(random(width));
  target_y = int(random(height));
  
  target_x = (target_x > width)? width : target_x;
  target_x = (target_x < 0) ? 0 : target_x;
  
  target_y = (target_y > height)? height : target_y;
  target_y = (target_y < 0) ? 0 : target_y;
  
  point(target_x, target_y);
}