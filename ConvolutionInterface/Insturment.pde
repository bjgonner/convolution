class Instrument{
 String theName;
 int id;
 float atk;
 float decay;
 float sustain;
 float release;
 float effect1, effect2;
 boolean visible = false;
 int[] steps;
 float[] sliderValues = {0.1,0.5,0.3,0.2,0.0,0.0};
 //EnvShaper env;
 
 
 Instrument(String _theName, int _id){
   atk = 0.1;
   decay = 0.5;
   sustain = 0.3;
   release =0.2;
   theName = _theName;
   id = _id;
   
   
   
       
 }
  
  void setVisible(boolean v){
    //do something
    
  }
  
  void record(){
  }
  
  void setAtk(float v){
   //atk = v;
   sliderValues[0] = v;
   println(theName + ": attack: " + sliderValues[0]);
  }
  
  void setDcy(float v){
   decay = log(v)*10;
   sliderValues[1] = v; //log(v)*10;
   println(theName + ": decay: " + sliderValues[1]);
  }
  
  void setSus(float v){
    sustain = v;
    sliderValues[2] = v;
    println(theName + ": sustain: " + sliderValues[2]);  
  }
  
   void setRel(float v){
    release = v;
    sliderValues[3] = v;
    println(theName + ": release: " + sliderValues[3]);  
  }
  
  void setEffect1(float v){
    effect1 = v;
    sliderValues[4] = v;
    println(theName + ": effect1: " + sliderValues[4]);  
  }
  
  void setEffect2(float v){
    effect2 = v;
    sliderValues[5] = v;
    println(theName + ": effect2: " + sliderValues[5]);  
  }
  
   
}