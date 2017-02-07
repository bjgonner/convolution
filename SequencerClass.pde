/*
@Author Ben Gonner
*/

/**
*Personalized class that combines a matrix, a radio button, and a slider, to be used for a Step Sequencer.
*/

class StepSequencer {
  /**
  *Defines the name of the Matrix that controls the Step Sequencer.
  */ 
 String matrixName;
 
 /**
 *Defines the number of buttons in one (horizontal) row of the Matrix.
 */
 int xSteps;

 /**
 *Defines the number of buttons in one (vertical) column of the Matrix.
 */
 int yNotes;
 
 /**
 *Remembers the last value of xSteps for use in stepCount function.
 */
 int lastXSteps;
 
/**
*Defines the interval for the Matrix object.
*/
 int tempo;
 
 /**
 *Used in the slider to change the number of (horizontal) rows in the Matrix.
 */
 int stepCount;
 
 /**
 *Defines the X(horizontal) position of the Radio Button (used to change musical keys) on the screen.
 */
 int posKeySelector_X;
 
 /**
 *Defines the Y(vertical) position of the Radio Button (used to change musical keys) on the screen.
 */
 int posKeySelector_Y;
 
 /**
 *Defines the X(horizontal) position of the Matrix on the screen.
 */
 int posMatrix_X;
 
 /**
 *Defines the Y(vertical) position of the Matrix on the Screen.
 */
 int posMatrix_Y;
 
 /**
 *Defines of the size of the Matrix in the X(horizontal) direction.
 */
 int sizeMatrix_X;
 
 /**
 *Defines the size of the Matrix in the Y(vertical) direction
 */
 int sizeMatrix_Y;
 
 /**
 *Defines the X(horizontal) position of the Slider on the screen.
 */
 int posStepSlider_X;
 
 /**
 *Defines the Y(vertical) position of the Slider on the screen.
 */
 int posStepSlider_Y;
 
 /**
 *Defines the X(horizonal) position of the Random Button on the screen.
 */
 int posButton_X;
 
 /**
 *Defines the Y(vertical) position of the Random Button on the screen.
 */
 int posButton_Y;
 
 /**
 *Radio button for changing the key of the Step Sequencer.
 */
 RadioButton keySelector;
 
 /**
 *A random number generator to randomize the beat on the sequencer.
 */
 Random rand = new Random();
 
