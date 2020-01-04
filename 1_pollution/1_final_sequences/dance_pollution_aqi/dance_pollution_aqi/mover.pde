class Mover {
 PVector location;
 PVector velocity;
 PVector acceleration;
 float topspeed;
 color col;
 color orig_col;
 float r; //Radius
 boolean move;
 int col_count = 1;
 float overshoot_dist; //60.0 makes them stop too soon, 10.0 makes them overshoot
 
 Mover(color c, float radius, float max_speed, float inertia){
  location = new PVector(random(width), random(height));
  velocity = new PVector(random(-2,2), random(-2,2));
  topspeed = max_speed;
  col = c;
  r = radius;
  overshoot_dist = inertia;
}
 
 void update(PVector destination){
   //PVector mouse = new PVector(mouseX, mouseY);
   PVector dir = PVector.sub(destination, location);
   if(dir.mag() < overshoot_dist){
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
} // class Mover