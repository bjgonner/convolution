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
//----Serial and OSC routing-----------------------
import processing.serial.*;

import netP5.*;
import oscP5.*;

// which serial device to use. this is an index into the list
// of serial devices printed when this program runs. 
int SERIAL_PORT = 5;
int BAUD = 1843200; // baud rate of the serial device

// the OSC server to talk to
String HOST = "127.0.0.1";
int PORT = 57121;
float cnt = 0;

int LEAD = 1;
int SEQUENCER = 0;
int root = 60;

Serial port;
OscP5 osc;
NetAddress address;
HardwareInput arduino;
Matricks seq;
//---------------------------
//--------Interface---------------
import controlP5.*;
import java.util.*;
EnvShaper sup;
ControlP5 cp5;
Instrument bass;
Instrument[] insts;
EffectsGroup efg;

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
String[] globalSliders = {"Global FX1",
                        "Global FX2",
                        "Global FX3",
                        "Global FX4",
                        "Global FX5",
                        "Global FX6"
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
int mode = 1;  //sequencer mode
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
//================================================
//========Setup=================================
void setup() {
  size(800, 480, P2D);
  frameRate(30);
  //smooth(2);
  //==========Serial/OSC setup==============
  arduino = new HardwareInput(6,128,2,0);
  printArray(Serial.list());
  osc = new OscP5(this, 12000);
  address = new NetAddress(HOST, PORT);
 // port = new Serial(this, Serial.list()[SERIAL_PORT], BAUD);
  port = new Serial(this, Serial.list()[2], BAUD);
  port.bufferUntil('\n');
  //==============================================
  
  sup = new EnvShaper(5,425,15,350,233, 20);
  String instText = join(instNames, "\n");
  String dynText = "Insturment: " + instNames[0];
  cp5 = new ControlP5(this);
  
  
    // use setMode to change the cell-activation which by 
  // default is ControlP5.SINGLE_ROW, 1 active cell per row, 
  // but can be changed to ControlP5.SINGLE_COLUMN or 
  // ControlP5.MULTIPLES
  //check about changing matrix buttons from toggles
  // Matricks(String _matrixName, int _nx, int _ny, int _mWidth, int _mHeight, String[] _instNames){
    seq = new Matricks("seq", nx, ny, mWidth, mHeight, instNames, 125);
 /* cp5.addMatrix("myMatrix", nx,ny,0,height-mHeight,mWidth, mHeight)//704,176)
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
     */
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
     cp5.addTextlabel("current")
      .setText("---------------------------------------------------")
      .setPosition(0,height-mHeight-25)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",50))
      //.setMultiline(true)
      .setLineHeight(0)
      
      ;
      
     cp5.addKnob("bpm")
       .setSize(50, 50)
       .setPosition(width-75, 10)
       .setRange(30,240)
       .plugTo(this,"setBPM")
       ;
        

//  cp5.getController("myMatrix").getCaptionLabel().alignX(CENTER);
  


  noStroke();
  smooth();
  instDsplyTime = new Timer(2000);
  
  bass = new Instrument("bass", 0);
  insts = new Instrument[instNames.length];
  for(int i=0; i < instNames.length; i++){
    insts[i] = new Instrument(instNames[i], i);
   
  }
  
  setupInstSliders();
 // efg = new EffectsGroup("test", sliderNames, 100,100,500, 300);
 // efg.setupSliders();
}


void draw() {
  transpose();
  if(arduino.enc1Mode == LEAD){
    leadMode();
  }else if(arduino.enc1Mode == SEQUENCER){
    seqMode();
  }else{
    cp5.getController("seq").setVisible(false);
    cp5.get(Group.class, "Effects Controls").setVisible(false);
    cp5.get(Group.class, "Global Controls").setVisible(false);
    background(0);
    fill(255,0,255);
  }
  updateInsturment();
}


void transpose(){
  OscMessage scaleRoot = new OscMessage( "/root" );
  //change scale root note
  //currently holding down produces many ticks add timer
  if(arduino.quadPad[2] == true){
    arduino.quadPad[2] = false;
    scaleRoot.add(root++);
    osc.send(scaleRoot, address);
    println(root);
  }else if(arduino.quadPad[0] == true){
    arduino.quadPad[0] = false;
    scaleRoot.add(root--);
    osc.send(scaleRoot, address);
    println(root);
  }
  
  
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
    cp5.getGroup("Effects Controls").setVisible(true);
    sup.opacity = 255;
  } 
  else if (key=='2') {
    cp5.get(Matrix.class, "myMatrix").set(0, 1, true);
  }  
  else if (key=='3') {
   // cp5.get(Matrix.class, "myMatrix").trigger(0);
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
    cp5.getGroup("Effects Controls").setVisible(false);
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
  //cannot use left/right without error!
  if(key == CODED){
    lastListIndex = listIndex;
    if (keyCode == UP) {
      listIndex -= 1;
      if(listIndex < 0) listIndex = instNames.length-1;
    } else if (keyCode == DOWN) {
     listIndex = (listIndex+1) % instNames.length;
    }
//-----------Code to be moved into function called on keyup/down and rotary encoder change
   cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);  //change inst name display
   cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);  //change inst name display
   sup.copyEnvPointsTo(insts[lastListIndex]);  //copy the existing envelop from the shaper to the last insturment

   sup.copyEnvPointsFrom(insts[listIndex]);  //copy the envelop from current instrument to shaper
   sup.updateVertices();  //update vertices on envelop display
  
   unPlugSliders(lastListIndex);  //unplug the effects sliders from the previos instrument
   plugSliders(listIndex, lastListIndex);  //plug the sliders to the current instrument
//-------------------------------------------------
  }
}

