public float imageSubtraction(PImage imageOne, PImage imageTwo)
{
  float totalError = 0;
  imageOne.loadPixels();
  imageTwo.loadPixels();
  int pixelsLength = imageOne.width * imageOne.height;
  for(int i = 0; i < pixelsLength; i++)
  {
    totalError += abs(brightness(imageOne.pixels[i]) - brightness(imageTwo.pixels[i]));
  }
  return totalError;
}
