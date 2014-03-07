/*
This sketch receives a custom "accel" data type via spacebrew. The accel type
contains three axes of accelerometer data: x, y and z.

The sketch then sets the position of tw pan/tilt servos depending on accelerometer
input and will "fire" laser pointers based on the fire boolean, also triggered via spacebrew.

by Adiel Fernandez

*/

//------------------------------Serial Connection------------------------------
import processing.serial.*;

//Make a serial port object
Serial port;             


//------------------------------Spacebrew Connection------------------------------
import spacebrew.*;

//Allocate space for a Spacebrew object called "sb"
Spacebrew sb;

//Set parameters for spacebrew connection
String server = "sandbox.spacebrew.cc";
String name = "Turret controller";
String description = "Receives JSON formatted accelerometer data";


float x, y, z;
float pan = 90; 
float tilt = 90;
int firing = 0;




void setup(){
  size(420,180);
  
  //Fill allocated space with a new Spacebrew connection object
  sb = new Spacebrew( this );
  
  //Create a subscriber to receive RFID data from the publisher. This app needs no publishers
  sb.addSubscribe ("Accel in", "accel");
  sb.addSubscribe ("Fire", "boolean");

  //Start the connection to the server
  sb.connect(server, name, description);
  

  // List all the available serial ports
  printArray(Serial.list());

  // Choose the proper serial port from the list printed and insert number between square brackets
  port = new Serial(this, Serial.list()[11], 9600);
}

void draw(){
  
  background(255);

  //print values in window instead of to console
  textSize(30);
 
  fill(0);
  text("X: " + x, 20, 40);
  text("Y: " + y, 20, 70);
  text("Z: " + z, 20, 100);
  
  textSize(40);
  if(firing == 1){
    fill(255, 0, 0);
    text("Firing!", 20, 150);
  } else {
    fill(0);
    text("Not Firing", 20, 150);    
  }
  
  

  if(z > 0.5 && pan > 0){
    pan -= 1.2;
  } else if(z < -0.5 && pan < 180){
    pan += 1.2;
  }
  
  pan = constrain(pan, 0, 180);
  tilt = map(y, -1, 1, 45, 160);


  sendData(round(pan), round(tilt), firing);  


}



void sendData(int _pan, int _tilt, int _fire) {
  // load up all the values into a byte array
  // then send the full byte array out over serial
  // NOTE: This only works for values from 0-255  
  byte out[] = new byte[3];
  out[0] = byte(_pan);
  out[1] = byte(_tilt);
  out[2] = byte(_fire);
  port.write(out);
  println(_pan + ", " + _tilt + ", " + _fire);
}


//Receives custom message from spacebrew
void onCustomMessage( String name, String type, String value ){
  //check to see if the data type matches the RFID type we want to receive 
  if ( type.equals("accel") ){
    
    // Take data from the incomming JSON object and store them locally into variables we can use  
    JSONObject m = JSONObject.parse( value );
    x = m.getFloat("x");
    y = m.getFloat("y");
    z = m.getFloat("z");
  }
  
}

//Receives boolean message from spacebrew
void onBooleanMessage( String name, boolean value ){

  //Store the received boolean value locally
  if (value == true) {
    firing = 1;
  } else {
    firing = 0;
  }
  
}
