/*
  Serial Call and Response
 Language: Wiring/Arduino

 This program sends an ASCII A (byte of value 65) on startup
 and repeats that until it gets some data in.
 Then it waits for a byte in the serial port, and
 sends three sensor values whenever it gets a byte in.

 Thanks to Greg Shakar and Scott Fitzgerald for the improvements

   The circuit:
 * potentiometers attached to analog inputs 0 and 1
 * pushbutton attached to digital I/O 2

 Created 26 Sept. 2005
 by Tom Igoe
 modified 24 April 2012
 by Tom Igoe and Scott Fitzgerald

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/SerialCallResponse

 */
String serialData = "";
int inByte = 0;         // incoming serial byte
int knobs[6];
#if defined(ARDUINO_SAMD_ZERO) && defined(SERIAL_PORT_USBVIRTUAL)
  // Required for Serial on Zero based boards
  #define Serial SERIAL_PORT_USBVIRTUAL
#endif

void setup() {
  // start serial port at 9600 bps:
  Serial.begin(1843200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  establishContact();  // send a byte to establish contact until receiver responds
  analogReadResolution(12);
}

void loop() {
  //serialComm();
  readKnobs(knobs, sizeof(knobs)/sizeof(int));
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}


void readKnobs(int k[], int theSize){
  serialData = "\\knobs ";
  for(int i = 0; i < theSize; i++){
      analogRead(i);
      k[i] = analogRead(i);
      serialData += String(k[i]) + " ";
    }
    serialData += "\n";
    Serial.clear();
    Serial.print(serialData);
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

/*
Processing sketch to run with this example:

// This example code is in the public domain.

import processing.serial.*;

int bgcolor;			     // Background color
int fgcolor;			     // Fill color
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;		             // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  size(256, 256);  // Stage size
  noStroke();      // No border on the next thing drawn

  // Set the starting position of the ball (middle of the stage)
  xpos = width/2;
  ypos = height/2;

  // Print a list of the serial ports for debugging purposes
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ypos = serialInArray[1];
      fgcolor = serialInArray[2];

      // print the values (for debugging purposes only):
      println(xpos + "\t" + ypos + "\t" + fgcolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
*/

