/**
 * ControlP5 Matrix
 *
 * A matrix can be used for example as a sequencer, a drum machine.
 *
 * find a list of public methods available for the Matrix Controller
 * at the bottom of this sketch.
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */

import controlP5.*;
import java.util.*;
EnvShaper sup;
ControlP5 cp5;
Instrument bass;
Dong[][] d;
Timer instDsplyTime;
boolean instDisplay = true;
String[] instNames = {"bass",
                      "conga",
                      "hi-hat",
                      "kick",
                      "flute",
                      "snare",
                      "synth1",
                      "synth2"
                    };
int listIndex = 5;
int bpm = 30;
boolean mFlag = true;
boolean tFlag = true;
int nx = 32;
int ny = 8;
int gap = 2;
int mWidth = 800;
int padSize = (mWidth-gap*nx)/nx;
float test = float((mWidth-gap*nx)/nx);
int mHeight = ny*padSize + ny*gap;
//32*w + 32*gap
int gWidth = (800-64)/32;//32*20+32*2; //int(700/float(nx));
int gHeight = 8*23 + 8*2;

JSONObject json;

void setup() {
  size(800, 480, P2D);
  //smooth(2);
  sup = new EnvShaper(5,425,65,300,200, 20);
  String instText = join(instNames, "\n");
  String dynText = "Insturment: " + instNames[0];
  cp5 = new ControlP5(this);
  println(mHeight);
  println(test);
  cp5.addMatrix("myMatrix", nx,ny,0,height-mHeight,mWidth, mHeight)//704,176)
     //.setPosition(100, height-200)
    // .setSize(750, 200)
     //.setGrid(nx, ny)
     .setGap(gap, gap)
     .setInterval(125)
     .setMode(ControlP5.MULTIPLES)
     .setColorBackground(color(120))
     .setBackground(color(40))
     .setVisible(mFlag);
     ;
    int tWidth = 100; 
    cp5.addTextlabel("label")
      .setText(instText)
      .setPosition(width/2-tWidth/2,height-mHeight-1)
      .setSize(tWidth,mHeight+1)
      .setColorValue(0xffffff00)
      .setFont(createFont("AvenirNext-DemiBold",20))
      .setMultiline(true)
      .setLineHeight(25)
      
      ;
      
     cp5.addKnob("bpm")
       .setSize(50, 50)
       .setPosition(width-75, 10)
       .setRange(30,240)
       .plugTo(this,"setBPM")
       ;
     
/*     List l = Arrays.asList(instNames);
   //add a ScrollableList, by default it behaves like a DropdownList 
  cp5.addScrollableList("Insturment")
     .setPosition(0, height-mHeight-60)
     .setSize(110, 60)
     .setBarHeight(30)
     .setItemHeight(30)
     .addItems(l)
     .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     .setFont(createFont("AvenirNext-DemiBold",14))
     ;
*/     
      cp5.addTextlabel("inst")
      .setText(dynText)
      .setPosition(0,height-mHeight-20)
      .setSize(300,30)
      .setColorValue(0xffffff00)
      .setFont(createFont("AvenirNext-DemiBold",14))
      .setMultiline(true)
      .setLineHeight(30)
      
      ;
  
  cp5.getController("myMatrix").getCaptionLabel().alignX(CENTER);
  
  // use setMode to change the cell-activation which by 
  // default is ControlP5.SINGLE_ROW, 1 active cell per row, 
  // but can be changed to ControlP5.SINGLE_COLUMN or 
  // ControlP5.MULTIPLES

    d = new Dong[nx][ny];
  for (int x = 0;x<nx;x++) {
    for (int y = 0;y<ny;y++) {
      d[x][y] = new Dong();
    }
  }  
  noStroke();
  smooth();
  instDsplyTime = new Timer(2000);
  
  bass = new Instrument("bass");
}


void draw() {
  if(instDisplay){
    if(instDsplyTime.isFinished()){
      instDisplay = false;
      cp5.getController("label").setVisible(instDisplay);
     }
   }
  background(0);
  fill(255, 100);
 
  pushMatrix();
  translate(width/2 + 150, height/2);
  rotate(frameCount*0.001);
  for (int x = 0;x<nx;x++) {
    for (int y = 0;y<ny;y++) {
      d[x][y].display();
    }
  }
  popMatrix();
   sup.updateEnvPoints();
  sup.disp();
}


void myMatrix(int theX, int theY) {
  println("got it: "+theX+", "+theY);
  d[theX][theY].update();
}

