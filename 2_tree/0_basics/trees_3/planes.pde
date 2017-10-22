class Planes{
    
  PShape[] pl = new PShape[4];
  color[] pl_col = {#C4D92E, #9FBC2E, #82A53C, #009649};
  color[] pl_col_g = new color[4]; //fade gray in/out
  color[] pl_col_bg = new color[4]; //fade gray to green
  //float plane_width;
  
  float g_d = 0.4;
  float[] g_delta ={g_d, g_d, g_d, g_d};
  
  Planes(){
    for(int i = 0; i< pl.length; i++){
    String file = "TSQ-01-plane0" + (i+1) + ".svg";
    pl[i] = loadShape(file);    
    //pl[i].scale(0.9);
    //pl[i].translate();   
    }      
  }
  
  void init(){
   println("Init, gray planes");
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
    //println(g_delta);
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
  boolean colorBright(float greening_speed){
    boolean done = false;
    //println("Draw, color bright by: " + delta);
    for(int i = 0; i< pl.length; i++){ 
    colorMode(HSB, 255);
    color c = pl_col[i];
    color g = pl_col_bg[i];  
     if (g == c){
       done = true; 
      }
      else {
        done = false;
      }  
    
    //if(brightness(g)<brightness(c)){
    //  g = color(hue(c), saturation(c), brightness(g)+delta);
    //}  
    //if(saturation(g)<saturation(c)){
    //  g = color(hue(g), saturation(g)+delta, brightness(g));
    //}
      g = lerpColor(g, c, greening_speed); //interpolate between gray and green
      pl_col_bg[i] = g;
      pl[i].setFill(g);
      shape(pl[i], i*pl[0].width+3, 0);
    //println("gray: "+i+ " " + brightness(g));
    //println("orig: " + i + " " + brightness(c));
    }
   return done;
  }
}