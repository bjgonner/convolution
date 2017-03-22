class Matricks {
 //add array for controls for each instrument rate and amp also lock state for each
  String matrixName;
  boolean instVals[][];
  boolean mute = false;
  boolean muteInst = false;
  int interval;
  int numInsts;
  int numSteps;
  String[] instNames;
  Timer time;
  int mHeight;
  int mWidth;
 // String[] buttons = {"Mute", "Adjust/Lock", "Clear Insturment", "Clear Matrix", "Save"};
  ButtonGroup b;
  
  
   String[] toggleNames = {"Adjust_Lock1","Mute_All1", "Mute_Instrument1"};
    String[] buttonNames = {"Randomize1", "Clear_Instrument1", "Clear_Matrix1"};
     Toggle[] toggles = new Toggle[toggleNames.length]; 
    Button[] buttons = new Button[buttonNames.length]; 
  
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
     
     for(int i = 0; i < toggleNames.length; i++){ 
     toggles[i] = cp5.addToggle( toggleNames[i])
       
       //.setValue( 0.1 )
       .setLabel(toggleNames[i])
       .setPosition(430, 5+i*45)
       .setSize(150, 30)
       
       ;
       cp5.getController(toggleNames[i]).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0); //getValueLabel().alignX(ControlP5.CENTER);
      // cp5.getController(toggles[i]).getValueLabel().alignY(ControlP5.CENTER);
  
      }
      for(int i = 0; i < buttonNames.length; i++){ 
       buttons[i] =  cp5.addButton( buttonNames[i])
       
       //.setValue( 0.1 )
       .setLabel(buttonNames[i])
       .setPosition(430, (toggleNames.length)*45 + i*45)
       .setSize(150, 30)
       
       ;
       cp5.getController(buttonNames[i]).getValueLabel().alignX(ControlP5.CENTER);
  
      }
      
     
     instVals = new boolean[numInsts][numSteps];
     for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
        instVals[i][j] = false;
      }
     }
     instNames = _instNames;
     
     time = new Timer(interval*(numSteps+1)-1);
     
     
     //String _gName, String[] _names, float _gX, float _gY, int _w, int _h
  //   b = new ButtonGroup("Controls", buttons, 5, 5, width/2,10);
 }
 
 void setVisibility(boolean vis){
   for (int i = 0; i < toggles.length; i++) toggles[i].setVisible(vis);
   for (int i = 0; i < buttons.length; i++) buttons[i].setVisible(vis);
 }
 
 void clearMatrix(){
   cp5.get(Matrix.class, matrixName).clear();
 }
 
 void clearInst(int cur){
   for(int i =0; i < numSteps; i++){
     cp5.get(Matrix.class, matrixName).set(i, cur, false);
   }
 }
 
 void randomize(){
   for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
        float rand = random(0,1);
        boolean state;
        if(rand <0.31) state = true;
        else state = false;
        
       cp5.get(Matrix.class, matrixName).set(j, i, state);
      }
   }
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
   if(mute != true){
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
   }
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