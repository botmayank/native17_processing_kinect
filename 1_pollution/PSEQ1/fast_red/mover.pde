class Mover {
 PVector location;
 PVector velocity;
 PVector acceleration;
 float topspeed;
 color col;
 float r; //Radius
 boolean move;
 
 Mover(){
  //location = new PVector(width/2, height/2);
  location = new PVector(random(width), random(height));
  //velocity = new PVector(random(-2,2), random(-2,2));
  velocity = new PVector(0, 0);
  topspeed = 5;
  col = color(random(50,255), 0, 0);
  r = random(30.0, 90.0);
  //acceleration = new PVector(-0.001,0.01);
}
 
 void update(PVector destination){
   //PVector mouse = new PVector(mouseX, mouseY);
   PVector dir = PVector.sub(destination, location);
   if(dir.mag() < 10.0){
     move = false;
   }
   else{
     move = true;
   }
     
   dir.normalize();   
   dir.mult(0.5);   
   acceleration = dir;   
   
   if(move){
     velocity.add(acceleration);
   }
   else{
     velocity.set(0.0,0.0);
   }    
   
   //velocity.add(acceleration);
   velocity.limit(topspeed);
   location.add(velocity); 
  
 }
  
  void display(){
    noStroke();
    fill(col);
    ellipse(location.x, location.y, r, r);
  }
  
  void checkEdges(){
  if (location.x > width){
   location.x = 0;
  } else if(location.x < 0) {
   location.x = width; 
  }
  
  if(location.y > height){
   location.y = 0;
  } else if (location.y < 0) {
   location.y = height; 
  }
  
  }
}