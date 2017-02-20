import netP5.*;
import oscP5.*;

//Ben Gonner
//First attempt at controlP5
//Making Radio buttons to control the scale, and a matrix to match the number of notes in the scale

import controlP5.*;
import java.util.*;

ControlP5 cp5;

StepSequencer musicMaker;

OscP5 osc;
NetAddress address;

//IntList activeCells = new IntList();
//IntList lastActiveCells = new IntList();
void setup() {
 size(800,480);
  
 cp5 = new ControlP5(this);

 musicMaker = new StepSequencer("MatrixMusic");
  
}

void draw(){
background(color(32));
musicMaker.stepCount(cp5.get(Slider.class, "stepCount").getValue());
}
 
void keySelector(int a) {
  println("a radio Button event: "+a);
  if (a == 8){
      musicMaker.sendMatrixOsc();
  }
}