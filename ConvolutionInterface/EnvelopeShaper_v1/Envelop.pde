class EnvelopeShaper{
 
  PVector start;
  PVector attack;
  PVector decay;
  PVector sustain;
  PVector release;
  //PVector end;
  
  
  EnvelopeShaper(){
   start = new PVector(0,0);
   attack = new PVector(1,1);
   decay = new PVector(1.5, 1.0);
   sustain = new PVector(2.0, 0.5);
   release = new PVector(3.0, 0);  
  }
  
  void drawEnvelope(float s, float x, float y, color c, float diam){
    stroke(c);
    strokeWeight(5);
    noFill();
    
    line(start.x*s, start.y*s, attack.x*s, attack.y*s);
    line(attack.x*s, attack.y*s, decay.x*s, decay.y*s);
    line(decay.x*s, decay.y*s, sustain.x*s, sustain.y*s);
    line(sustain.x*s, sustain.y*s, release.x*s, release.y*s);
    ellipse(attack.x*s, attack.y*s, diam, diam);
    ellipse(decay.x*s, decay.y*s, diam, diam);
    ellipse(sustain.x*s, sustain.y*s, diam, diam);
    ellipse(release.x*s, release.y*s, diam, diam);
  }
  
  void updateR(){
    release.x = map(mouseX, 0, width, 0, 3);
    release.x = constrain(release.x, sustain.x, 3);
  }
}