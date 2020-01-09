import java.util.Random;
Random randy = new Random();

public class Network
{
  float[] inputs;
  ArrayList<float[][]> layers;
  ArrayList<float[]> outputs;
  
  public Network(int numInputs)
  {
    this.inputs = new float[numInputs];
    this.layers = new ArrayList<float[][]>();
    this.outputs = new ArrayList<float[]>();
  }
  
  public void addLayer(int size)
  {
    //  add first layer code
    if( this.layers.size() == 0 )
    {
      float[][] newLayer = new float[size][this.inputs.length+1];  //  +1 is for the bias weight
      float[] newOutputs = new float[size];
      this.layers.add(newLayer);
      this.outputs.add(newOutputs);
    }
    else  //  add other layers code
    {
      //  this layer needs as many weights as the size of the previous layer
      int previousLayerSize = this.layers.get(this.layers.size()-1).length;
      float[][] newLayer = new float[size][previousLayerSize+1];  //  +1 is for the bias weight
      float[] newOutputs = new float[size];
      this.layers.add(newLayer);
      this.outputs.add(newOutputs);
    }
  }
  
  public Network clone()
  {
    Network newNetwork = new Network(this.inputs.length);
    for(int layer = 0; layer < this.layers.size(); layer++)
    {
      int layerSize = this.layers.get(layer).length;
      newNetwork.addLayer(layerSize);
    }
    return newNetwork;
  }
  
  public void copyWeights(Network target)
  { /*
      -  assumes networks have identical architectures
      -  doesnt reserve new memory, so is more efficient for copying
         |-  please dont make a new network every frame lol
             |-  preallocate, then use this function instead
    */
    //  copy layers
    //  //  no need to copy inputs or outputs
    //  //  //  they get wiped on each use anyways 
    for(int layer = 0; layer < this.layers.size(); layer++)
    {
      float[][] oldLayer = this.layers.get(layer);
      float[][] newLayer = target.layers.get(layer);
      for(int n = 0; n < oldLayer.length; n++)
      {
        for(int w = 0; w < oldLayer[n].length; w++)
        {
          newLayer[n][w] = oldLayer[n][w];
        }
      }
    }
  }
  
  public void printArchitecture()
  {  
    System.out.println("Network Architecture:");
    System.out.print("|-numInputs: ");
    System.out.println(this.inputs.length);
    System.out.print("|-numLayers: ");
    System.out.println(this.layers.size());
    System.out.print("|-numOutputs: ");
    System.out.println(this.outputs.get(this.outputs.size()-1).length);
    
    System.out.println("Layer Dimensions:");
    for(int l = 0; l < this.layers.size(); l++)
    {
      float[][] layer = this.layers.get(l);
      String output = String.format("|-layer %d: (#n's %d, #w's %d)",l, layer.length, layer[0].length);
      System.out.println(output);
    }
  }
  
  public void randomizeWeights()
  {
    for(int l = 0; l < this.layers.size(); l++)
    {
      float[][] layer = this.layers.get(l);
      for(int n = 0; n < layer.length; n++)
      {
        for(int w = 0; w < layer[n].length; w++)
        {
          float randomWeight = (randy.nextFloat() - 0.5 )* 2.0;
          layer[n][w] = randomWeight;
        }
      }
    }
  }
  
  public void wiggleWeights()
  { /*
      -  wiggles weights around. useless but looks cool
    */
    for(int l = 0; l < this.layers.size(); l++)
    {
      float[][] layer = this.layers.get(l);
      for(int n = 0; n < layer.length; n++)
      {
        for(int w = 0; w < layer[n].length; w++)
        {
          float oldWeight = layer[n][w];
          float randomDeviation = (randy.nextFloat() - 0.5 )* 2.0 * weightDeviation;
          layer[n][w] = oldWeight + randomDeviation;
        }
      }
    }
  }
  
  public void feedForward()
  { /*  
    -  this is pretty ugly
       |-  somehow all layers should use same code
    */
    //  compute first layer
    float[][] firstLayer = this.layers.get(0);
    float[] firstLayerOutputs = this.outputs.get(0);
    for(int n = 0; n < firstLayer.length; n++)
    {
      //System.out.println(n);
      float sum = 0;
      for(int input = 0; input < inputs.length; input++)
      {
        //System.out.println("\n neuron");
        //System.out.println("input" + str( inputs[input]));
        //System.out.println("weight" + str( firstLayer[n][input]));
        
        float neuronPartial = inputs[input] * firstLayer[n][input];
        //System.out.println("output" + str( neuronPartial));
        

        sum += neuronPartial;
      }
      //  add the bias
      int biasWeightIndex = firstLayer[n].length - 1;
      float neuronPartial = firstLayer[n][biasWeightIndex];
      sum += neuronPartial;
      
      //  activation function goes here
      //  |-  we are a RELU apparently
      firstLayerOutputs[n] = max(0, sum);
    }
    
    //compute other layers
    if( this.layers.size() > 1 )
    {
      for(int l = 1; l < this.layers.size(); l++)
      {
        float[][] layer = this.layers.get(l);
        float[] layerOutputs = outputs.get(l);
        float[] previousuLayerOutputs = outputs.get(l-1);
        for(int n = 0; n < layer.length; n++)
        {
          float sum = 0;
          for(int plo = 0; plo < previousuLayerOutputs.length; plo++)
          {
            float neuronPartial = previousuLayerOutputs[plo] * layer[n][plo];
            //  activation function goes here lol
            sum += neuronPartial;
          }
          //  add the bias
          int biasWeightIndex = layer[n].length - 1;
          float neuronPartial = layer[n][biasWeightIndex];
          sum += neuronPartial;
          
          //  activation function goes here
          //  |-  we are a RELU apparently
          layerOutputs[n] = max(0, sum);
        }
      }
    }
  }
}
