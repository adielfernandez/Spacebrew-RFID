/*
This sketch receives accelerometer data from a XBee connected arduino by listening 
to a serial port connected to an XBee explorer. The sketch then packages the data as
a custom "accel" data type and sends it out via spacebrew.


by Adiel Fernandez
*/

//------------------------------Serial Connection------------------------------
import processing.serial.*;

//Make a serial port object
Serial myPort;                  

//------------------------------Spacebrew Connection------------------------------
import spacebrew.*;

//Allocate space for a Spacebrew object called "sb"
Spacebrew sb;

//Set parameters for spacebrew connection
String server="sandbox.spacebrew.cc";
String name="Joystick reader/sender";
String description ="";

//------------------------------Other------------------------------

// set up JSON to be sent
JSONObject Accel_Data = new JSONObject();

//Two string variables to hold RFID data locally
String incomming = "";
boolean firstContact = false;        // Whether we've heard from the microcontroller

float x, y, z;
boolean firing;

void setup() {
  size(400, 180);
  
  //Fill allocated space with a new Spacebrew connection object
  sb = new Spacebrew( this );
  
  //Create a publisher to send out data to receivers. This app needs no subscribers
  sb.addPublish ("Accel out", "accel", Accel_Data.toString());
  sb.addPublish( "Fire", "boolean", false);
  
  
  //Start the connection to the server
  sb.connect(server, name, description);

  // List all the available serial ports
  printArray(Serial.list());

  // Choose the proper serial port from the list printed and insert number between square brackets
  myPort = new Serial(this, Serial.list()[10], 9600);

  //Sets up sketch to read bytes into a buffer until a linefeed (ASCII 10) is found
  //Then the sketch runs the serialEvent function found below
  myPort.bufferUntil('\n');
  
}



void draw() {
  
  background(0);
  
  //print values in window instead of to console
  textSize(30);
 
  fill(255, 255, 0);
  text("X: " + x, 20, 40);
  fill(0, 255, 0);
  text("Y: " + y, 20, 70);
  fill(0, 0, 255);
  text("Z: " + z, 20, 100);
  
  textSize(40);
  if(firing){
    fill(255, 0, 0);
    text("Firing!", 20, 150);
  } else {
    fill(255);
    text("Not Firing", 20, 150);    
  }


  //graph the accelerometer values on screen
  float graphX = map(x, -1, 1, height - 20, 20);
  float graphY = map(y, -1, 1, height - 20, 20); 
  float graphZ = map(z, -1, 1, height - 20, 20); 
  
  rectMode(CORNERS);
  fill(255, 255, 0);
  rect(300, height/2, 320, graphX);
  fill(0, 255, 0);
  rect(330, height/2, 350, graphY);
  fill(0, 0, 255);
  rect(360, height/2, 380, graphZ);


}




// serialEvent method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup()

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  incomming = myPort.readStringUntil('\n');

  //This line trims whitespace (unnecessary characters like spaces and linefeeds) from the string
  incomming = trim(incomming);
  
  // split the string at the commas
  // and convert the sections into integers:
  float accelVals[] = float(split(incomming, ','));



  //normalize values as floats from -1 to 1
  for(int i = 0; i < 3; i++){
    //normalize values as floats from -1 to 1 
    accelVals[i] = map(accelVals[i], -1000, 1000, -1, 1);
    
    //constrain the values from -1 to 1 (in case the joystick is shaken, i.e. high accelerometer values)
    accelVals[i] = constrain(accelVals[i], -1, 1);
  }
  
  
  //keep Values locally for printing to screen 
  //use nf() to format it (1 digit before decimal, 3 after)
  //then cast it as a float instead of the incomming string format
  x = float(nf(accelVals[0], 1, 3));
  y = float(nf(accelVals[1], 1, 3));
  z = float(nf(accelVals[2], 1, 3));
  
  
  //packages accelerometer values into JSON object
  Accel_Data.setFloat("x", accelVals[0]);
  Accel_Data.setFloat("y", accelVals[1]);
  Accel_Data.setFloat("z", accelVals[2]);

  
  //sends accelerometer JSON object out via spacebrew
  sb.send("Accel out", "accel", Accel_Data.toString());
  
  //send out firing boolean and set local boolean as well
  if(int(accelVals[3]) == 1){
    sb.send("Fire", true);  
    firing = true;
  } else {
    sb.send("Fire", false);
    firing = false;
  }
  
}

