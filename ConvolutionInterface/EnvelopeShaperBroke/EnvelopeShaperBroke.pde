EnvelopeShaper env;
void setup(){
  size(1000,1000);
  env = new EnvelopeShaper(0,0,500,200,255,0xbbff00ff);
  
  
}


void draw(){
  background(0);
  env.drawEnvelope(0,0,10);
  //env.updateR();
}

  void mouseDragged(){
    float distance = dist(env.attack.x*env.w/4, env.h-env.attack.y*env.w/4, mouseX, mouseY);
   if(distance < 20){
    
     env.attack.x = mouseX/env.w/4;
     env.attack.y = mouseY/env.w/4;
    
    println(env.attack.y);
    }
  }