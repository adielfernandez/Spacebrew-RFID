/*
This sketch receives a custom "rfid" data type via spacebrew. The rfid type
contains an RFID "tag" (a 12 digit alphanumeric string) and a timestamp to indicate when the
"user" last scanned in.

The sketch then checks the incomming rfid tag against a "database" of known user tags
and displays the information associated with that user, in this case, the name and an image.

by Adiel Fernandez

*/

//------------------------------Spacebrew Connection------------------------------
import spacebrew.*;

//Allocate space for a Spacebrew object called "sb"
Spacebrew sb;

//Set parameters for spacebrew connection
String server = "sandbox.spacebrew.cc";
String name = "RFID Data Reciever";
String description = "Receives JSON formatted RFID data";

//User "database". Arrays to hold names, RFID tags and images.
String people[] = {"Doge","Joseph Ducreux","Nicholas Cage","Grumpy Cat","Disaster Girl"};
String tags[] = {"50005C8A7EF8","50005C9EB220","50005BC23BF2","50005C2D99B8","50005B869F12"};
PImage images[] = new PImage[5];


//strings to hold RFID data locally
String RFID_Tag = "";
String timeStamp = "";

//Get a nice font for text
PFont type;

//Keep track of the current user being displayed
int currentUser = 0;

//Boolean to help us know when we've got our first user
//and to make sure we dont display anything before that
boolean bHasUser = false;


void setup(){
  size(1024,768);
  
  //Fill allocated space with a new Spacebrew connection object
  sb = new Spacebrew( this );
  
  //Create a subscriber to receive RFID data from the publisher. This app needs no publishers
  sb.addSubscribe ("RFID in", "rfid");

  //Start the connection to the server
  sb.connect(server, name, description);
  
  //load fonts and images
  type = loadFont("AmericanTypewriter-24.vlw");
  images[0] = loadImage("doge.png");
  images[1] = loadImage("ducreux.png");
  images[2] = loadImage("cage.png");
  images[3] = loadImage("grumpycat.png");
  images[4] = loadImage("disastergirl.png");
  
}

void draw(){
  
  background(255);
  
  //visual formatting stuff
  int leftMargin = 40;
  int topMargin = 50;
  int lineSpacing = 35;
  
  textFont(type, 24);
  textAlign(LEFT, TOP);
  
  //Only display data if we have actually received data about a particular user
  //This boolean starts false and is made true in the onCustomMessage() function below
  if(bHasUser){
    fill(255, 0, 0);
    text(people[currentUser], leftMargin, topMargin + lineSpacing);
    text(tags[currentUser], leftMargin, topMargin + lineSpacing * 3);
    text(timeStamp, leftMargin, topMargin + lineSpacing * 5);
    image(images[currentUser], width - leftMargin - images[currentUser].width, topMargin);
  }


  //Display names of data fields
  fill(0);
  text("User Name:", leftMargin, topMargin);
  text("ID Number:", leftMargin, topMargin + lineSpacing * 2);
  text("Last Scanned:", leftMargin, topMargin + lineSpacing * 4);
    
  //draw image border
  noFill();
  if(bHasUser){
    stroke(255, 0, 0);
  } else {
    stroke(0); 
  }
  strokeWeight(10);
  rect(width - leftMargin - images[currentUser].width, topMargin, images[currentUser].width, images[currentUser].height); 

}


void onCustomMessage( String name, String type, String value ){
  //check to see if the data type matches the RFID type we want to receive 
  if ( type.equals("rfid") ){
    
    // Take data from the incomming JSON object and store them locally into variables we can use  
    JSONObject m = JSONObject.parse( value );
    RFID_Tag = m.getString("id");
    timeStamp = m.getString("timestamp");
    
    //check ID against the users we have in the database. 
    //If we find a match flip boolean to display info
    for(int i = 0; i < people.length; i++){
      if(RFID_Tag.equals(tags[i])){
        currentUser = i;
        bHasUser = true;
      }
    }
    

    //Print for debug
    //print("Timestamp: " + timeStamp + "    ID: " + RFID_Tag); 

  }
}
