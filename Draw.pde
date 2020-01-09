public void drawTargetImage()
{
    //  draw output image
  float halfWidth = width / 2.0;
  float imgWidth = 500;
  float imgHeight = 500;
  
  fill(0, 0, 0);
  rect(halfWidth, 0, halfWidth + imgWidth, 0 + imgHeight);
  
  imageMode(CORNERS);
  image(targetImage, halfWidth, 0, halfWidth + imgWidth, 0 + imgHeight);
}

public void drawTrialImage()
{
    //  draw output image
  float halfHeight = height / 2.0;
  float imgWidth = 500;
  float imgHeight = 500;
  
  fill(0, 0, 0);
  rect(0, halfHeight, 0 + imgWidth, halfHeight + imgHeight);
  
  imageMode(CORNERS);
  image(trialOutputImage, 0, halfHeight, 0 + imgWidth, halfHeight + imgHeight);
}

public void drawOutputImage(){  
  //  draw output image
  float halfWidth = width / 2.0;
  float halfHeight = height / 2.0;
  float imgWidth = 500;
  float imgHeight = 500;
  
  fill(0, 0, 0);
  rect(halfWidth, halfHeight, halfWidth + imgWidth, halfHeight + imgHeight);
  
  
  imageMode(CORNERS);
  image(outputImage, halfWidth, halfHeight, halfWidth + imgWidth, halfHeight + imgHeight);
}
