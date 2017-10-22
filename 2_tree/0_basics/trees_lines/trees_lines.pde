int line_height = 0;
int line_width = 0;
//int delta = 2;


void setup(){
  size(1440, 500, P2D);
  smooth();
  background(0);  
}


void draw(){
  noStroke();
  fill(color(100, 200, 100));
  //rect(40, 40, 100, 200);
  baseLinesShow();

}





void baseLinesShow(){
  int line_speed = 15;  
  //if(line_height > -120){   
  line_height += line_speed;
  line_width += line_speed;
  //}  
  fill(color(100, 200, 100));
  rect(width/3, 0, 40, line_height);
  rect(2*width/3, height, 40, -line_height);  
  
  fill(color(200, 100, 0));
  rect(0, height/3, line_width, 40);
  rect(width, 2*height/3, -line_width, 40);  
}