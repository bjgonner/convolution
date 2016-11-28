int inByte = 0;         // incoming serial byte
int knobs[6];
#if defined(ARDUINO_SAMD_ZERO) && defined(SERIAL_PORT_USBVIRTUAL)
  // Required for Serial on Zero based boards
  #define Serial SERIAL_PORT_USBVIRTUAL
#endif

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}


void readKnobs(int k[], int theSize){
  for(int i = 0; i < theSize; i++){
      analogRead(i);
      k[i] = analogRead(i);
    }
}

void serialComm(){
   // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    if(inByte == 'A'){
      //convert analog input to byte array
      //and send out
      byte bytes[sizeof(knobs)/2];
      for(int i = 0; i < sizeof(bytes); i+=2){
        bytes[i] = highByte(knobs[i/2]);
        bytes[i+1] = lowByte(knobs[i/2]);
      }
      // send sensor values:
      Serial.write(bytes, sizeof(bytes));
    }
  }
}

