/*
@Author Ben Gonner
*/

/**
*Personalized class that combines a matrix, a radio button, a slider, and a series of buttons and toggles to be used for a Step Sequencer.
*/

class StepSequencer {
  
  /**
  *A constant that defines the screen size in the X (horizontal) direction.
  */
 static final int SCREEN_SIZE_X = 800;

  /**
  *A constant that defines the screen size in the Y (vertical) direction.
  */
 static final int SCREEN_SIZE_Y = 480;

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
 *A random number generator to randomize the beat on the sequencer.
 */
 Random rand = new Random();
 
 /**
 *A random number generator to randomize the beat on the sequencer.
 */
 Random rando = new Random();
 
 /**
 *A list to keep track of the active cells in the matrix; when filled, it holds one number for each (vertical) column; 
 *negative one (-1) represents the bottom cell in that column; each cell up increases the count by one, so that the top
 *cell is represented by seven (7).
 */
 IntList activeCells = new IntList();
 
 /**
 *A list that follows the same conventions as activeCells, but keeps track of the most recent list of active cells, as
 *opposed to the current list.
 */
 IntList lastActiveCells = new IntList();




/**
*Constructs a new Step Sequencer with a Matrix with given Name, given rows, given columns, given x-position, given y-position, given x-size, and given y-size;
* a Radio Button with given x-position and given y-position; a Slider with given x-position and given y-position; and a set of Buttons at given x-position and given
* y-position; The given position of the set of buttons directly corresponds to the right-most button; All other buttons are in line (vertically) with that one.
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
      
  //  I've added this as a safety net to avoid creating a matrix with an error zone on the side.
  if (!(sizeMatrix_X % xSteps == 0)){
     if (sizeMatrix_X % xSteps >= (xSteps / 2)){
      sizeMatrix_X += xSteps - (sizeMatrix_X % xSteps);  
     }
     else {
      sizeMatrix_X -= (sizeMatrix_X % xSteps); 
     }
  }
  if(!(sizeMatrix_Y % yNotes == 0)){
    if (sizeMatrix_Y % yNotes >= (yNotes / 2)){
       sizeMatrix_Y += yNotes - (sizeMatrix_Y % yNotes); 
    }
  }
    else {
      sizeMatrix_Y -= (sizeMatrix_Y % yNotes);
    }
    
      
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
                
       cp5.addRadioButton("keySelector")
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
      .setSize(35,200)
      .setRange(1,5)
      .setValueSelf(5.00)
      .setNumberOfTickMarks(5)
      .setSliderMode(Slider.FLEXIBLE)
      .setDecimalPrecision(0)
      ;
      
    cp5.addButton("random")
       .setPosition(posButton_X,posButton_Y)
       ;
                  
  cp5.addToggle("slide_Mode")
    .setPosition(posButton_X - 100, posButton_Y)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
    
  cp5.addToggle("mute")
    .setPosition(posButton_X - 200, posButton_Y)
    ;
    
  cp5.addToggle("loop")
    .setPosition(posButton_X - 520, posButton_Y)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
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
    posMatrix_X = 90;
    posMatrix_Y = 20;
    sizeMatrix_X = 608; //safe: 592, 608, 624 (add 16). Turns out, the size of the matrix needs to be evenly divisible by the number of cells in each direction.
    sizeMatrix_Y = 351; //safe Value: 342, 351, 360 (add 9)
  
    posKeySelector_X = 10;
    posKeySelector_Y = 20;

    posStepSlider_X = 730;
    posStepSlider_Y = 40;
    
    posButton_X = 600;
    posButton_Y = 385;

  //posMatrix_Y = SCREEN_SIZE_Y - sizeMatrix_Y + 3;
  //posMatrix_X = SCREEN_SIZE_X - sizeMatrix_X + 8;

   cp5.addMatrix(matrixName)
     .setPosition(posMatrix_X,posMatrix_Y)
     .setSize(sizeMatrix_X,sizeMatrix_Y)
     .setGrid(xSteps,yNotes)
     .setGap(sizeMatrix_X / (xSteps * 10), 1)
     .setInterval(tempo)
     .setMode(ControlP5.SINGLE_COLUMN)
     .setColorBackground(color(120))
     .setBackground(color(40))
     ;

    cp5.addRadioButton("keySelector")
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
    .setSize(35,200)
    .setRange(1,5)
    .setValueSelf(5.00)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0)
    ; 
    
  cp5.addButton("random")
    .setPosition(posButton_X,posButton_Y)
    ;
    
  cp5.addToggle("mute")
    .setPosition(posButton_X - 80, posButton_Y)
    ;
    
  cp5.addToggle("slide_Mode")
    .setPosition(posButton_X - 170, posButton_Y)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
    
  cp5.addToggle("loop")
    .setPosition(posButton_X - 520, posButton_Y)
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
  
  /**
  *Randomizes which buttons on the matrix are selected.
  */
  void random(){
    int i;
    cp5.get(Matrix.class,matrixName).clear();
    for (i = 0; i < xSteps; i++){
        if (rand.nextInt(2) == 1){
          cp5.get(Matrix.class,matrixName).set(i, rando.nextInt(yNotes), true);
        }
    }
    
  }
  
  
  //I don't know what the rest of this does.------------------------------
  
  /**
  *Iterates through the matrix to make a list of which cell is active in each (vertical) column; Then compares the current active cells list to
  * to the most recent list of active cells. If the lists are different, it makes a new OSC message and sends it.
  */
   void sendMatrixOsc(){
     
     int i, j, k; //i and j iterate through the matrix. K counts the number of active cells in a row.
     activeCells.clear();
     for(i = 0; i < xSteps; i ++){
       k = 0;
       for (j = 0; j < yNotes; j++){
         if (cp5.get(Matrix.class,"MatrixMusic").get(i,j)){
            k++;
            activeCells.append(7 - j);
         }
       }
       if (k == 0) activeCells.append(-1);
     }
      if (!(activeCells.size() == lastActiveCells.size())){
            k = 1;
        }
        else {
          k = activeCells.size();
          for (i = 0; i < activeCells.size(); i ++){
             if(activeCells.get(i) == lastActiveCells.get(i)){
               k--;
             }
          }
        }
        println("k :" +k);
     if (!(k == 0) && !(cp5.get(Toggle.class,"loop").getBooleanValue())){
     lastActiveCells.clear();
     lastActiveCells = activeCells.copy();
     println(activeCells); // FIXME!!! change this line from print to send the message * * * * * * * *
     }

     OscMessage mMessage = new OscMessage("/StepSeq");
     int[] activeCellsOut = activeCells.array();
      mMessage.add(activeCellsOut);
      
    osc.send(mMessage, address);
    
    
 
  }
  /*
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