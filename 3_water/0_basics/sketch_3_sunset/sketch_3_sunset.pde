
int state;
Sunset sunset;

void setup()
{
  size(1920, 1080,P3D);
  background(0);
  smooth(); //TODO doesn't really work
  frameRate(10); //TODO can be faster
  sunset = new Sunset();
  state = 0;  //default state "D"
}
void draw()
{
  switch(state)
  {
    case 0: //default state "D"
          sunset.saturate_desaturate(60, 1);//float maxSaturation, float satIncrementRate
          sunset.wiggleSkyRate = 0.2;
          sunset.wiggleSeaRate = 0.2;
          sunset.wiggleSky();//float rate
          sunset.wiggleSea();//float rate
          sunset.display();
          break;
    case 1: //appear state "A"
          sunset.appear(1); // float satIncrementRate
          sunset.display();
          break;
    case 2: //interaction state "I"
          sunset.appear(1);
          sunset.wiggleSky();//float rate
          sunset.wiggleSea();//float rate
          sunset.display();
          break;   
  }
}
void mouseClicked(){ //appear state "A"
 state = 2;  
}

void keyPressed() {
  float maxOffsetLimit = 30;
  float maxOffsetRate = 1;
  if(key == 'w' || key == 'W') //sky up
  {
    sunset.wiggleSkyRate = constrain(sunset.wiggleSkyRate + 0.1, 0, sunset.maxWiggleRate);
    sunset.changeMaxOffset(constrain(sunset.layers[1].maxOffset + maxOffsetRate, sunset.minOffset, maxOffsetLimit));
    
  }
  else if(key == 's' || key == 'S') //sky down
  {
    sunset.wiggleSkyRate = constrain(sunset.wiggleSkyRate - 0.1, 0, sunset.maxWiggleRate);
    sunset.changeMaxOffset(constrain(sunset.layers[1].maxOffset - maxOffsetRate, sunset.minOffset, maxOffsetLimit));
  }
  else if(key == 'i' || key == 'I') //sea up
    sunset.wiggleSkyRate = constrain(sunset.wiggleSeaRate + 0.1, 0, sunset.maxWiggleRate);
  else if(key == 'j' || key == 'J') //sea down
    sunset.wiggleSkyRate = constrain(sunset.wiggleSeaRate - 0.1, 0, sunset.maxWiggleRate);
  else if(key == 'q' || key == 'Q') //trigger interaction state "I"
    state = 2;
}