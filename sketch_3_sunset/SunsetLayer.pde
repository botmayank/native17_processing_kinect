class SunsetLayer
{
  PShape layer;
  int changingVertex;
  color initialColor;
  SunsetLayer(PShape layer, int changingVertex, color initialColor)
  {
    this.layer = layer;
    this.changingVertex = changingVertex;
    this.initialColor = initialColor;
  }

}