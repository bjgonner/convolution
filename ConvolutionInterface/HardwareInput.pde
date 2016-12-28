class HardwareInput{
  float[] knobs;
  boolean knobFlag;
  int[] notes;
  float[] encoders;
  float mode;
  int enc1Mode = 0;
  int enc2Mode = 0;
  float[] lastEncode;
  float[] rawEncode = {0,0};
  float[][] smoothing;
  float[] smoothKnobs;
  float[] quadPad;
  int smoothSteps;
  
 HardwareInput(int numKnobs, int numNotes, int numEncoders, float initMode){
   smoothSteps = 10;
   quadPad = new float[4];
   knobs = new float[numKnobs];
   smoothKnobs = new float[numKnobs];
   smoothing = new float[smoothSteps][numKnobs];
   
   for(int i=0; i < numKnobs; i++) knobs[i] = 0;
   
   notes = new int[numNotes];
   for(int i=0; i < numNotes; i++) notes[i] = 0;
   
   encoders = new float[numEncoders];
   lastEncode = new float[numEncoders];
   for(int i=0; i < numEncoders; i++){
     encoders[i] = 0;
     lastEncode[i] = 0;
   }
   mode = initMode;
 }

 void updateKnobs(float[] k){
   knobs = k;
 }
 
 void updateNotes(int[] n){
   notes = n;
 }
 
 void updateEncoders(float[] e){
   encoders = e;
 }
 
 void updateMode(int encNum, int m){
   if(encNum==0)enc1Mode = m;
   else if(encNum==1)enc2Mode = m;
   else println("No encoder of that number!!");
   println("1: " + enc1Mode + "  2: " + enc2Mode);
 }
 
 int getMode(int encNum){
   if(encNum==0) return enc1Mode;
   else if(encNum==1)return enc2Mode;
   else return -1;
 }
 
 float[] getKnobs(){
   return knobs;
 }
 
 float[] smoothKnobs(){
   
   for (int i =0; i < smoothSteps-1; i++){
     smoothing[i] = smoothing[i+1];
   }
   smoothing[smoothSteps-1] = knobs;
   float[] sum = new float[knobs.length];
   for (int j = 0; j < sum.length; j++){
     for(int i = 0; i < smoothSteps; i++){
       sum[j] += smoothing[i][j];
     }
   sum[j] = sum[j]/smoothSteps;
   }
     return sum;
 }
 void recordValues(String[] v){
  
  if(v[0].equals("/encoder")){
    //encoder has 12 positions (0-11) based on Midi notes there should only be 11 octaves  may need to fix better in future
    //code to turn off notes if held down while octave changes
    for (int i = 1; i < v.length; i++){
      lastEncode[i-1] = encoders[i-1];
      encoders[i-1] = float(trim(v[i]));
    //  lastEncode[1] = encoders[1];
     // encoders[1] = float(trim(v[2]));
  }
   if(lastEncode[0] < encoders[0]){
     int subLength;
   //  println("positive encoder change! turn off keys:" + (12*lastEncode[0]) + " to " + (12*lastEncode[0]+11) );
     if(encoders[0] < 11) subLength = int(12*encoders[0]);
     else subLength = 128;
     for(int i = int(12*lastEncode[0]); i < subLength; i++){
       //if(notes[i] == 1){
       //  OscMessage offOn = new OscMessage("/noteOff");
       //  offOn.add(0x80);
       //  offOn.add(i);
       //  offOn.add(0x00);
       //  osc.send(offOn, address);
       //  print(" sent:");
       //  offOn.print();
       //  offOn.clearArguments();
       //  offOn.setAddrPattern("/noteOn");
       //  offOn.add(0x90);
       //  offOn.add(i+12);
       //  offOn.add(127);
       //  osc.send(offOn, address);
       //  offOn.print();
       //}
       notes[i] = 0;
     }
   }else if(lastEncode[0] > encoders[0]){
     int subLength;
     if(lastEncode[0] >= 10) subLength = 128;
     else subLength = int(12*lastEncode[0]+12);
   //  println("negative encoder change! turn off keys:" +int(12*lastEncode[0]) + " to " + int(12*lastEncode[0]+12)  );
     for(int i = int(12*lastEncode[0]); i < subLength; i++){
       notes[i] = 0;
     }
   }
  }else if(v[0].equals("/knobs")){
    for (int i = 1; i < v.length; i++) knobs[i-1] = float(trim(v[i]));
    knobFlag = true;
  }else if(v[0].equals("/mode")){
   if(int(trim(v[1])) == 0) enc1Mode = int(trim(v[2])); 
   if(int(trim(v[1])) == 1) enc2Mode = int(trim(v[2]));
   //println(v[0] + v[1] + v[2]);
   
  }else if(v[0].equals("/noteOn")){
    notes[int(trim(v[2]))] = 1;
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  //set note to off
  }else if(v[0].equals("/noteOff")){
    notes[int(trim(v[2]))] = 0;
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  }else if(v[0].equals("/rawEnc")){
    rawEncode[1] = rawEncode[0];
    rawEncode[0] = float(trim(v[1]));
        //println(v[0] + ": " + int(trim(v[1])));
  }else if(v[0].equals("/buttons")){
   // print(v[0] + " : ");
    for(int z = 1; z < v.length; z++){
      quadPad[z-1] = float(trim(v[z]));
     // print(quadPad[z-1] + " | " );
    }
   // println();
  }
}
  
}