/*
This sketch controls the servos attached to an electric kettle as
well as a teabag and sugar releasing device.

On button servo     pin 9       (100 deg = rest, 130 deg for 600ms = press on)
pour servo          pin 10      (45 deg = not pour, 80 deg = pour)
sugar servo         pin 11      (0 deg = pullback, 180 deg = block sugar cubes)
tea servo           pin 12      (move forward at servo val = 99 until teabag detected)

IR Detector         pin A0
IR Emitter          (not attached to IO pin, always on)

debugButton         pin 2

*/

#include <Servo.h>



//create servo objects
Servo ONServo;
Servo POURServo;
Servo sugarServo;
Servo teaServo;

//servo states (i.e. degree values for behaviors)
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
int IRThreshold = 500;

int debugButtonPin = 2;
boolean makeTea = false;
boolean bagDropped = false;


int heatingWaitTime = 5000;    //2 min = 120,000 ms

int pourTime = 10000;

int numSugars = 1;



void setup(){
  Serial.begin(9600);
  
  //attach servos
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
  
  
  //if we press the button reset states
  if(digitalRead(debugButtonPin) == 1){
    makeTea = true;
    bagDropped = false;
    Serial.println("Lets make some tea");
  }
  
  
  if(makeTea){
    
    //turn on water heater

    Serial.println("Turning on heater");
    ONServo.write(ON);
    delay(600);
    ONServo.write(OFF);
    
    //dispense sugar cube depending on numSugars variable
    Serial.println("Dropping Sugar Cubes");
    for(int i = 0; i < numSugars; i++){
      sugarServo.write(PULLBACK);
      delay(500);  
      sugarServo.write(BLOCK);
      delay(750);
    }
  
    //drop teabag
    Serial.println("Looking for teabag...");
    while(bagDropped == false){
      teaServo.write(TURN);
      delay(20);
      IRVal = analogRead(IRPin);
      
      if(IRVal < IRThreshold){
        teaServo.write(STOP);
        bagDropped = true;
        Serial.println("Found one!");
      }
      
    }
  
    //sugar and tea dispensed, wait 120 seconds for water to heat up
    Serial.println("Waiting for water to heat");
    delay(65000);
    
    //once water is heated, pour for 10 seconds
    Serial.println("Pouring water now");
    POURServo.write(POUR);
    delay(12000);
    POURServo.write(notPOUR);
  
  
    Serial.println("Enjoy Your Tea!");
    makeTea = false;
  }
  
  
  
  
  
  
  
  
}
