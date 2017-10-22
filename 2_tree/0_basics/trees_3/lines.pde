class Lines{
  PShape vline_1, vline_2, dline_l, dline_r;
  int line_gray = 0;
  int line_height; 
  int l_index = 5;
  int r_index = 4;
  
  Lines(){
    vline_1 = loadShape("TSQ-01-vline01.svg");
    vline_2 = loadShape("TSQ-01-vline01.svg");
    dline_l = loadShape("TSQ-01-dline01.svg");
    dline_r = loadShape("TSQ-01-dline02.svg");    
  }
  
  void growLineL(int line_index){
    //line_index based on left hand movt. count   
    
   //color line_g = color(line_gray);
   dline_l.setFill(255);
   
   //0 - lower left, 1 - top left, 2 - top right, 3 - bottom right
   //if((l_index == 5)|| (l_index == 8)){
   //PVector ll = dline_l.getVertex(0);
   //PVector tl = dline_l.getVertex(1);
   //ll.x += l_index*10;
   //tl.x += l_index*10;
   
   //dline_l.setVertex(0, ll.x, ll.y);
   //dline_l.setVertex(1, tl.x, tl.y);
   //}   
   
   shape(dline_l, plane_width - dline_l.width + 1, height - l_index*80);
   if(l_index < 10){
     l_index++;
   }   
  }
  void growLineR(){
   shape(dline_r, plane_width + 2, height-r_index*100);
   if(r_index < 8){
     r_index++;
   } 
  }
  void showLinesD(){
  //colorMode(HSB, 100);
  //HSB = (324, 0, 100);
  //TODO: Get x_center, y_center of a shape!! Or store and keep track
  //TODO: Get x, y of corner vertex to draw line from
    
  float line_speed = 1;
  float line_y = height/2 - 130; 
  color line_g = color(line_gray);  
  //println("line gray:" + line_gray);

   //Set color to gray shade goint to white
   vline_1.setFill(line_g);
   vline_2.setFill(line_g);
   dline_l.setFill(line_g);
   dline_r.setFill(line_g);    
   
   shape(dline_l, plane_width - dline_l.width + 1, height/2);
   shape(dline_r, plane_width - 1, height/2.5);          
 }

  void baseLinesShow(){
  int line_speed = 15;
  int limit = 390;
  
  line_height -= line_speed;
  line_height = constrain(line_height, limit, height);
  //println("line height: " + line_height);
  
  noStroke();
  fill(255);
  rectMode(CORNERS);
  rect(plane_width, height - 40, plane_width+10, line_height, 6); //co-ord of one corner, opp corner, radius of corner
  rect(3*plane_width, height - 40, 3*plane_width+10, line_height, 6);    
  }  
}