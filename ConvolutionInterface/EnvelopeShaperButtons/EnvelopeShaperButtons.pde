
EnvShaper sup;
void setup(){
  size(600,600);
  sup = new EnvShaper(5,100,100,300,200, 20);
  
}


void draw(){
  background(0);
  //for(int i = 0; i< balls.length; i++){
  
  
  //if(i<balls.length-1){
  //  line(balls[i].x, balls[i].y, balls[i+1].x, balls[i+1].y);
    
  //}
  //balls[i].disp(5, -1);
  //}
  sup.updateEnvPoints();
  sup.disp();
  
}

void keyPressed(){
  if(key=='a'){
   
    println(sup.envPoints);
  }
}