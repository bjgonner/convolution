import processing.serial.*;

int bgcolor =255;           // Background color
int fgcolor = 0;           // Fill color
Serial myPort;                       // The serial port
char[] serialInArray = new char[12];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;                 // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  size(256, 256);  // Stage size
  noStroke();      // No border on the next thing drawn

  // Set the starting position of the ball (middle of the stage)
  xpos = width/2;
  ypos = height/2;

  // Print a list of the serial ports for debugging purposes
  // if using Processing 2.1 or later, use Serial.printArray()
  printArray(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 1843200);
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
    serialInArray[serialCount] = char(inByte);
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 11 ) {
     
        xpos = serialInArray[0] << 8 | serialInArray[1];
        xpos = int(map(xpos, 0, 4096, 0, width));
      ypos = serialInArray[2] << 8 | serialInArray[3];
      ypos = int(map(ypos, 0, 4096, 0, height));
      fgcolor = serialInArray[4] << 8 | serialInArray[5];
      fgcolor = int(map(fgcolor, 0, 4096, 0, 255));
      // print the values (for debugging purposes only):
      
      println("xpos: " + xpos + " ypos: " + ypos);
      //printArray(serialInArray);
      // Send a capital A to request new sensor readings:
     // myPort.clear(); 
      myPort.write('A');
      
      // Reset serialCount:
      serialCount = 0;
    }
  }
}