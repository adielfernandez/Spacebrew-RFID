#include <Adafruit_NeoPixel.h>

#define strip1Pin 4
#define strip2Pin 5
#define strip3Pin 6
#define strip4Pin 7
#define strip5Pin 8
#define strip6Pin 9




// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip)
Adafruit_NeoPixel strip1 = Adafruit_NeoPixel(96, strip1Pin, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip2 = Adafruit_NeoPixel(96, strip2Pin, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip3 = Adafruit_NeoPixel(96, strip3Pin, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip4 = Adafruit_NeoPixel(96, strip4Pin, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip5 = Adafruit_NeoPixel(96, strip5Pin, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strip6 = Adafruit_NeoPixel(96, strip6Pin, NEO_GRB + NEO_KHZ800);






//incoming data stored as longs
long data[4];

// This will be the buffered string from Serial.read()
// up until you hit a \n
String str = "";

// Keep track of current position in array
int counter = 0;

// Keep track of the last comma so we know where to start the substring
int lastIndex = 0;

//small array of ints to store current rgb values to be converted from HSB
int rgb[3];



void setup(){
  Serial.begin(115200);


  //  pinMode(9, OUTPUT);
  //  digitalWrite(9, LOW);

  strip1.begin();
  strip2.begin();
  strip3.begin();
  strip4.begin();
  strip5.begin();
  strip6.begin();

  //  rgb[0] = 255;
  //  rgb[1] = 255;
  //  rgb[2] = 0;


  for(int i = 0; i < strip1.numPixels(); i++){
    strip1.setPixelColor(i, strip1.Color(255, 0, 0));
    //    strip1.show();
    strip2.setPixelColor(i, strip2.Color(128, 128, 0));
    //    strip2.show();
    strip3.setPixelColor(i, strip3.Color(0, 255, 0));
//    //    strip3.show();
    strip4.setPixelColor(i, strip4.Color(0, 128, 128));
//    //    strip4.show();
    strip5.setPixelColor(i, strip5.Color(0, 0, 255));
//    //    strip5.show();
    strip6.setPixelColor(i, strip6.Color(128, 0, 128));
//    //    strip6.show();


  }



  strip1.show(); // Initialize all pixels to 'off'
  strip2.show();
  strip3.show();
  strip4.show();
  strip5.show();
  strip6.show();


}

void loop() {


  //if there is data coming in from serial
  if (Serial.available() > 0) {

    //read the first byte and store it as a char type
    char ch = Serial.read();

    //if we find a newline character, it means we got to the end of the string so lets do something
    if (ch == '\n') {

      //lets loop through each character in the string
      for (int i = 0; i < str.length(); i++) {

        // check if it's a comma
        if (str.substring(i, i+1) == ",") {

          // Grab the piece from the last index up to the current position and store it temporarily
          String tempString = str.substring(lastIndex, i);

          // Then convert that temporary string to an int and store that
          data[counter] = tempString.toInt();

          // Update the last position and add 1, so it starts from the next character
          lastIndex = i + 1;

          // Increase the position in the array that we store into
          counter++;

        }

        //If we're at the end of the string (no more commas to stop us)
        if (i == str.length() - 1) {
          //grab the last part of the string from the lastIndex to the end
          String tempString = str.substring(lastIndex);
          //And convert to int
          data[counter] = tempString.toInt();
        }

      }   

      //clear out string and counters to get ready for the next incoming string
      str = "";
      counter = 0;
      lastIndex = 0;





      hsi2rgb(data[1], data[2], data[3], rgb);
      
//      if(data[1] == 361){
//        hsi2rgb(data[1], 255, 0, rgb);
//      } else{
//        hsi2rgb(data[1], 255, 255, rgb);
//      }    

      //and put the 3 values in our local variables
      if(data[0] < 96){
        strip1.setPixelColor(data[0], strip1.Color(rgb[0], rgb[1], rgb[2]));
        //        strip1.show();
      } 
      else if(data[0] < 192){


        strip2.setPixelColor(data[0] - 96, strip2.Color(rgb[0], rgb[1], rgb[2]));
        //        strip2.show();       
      } 
      else if(data[0] < 288){
        strip3.setPixelColor(data[0] - 192, strip3.Color(rgb[0], rgb[1], rgb[2]));
        //        strip3.show();       
      } 
      else if(data[0] < 384){
        strip4.setPixelColor(data[0] - 288, strip4.Color(rgb[0], rgb[1], rgb[2]));
        //        strip4.show();       
      } 
      else if(data[0] < 480){
        strip5.setPixelColor(data[0] - 384, strip5.Color(rgb[0], rgb[1], rgb[2]));
        //        strip5.show();       
      } 
      else {
        strip6.setPixelColor(data[0] - 480, strip6.Color(rgb[0], rgb[1], rgb[2]));
        //        strip6.show();       
      }  



      strip1.show(); // Initialize all pixels to 'off'
      strip2.show();
      strip3.show();
      strip4.show();
      strip5.show();
      strip6.show();





    }
    else {

      //if we havent reached a newline character yet, add the current character to the string
      str += ch;
    }

  }








}






//------------------------------Functions------------------------------




// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip1.numPixels(); i++) {
    strip1.setPixelColor(i, c);
    strip1.show();
    delay(wait);
  }
}

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j++) {
    for(i=0; i<strip1.numPixels(); i++) {
      strip1.setPixelColor(i, Wheel((i+j) & 255));
    }
    strip1.show();
    //delay(wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256*5; j++) { // 5 cycles of all colors on wheel
    for(i=0; i< strip1.numPixels(); i++) {
      strip1.setPixelColor(i, Wheel(((i * 256 / strip1.numPixels()) + j) & 255));
    }
    strip1.show();
    delay(wait);
  }
}



// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  if(WheelPos < 85) {
    return strip1.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  } 
  else if(WheelPos < 170) {
    WheelPos -= 85;
    return strip1.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } 
  else {
    WheelPos -= 170;
    return strip1.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
}



void hsi2rgb(float H, float S, float I, int* rgb) {
  int r, g, b;

  H = fmod(H,360); // cycle H around to 0-360 degrees
  H = 3.14159*H/(float)180; // Convert to radians.
  S = S>0?(S<1?S:1):
  0; // clamp S and I to interval [0,1]
  I = I>0?(I<1?I:1):
  0;

  // Math! Thanks in part to Kyle Miller.
  if(H < 2.09439) {
    r = 255*I/3*(1+S*cos(H)/cos(1.047196667-H));
    g = 255*I/3*(1+S*(1-cos(H)/cos(1.047196667-H)));
    b = 255*I/3*(1-S);
  } 
  else if(H < 4.188787) {
    H = H - 2.09439;
    g = 255*I/3*(1+S*cos(H)/cos(1.047196667-H));
    b = 255*I/3*(1+S*(1-cos(H)/cos(1.047196667-H)));
    r = 255*I/3*(1-S);
  } 
  else {
    H = H - 4.188787;
    b = 255*I/3*(1+S*cos(H)/cos(1.047196667-H));
    r = 255*I/3*(1+S*(1-cos(H)/cos(1.047196667-H)));
    g = 255*I/3*(1-S);
  }
  rgb[0]=r;
  rgb[1]=g;
  rgb[2]=b;
}





