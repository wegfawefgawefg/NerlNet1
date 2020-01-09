public void drawNetwork(Network network)
{
  noStroke();
  float neuronWidth = 5;
  float neuronHeight = 2;
  float neuronSpacing = 10;
  
  float layerSpacing = 20;

  rectMode(CORNERS);
    
  float xStart = 50;
  float yStart = 50;
  
  float x = xStart;
  float y = yStart;
  //  draw inputs
  for(int i = 0; i < network.inputs.length; i++)
  {
    float input = network.inputs[i];
    if(input < 0.0)
    {
      fill(-input * 255.0, 0, 0);
    }
    else  //  input > 0.0
    {
      fill(0, input * 255, 0);
    }
    rect(x, y, x + neuronWidth, y + neuronHeight);
    y = y + neuronHeight + neuronSpacing;
  }
  
  //  draw layers 
  rectMode(CORNERS);
  
  float lx = x;
  lx = lx + neuronWidth + layerSpacing;
  float ly = yStart;
  for(int l = 0; l < network.layers.size(); l++ )
  {
    ly = yStart;
    
    float nx = lx;
    float ny = ly;
    float[][] layer = network.layers.get(l);
    float[] layerOutputs = network.outputs.get(l);
    for(int n = 0; n < layer.length; n++)
    { 
      nx = lx;
     
      float wx = nx;
      float wy = ny;
      
      //  //  draw output   
      float output = layerOutputs[n];
      if(output < 0.0)
      {
        fill(-output * 255.0, 0, 0);
      }
      else  //  weight > 0.0
      {
        fill(0, output * 255, 0);
      }
      wx = nx + neuronWidth + neuronWidth;
      rect(wx, wy, wx + neuronWidth, wy + neuronHeight);
      
      wx = nx;
      for(int w = 0; w < layer[n].length; w++)
      {
        float weight = layer[n][w];
        if(weight < 0.0)
        {
          fill(-weight * 255.0, 0, 0);
        }
        else  //  weight > 0.0
        {
          fill(0, weight * 255, 0);
        }
        rect(wx, wy, wx + neuronWidth, wy + neuronHeight);
        //wx = wx + neuronHeight;
        wy = wy + neuronHeight;
      }
      
      //  adjust height for next neuron
      ny = wy + neuronHeight + neuronSpacing;
    }
    lx = lx + neuronWidth + layerSpacing;
  }
}

public void renderNetworkToImage(Network network, PImage outputImage)
{
  float[] networkOutputs = network.outputs.get(network.outputs.size()-1);
  outputImage.loadPixels();
  float fractWidth = 1.0 / outputImage.width;
  float fractHeight = 1.0 / outputImage.height;
  
  float yFract = 0.0;
  float xFract = 0.0;
  
  for(int y = 0; y < outputImage.height; y++)
  {
    xFract = 0.0;
    for(int x = 0; x < outputImage.width; x++)
    {
      int id = x + y * outputImage.width;
      network.inputs[0] = xFract;
      network.inputs[1] = yFract;
      network.feedForward();
      float brightness = networkOutputs[0];
      outputImage.pixels[id] = color(brightness * 255);
      
      xFract += fractWidth;
    }
    yFract += fractHeight;
  }
  outputImage.updatePixels();
}
