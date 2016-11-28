class Ball{
  
  float x,y,diam;
  color c;
  
  Ball(float _x, float _y, float _diam){
    x = _x;
    y = _y;
    diam = _diam;
    c = 0xffffff00;
  }
  
  Ball(float _x, float _y, float _diam, color _c){
    x = _x;
    y = _y;
    diam = _diam;
    c = _c;
  }
  
  void disp(float offset, int i, EnvShaper s){
   // printArray(s.selected);
    if(isOver(mouseX, mouseY, offset) && mousePressed && checkOtherSelected(s.selected, i)==false){
      
      s.selected[i] =true;
      
     x = mouseX;
     y = mouseY;
     //boundary check
     if(mouseX > s.w+s.x) x = s.w+s.x;
     if(mouseX < 0+s.x)   x = 0+s.x;
     if(mouseY > s.h+s.y) y = s.h+s.y;
     if(mouseY < 0+s.y)   y = 0+s.y;
     //println(i);
     if(i != -1){
       if(i!=0){
         if(x - (s.vertices[i-1].x) <= 1) x = (s.vertices[i-1].x)+1;
         
       }
      if(i< s.vertices.length-1){
       if((s.vertices[i+1].x) - x <= 1) x = (s.vertices[i+1].x)-1;
      }
     }
     fill(255);
     
    }else{
      fill(c);
      s.selected[i] = false;
    }
   
    ellipse(x,y,diam,diam);
  }
  
  void dispButt(float offset, int i, EnvShaper s){
   // printArray(s.selected);
    if(isOver(mouseX, mouseY, offset) && mousePressed && checkOtherSelected(s.buttClicked, i)==false){
      
      s.buttClicked[i] =true;
     fill(255);
     
    }else{
      fill(c);
      s.buttClicked[i] = false;
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
       
  boolean checkOtherSelected(boolean[] a, int _i){
    //if this one is selected no other can be so return false
    if(a[_i]){
      return false;
    }
    else{
      //check all balls return true if any selected
      for (int j = 0; j < a.length; j++){
          if(a[j]) return true;
      }
    //if none are selected return false
    return false;
    }
  }
  
}
  

    