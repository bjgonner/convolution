/**
 * oscP5message by andreas schlegel
 * example shows how to create osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

float[] knobs;
int[] beats;

OscP5 oscP5;
NetAddress supercollider;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  supercollider = new NetAddress("127.0.0.1",57120);
  knobs = new float[6];
  beats = new int[32];
  
  for(int i = 0; i<knobs.length; i++) knobs[i] = 0.0;
  for(int i = 0; i<beats.length; i++) beats[i] = 0;
}


void draw() {
  background(0);  
}

void mousePressed() {
  for(int i = 0; i<beats.length; i++){
    if(random(1) < 0.7) beats[i] = 1;
    else beats[i] = 0;
  }
  
  for(int i = 0; i<knobs.length; i++) knobs[i] = random(5);
  //printArray(knobs);
  
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage msg = new OscMessage("/test");
  
  msg.add(beats); /* add an int to the osc message */
  msg.add("end of arrary");
  msg.add(knobs); /* add a float to the osc message */
  

  /* send the message */
  oscP5.send(msg, supercollider); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}