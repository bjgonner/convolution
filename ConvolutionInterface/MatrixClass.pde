class Matricks {
 
  String matrixName;
  boolean instVals[][];
  int interval;
  int numInsts;
  int numSteps;
  String[] instNames;
  Timer time;
  
 Matricks(String _matrixName, int _nx, int _ny, int _mWidth, int _mHeight, String[] _instNames, int _interval){
   //make numSteps variable from 16 -128 while only displaying 32 steps
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
 
 void sendMatrixOsc(){
   OscBundle mBundle = new OscBundle();
   for(int i = 0; i < numInsts;  i++){
      OscMessage mMessage = new OscMessage("/" + instNames[i]);
      int[] instSteps = new int[numSteps];
      for( int j = 0; j < numSteps; j++){
       instSteps[j] = int(instVals[i][j]); // =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
      println(instNames[i] + " : " + instSteps[0]);
      mMessage.add(instSteps);
      mBundle.add(mMessage);
      
    }
    mBundle.setTimetag(mBundle.now() + 10000);
    osc.send(mBundle, address);
    
    //println(mBundle);
    
 
}

  
}