import java.lang.Math; 
import java.util.ArrayList;

/*  TODO
done -  add biases
-  add learning
-  add information sampling into inputs
-  add error computation

-~~
~~~
-  image error compute function
-  single pixel error compute function
done -  deep copy the network function
-  itterate the network function

done -  change feedforward to work with any network
*/

float weightDeviation = 0.001;

PImage outputImage;
PImage trialOutputImage;
PGraphics targetImage;

Network networkOne;
Network networkTwo;

float lastError = Float.POSITIVE_INFINITY;

void setup()
{
  size(1000, 1000, P2D);
  frameRate(1000);
  
  networkOne = new Network(2);
  networkOne.addLayer(30);
  networkOne.addLayer(30);


  networkOne.addLayer(1);
  
  networkOne.randomizeWeights();
  
  
  networkOne.printArchitecture();
  networkTwo = networkOne.clone();
  networkTwo.printArchitecture();
  networkOne.copyWeights(networkTwo);
  
  int imageWidth = 100;
  int imageHeight = 100;
  outputImage = createImage(imageWidth, imageHeight, ALPHA);
  trialOutputImage = createImage(imageWidth, imageHeight, ALPHA);
  targetImage = createGraphics(imageWidth, imageHeight);
  
  //  fill target image with some data
  targetImage.beginDraw();
  targetImage.background(255);
  targetImage.fill(0);
  targetImage.circle(targetImage.width/2, targetImage.height / 2, targetImage.width/2);
  targetImage.endDraw();
}

void draw()
{
  background(255);
  
  //  draw onto image on the right
  if (mousePressed && (mouseButton == LEFT)) {
    fill(0);
  } else if (mousePressed && (mouseButton == RIGHT)) {
    fill(255);
  }

  float deviationGrowth = 0.00001;
  if(keyPressed)
  {
    if(key =='q')
    {
      weightDeviation += deviationGrowth;
    }
    if(key =='a')
    {
      weightDeviation -= deviationGrowth;
    }
    if(key =='w')
    {
      weightDeviation += deviationGrowth * 10;
    }
    if(key =='s')
    {
      weightDeviation -= deviationGrowth * 10;
    }
    if(key =='e')
    {
      weightDeviation += deviationGrowth * 100;
    }
    if(key =='d')
    {
      weightDeviation -= deviationGrowth * 100;
    }
    if(key =='r')  
    {
      weightDeviation += deviationGrowth * 1000;
    }
    if(key =='f')
    {
      weightDeviation -= deviationGrowth * 1000;
    }
    if(weightDeviation < 0.0)
    {
      weightDeviation = 0.00000001;
    }
  }

  networkOne.feedForward();
  renderNetworkToImage(networkOne, outputImage);
  
  drawTargetImage();
  drawOutputImage();
  drawTrialImage();

  //drawNetwork(networkOne);
  
  //  try to mutate the network
  networkOne.copyWeights(networkTwo);
  networkTwo.wiggleWeights();
  renderNetworkToImage(networkTwo, trialOutputImage);
  float error = imageSubtraction(targetImage, trialOutputImage);
    
  text("adaptationRate", 50, 50);
  text(weightDeviation, 50, 70);
  text("error", 50, 90);
  text(error, 50, 110);
  text("lowestError", 50, 130);
  text(lastError, 50, 150);
  if( error < lastError )
  {
    networkTwo.copyWeights(networkOne);
    lastError = error;
  }

  
}

void mouseClicked()
{
  
}

void keyPressed() {
  if(key =='c')
  {
    networkOne.randomizeWeights();
    networkOne.copyWeights(networkTwo);
    lastError = Float.POSITIVE_INFINITY;
  }
}

  //  set inputs to be mouse value
  //float scaledMouseX = map(mouseX, 0, width, -1.0, 1.0);
  //float scaledMouseY = map(mouseY, 0, height, -1.0, 1.0);
  //inputs[0] = scaledMouseX;
  //inputs[1] = scaledMouseY;
  //System.out.println(scaledMouseX);
