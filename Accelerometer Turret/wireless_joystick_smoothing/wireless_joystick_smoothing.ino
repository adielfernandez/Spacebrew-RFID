/*
This code accesses the data from Adafruit's LSM303 accelerometer.
It then smoothes the data by averaging it out and sends it to 
processing via the serial port.

Smoothing code borrowed from Arduino Examples:
http://arduino.cc/en/Tutorial/Smoothing#.UxofUuddVvY

By Adiel Fernandez

 */



#include <Wire.h>
#include <Adafruit_LSM303.h>

Adafruit_LSM303 lsm;

int x,y,z;
int switchPin = 9;

//code for averaging values
const int numReadings = 10;

int Xreadings[numReadings];      // the readings from the analog input
int Xindex = 0;                  // the index of the current reading
int Xtotal = 0;                  // the running total
int Xaverage = 0;                // the average

int Yreadings[numReadings];      // the readings from the analog input
int Yindex = 0;                  // the index of the current reading
int Ytotal = 0;                  // the running total
int Yaverage = 0;                // the average

int Zreadings[numReadings];      // the readings from the analog input
int Zindex = 0;                  // the index of the current reading
int Ztotal = 0;                  // the running total
int Zaverage = 0;                // the average

void setup()
{

  //Start the serial connection
  Serial.begin(9600);

  // Try to initialise and warn if we couldn't detect the chip
  if (!lsm.begin())
  {
    Serial.println("Oops ... unable to initialize the LSM303. Check your wiring!");
    while (1);
  }
  
  pinMode(switchPin, INPUT);

  for (int thisReading = 0; thisReading < numReadings; thisReading++){
    Xreadings[thisReading] = 0;
    Yreadings[thisReading] = 0;
    Zreadings[thisReading] = 0;
  }  

}

void loop(){

  lsm.read();

  // subtract the last reading:
  Xtotal= Xtotal - Xreadings[Xindex];         
  // read from the sensor:  
  Xreadings[Xindex] = (int)lsm.accelData.x; 
  // add the reading to the total:
  Xtotal= Xtotal + Xreadings[Xindex];       
  // advance to the next position in the array:  
  Xindex = Xindex + 1;                    

  // if we're at the end of the array...
  if (Xindex >= numReadings)              
    // ...wrap around to the beginning: 
    Xindex = 0;                           

  // calculate the average:
  Xaverage = Xtotal / numReadings;  
  
  
  // subtract the last reading:
  Ytotal= Ytotal - Yreadings[Yindex];         
  // read from the sensor:  
  Yreadings[Yindex] = (int)lsm.accelData.y; 
  // add the reading to the total:
  Ytotal= Ytotal + Yreadings[Yindex];       
  // advance to the next position in the array:  
  Yindex = Yindex + 1;                    

  // if we're at the end of the array...
  if (Yindex >= numReadings)              
    // ...wrap around to the beginning: 
    Yindex = 0;                           

  // calculate the average:
  Yaverage = Ytotal / numReadings; 


  // subtract the last reading:
  Ztotal= Ztotal - Zreadings[Zindex];         
  // read from the sensor:  
  Zreadings[Zindex] = (int)lsm.accelData.z; 
  // add the reading to the total:
  Ztotal= Ztotal + ZreadingsZXindex];       
  // advance to the next position in the array:  
  Zindex = Zindex + 1;                    

  // if we're at the end of the array...
  if (Zindex >= numReadings)              
    // ...wrap around to the beginning: 
    Zindex = 0;                           

  // calculate the average:
  Zaverage = Ztotal / numReadings;   
  

  //Print to serial port  
  Serial.print(Xaverage);
  Serial.print(",");
  Serial.print(Yaverage);
  Serial.print(",");
  Serial.print(Zaverage);
  Serial.print(",");
  Serial.println(digitalRead(switchPin));
  
  //delay to stop from sending too fast (helps for more reliable data)
  delay(100); 

}


