PShape fish;
PShape river;

float f_size = 1.0;
int f_x, f_y;

void setup(){
 size(1280, 990, P3D);
 fish = loadShape("fish.svg");
 river = loadShape("wave-01.svg");
 f_x = 100;
 f_y = 100;
 
 fish.translate(width/2 - fish.width, height/2 - fish.height, -0.5);
 river.scale(0.8);
 river.setFill(color(0,0,200, 127));
 river.translate(width/2 - river.width/3, height/2 - river.height/2, 0.5);
 
}

void draw(){
  
 background(255);
 //translate(f_x, f_y);
 //rotate(90);
 
 //scale(f_size);

 fish.translate(1,1);
 shape(fish);
 shape(river);

}