 /**
 *A random number generator to randomize the beat on the sequencer.
 */
 Random rando = new Random();

static final int SCREEN_SIZE_X = 800;
static final int SCREEN_SIZE_Y = 480;


/**
*Constructs a new Step Sequencer with a Matrix with given Name, given rows, given columns, given x-position, given y-position, given x-size, and given y-size;
* a Radio Button with given x-position and given y-position; a Slider with given x-position and given y-position; and a Button at given x-position and given
* y-position.
*@param _matrixName
*@param _xSteps
*@param _yNotes
*@param _posMatrix_X
*@param _posMatrix_Y
*@param _sizeMatrix_X
*@param _sizeMatrix_Y
*@param _posKeySelector_X
*@param _posKeySelector_Y
*@param _posStepSlider_X
*@param _posStepSlider_Y
*@param _posButton_X
*@param _posButton_Y
*/
StepSequencer(String _matrixName, int _xSteps, int _yNotes, int _posMatrix_X, int _posMatrix_Y,int _sizeMatrix_X, 
    int _sizeMatrix_Y, int _posKeySelector_X, int _posKeySelector_Y,int _posStepSlider_X, int _posStepSlider_Y, int _posButton_X, int _posButton_Y){
              
      matrixName = _matrixName;
      xSteps = _xSteps;
      yNotes = _yNotes;
      posMatrix_X = _posMatrix_X;
      posMatrix_Y = _posMatrix_Y;
      sizeMatrix_X = _sizeMatrix_X;
      sizeMatrix_Y = _sizeMatrix_Y;
      tempo = 200;
      stepCount = 5;
      
      posKeySelector_X = _posKeySelector_X;
      posKeySelector_Y = _posKeySelector_Y;
      
      posStepSlider_X = _posStepSlider_X;
      posStepSlider_Y = _posStepSlider_Y;
      
      posButton_X = _posButton_X;
      posButton_Y = _posButton_Y;
      
      posMatrix_Y = SCREEN_SIZE_Y - sizeMatrix_Y + 3;
      
        cp5.addMatrix(matrixName)
         .setPosition(posMatrix_X,posMatrix_Y)
         .setSize(sizeMatrix_X,sizeMatrix_Y)
         .setGrid(xSteps,yNotes)
         .setGap(6, 1)
         .setInterval(tempo)
         .setMode(ControlP5.SINGLE_COLUMN)
         .setColorBackground(color(120))
         .setBackground(color(40))
       ;
                
       keySelector = cp5.addRadioButton("radioButton")
         .setPosition(posKeySelector_X, posKeySelector_Y)
         .setSize(40,20)
         .setColorForeground(color(170))
         .setColorActive(color(255))
         .setColorLabel(color(225))
         .setItemsPerRow(1)
         .setSpacingColumn(50)
         .addItem("C",1)
         .addItem("D flat",2)
         .addItem("D",3)
         .addItem("E flat",4)
         .addItem("E",5)
         .addItem("F",6)
         .addItem("F sharp",7)
         .addItem("G",8)
         .addItem("A flat",9)
         .addItem("A",10)
         .addItem("B flat",11)
         .addItem("B",12)
         ;
         
     cp5.addSlider("stepCounter")
      .setPosition(posStepSlider_X,posStepSlider_Y)
      .setSize(20,200)
      .setRange(1,5)
      .setNumberOfTickMarks(5)
      .setSliderMode(Slider.FLEXIBLE)
      ;
      
    cp5.addButton("random")
       .setPosition(posButton_X,posButton_Y)
       ;
  }
/**
*Constructs a new StepSequencer with given Name and other default values.
*@param _matrixName
*/
  StepSequencer(String _matrixName){
    matrixName = _matrixName;
    xSteps = 16; 
    yNotes = 9;
    tempo = 200;
    stepCount = 5;
    posMatrix_X = 150;
    posMatrix_Y = 40;
    sizeMatrix_X = 600;
    sizeMatrix_Y = 345;
  
    posKeySelector_X = 30;
    posKeySelector_Y = 50;

    posStepSlider_X = 760;
    posStepSlider_Y = 40;

  posMatrix_Y = SCREEN_SIZE_Y - sizeMatrix_Y + 3;

   cp5.addMatrix(matrixName)
     .setPosition(posMatrix_X,posMatrix_Y)
     .setSize(sizeMatrix_X,sizeMatrix_Y)
     .setGrid(xSteps,yNotes)
     .setGap(6, 1)
     .setInterval(tempo)
     .setMode(ControlP5.SINGLE_COLUMN)
     .setColorBackground(color(120))
     .setBackground(color(40))
     ;

    keySelector = cp5.addRadioButton("radioButton")
     .setPosition(posKeySelector_X,posKeySelector_Y)
     .setSize(40,20)
     .setColorForeground(color(170))
     .setColorActive(color(255))
     .setColorLabel(color(225))
     .setItemsPerRow(1)
     .setSpacingColumn(50)
     .addItem("C",1)
     .addItem("D flat",2)
     .addItem("D",3)
     .addItem("E flat",4)
     .addItem("E",5)
     .addItem("F",6)
     .addItem("F sharp",7)
     .addItem("G",8)
     .addItem("A flat",9)
     .addItem("A",10)
     .addItem("B flat",11)
     .addItem("B",12)
     ;

  cp5.addSlider("stepCount")
    .setPosition(posStepSlider_X,posStepSlider_Y)
    .setSize(20,200)
    .setRange(1,5)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ; 
    
      cp5.addButton("random")
     .setPosition(700,420)
     ;
    
    
  }
  
  /**
  *Changes the number of (horizontal) rows in the Matrix based on the setting of the slider.
  */

 void stepCount(float count){
   lastXSteps = xSteps;
    switch(str(int(count))){
      case("1"):xSteps = 2; break;
      case("2"):xSteps = 3; break;
      case("3"):xSteps = 4; break;
      case("4"):xSteps = 8; break;
      case("5"):xSteps = 16; break;
      }
      if (lastXSteps != xSteps){
    println("Number of Steps: "+ xSteps + " : " + cp5.get(Slider.class, "stepCount").getValue());
    cp5.get(Matrix.class,matrixName).setGrid(xSteps,yNotes);
      }
  }
  
  void random(){
    int i;
    for (i = 0; i < xSteps; i++){
        if (rand.nextInt(2) == 1){
          cp5.get(Matrix.class,matrixName).set(i, rando.nextInt(yNotes), true);
        }
    }
    
  }
  
  
  
  //I don't know what the rest of this does.------------------------------
  
  
/*   void sendMatrixOsc(){
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
  
   void drawExtras(){
  rectMode(CENTER);
    float spacing  = width/xSteps*(cnt+1);
    rect(spacing-(width/xSteps)/2,height-mHeight-(gap), width/xSteps-gap*2, 20); 
    rectMode(CORNER); 
    
 //   cp5.getController("current").setPosition(0,(height-mHeight-25)+(25*listIndex)+10);
   
   
 }
  
    void update(){
    
    for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < xSteps; j++){
       instVals[i][j] =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
    }
    //println("current: " + time.current + "   " + (millis()-time.current) + "   delay: " + time.delayTime);
    if(time.isFinished()){
     // println("truth");
     // sendMatrixOsc();
    }
    
  }
  
  */
  
}