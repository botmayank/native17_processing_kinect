Sunset sunset;
void setup()
{
  size(1920, 1080,P3D);
  background(0);
  smooth(); //TODO doesn't really work
  frameRate(4); //TODO can be faster
  sunset = new Sunset();
}
void draw()
{
  sunset.default_state();
  sunset.wiggle();
  sunset.display();
}