void updateInsturment(){
  if(arduino.encChangeFlag == true){
    lastListIndex = listIndex;
    arduino.encChangeFlag = false;
    if( arduino.rawEnc2[0] > arduino.rawEnc2[1]){
       listIndex = (listIndex+1) % instNames.length;
     }else if(arduino.rawEnc2[0] < arduino.rawEnc2[1]){
       
       listIndex -= 1;
       if(listIndex < 0) listIndex = instNames.length-1;
     }
     cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);  //change inst name display
     cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);  //change inst name display
     sup.copyEnvPointsTo(insts[lastListIndex]);  //copy the existing envelop from the shaper to the last insturment
  
     sup.copyEnvPointsFrom(insts[listIndex]);  //copy the envelop from current instrument to shaper
     sup.updateVertices();  //update vertices on envelop display
    
     unPlugSliders(lastListIndex);  //unplug the effects sliders from the previos instrument
     plugSliders(listIndex, lastListIndex);  //plug the sliders to the current instrument
     //println(listIndex + " | " + lastListIndex);
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
  Group g2 = cp5.addGroup("Global Controls")
                 .setPosition(10,40)
                 .setBarHeight(40)
                 .setBackgroundHeight(200)
                 .setSize(400,220)
                 .setBackgroundColor(0xff1111ff)
                 //.close()
                 ;
                 
  Group g1 = cp5.addGroup("Effects Controls")
                 .setPosition(10,40)
                 .setBarHeight(40)
                 .setBackgroundHeight(200)
                 .setSize(400,220)
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
       
       //End g1 === ========
       
  cp5.addSlider( "Global FX1" )
       .setRange( 0.0, 5.0 )
       //.plugTo( this, "setAtk" )
       .setValue( 0.1 )
       .setLabel("FX1")
       .setPosition(10,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
     cp5.addSlider( "Global FX2" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setDcy" )
       .setValue( 0.5 )
       .setLabel("FX2")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX3" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setSus" )
       .setValue( 0.3 )
       .setLabel("FX3")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
 cp5.addSlider( "Global FX4" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setRel" )
       .setValue( 1 )
       .setLabel("FX4")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX5" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect1" )
       .setValue( 50 )
       .setLabel("FX5")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX6" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect2" )
       .setValue( 50 )
       .setLabel("FX6")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;   
       
  cp5.addTextlabel("instName2")
       .setText("Instrument: " + instNames[listIndex])
       .setPosition(10,210)
       .setSize(50, 300)
       .setColorValue(0xffffff00)
       .setFont(createFont("AvenirNext-DemiBold",24))
       //.setMultiline(true)
       .setLineHeight(30)
       .setGroup(g2)
       ;
 cp5.getController("Global FX1").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX2").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX3").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX4").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX5").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX6").getValueLabel().alignX(ControlP5.CENTER); 
  
  plugSliders(listIndex, 0);
}

void setGlobalEffects(float[] input){
  for(int i = 0; i < input.length; i++){
    float min = cp5.getController(globalSliders[i]).getMin();
    float max = cp5.getController(globalSliders[i]).getMax();
    float temp = map(input[i], 0, 4096, min, max);
    cp5.getController(globalSliders[i]).setValue(temp);
  }
  }
  

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  listIndex += e;
  if(listIndex < 0) listIndex = instNames.length-1;
  listIndex = (listIndex+1) % instNames.length;
  cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);
  cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);
   unPlugSliders(lastListIndex);
   plugSliders(listIndex, lastListIndex);
  println(e + " " +listIndex);
}
//version that forwards info directly from serial to osc
void serialEvent(Serial port)
{
  String line = port.readStringUntil('\n');
  if (line == null) return;
  String[] vals = splitTokens(line);
  OscMessage msg = new OscMessage(trim(vals[0]));
  
  for (int i = 1; i < vals.length; i++) {
    float val = float(trim(vals[i]));
  //  print("\t" + val);
    msg.add(val);
  }
  //println();
  osc.send(msg, address);
  arduino.recordValues(vals);
  
}
void oscEvent(OscMessage msg)
{
  //print("<");
  if(msg.addrPattern().equals("/tick")) cnt = (float)msg.arguments()[0];
  //println(msg.arguments()[0]);
  if(cnt == 31) seq.sendMatrixOsc();
  //println(cnt);
  
}
//void oscEvent(OscMessage msg)
//{
//  print("<");
//  print(msg.addrPattern());
//  for (int i = 0; i < msg.arguments().length; i++) {
//    print("\t" + msg.arguments()[i].toString());
//    port.write(msg.arguments()[i].toString());
//    if (i < msg.arguments().length - 1) port.write("\t");
//  }
//  println();
//  port.write("\n");
//}