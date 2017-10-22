int y = 2;
int delta = 5;

void setup(){
  size(1440, 800,P3D);
  background(0);
  smooth();
  
  //rect(width/2, height/2, 80, 120);
}

void draw(){
  fill(100,0,0);
  rect(width/2+80, height, 80, y);
  y-=delta;
  println("Y is:");
  println(y); 
  
  if(y < -80){
    fill(200, 100, 0);
    pushMatrix();
    translate(width/2+80, -100);
    rotate(PI/4);
    rect(width/2-80, 0, 80, -y);
    popMatrix();
  }
}