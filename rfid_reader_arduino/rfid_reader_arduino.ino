/*
This sketch receives a string input from an RFID reader 
 on a software serial connection and prints it via serial 
 to be read by processing
 
 RFID reader can be found here:
 https://www.sparkfun.com/products/11827
 
 This tutorial also utilizes this break out board:
 https://www.sparkfun.com/products/8423
 
 RFID Wiring
 Break out pin      Arduino Pin 
 -------------      -----------
 1                  Ground
 2                  13                  
 7                  Ground
 9                  Software Serial Receive Pin (Pin 5)
 11                 +5v
 
 Some data parsing based on code from:
 http://bildr.org/2011/02/rfid-arduino/
 
 by Adiel Fernandez
 
 */



//Import Software serial library. This allows us to put the RFID reader on a virtual serial port
//while still using the hardware serial port for debugging to the serial monitor
#include <SoftwareSerial.h>

//Setup the virtual serial port on pins 5 (RX = receive) and 6 (TX = transmit)
SoftwareSerial RFID_Reader(5,6);

//The RFID reader requires power to the reset pin be turned on 
//and off after reading to allow it to read again
int RFID_Reset_Pin = 13;


void setup(){

  //start the normal serial connection
  Serial.begin(9600);
  
  //start the software serial connection to the reader
  RFID_Reader.begin(9600);

  //set the pinmode for the reset pin and bring it high to enable the reader
  pinMode(RFID_Reset_Pin, OUTPUT);
  digitalWrite(RFID_Reset_Pin, HIGH);
  
}



void loop(){

  //Similar to a string, this is an array of char type variables 
  //to store incomming RFID tag as a sequence of single digits
  char incommingTag[13];
  //byteNumber helps us keep track of which digit we're loading into the char array at a time
  int byteNumber = 0;
  
  //This boolean helps us know if we're currently reading data in the while loop below
  boolean reading = false;

    //The while loop makes sure we read EVERYTHING available from the serial buffer
    //to make sure we get the most recent and complete RFID tags available
    while (RFID_Reader.available() > 0) {
      
      
      //read next available byte
      int thisByte = RFID_Reader.read(); 

      //ASCII 2 = "start of text" and is the first bit sent by the reader
      if(thisByte == 2) reading = true; 
      //ASCII 3 = "end of text" and is the last bit sent by the reader
      if(thisByte == 3) reading = false;  

      //if we are reading, and the current byte is not "start of text" (2), 
      //a linefeed (10) or a carriage return (13), store it.
      if(reading && thisByte != 2 && thisByte != 10 && thisByte != 13){
        //store the tag
        incommingTag[byteNumber] = thisByte;
        //Increment the counter so we can fill the next slot of the array
        byteNumber ++;
      }

    }
  
  //If the incommingTag variable is not empty then send it via 
  //the serial port (Processing will be waiting on the other side)
  if(strlen(incommingTag) != 0){
    //There is some weird data being parsed after the ID is read so we 
    //chop off the last digit by making last digit a null value (ASCII 0)
    incommingTag[13] = 0;
    Serial.println(incommingTag);  
  }

  //"Clear" the char array by making all the digits a null value (ASCII 0)
  for(int i = 0; i < strlen(incommingTag); i++){
    incommingTag[i] = 0;
  }

  //reset the RFID reader by bringing the reset pin low
  //then make it high and give it a delay so the reader can reset
  digitalWrite(RFID_Reset_Pin, LOW);
  digitalWrite(RFID_Reset_Pin, HIGH);
  delay(150);

}




