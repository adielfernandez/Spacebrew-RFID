/*
This sketch controls an automated tea making system. It receives a message via 
spacebrew containing how many cubes a sugar the person would like in their tea.
Once it recieves this message it passes the number to the arduino so that it can
make the tea (with the appropriate number of sugar cubes.

by Adiel Fernandez and Stephanie Burgess

"sendData()" function taken from Greg Borenstein
 https://gist.github.com/atduskgreg/1349176


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
String name = "Teabot Controller";
String description = "Receives number of sugar cubes desired then makes tea";

int numSugars = 0;


void setup(){
  size(420,180);
  
  //Fill allocated space with a new Spacebrew connection object
  sb = new Spacebrew( this );
  
  //Create a subscriber to receive the requested number of sugars desired in the tea. 
  //The first argument is the name of the subscriber we'll be receiving values in later
  //the second is the type of data we want to be set up to receive on this subscriber 
  sb.addSubscribe ("Number of sugars", "string");
  //This app needs no publishers for now


  //Start the connection to the server based on the parameters set above
  sb.connect(server, name, description);
  

  // List all the available serial ports in the console so we can see which one we need to connect to
  printArray(Serial.list());

  // Choose the proper serial port from the list printed and insert number between square brackets
  port = new Serial(this, Serial.list()[9], 9600);
}

void draw(){
  
  background(255);

  //print values in small window instead of to console
  textSize(30);
  fill(0);
  text("Recieved string: " + numSugars, 20, 40);


  //check onStringMessage function for code that sends data to arduino

}



//Receives string message from spacebrew
void onStringMessage( String name, String value ){
  
  //because we only have one subscriber, this if statement is unnecessary, but it shows how you 
  //would distinguish between multiple incomming values if there were more than one subscriber 
  if(name.equals("Number of sugars")){
    
    numSugars = int(value);
    
  }
  

  //This function will send 3 values via serial. 
  //We are only using one for now, but there is space  
  //in case we want to add more functionality later
  sendData(numSugars, 0, 0);  
  
  //Note because the arduino sketch is set up to make tea whenever it gets a message
  //we place the sendData command in here so it only sends to arduino when processing 
  //actually gets a message to make tea

}




void sendData(int first, int second, int third) {
  // load up all the values into a byte array
  // then send the full byte array out over serial
  // NOTE: This only works for values from 0-255  
  byte out[] = new byte[3];
  out[0] = byte(first);
  out[1] = byte(second);
  out[2] = byte(third);
  port.write(out);
  
  //print it out for debugging purposes
  println(first + ", " + second + ", " + third);
}
