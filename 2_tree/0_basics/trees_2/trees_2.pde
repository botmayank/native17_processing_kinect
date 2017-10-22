//Green planes and brightness increasing, transition to bright green and vertical lines growing

//Planes

PShape[] pl = new PShape[4];
color[] pl_col = {#C4D92E, #9FBC2E, #82A53C, #009649};
color[] pl_col_g = new color[4]; //fade gray in/out
color[] pl_col_bg = new color[4]; //fade gray to green
//float plane_width;

float g_d = 0.4;
float[] g_delta ={g_d, g_d, g_d, g_d};

//Lines
PShape vline_1, vline_2, dline_l, dline_r, leaf_l, leaf_r;
int line_gray = 0;
int line_height = 0;

//Leaves




//Kinect variables

boolean appear = false; //when body appears, on mouse click/kinect


void setup(){
  size(1920, 1080,P2D);
  background(0);
  smooth();
  println("Trees 01 Sequence");
  //Load background planes
  for(int i = 0; i< pl.length; i++){
    String file = "TSQ-01-plane0" + (i+1) + ".svg";
    pl[i] = loadShape(file);    
    //pl[i].scale(0.9);
    //pl[i].translate();
  }  
  //plane_width = pl[0].width;
  
  vline_1 = loadShape("TSQ-01-vline01.svg");
  vline_2 = loadShape("TSQ-01-vline01.svg");
  dline_l = loadShape("TSQ-01-dline01.svg");
  dline_r = loadShape("TSQ-01-dline02.svg");
  leaf_l = loadShape("TSQ-01-leaf01.svg");
  leaf_r = loadShape("TSQ-01-leaf02.svg");
    
  intro();
}

void draw(){
    
    
    //Default
    //Planes dark to light moving
    if(!appear){      
    grayFade();
    }
    
    //Appear
    //Planes turn to bright green
    if(appear){      
      colorBright(0.008); //lerp transition value
      baseLinesShow();
        //showLines();
    }
    
    //Interaction
    //Lines grow
    
    //Post Interaction (Disappear)
    //Transition to BI
    //Back to gray planes oscillating
}


//for(int i = 0; i < pl[1].getVertexCount(); i++){
//  PVector vertex = pl[1].getVertex(i);
//  println(vertex.x, vertex.y);
//}

//Static Gray planes init
void intro(){
  println("Intro, gray planes");
 for(int i = 0; i< pl.length; i++){
   //Orig color
   colorMode(HSB, 255);
   color c = pl_col[i];
   //println("Orig col of " + i + "is :");
   //println(hue(c), saturation(c), brightness(c));
   
   color g = color(hue(c), 0, brightness(c)-100);
   //println("Gray col of " + i + "is :");
   //println(hue(g), saturation(g), brightness(g));   
    pl[i].setFill(g);
    pl_col_g[i] = g;
    shape(pl[i], i*pl[0].width+3, 0);
  }  
}


//Gray planes fading in/out
void grayFade(){
  colorMode(HSB,100);
  println(g_delta);
  int upper = 70;
  int lower = 10;
  
  for(int i = 0; i<pl.length; i++)
  {
    color g = pl_col_g[i];
    if(i == 1){
      //println("g value of 1:" + brightness(g));
      //println("Brightness of " + i + "is: " + brightness(g));
    }
    
    if((brightness(g) > upper)||(brightness(g) < lower)){
      g_delta[i] *= -1;
    }    
    
    g = color(hue(g), saturation(g), brightness(g) + g_delta[i]);
    pl_col_g[i] = g;
    pl[i].setFill(g);
    shape(pl[i], i*pl[0].width+3, 0);    
  }  
}

//Change color to bright green scenes for planes
void colorBright(float greening_speed){
  //println("Draw, color bright by: " + delta);
  for(int i = 0; i< pl.length; i++){ 
  colorMode(HSB, 255);
  color c = pl_col[i];
  color g = pl_col_bg[i];  
  
  //if(brightness(g)<brightness(c)){
  //  g = color(hue(c), saturation(c), brightness(g)+delta);
  //}  
  //if(saturation(g)<saturation(c)){
  //  g = color(hue(g), saturation(g)+delta, brightness(g));
  //}
    g = lerpColor(g, c, greening_speed); //interpolate between gray and green
    pl_col_bg[i] = g;
    pl[i].setFill(g);
    shape(pl[i], i*pl[0].width, 0);
  
  //println("gray: "+i+ " " + brightness(g));
  //println("orig: " + i + " " + brightness(c));
  }
}


void showLines(){
  //colorMode(HSB, 100);
  //HSB = (324, 0, 100);
  //TODO: Get x_center, y_center of a shape!! Or store and keep track
  //TODO: Get x, y of corner vertex to draw line from
    
  float line_speed = 1;
  float line_y = height/2 - 130; 
  color line_g = color(line_gray);  
  //println("line gray:" + line_gray);
  if(line_gray < 255){
    
  }
    
       //Set color to gray shade goint to white
       vline_1.setFill(line_g);
       vline_2.setFill(line_g);
       dline_l.setFill(line_g);
       dline_r.setFill(line_g);
       leaf_l.setFill(line_g);
       leaf_r.setFill(line_g);
       
       shape(vline_1, pl[0].width, line_y);
       shape(vline_2, 3*pl[0].width, line_y);
       
       shape(dline_l, pl[0].width - dline_l.width + 1, height/2);
       shape(dline_r, pl[0].width - 1, height/2.5);
       
       shape(leaf_r, 3*pl[0].width - 1, height/2.5);
       shape(leaf_l, 3*pl[0].width - leaf_l.width , height/2.5);       
}


void baseLinesShow(){
  int line_speed = 15;  
  if(line_height > -100){   
  line_height += line_speed;
  println("line height: " + line_height);
  }  
  
  fill(255);
  rect(pl[0].width, height, 10, -line_height);
  rect(3*pl[0].width, height, 10, -line_height);    
    
}


void mouseClicked(){
 appear = true; 
 
  
}