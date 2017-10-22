class Sunset 
{
  SunsetLayer[] layers;
  int nLayers;
  
  float maxDesaturated = 30; // color range 0-100
  float curDesaturated;
  boolean isIncDesaturation;
  float saturationIncrement = 0.5;
  Sunset()
  {
    isIncDesaturation = true;
    curDesaturated = 0;
    nLayers = 3;
    layers = new SunsetLayer[nLayers];
    colorMode(HSB,  360, 100, 100);
    layers[0] = new SunsetLayer(loadShape("WSQ-01-sky00.svg").getChild(0), 3, color(15, 79.9, 83.9));
    layers[1] = new SunsetLayer(loadShape("WSQ-01-sky01.svg").getChild(0), 2, color(24, 79.3, 92.9));
    layers[2] = new SunsetLayer(loadShape("WSQ-01-sky02.svg").getChild(0), 0, color(42, 76.2, 95.7));
    
    //layers[3] = new SunsetLayer(loadShape("WSQ-01-wave03.svg").getChild(0), 3, color(192, 14.4, 95.3));
    //layers[4] = new SunsetLayer(loadShape("WSQ-01-wave04.svg").getChild(0), 2, color(191, 59.6, 88.2));
    //layers[5] = new SunsetLayer(loadShape("WSQ-01-wave05.svg").getChild(0), 2, color(188, 100, 83.9));
  }

  void wiggle()
  {
    float three_per_w = map(1, 0, 100, 0, width); //3% of screen width
    PVector v = layers[2].layer.getVertex(layers[2].changingVertex);
    println(v);
    //v.y = constrain(random(-three_per_w, three_per_w), 0, height);
    //sky01.setVertex(3, v);
    
  } 
  
  //Fade in light colors, light blue gray, light orange (destaurated)
  void default_state()
  {
    for (int i = 0; i < layers.length; i++) {
      colorMode(HSB,  360, 100, 100);
      float h = hue(layers[i].initialColor);
      float s = map(curDesaturated, 0, 100, 0, saturation(layers[i].initialColor));
      float b = brightness(layers[i].initialColor);
      layers[i].layer.setFill(color(h, s, b));
    }
    //update curDesaturated
    if(isIncDesaturation && curDesaturated < maxDesaturated)
    {
      curDesaturated += saturationIncrement;
    }
    else if( isIncDesaturation && curDesaturated == maxDesaturated)
    {
      curDesaturated -= saturationIncrement;
      isIncDesaturation = false;
    }
    else if (!isIncDesaturation && curDesaturated > 0)
    {
      curDesaturated -= saturationIncrement;
    }
    else if(!isIncDesaturation && curDesaturated == 0)
    {
      curDesaturated += saturationIncrement;
      isIncDesaturation = true;
    }
  }
  void display()
  {
    for (int i = 0; i < layers.length; i++) 
    {
      shape(layers[i].layer);
    }
    //for (int i = layers.length/2; i < layers.length; i++) 
    //{
    //   pushMatrix();
    //   translate(0, height/2);
    //   shape(layers[i].layer);
    //   popMatrix();
    //}
  }
}