class EnvShaper{
  
  Ball[] vertices;
  float x,y,w,h, vDiam;
  int vNum;
  FloatList envDefaults;
  float tSecs = 5;
  float maxSecs = 15;
  float res = 0.5;
  boolean[] selected;
  int selectedIndex;
  float offset = 5;
 
  EnvShaper(int _vNum, float _x, float _y, float _w, float _h, float _vDiam){
    //how much time for default? 5Sec
    envDefaults = new FloatList();
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
    vertices = new Ball[vNum];
    selected = new boolean[vNum];
    float defaultSubs = w/vertices.length;
    for(int i = 0; i< vertices.length; i++){
      vertices[i] = new Ball(i*defaultSubs,h-(envDefaults.get(i)*h),vDiam);
      selected[i] = false;
    }
  }
  
  void disp(){
    color fillc = color(128);
    color strokec = color(190);
   fill(fillc);
   stroke(strokec);
   strokeWeight(1);
   rect(x,y,w,h);
   updateTsecs();
    for(int i=int(w); i>=0; i-=w/tSecs){
      for(int j=0; j <=h; j+=h/10){
        line(i,j,i,h);
        line(0,j,w,j);
      }
    }
    strokec = color(255,255,0);
    stroke(strokec);
    for(int i = 0; i<vertices.length; i++){
      if(i<vertices.length-1){
      line(vertices[i].x, vertices[i].y, vertices[i+1].x, vertices[i+1].y);
    
  }
    
      noStroke();
      vertices[i].disp(offset, i, this);
      stroke(strokec);
  }
  
  }
  
  void updateTsecs(){
    if(vertices[vertices.length-1].x == w){
      for(int i = 0; i < vertices.length; i++){
        vertices[i].x = map(vertices[i].x/tSecs, 0, w/tSecs, 0, w/(tSecs+1))*(tSecs);
      }
      tSecs++;
      if(tSecs >= maxSecs) tSecs = maxSecs;
    }
    if(vertices[vertices.length-1].x < ((tSecs-1)*w/tSecs-offset)){
      for(int i = 0; i < vertices.length; i++){
        vertices[i].x = map(vertices[i].x/tSecs, 0, w/tSecs, 0, w/(tSecs-1))*(tSecs);
      }
      tSecs--;
      if(tSecs < 1) tSecs = 1;
    }
  }
}