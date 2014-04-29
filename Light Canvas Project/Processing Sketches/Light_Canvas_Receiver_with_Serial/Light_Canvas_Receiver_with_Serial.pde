import spacebrew.*;


import processing.serial.*;
Serial port;


String server= "sandbox.spacebrew.cc";
String name="Light Canvas Controller";
String description ="Receives x,y and RGB data from phones";

Spacebrew sb;

// set up JSON to be sent!
JSONObject outgoing = new JSONObject();



int canvasSide = 500;
int gap = 0;

color drawing = color(0, 255, 255);


//arrays that store the 
int numPixels = 576;
int hueVals[] = new int[numPixels];
color colorVals[] = new color[numPixels];

float pixelsPerSide = 24;
float pixelSpacing = canvasSide/pixelsPerSide;
float circleSize = canvasSide/pixelsPerSide;
boolean updatePixels = true;


int sendingPixel = 0;
boolean firstScan = true;

float test = 0;


void setup() {
  size(1000, 500);
  //  frameRate(200);
  sb = new Spacebrew( this );
  //  sb.addPublish ("p5Point", "point2d", outgoing.toString());
  sb.addSubscribe ("paint", "paintval");
  sb.connect(server, name, description);

  // List all the available serial ports
  printArray(Serial.list());

  // Choose the proper serial port from the list printed and insert number between square brackets
  port = new Serial(this, Serial.list()[13], 115200);



  for (int i = 0; i < 576; i++) {
    //    hueVals[i] = i * 255/24;
    hueVals[i] = 0;
  }

  //  blendMode(ADD);

  background(0);
  colorMode(HSB, 255);
  ellipseMode(CENTER);
}

void draw() {

    if (millis() % 1000 < 10) {


      //go through output and get color values for pixels
      //  if (millis() % 200 < 20) {
      for (int i = 0; i < numPixels; i++) {
        float X = (i * pixelSpacing + pixelSpacing/2) % (pixelSpacing * pixelsPerSide);
        float Y = (i * pixelSpacing - X)/pixelsPerSide + pixelSpacing/2;
        color currentColor = color(get(int(X), int(Y)));

        hueVals[i] = int(hue(currentColor));
        colorVals[i] = currentColor;
        fill(currentColor);
        noStroke();
        ellipse(X + canvasSide + gap, Y, circleSize, circleSize);
        //      textSize(10);
        //      fill(255);
        //      textAlign(CENTER, CENTER);
        //      text(str(hueVals[i]), X + canvasSide + gap, Y);
      }
      
      
    }
  
  

  if (updatePixels) {



    //remap hue from 255, to 360 for arduino to convert hsb to rgb
    int mappedHue = int(map(hue(colorVals[sendingPixel]), 0, 255, 0, 360));

    String pixelData = str(sendingPixel) + "," + str(mappedHue) + "," + str(int(brightness(colorVals[sendingPixel]))) + "," + str(int(saturation(colorVals[sendingPixel]))) + "\n";  
    //  String pixelData = str(sendingPixel) + "," + str(mappedHue) + "\n";

    port.write(pixelData);
    print(pixelData);
    sendingPixel++;
    if (sendingPixel > 575) {
      sendingPixel = 0;

      updatePixels = false;
      
    }
  } 
  
  
  
  
}






void keyPressed() {
  if (key == ' ') {
    background(0);
  } 
  else {
    drawing = color(random(255), 255, 255);
  }
}



void onCustomMessage( String name, String type, String value ) {


  if ( type.equals("paintval") ) {


    // parse JSON!
    JSONObject m = JSONObject.parse( value );

    //    float newPaintX = int(map(m.getInt("x"), 0, 100, 0, canvasSide));
    //    float newPaintY = int(map(m.getInt("y"), 0, 100, 0, canvasSide)); 

    float newPaintX = m.getFloat("x");
    float newPaintY = m.getFloat("y"); 


    float hue = m.getFloat("h");

    //println("X: " + m.getFloat("x") + " Y: " + m.getFloat("y") + " Hue: " + hue);



    noStroke();
    fill(hue, 255, 255, 255 * 0.05);
    ellipse(newPaintX, newPaintY, 100, 100);
    ellipse(newPaintX, newPaintY, 65, 65);
    ellipse(newPaintX, newPaintY, 30, 30);

    updatePixels = true;
  }



  //  }
}

void mousePressed() {
  int newPaintX = mouseX;
  int newPaintY = mouseY; 


  pushStyle();
  noStroke();
  fill(drawing, 255 * 0.4);
  ellipse(newPaintX, newPaintY, 100, 100);
  ellipse(newPaintX, newPaintY, 65, 65);
  ellipse(newPaintX, newPaintY, 30, 30);
  popStyle();
}

void mouseDragged() {

  //    int newPaintX = int(random(canvasSide));
  //    int newPaintY = int(random(canvasSide)); 

  int newPaintX = mouseX;
  int newPaintY = mouseY; 


  pushStyle();
  noStroke();
  fill(drawing, 255 * 0.4);
  ellipse(newPaintX, newPaintY, 100, 100);
  ellipse(newPaintX, newPaintY, 65, 65);
  ellipse(newPaintX, newPaintY, 30, 30);
  popStyle();
}

