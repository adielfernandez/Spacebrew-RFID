/*
This sketch controls the servos attached to an electric kettle as
well as a teabag and sugar releasing device.

On button servo     pin 9       (100 deg = rest, 130 deg for 600ms = press on)
pour servo          pin 10      (45 deg = not pour, 80 deg = pour)
sugar servo         pin 11      (0 deg = pullback, 180 deg = block sugar cubes)
tea servo           pin 12      (move forward at servo val = 99 until teabag detected)

IR Detector         pin A0
IR Emitter          (not attached to IO pin, always on)

 Serial Data parsing taken from Greg Borenstein
 https://gist.github.com/atduskgreg/1349176


by Adiel Fernandez and Stephanie Burgess, March 2014 
 

*/



//Import servo library
#include <Servo.h>


//This array will receive values from processing
int values[] = {0,0,0};

//counter to help us loop through values[] array
int currentValue = 0;

//create servo objects
Servo ONServo;
Servo POURServo;
Servo sugarServo;
Servo teaServo;

//servo states (i.e. degree values for behaviors)
//NOTE: you will have to change these values to 
//ones that correspond to your servos!

//for on/off servo
int ON = 130;
int OFF = 100;

//for pour control servo
int POUR = 80;
int notPOUR = 35;

//for tea dispenser servo
int TURN = 99;
int STOP = 90;

//for sugar cube servo
int BLOCK = 180;
int PULLBACK = 0;


//Infrared sensor for detecting dropped teabag
int IRPin = A0;
int IRVal = 0;
int IRThreshold = 700;

//Some booleans that help us control what is going on
boolean makeTea = false;
boolean bagDropped = false;


//how much time to wait for the water to heat before pouring
int heatTime = 55000;

//How long to keep the pouring valve open
int pourTime = 13000;

//The number of sugars to drop in a given cup
int numSugars = 0;



void setup(){
  //open the serial port for debugging purposes
  Serial.begin(9600);
  
  //attach servos to their pins
  ONServo.attach(9);
  POURServo.attach(10);
  sugarServo.attach(11);
  teaServo.attach(12);

  //set default states
  ONServo.write(OFF);
  POURServo.write(notPOUR);
  sugarServo.write(BLOCK);
  teaServo.write(STOP);

  pinMode(debugButtonPin, INPUT);

  Serial.println("Teabot Ready");
  
}

void loop(){
  
  //if we have serial data, lets do something with it
  if(Serial.available()){
    //read the information from thes serial buffer
    int incomingValue = Serial.read();

    //store the data in a slot of our array
    values[currentValue] = incomingValue;

    //move to the next spot in the array
    currentValue++;
    
    //if we have all three values
    if(currentValue > 2){
      //start the counter over
      currentValue = 0;

      //and take the first variable as our number of sugars to add
      numSugars = values[0];
      //other variable         = values[1];
      //other other variable   = values[2];
      
      //once we've received all three variables, we're ready to 
      //make the makeTea and bagDropped booleans true
      makeTea = true;
      bagDropped = false;
      
    }
  }  
  
  //if we actually want to make tea:
  if(makeTea){
    
    
    //turn on water heater
    Serial.println("Turning on heater");
    ONServo.write(ON);
    delay(600);
    ONServo.write(OFF);
    
    
    //dispense sugar cube using a for loop depending on numSugars variable
    Serial.println("Dropping Sugar Cubes");
    for(int i = 0; i < numSugars; i++){
      sugarServo.write(PULLBACK);
      delay(500);  
      sugarServo.write(BLOCK);
      delay(750);
    }
  
    //drop teabag
    Serial.println("Looking for teabag...");
    //we use a while loop to make sure we are doing nothing except
    //looking for when a teabag has been dropped to make sure we
    //dont miss it and accidentally drop two
    while(bagDropped == false){
      //turn the continuous rotation servo slowly
      teaServo.write(TURN);
      delay(20);
      //read the IR emitter
      IRVal = analogRead(IRPin);
      
      //if the value falls below a certain threshold (stated above)
      //i.e. a tea bag is blocking the detector, then stop the servo
      //and change the bagDropped boolean so we exit the while loop
      if(IRVal < IRThreshold){
        teaServo.write(STOP);
        bagDropped = true;
        Serial.println("Found one!");
      }
      
    }
  
    //sugar and tea dispensed, wait for the water to heat up
    Serial.println("Waiting for water to heat");
    delay(heatTime);
    
    //once water is heated, pour it into the cup
    Serial.println("Pouring water now");
    POURServo.write(POUR);
    delay(pourTime);
    POURServo.write(notPOUR);
  
    
    Serial.println("Enjoy Your Tea!");
    makeTea = false;
  }
  
  
  
}