void setBPM(float v){
    //bpm = v;
    float rate = 60/v/4;
    println("BPM: " +rate);  
    cp5.get(Matrix.class,"myMatrix").setInterval(int(rate*1000));
  }


void keyPressed() {
  if (key=='1') {
    cp5.get(Matrix.class, "myMatrix").set(0, 0, true);
  } 
  else if (key=='2') {
    cp5.get(Matrix.class, "myMatrix").set(0, 1, true);
  }  
  else if (key=='3') {
    cp5.get(Matrix.class, "myMatrix").trigger(0);
  }
  else if (key=='p') {
    if (cp5.get(Matrix.class, "myMatrix").isPlaying()) {
      cp5.get(Matrix.class, "myMatrix").pause();
    } 
    else {
      cp5.get(Matrix.class, "myMatrix").play();
    }
  }  
  else if (key=='0') {
    cp5.get(Matrix.class, "myMatrix").clear();
  }
   else if (key=='7') {
     mFlag = !mFlag;
    cp5.get(Matrix.class, "myMatrix").setVisible(mFlag);
  }
  else if (key=='8') {
     instDisplay = true;
    cp5.get(Textlabel.class, "label").setVisible(instDisplay);
    instDsplyTime.reset();
  }
  else if (key=='8') {
     instDisplay = true;
    cp5.get(Textlabel.class, "label").setVisible(instDisplay);
    instDsplyTime.reset();
    
  }
  
  if(key == CODED){
    if (keyCode == UP) {
      listIndex -= 1;
      if(listIndex < 0) listIndex = instNames.length-1;
    } else if (keyCode == DOWN) {
     listIndex = (listIndex+1) % instNames.length;
    }
   // println(cp5.get(ScrollableList.class, "Insturment").setValue(listIndex));
   cp5.get(Textlabel.class, "inst").setText("Insturment: " + instNames[listIndex]);
  // println(listIndex + " : " + log(listIndex)*10);
  }
}

void controlEvent(ControlEvent theEvent) {
}


class Dong {
  float x, y;
  float s0, s1;

  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(100, 150);
    y = sin(f)*random(100, 150);
    s0 = random(2, 10);
  }

  void display() {
    s1 += (s0-s1)*0.1;
    ellipse(x, y, s1, s1);
  }

  void update() {
    s1 = 50;
  }
}



