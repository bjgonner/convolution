EnvelopeShaper env;
void setup(){
  size(1000,1000);
  env = new EnvelopeShaper();
  
  
}


void draw(){
  background(0);
  env.drawEnvelope(width/3,0,0,255,10);
  env.updateR();
}