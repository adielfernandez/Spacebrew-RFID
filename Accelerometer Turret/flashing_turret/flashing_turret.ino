/* 

 This code receives values from processing and uses them to
 control a laser turrent on a pan-tilt servo rig.
 
 Wiring:
 Pan servo on pin 5
 Titl servo on pin 6
 
 Two laser diodes on pins 9 and 10 via p2n2222a transistor
 
 Serial Data parsing taken from Greg Borenstein
 https://gist.github.com/atduskgreg/1349176
 
 
 
 */


//add servo library
#include <Servo.h> 

//name servo objects
Servo panServo;
Servo tiltServo;

//This array will receive values from processing
int values[] = {90,90,0};

//counter to help us loop through values[] array
int currentValue = 0;

//variables to hold turret data
int pan = 0;
int tilt = 0;
int firing = 0;

//laser diodes on pins:
int laser1 = 9;
int laser2 = 10;

//Variables to control blinking of lasers
boolean flashState = false;
long currentTime = 0;
long prevTime = 0;
int duration = 100;



void setup()  {
  //Open connection to serial port
  Serial.begin(9600);

  //attach pins 5 and 6 to their servo objects
  panServo.attach(5);
  tiltServo.attach(6);
  
  //set pinmodes
  pinMode(laser1, OUTPUT);
  pinMode(laser2, OUTPUT);

}


void loop() {   
  
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

      //and put the 3 values in our local variables
      pan = values[0];
      tilt = values[1];
      firing = values[2];
    }
  }

  //write pan and tilt values to servos
  panServo.write(pan);
  tiltServo.write(tilt);
  
  //if we're not getting a fire command (firing = 1), tell lasers to chill
  if(firing == 0){
    //if we're supposed to be off, leave lights off
    digitalWrite(laser1, LOW);
    digitalWrite(laser2, LOW); 
    
    
  } else {
    
    //if we're supposed to be on, use timers to turn the lights on and off in sequence
    //note current time:
    currentTime = millis();
    
    //if the time noted in the duration variable has passed since the last time 
    //we checked the time, flip the flashState boolean
    if(currentTime - prevTime > duration){
      flashState = !flashState;
      prevTime = currentTime;
    }

    //the flashState boolean tells one laser to be on or the other.
    //Using the timer to switch the boolean causes the lasers to flip back and forth quickly
    if(flashState){
      digitalWrite(laser1, HIGH);
      digitalWrite(laser2, LOW);    
    } else {
      digitalWrite(laser1, LOW);
      digitalWrite(laser2, HIGH);    
    }
    
   
  }




} 