/*
a list of all methods available for the Matrix Controller
use ControlP5.printPublicMethodsFor(Matrix.class);
to print the following list into the console.

You can find further details about class Matrix in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : ControllerView getView() 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : Matrix addCallback(CallbackListener) 
controlP5.Controller : Matrix addListener(ControlListener) 
controlP5.Controller : Matrix addListenerFor(int, CallbackListener) 
controlP5.Controller : Matrix align(int, int, int, int) 
controlP5.Controller : Matrix bringToFront() 
controlP5.Controller : Matrix bringToFront(ControllerInterface) 
controlP5.Controller : Matrix hide() 
controlP5.Controller : Matrix linebreak() 
controlP5.Controller : Matrix listen(boolean) 
controlP5.Controller : Matrix lock() 
controlP5.Controller : Matrix onChange(CallbackListener) 
controlP5.Controller : Matrix onClick(CallbackListener) 
controlP5.Controller : Matrix onDoublePress(CallbackListener) 
controlP5.Controller : Matrix onDrag(CallbackListener) 
controlP5.Controller : Matrix onDraw(ControllerView) 
controlP5.Controller : Matrix onEndDrag(CallbackListener) 
controlP5.Controller : Matrix onEnter(CallbackListener) 
controlP5.Controller : Matrix onLeave(CallbackListener) 
controlP5.Controller : Matrix onMove(CallbackListener) 
controlP5.Controller : Matrix onPress(CallbackListener) 
controlP5.Controller : Matrix onRelease(CallbackListener) 
controlP5.Controller : Matrix onReleaseOutside(CallbackListener) 
controlP5.Controller : Matrix onStartDrag(CallbackListener) 
controlP5.Controller : Matrix onWheel(CallbackListener) 
controlP5.Controller : Matrix plugTo(Object) 
controlP5.Controller : Matrix plugTo(Object, String) 
controlP5.Controller : Matrix plugTo(Object[]) 
controlP5.Controller : Matrix plugTo(Object[], String) 
controlP5.Controller : Matrix registerProperty(String) 
controlP5.Controller : Matrix registerProperty(String, String) 
controlP5.Controller : Matrix registerTooltip(String) 
controlP5.Controller : Matrix removeBehavior() 
controlP5.Controller : Matrix removeCallback() 
controlP5.Controller : Matrix removeCallback(CallbackListener) 
controlP5.Controller : Matrix removeListener(ControlListener) 
controlP5.Controller : Matrix removeListenerFor(int, CallbackListener) 
controlP5.Controller : Matrix removeListenersFor(int) 
controlP5.Controller : Matrix removeProperty(String) 
controlP5.Controller : Matrix removeProperty(String, String) 
controlP5.Controller : Matrix setArrayValue(float[]) 
controlP5.Controller : Matrix setArrayValue(int, float) 
controlP5.Controller : Matrix setBehavior(ControlBehavior) 
controlP5.Controller : Matrix setBroadcast(boolean) 
controlP5.Controller : Matrix setCaptionLabel(String) 
controlP5.Controller : Matrix setColor(CColor) 
controlP5.Controller : Matrix setColorActive(int) 
controlP5.Controller : Matrix setColorBackground(int) 
controlP5.Controller : Matrix setColorCaptionLabel(int) 
controlP5.Controller : Matrix setColorForeground(int) 
controlP5.Controller : Matrix setColorLabel(int) 
controlP5.Controller : Matrix setColorValue(int) 
controlP5.Controller : Matrix setColorValueLabel(int) 
controlP5.Controller : Matrix setDecimalPrecision(int) 
controlP5.Controller : Matrix setDefaultValue(float) 
controlP5.Controller : Matrix setHeight(int) 
controlP5.Controller : Matrix setId(int) 
controlP5.Controller : Matrix setImage(PImage) 
controlP5.Controller : Matrix setImage(PImage, int) 
controlP5.Controller : Matrix setImages(PImage, PImage, PImage) 
controlP5.Controller : Matrix setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : Matrix setLabel(String) 
controlP5.Controller : Matrix setLabelVisible(boolean) 
controlP5.Controller : Matrix setLock(boolean) 
controlP5.Controller : Matrix setMax(float) 
controlP5.Controller : Matrix setMin(float) 
controlP5.Controller : Matrix setMouseOver(boolean) 
controlP5.Controller : Matrix setMoveable(boolean) 
controlP5.Controller : Matrix setPosition(float, float) 
controlP5.Controller : Matrix setPosition(float[]) 
controlP5.Controller : Matrix setSize(PImage) 
controlP5.Controller : Matrix setSize(int, int) 
controlP5.Controller : Matrix setStringValue(String) 
controlP5.Controller : Matrix setUpdate(boolean) 
controlP5.Controller : Matrix setValue(float) 
controlP5.Controller : Matrix setValueLabel(String) 
controlP5.Controller : Matrix setValueSelf(float) 
controlP5.Controller : Matrix setView(ControllerView) 
controlP5.Controller : Matrix setVisible(boolean) 
controlP5.Controller : Matrix setWidth(int) 
controlP5.Controller : Matrix show() 
controlP5.Controller : Matrix unlock() 
controlP5.Controller : Matrix unplugFrom(Object) 
controlP5.Controller : Matrix unplugFrom(Object[]) 
controlP5.Controller : Matrix unregisterTooltip() 
controlP5.Controller : Matrix update() 
controlP5.Controller : Matrix updateSize() 
controlP5.Controller : Pointer getPointer() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getAbsolutePosition() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : float[] getPosition() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
controlP5.Matrix : Matrix clear() 
controlP5.Matrix : Matrix pause() 
controlP5.Matrix : Matrix play() 
controlP5.Matrix : Matrix plugTo(Object) 
controlP5.Matrix : Matrix plugTo(Object, String) 
controlP5.Matrix : Matrix set(int, int, boolean) 
controlP5.Matrix : Matrix setBackground(int) 
controlP5.Matrix : Matrix setCells(int[][]) 
controlP5.Matrix : Matrix setGap(int, int) 
controlP5.Matrix : Matrix setGrid(int, int) 
controlP5.Matrix : Matrix setInterval(int) 
controlP5.Matrix : Matrix setMode(int) 
controlP5.Matrix : Matrix setValue(float) 
controlP5.Matrix : Matrix stop() 
controlP5.Matrix : Matrix trigger(int) 
controlP5.Matrix : Matrix update() 
controlP5.Matrix : boolean get(int, int) 
controlP5.Matrix : boolean isPlaying() 
controlP5.Matrix : int getInterval() 
controlP5.Matrix : int getMode() 
controlP5.Matrix : int[][] getCells() 
controlP5.Matrix : void remove() 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 

created: 2015/03/24 12:21:14

*/