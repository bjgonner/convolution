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
Instrument[] insts;
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
String[] sliderNames = {"attack",
                        "decay",
                        "sustain",
                        "release",
                        "effect1",
                        "effect2"
                        };
                        
String[] funcs = {"setAtk",
                  "setDcy",
                  "setSus",
                  "setRel",
                  "setEffect1",
                  "setEffect2"
                  };
                  
int listIndex = 5;
int lastListIndex = 4;
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
  sup = new EnvShaper(5,425,15,300,200, 20);
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
  
  bass = new Instrument("bass", 0);
  insts = new Instrument[instNames.length];
  for(int i=0; i < instNames.length; i++){
    insts[i] = new Instrument(instNames[i], i);
   
  }
  
  setupInstSliders();
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
    cp5.getGroup("bass").setVisible(true);
    sup.opacity = 255;
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
    cp5.getGroup("bass").setVisible(false);
    sup.opacity = 0;
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
    lastListIndex = listIndex;
    if (keyCode == UP) {
      listIndex -= 1;
      if(listIndex < 0) listIndex = instNames.length-1;
    } else if (keyCode == DOWN) {
     listIndex = (listIndex+1) % instNames.length;
    }
   // println(cp5.get(ScrollableList.class, "Insturment").setValue(listIndex));
   //cp5.get(Textlabel.class, "inst").setText("Instrument: " + instNames[listIndex]);
   cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);
   unPlugSliders(lastListIndex);
   plugSliders(listIndex, lastListIndex);
   //println(listIndex);
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

void plugSliders(int active, int last){
 unPlugSliders(last);
  
  for(int i=0; i < sliderNames.length; i++){
  cp5.getController(sliderNames[i]).setValue(insts[active].sliderValues[i]); //.setSliderValue(insts[active], funcs[i]);
  cp5.getController(sliderNames[i]).plugTo(insts[active], funcs[i]);
  }
}

void unPlugSliders(int last){
  for(int i=0; i < sliderNames.length; i++){
  cp5.getController(sliderNames[i]).unplugFrom(insts[last]);
  }
}

void setupInstSliders(){
  Group g1 = cp5.addGroup("test")
                 .setPosition(10,10)
                 .setBackgroundHeight(250)
                 .setSize(400,250)
                 .setBackgroundColor(0xff1111ff)
                 ;
   
   cp5.addSlider( "attack" )
       .setRange( 0.0, 5.0 )
       //.plugTo( this, "setAtk" )
       .setValue( 0.1 )
       .setLabel("attack")
       .setPosition(10,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
     cp5.addSlider( "decay" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setDcy" )
       .setValue( 0.5 )
       .setLabel("Decay")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "sustain" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setSus" )
       .setValue( 0.3 )
       .setLabel("Sustain")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
 cp5.addSlider( "release" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setRel" )
       .setValue( 1 )
       .setLabel("Release")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect1" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect1" )
       .setValue( 50 )
       .setLabel("Effect1")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect2" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect2" )
       .setValue( 50 )
       .setLabel("Effect2")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addTextlabel("instName")
       .setText("Instrument: " + instNames[listIndex])
       .setPosition(10,210)
       .setSize(50, 300)
       .setColorValue(0xffffff00)
       .setFont(createFont("AvenirNext-DemiBold",24))
       //.setMultiline(true)
       .setLineHeight(30)
       .setGroup(g1)
       ;
       
       
       
  cp5.getController("attack").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("decay").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("sustain").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("release").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("effect1").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("effect2").getValueLabel().alignX(ControlP5.CENTER);
  
  plugSliders(listIndex, 0);
}