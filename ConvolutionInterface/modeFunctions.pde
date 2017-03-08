void seqMode(){
}

void leadMode(){
 background(0);
    fill(255,0,255);
    cp5.getController("seq").setVisible(false);
    cp5.get(Textlabel.class, "bpm").setVisible(false);
    cp5.get(Textlabel.class, "current").setVisible(false);
    cp5.get(Group.class, "Effects Controls").setVisible(false);
    cp5.get(Group.class, "Global Controls").setVisible(true);
     sup.updateEnvPoints();
     sup.disp();
    if(arduino.knobFlag){
      setGlobalEffects(arduino.smoothKnobs());
      arduino.knobFlag  = false;
     }
  
}

void dmMode(){
  cp5.get(Textlabel.class, "bpm").setVisible(true);
  cp5.get(Textlabel.class, "current").setVisible(true);
  cp5.get(Group.class, "Effects Controls").setVisible(true);
    cp5.get(Group.class, "Global Controls").setVisible(false);
    cp5.getController("seq").setVisible(true);
  if(instDisplay){
    if(instDsplyTime.isFinished()){
      instDisplay = false;
      cp5.getController("label").setVisible(instDisplay);
     }
   }
  // if(Clear_Matrix) seq.clearMatrix();
  background(0);

  fill(255, 100);
  seq.setInstSteps(arduino, listIndex);
   seq.update();
   //seq.sendMatrixOsc();
   sup.updateEnvPoints();
 // sup.disp();
  if(arduino.knobFlag){
    setGlobalEffects(arduino.smoothKnobs());
    
    arduino.knobFlag  = false;
  }
// double total = (double)((Runtime.getRuntime().totalMemory()/1024)/1024);
//double used  = (double)((Runtime.getRuntime().totalMemory()/1024 - Runtime.getRuntime().freeMemory()/1024)/1024);
//println("total: " + total + " Used: " + used); 
  seq.drawExtras();
  setBPM();
  
}