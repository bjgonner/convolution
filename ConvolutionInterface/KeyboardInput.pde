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