class SunsetLayer
{
  PShape layer;
  int changingVertex; //index of shape of vertex to be wiggled
  color initialColor;
  float maxOffset; //in pixels
  boolean isIncreasing;
  float currentValue; // of the vextex's y offset to be incremented
  float changingVertexOrigY;
  
  SunsetLayer(PShape layer, int changingVertex, color initialColor, float maxOffset, boolean isIncreasing)
  {
    this.layer = layer;
    this.changingVertex = changingVertex;
    this.initialColor = initialColor;
    this.maxOffset = maxOffset;
    this.isIncreasing = isIncreasing;
    this.currentValue = 0;
    changingVertexOrigY = (layer.getVertex(changingVertex)).y; //maybe needed later to reset vertex position
    layer.setFill(initialColor);
    layer.setStroke(initialColor);
  }
  
  void changeNextIncDec(float rate)
  {

    PVector v = this.layer.getVertex(changingVertex);
    v.y += currentValue;
    layer.setVertex(changingVertex, new PVector(v.x, v.y));
    if(isIncreasing && currentValue < maxOffset)
    {
      currentValue += rate;
    }
    else if( isIncreasing && currentValue >= maxOffset)
    {
      currentValue -= rate;
      isIncreasing = false;
    }
    else if (!isIncreasing && currentValue > -maxOffset)
    {
      currentValue -= rate;
    }
    else if(!isIncreasing && currentValue <= -maxOffset)
    {
      currentValue += rate;
      isIncreasing = true;
    }
  }    
}