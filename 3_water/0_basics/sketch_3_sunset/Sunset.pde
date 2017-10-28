class Sunset 
{
  SunsetLayer[] layers;
  int nLayers;
  float wiggleSkyRate;
  float wiggleSeaRate;
  float curDesaturated;
  boolean isIncDesaturation;
  float maxWiggleRate = 5; //just to keep a check on how fast can u wiggle
  float maxOffset = 3;
  float minOffset = 1;
  boolean randomBool() {
  return random(1) > .5;
  }
  Sunset()
  {
    isIncDesaturation = true;
    curDesaturated = 0;
    nLayers = 6;
    layers = new SunsetLayer[nLayers];
    colorMode(HSB,  360, 100, 100);

    layers[0] = new SunsetLayer(initShape("WSQ-01-sky00.svg"), 2, color(15, 79.9, 83.9), random(minOffset, maxOffset), randomBool());
    layers[1] = new SunsetLayer(initShape("WSQ-01-sky01.svg"), 1, color(24, 79.3, 92.9), random(minOffset, maxOffset), randomBool());
    layers[2] = new SunsetLayer(initShape("WSQ-01-sky02.svg"), 0, color(42, 76.2, 95.7), random(minOffset, maxOffset), randomBool());
    
    layers[3] = new SunsetLayer(initShape("WSQ-01-wave03a.svg"), 2, color(192, 14.4, 95.3), random(minOffset, maxOffset), randomBool());
    layers[4] = new SunsetLayer(initShape("WSQ-01-wave04a.svg"), 2, color(191, 59.6, 88.2), random(minOffset, maxOffset), randomBool());
    layers[5] = new SunsetLayer(initShape("WSQ-01-wave05a.svg"), 0, color(188, 100, 83.9), random(minOffset, maxOffset), randomBool());
    
  }
    void changeMaxOffset(float offset)
  {
    for( int i = 0; i < 6; i++)
    {
      layers[i].maxOffset = offset;
    }
  }
  
  PShape initShape(String file) //workaround as setVertex() doesn't work with object returned by loadShape
  {
    PShape s = createShape();
    s.beginShape();
    PShape tempS = loadShape(file).getChild(0);
    for(int i = 0; i < tempS.getVertexCount(); i++)
    {  
      PVector v = tempS.getVertex(i);
      s.vertex(v.x, v.y);
    }
    s.endShape(CLOSE);
    return s;
  }

  void wiggleSky()
  {
     for (int i = 0; i < layers.length/2; i++) {
        layers[i].changeNextIncDec(wiggleSkyRate);
     }
  } 
  void wiggleSea()
  {
     for (int i = layers.length/2; i < layers.length; i++) {
        layers[i].changeNextIncDec(wiggleSeaRate);
     }
  }
  
  //Fade in light colors, light blue gray, light orange (destaurated)
  void saturate_desaturate(float maxSaturation, float satIncrementRate) //range 0-100
  {
    background(200);
    for (int i = 0; i < layers.length; i++) {
      colorMode(HSB,  360, 100, 100);
      float h = hue(layers[i].initialColor);
      float s = map(curDesaturated, 0, 100, 0, saturation(layers[i].initialColor));
      float b = brightness(layers[i].initialColor);
      color currColor = color(h, s, b);
      layers[i].layer.setFill(currColor);
      layers[i].layer.setFill(currColor);
      layers[i].layer.setStroke(currColor);
    }
    //update curDesaturated    
    if(isIncDesaturation && curDesaturated < maxSaturation)
    {
      curDesaturated += satIncrementRate;
    }
    else if( isIncDesaturation && curDesaturated == maxSaturation)
    {
      curDesaturated -= satIncrementRate;
      isIncDesaturation = false;
    }
    else if (!isIncDesaturation && curDesaturated > 0)
    {
      curDesaturated -= satIncrementRate;
    }
    else if(!isIncDesaturation && curDesaturated == 0)
    {
      curDesaturated += satIncrementRate;
      isIncDesaturation = true;
    }
  }
  
  void appear(float satIncrementRate)
  {
    background(0);
    for (int i = 0; i < layers.length; i++) {
      colorMode(HSB,  360, 100, 100);
      float h = hue(layers[i].initialColor);
      float s = map(curDesaturated, 0, 100, 0, saturation(layers[i].initialColor));
      float b = brightness(layers[i].initialColor);
      color currColor = color(h, s, b);
      layers[i].layer.setFill(currColor);
      layers[i].layer.setFill(currColor);
      layers[i].layer.setStroke(currColor);
    }
    //update curDesaturated    
    if(curDesaturated < 100)
    {
      curDesaturated += satIncrementRate;
    }
  }

  void display()
  {
    for (int i = 0; i < layers.length/2; i++) 
    {
        shape(layers[i].layer);
    }
    for (int i = layers.length/2; i < layers.length; i++) 
    {
      pushMatrix();
      translate(0, height/2);
      shape(layers[i].layer);
      popMatrix();
    }
  }
}