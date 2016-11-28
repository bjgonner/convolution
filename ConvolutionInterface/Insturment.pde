class Instrument{
 String theName;
 float atk;
 float decay;
 float sustain;
 float release;
 float effect1, effect2;
 boolean visible = false;
 int[] steps;
 
 Instrument(String _theName){
   atk = 0.1;
   decay = 0.5;
   sustain = 0.3;
   release =0.2;
   theName = _theName;
   
   Group g1 = cp5.addGroup(theName)
                 .setPosition(10,10)
                 .setBackgroundHeight(250)
                 .setSize(400,250)
                 .setBackgroundColor(0xff1111ff)
                 ;
   
   cp5.addSlider( "attack" )
       .setRange( 0.0, 5.0 )
       .plugTo( this, "setAtk" )
       .setValue( atk )
       .setLabel("attack")
       .setPosition(10,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
     cp5.addSlider( "decay" )
       .setRange( 0.01, 5.0 )
       .plugTo( this, "setDcy" )
       .setValue( decay )
       .setLabel("Decay")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "sustain" )
       .setRange( 0.01, 5.0 )
       .plugTo( this, "setSus" )
       .setValue( sustain )
       .setLabel("Sustain")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
 cp5.addSlider( "release" )
       .setRange( 0.01, 5.0 )
       .plugTo( this, "setRel" )
       .setValue( release )
       .setLabel("Release")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect1" )
       .setRange( 0.0, 100.0 )
       .plugTo( this, "setEffect1" )
       .setValue( effect1 )
       .setLabel("Effect1")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect2" )
       .setRange( 0.0, 100.0 )
       .plugTo( this, "setEffect2" )
       .setValue( effect2 )
       .setLabel("Effect2")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
  cp5.getController("attack").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("decay").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("sustain").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("release").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("effect1").getValueLabel().alignX(ControlP5.CENTER);
       
 }
  
  void setVisible(boolean v){
    //do something
    
  }
  
  void record(){
  }
  
  void setAtk(float v){
   atk = v;
   println(theName + ": attack: " + atk);
  }
  
  void setDcy(float v){
   decay = log(v)*10;
   println(theName + ": decay: " + decay);
  }
  
  void setSus(float v){
    sustain = v;
    println(theName + ": sustain: " + sustain);  
  }
  
   void setRel(float v){
    release = v;
    println(theName + ": release: " + release);  
  }
  
  void setEffect1(float v){
    effect1 = v;
    println(theName + ": effect1: " + effect1);  
  }
  
  void setEffect2(float v){
    effect2 = v;
    println(theName + ": effect2: " + effect2);  
  }
  
   
}