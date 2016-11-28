class EnvShaper{
  
  Ball[] vertices;
  float x,y,w,h, vDiam;
  float xOffset, yOffset;
  int vNum;
  FloatList envDefaults;
  FloatList envPoints;
  float tSecs = 5;
  float maxSecs = 15;
  float res = 0.5;
  boolean[] selected;
  int selectedIndex;
  float offset = 5;
  float boarder;
  
 
  EnvShaper(int _vNum, float _x, float _y, float _w, float _h, float _vDiam){
    //how much time for default? 5Sec
    envDefaults = new FloatList();
    envPoints = new FloatList();
    //set defaults to differnet values baes on number of vertices 
    switch(_vNum){
      case 5: 
        envDefaults.append(0.0);  //start
        envDefaults.append(1.0);  //attack
        envDefaults.append(0.5);  //decay
        envDefaults.append(0.3);  //sustain
        envDefaults.append(0.0);  //release
        break;
      case 4:
        envDefaults.append(0.0);  //start
        envDefaults.append(1.0);  //attack
        envDefaults.append(0.5);  //decay
        envDefaults.append(0.0);  //release
        break;
      case 3:
        envDefaults.append(0.0);  //start
        envDefaults.append(1.0);  //attack
        envDefaults.append(0.0);  //decay
        break;
      default:
      envDefaults.append(0.0);
        println("ERROR: too few envelope points");
        break;
    }

    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
    vNum = _vNum;
    vDiam = _vDiam;
    boarder = vDiam/2;
    vertices = new Ball[vNum];
    selected = new boolean[vNum];
    //default x values for envelope are evenly spaced across 5 seconds
    float[] dummy = {0,0};
    float defaultSubs = w/vertices.length;
    for(int i = 0; i< vertices.length; i++){
      
      //init vertices
      vertices[i] = new Ball(i*defaultSubs,h-(envDefaults.get(i)*h),vDiam);
      //init selected state of each vert
      selected[i] = false;
      //adjust values for x,y != 0
      vertices[i].x += x;
      vertices[i].y += y;
      //init envPoints
      envPoints.append(dummy);
    }
    println(envPoints);
  }
  
  void disp(){
    color fillc = color(128);
    color strokec = color(190);
   fill(fillc);
   stroke(strokec);
   strokeWeight(1);
   rect(x-boarder,y-boarder,w+2*boarder,h+2*boarder);
   updateTsecs();
    for(int i=0; i<=int(w); i+=w/tSecs){
      for(int j=0; j <=h; j+=h/10){
        line(i+x,j+y,i+x,h+y);  //vertical
        line(0+x,j+y,w+x,j+y);  //horizontal
      }
    }
    line(w+x, y, w+x, y+h);
    strokec = color(255,255,0);
    stroke(strokec);
    for(int i = 0; i<vertices.length; i++){
      if(i<vertices.length-1){
      line(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y);
    
  }
    
      noStroke();
      vertices[i].disp(offset, i, this);
      String xVal = nf(map(vertices[i].x, x, w+x, 0, tSecs),1,3);
      String yVal = nf(map(vertices[i].y, h+y, y, 0,1),1,3);
      text("("+ xVal+","+yVal+")",vertices[i].x+10,vertices[i].y );
      stroke(strokec);
  }
  
  }
  
  void updateTsecs(){
    //if the final vertex is equal to the width scale timeline by 1 second(more time)
    //may change to plus and minus buttons
    if(vertices[vertices.length-1].x == w+x && tSecs != maxSecs){
      for(int i = 0; i < vertices.length; i++){
        if(vertices[i].x <= x) vertices[i].x = x;
        else vertices[i].x = envPoints.get(i*2) * w/(tSecs+1) +x;
        
      }
      //stop runaway expansion
      if(tSecs >= maxSecs) tSecs = maxSecs;
      else tSecs++;
      vertices[vertices.length-1].x += w/tSecs-10;
    }
    //if it is at the next lower subdivision scale timeline by 1 second (less time)
    if(vertices[vertices.length-1].x < ((tSecs-1)*(w+x)/tSecs-offset)){
      for(int i = 0; i < vertices.length; i++){
        if(i==0) vertices[i].x = x;
        else vertices[i].x = envPoints.get(i*2) * w/(tSecs-1)+x;
      }
      //stop runaway shrink
      if(tSecs < 1) tSecs = 1;
      else tSecs--;
    }
  }
  
  void updateEnvPoints(){
   for(int i=0; i<envPoints.size(); i+=2){
    
     envPoints.set(i, map(vertices[i/2].x, x, w+x, 0, tSecs));
     envPoints.set(i+1, map(vertices[i/2].y, h+y, y, 0,1));
    
    }
  }
  
}