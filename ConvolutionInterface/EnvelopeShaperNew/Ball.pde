class Ball{
  
  float x,y,diam;
  
  Ball(float _x, float _y, float _diam){
    x = _x;
    y = _y;
    diam = _diam;
  }
  
  void disp(float offset, int i, EnvShaper s){
   // printArray(s.selected);
    if(isOver(mouseX, mouseY, offset) && mousePressed && checkOtherSelected(s, i)==false){
      
      s.selected[i] =true;
      
     x = mouseX;
     y = mouseY;
     //boundary check
     if(mouseX > s.w) x = s.w;
     if(mouseX < 0) x =0;
     if(mouseY > s.h) y = s.h;
     if(mouseY < 0) y = 0;
     //println(i);
     if(i != -1){
       if(i!=0){
         if(x - s.vertices[i-1].x <= 1) x = s.vertices[i-1].x+1;
         
       }
      if(i< s.vertices.length-1){
       if(s.vertices[i+1].x - x <= 1) x = s.vertices[i+1].x-1;
      }
     }
     fill(255);
     
    }else{
      fill(255,255,0);
      s.selected[i] = false;
    }
   
    ellipse(x,y,diam,diam);
  }
  
  boolean isOver(float mx, float my, float _offset){
   if (mx > x-diam/2-_offset &&
       mx < x+diam/2+_offset &&
       my > y-diam/2-_offset &&
       my < y+diam/2+_offset)
       {
         return true;
       }else{
         return false;
       }
  }
       
  boolean checkOtherSelected(EnvShaper _s, int _i){
    //if this one is selected no other can be so return false
    if(_s.selected[_i]){
      return false;
    }
    else{
      //check all balls return true if any selected
      for (int j = 0; j < _s.selected.length; j++){
          if(_s.selected[j]) return true;
      }
    //if none are selected return false
    return false;
    }
  }
  
}
  
  
    