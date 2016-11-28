class EnvelopeShaper{
  PVector[] adsr, adsrScale;
  PVector start;
  PVector attack;
  PVector decay;
  PVector sustain;
  PVector release;
  //PVector end;
  float x, y, w,h;
  color fg, bg;
  float yScalar;
  float xScalar;
  
  
  EnvelopeShaper(float _x, float _y, float _w, float _h, color _bg, color _fg){
   adsr = new PVector[5];
   float defaultY[] = {0, 1, 0.8, 0.5, 0.0};
    // adsr[0] = new PVector(0,0);
    for(int i=0; i<adsr.length; i++){
      adsr[i] = new PVector(float(i)/2,defaultY[i]);
    }
    adsrScale = new PVector[5];
    for(int i=0; i<adsrScale.length; i++){
      adsr[i] = new PVector(float(i)/2,defaultY[i]);
    }
    
    printArray(adsr);
    start = new PVector(0,0);
   attack = new PVector(0.1,1);
   decay = new PVector(1.5, 1.0);
   sustain = new PVector(2.0, 0.5);
   release = new PVector(3.0, 0); 
   
   x = _x;
   y = _y;
   w = _w;
   h = _h;
   fg = _fg;
   bg = _bg;
   
  }
  
  void drawEnvelope(float xpos, float ypos, float diam){
    float s=w/4;
    //background
    fill(bg);
    stroke(0xffaaaaaa);
    rect(xpos, ypos, w, h);
    PVector relative = new PVector(xpos, ypos);
    for(int i=0; i<=w; i+=w/10){
      for(int j=0; j <=h; j+=w/10){
        line(i,j,i,h);
        line(0,j,w,j);
      }
    }
    
    //lines
    stroke(fg);
    strokeWeight(3);
    noFill();
    
    line(start.x*s+xpos, h-start.y*s+ypos, attack.x*s+xpos, h-attack.y*s+ypos);
    line(attack.x*s+xpos, h-attack.y*s+ypos, decay.x*s+xpos, h-decay.y*s+ypos);
    line(decay.x*s+xpos, h-decay.y*s+ypos, sustain.x*s+xpos, h-sustain.y*s+ypos);
    line(sustain.x*s+xpos, h-sustain.y*s+ypos, release.x*s+xpos, h-release.y*s+ypos);
    //dots
    fill(fg);
    ellipse(start.x*s+xpos, h-(start.y*s+ypos), diam, diam);
    ellipse(attack.x*s+xpos, h-(attack.y*s+ypos), diam, diam);
    ellipse(decay.x*s+xpos, h-(decay.y*s+ypos), diam, diam);
    ellipse(sustain.x*s+xpos, h-(sustain.y*s+ypos), diam, diam);
    ellipse(release.x*s+xpos, h-(release.y*s+ypos), diam, diam);
    
    //coordinates
    
    text("atk(" + attack.x +"," + attack.y +")", (attack.x*s+xpos), (h-attack.y*s+ypos));
    text("decay(" + decay.x +"," + decay.y +")", (decay.x*s+xpos), (h-decay.y*s+ypos));
  }
  
  void updateR(){
    release.x = map(mouseX, 0, width, 0, 3);
    release.x = constrain(release.x, sustain.x, 3);
  }
  

}