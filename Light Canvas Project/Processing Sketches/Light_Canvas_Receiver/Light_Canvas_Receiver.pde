import spacebrew.*;

String server= "sandbox.spacebrew.cc";
String name="Light Canvas Controller";
String description ="Receives x,y and RGB data from phones";

Spacebrew sb;

// set up JSON to be sent!
JSONObject outgoing = new JSONObject();



int canvasSide = 500;
int gap = 0;



//arrays that store the 
int numPixels = 576;
int hueVals[] = new int[numPixels];


float pixelsPerSide = 24;
float pixelSpacing = canvasSide/pixelsPerSide;
float circleSize = canvasSide/pixelsPerSide;
boolean updatePixels = false;


int sendingPixel = 0;

void setup() {
  size(1000, 500);
  sb = new Spacebrew( this );
  //  sb.addPublish ("p5Point", "point2d", outgoing.toString());
  sb.addSubscribe ("paint", "paintval");
  sb.connect(server, name, description);

  background(0);
  colorMode(HSB, 255);
  ellipseMode(CENTER);
}

void draw() {

  //go through output and get color values for pixels

  if (millis() % 500 < 20) {
    for (int i = 0; i < numPixels; i++) {
      float X = (i * pixelSpacing + pixelSpacing/2) % (pixelSpacing * pixelsPerSide);
      float Y = (i * pixelSpacing - X)/pixelsPerSide + pixelSpacing/2;
      color currentColor = color(get(int(X), int(Y)));

      hueVals[i] = int(hue(currentColor));
      fill(currentColor);
      noStroke();
      ellipse(X + canvasSide + gap, Y, circleSize, circleSize);
    }
  }



  //start sending data to arduino
  
  
}



void keyPressed() {
  if (key == ' ') {
    background(0);
  }
}



void onCustomMessage( String name, String type, String value ) {


  if ( type.equals("paintval") ) {


    // parse JSON!
    JSONObject m = JSONObject.parse( value );

    //    int newPaintX = int(map(m.getInt("x"), 0, 100, 0, canvasSide));
    //    int newPaintY = int(map(m.getInt("y"), 0, 100, 0, canvasSide)); 

    float newPaintX = m.getFloat("x");
    float newPaintY = m.getFloat("y"); 


    float hue = m.getFloat("h");

    println("X: " + m.getFloat("x") + " Y: " + m.getFloat("y") + " Hue: " + hue);



    noStroke();
    fill(hue, 255, 255, 255 * 0.4);
    ellipse(newPaintX, newPaintY, 100, 100);
    ellipse(newPaintX, newPaintY, 65, 65);
    ellipse(newPaintX, newPaintY, 30, 30);
  }



}

void mousePressed() {
  int newPaintX = mouseX;
  int newPaintY = mouseY; 

  int hue = int(random(255));

  pushStyle();
  noStroke();
  fill(hue, 255, 255, 255 * 0.4);
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

  int hue = int(random(255));

  pushStyle();
  noStroke();
  fill(hue, 255, 255, 255 * 0.4);
  ellipse(newPaintX, newPaintY, 100, 100);
  ellipse(newPaintX, newPaintY, 65, 65);
  ellipse(newPaintX, newPaintY, 30, 30);
  popStyle();
}

