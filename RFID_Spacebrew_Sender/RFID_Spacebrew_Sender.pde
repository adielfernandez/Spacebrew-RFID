/*
This sketch receives string data from an arduino connected to an RFID reader
and sends it (along with a timestamp) via spacebrew in a custom data type.

Serial Event code adapted from arduino reference code found here:
http://arduino.cc/en/Tutorial/SerialCallResponseASCII

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
String name="RFID Reader";
String description ="";

//------------------------------Other------------------------------

// set up JSON to be sent
JSONObject RFID_Data = new JSONObject();

//Two string variables to hold RFID data locally
String incomming = "";
String timeStamp = "";



void setup() {
  size(500, 150);
  
  //Fill allocated space with a new Spacebrew connection object
  sb = new Spacebrew( this );
  
  //Create a publisher to send out data to receivers. This app needs no subscribers
  sb.addPublish ("RFID out", "rfid", RFID_Data.toString());
  
  //Start the connection to the server
  sb.connect(server, name, description);

  // List all the available serial ports
  println(Serial.list());

  // Choose the proper serial port from the list printed and insert number between square brackets
  myPort = new Serial(this, Serial.list()[9], 9600);

  //Sets up sketch to read bytes into a buffer until a linefeed (ASCII 10) is found
  //Then the sketch runs the serialEvent function found below
  myPort.bufferUntil('\n');
  
}



void draw() {
  
  background(0);
  
  //----------displays Title and most recently scanned RFID data----------

  //Title
  fill(255);
  textAlign(LEFT, TOP);
  textSize(26);
  text("Read RFID, send via Spacebrew", 20, 10);

  //Title underline
  stroke(255);
  strokeWeight(3);
  line(20, 45, 400, 45);

  //display data text
  textSize(20);
  fill(255, 0, 0);
  text("Tag #:             " + incomming, 20, 60);
  text("Timestamp:    " + timeStamp, 20, 90);


}




// serialEvent method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup()

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  incomming = myPort.readStringUntil('\n');
  
  //stuff to make time stamp formatting pretty
  String hourStr = "";
  String minStr = "";
  String secStr = "";

  //If the hour, minute or second values are in single digits, add a 0 so they display as double
  //i.e. 4:5:9 will display as 04:05:09
  if(hour() < 10){
    hourStr = "0" + hour();
  } else {
    hourStr = "" + hour();
  }  
  if(minute() < 10){
    minStr = "0" + minute();
  } else {
    minStr = "" + minute();
  }
  if(second() < 10){
    secStr = "0" + second();
  } else {
    secStr = "" + second();
  }

  
  //note the time and date the ID was received and store it in timeStamp variable 
  timeStamp = hourStr + ":" + minStr + ":" + secStr + " on " + month() + "/" + day() + "/" + year();
  
  //This line trims whitespace (unnecessary characters like spaces and linefeeds) from the string
  incomming = trim(incomming);
  
  //packages ID and timestamp into JSON object
  RFID_Data.setString("id", incomming);
  RFID_Data.setString("timestamp", timeStamp);  

  //sends JSON object out via spacebrew
  sb.send("RFID out", "rfid", RFID_Data.toString());
  
  
  
  //print for debug purposes
//  print(timeStamp + "    " + incomming);
    
}

