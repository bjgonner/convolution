/*
  Analog input, analog output, serial output

 Reads an analog input pin, maps the result to a range from 0 to 255
 and uses the result to set the pulsewidth modulation (PWM) of an output pin.
 Also prints the results to the serial monitor.

 The circuit:
 * potentiometer connected to analog pin 0.
   Center pin of the potentiometer goes to the analog pin.
   side pins of the potentiometer go to +5V and ground
 * LED connected from digital pin 9 to ground

 created 29 Dec. 2008
 modified 9 Apr 2012
 by Tom Igoe

 This example code is in the public domain.

 */

// These constants won't change.  They're used to give names
// to the pins used:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int analogOutPin = 9; // Analog output pin that the LED is attached to
const int analogPins[5] = {A0, A1, A2, A3, A4};

int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)

int sensVal[5];
 int len = sizeof(sensVal)/sizeof(int);

void setup() {
  // initialize serial communications at 9600 bps:
  SerialUSB.begin(9600);
  analogReadResolution(12);
}

void loop() {
  // read the analog in value:
 //sensorValue = analogRead(9);
 //SerialUSB.println(sensorValue);
  // map it to the range of the analog out:
 // outputValue = map(sensorValue, 0, 1023, 0, 255);
  // change the analog out value:
 // analogWrite(analogOutPin, outputValue);
   
    readSensors(sensVal, len);
    printSensors(sensVal, len);
  // print the results to the serial monitor:
 

  // wait 2 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(50);
}

void readSensors(int _sensVal[], int n){
  for(int i=0; i < n; i++){
  _sensVal[i] = analogRead(analogPins[i]);
  delay(1);
  }
  
}

void printSensors(int _sensVal[], int n){
  for(int i=0; i < n; i++){
    SerialUSB.print(" S: ");
    SerialUSB.print(i);
    SerialUSB.print(" V: ");
    SerialUSB.print(_sensVal[i]);
  
  }
  SerialUSB.println();
}

