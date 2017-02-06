class Matricks {
 
  String matrixName;
  boolean instVals[][];
  int interval;
  int numInsts;
  int numSteps;
  String[] instNames;
  Timer time;
  int mHeight;
  int mWidth;
  
  
 Matricks(String _matrixName, int _nx, int _ny, int _mWidth, int _mHeight, String[] _instNames, int _interval){
   //make numSteps variable from 16 -128 while only displaying 32 steps
   mHeight = _mHeight;
   numInsts = _ny;
   numSteps = _nx;
   interval = _interval;
   matrixName = _matrixName;
    cp5.addMatrix(_matrixName, _nx, _ny,0,height-_mHeight,_mWidth, _mHeight)//704,176)
     //.setPosition(100, height-200)
    // .setSize(750, 200)
     //.setGrid(nx, ny)
     .setGap(gap, gap)
     //.setInterval(interval)
     .setMode(ControlP5.MULTIPLES)
     .setColorBackground(color(120))
     .setBackground(color(40))
     //.setVisible(mFlag);
     .stop()
     ;
     
     instVals = new boolean[numInsts][numSteps];
     for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
        instVals[i][j] = false;
      }
     }
     instNames = _instNames;
     
     time = new Timer(interval*(numSteps+1)-1);
 }
  void update(){
    
    for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
       instVals[i][j] =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
    }
    //println("current: " + time.current + "   " + (millis()-time.current) + "   delay: " + time.delayTime);
    if(time.isFinished()){
     // println("truth");
     // sendMatrixOsc();
    }
    
  }
 void drawExtras(){
    rectMode(CENTER);
    fill(255,0,255);
    float spacing  = width/numSteps*(cnt+1);
    rect(spacing-(width/numSteps)/2,height-mHeight-(gap), width/numSteps-gap*2, 20); 
    rectMode(CORNER); 
    
    cp5.getController("current").setPosition(0,(height-mHeight-25)+(25*listIndex)+10);
   
   
 }
 void sendMatrixOsc(){
   OscBundle mBundle = new OscBundle();
   for(int i = 0; i < numInsts;  i++){
      OscMessage mMessage = new OscMessage("/" + instNames[i]);
      int[] instSteps = new int[numSteps];
      for( int j = 0; j < numSteps; j++){
       instSteps[j] = int(instVals[i][j]); // =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
      //println(instNames[i] + " : " + instSteps[0]);
      mMessage.add(instSteps);
      mBundle.add(mMessage);
      
    }
    mBundle.setTimetag(mBundle.now() + 10000);
    osc.send(mBundle, address);
    
    //println(mBundle);
    
 
  }

  //void setInstSteps(HardwareInput a, int index){
  //  int encPos = (int)a.encoders[0];
  //  int start  = encPos*12;
  //  int end;
  //  if (encPos > 9) end = 128;
  //  else end = start + 16;
  // // println("start: " + start + " | End: " + end + " | " + a.encoders[0]);
  //  for(int i = start; i <end; i++){
  //    int dex; 
  //    if (start == 0) dex = 0;
  //    else dex = i%start +16*(encPos%2) ;
  //    cp5.get(Matrix.class, matrixName).set(dex, index, boolean(a.notes[i]));
  //  //  print(dex + " : " + boolean(a.notes[i]) +" | ");
  //  }
  // // println();
  //} 
  
  void setInstSteps(HardwareInput a, int index){
    int encPos = (int)a.encoders[0];
    int start  = encPos*12;
    int end;
    if (encPos > 9) end = 128;
    else end = start + 16;
   // println("start: " + start + " | End: " + end + " | " + a.encoders[0]);
    for(int i = 0; i < a.pads.length; i++){
      int dex = i + 16*(encPos%2);
      
      if(a.pads[i] == true){
        boolean state  = cp5.get(Matrix.class, matrixName).get(dex, index);
        state = !state;
        cp5.get(Matrix.class, matrixName).set(dex, index, state);
        a.pads[i] = false;
      }
    //  print(dex + " : " + boolean(a.notes[i]) +" | ");
    }
   // println();
  } 
}