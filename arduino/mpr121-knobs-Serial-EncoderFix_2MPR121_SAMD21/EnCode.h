class EnCode {
  private:

  int pinA;
  int pinB;
  int buttPin;
  volatile bool currA;
  volatile bool currB;
  volatile bool lastA;
  volatile bool lastB;

  volatile int pos;

  public:

  EnCode(int a, int b, int but);
  int readPins();
};

EnCode::EnCode(int a, int b, int but){
  this->pinA = a;
  this->pinB = b;
  this->buttPin = but;
  this->currA = LOW;
  this->currB = LOW;
  this->lastA = LOW;
  this->lastB = LOW;
  
  pinMode(this->pinA, INPUT_PULLUP); // set pinA as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)
  pinMode(this->pinB, INPUT_PULLUP); // set pinB as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)

  pinMode(this->buttPin, INPUT_PULLUP);
}

int EnCode::readPins(){
   this->currA = digitalRead(this->pinA);
  this->currB = digitalRead(this->pinB);

  if(!this->currA && this->lastA){
    if(this->currB == LOW){
    this->pos++;
    
    }else{
      this->pos--;
      
    }
    
  }
  
  this->lastA = this->currA;
  return this->pos;
}

