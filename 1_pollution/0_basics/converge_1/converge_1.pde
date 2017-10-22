Mover[] movers = new Mover[10];

void setup(){
  size(1280, 500);
  background(0);
  smooth();  
  for(int i = 0; i < movers.length; i++){
    movers[i] = new Mover();
  }


}

void draw(){
  noStroke();
  fill(255, 10);
  rect(0, 0, width, height);  
    for(int i = 0; i < movers.length; i++){
      movers[i].update();
      movers[i].checkEdges();
      movers[i].display();
  }  
}