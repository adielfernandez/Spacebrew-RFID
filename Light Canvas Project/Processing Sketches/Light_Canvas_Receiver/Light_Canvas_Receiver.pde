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

  
  //draw black background on right half
  fill(0);
  
  rect(canvasSide, 0, canvasSide, height);

  
  float circleSize = canvasSide/pixelsPerSide;


  //go through output and get color values for pixels
  for(int i = 0; i < numPixels; i++){
    float X = (i * pixelSpacing + pixelSpacing/2) % (pixelSpacing * pixelsPerSide);
    float Y = (i * pixelSpacing - X)/pixelsPerSide + pixelSpacing/2;
    color currentColor = color(get(int(X), int(Y)));

    hueVals[i] = int(hue(currentColor));
    
    
  
    
    fill(currentColor);
    noStroke();
    ellipse(X + canvasSide + gap, Y, circleSize, circleSize);


  }




//    int X = (currentPixel * pixelSpacing) % (pixelsPerSide * pixelSpacing);
//    int Y = ((currentPixel * pixelSpacing) - X)/pixelsPerSide;
//    color currentColor = color(get(X, Y));

  




  //draw boundary box in middle 
  fill(255);
  rect(canvasSide, 0, gap, height);


}







void onCustomMessage( String name, String type, String value ) {

  println("we got something");

  if ( type.equals("paintval") ) {

    println("we got a paintval");
    // parse JSON!
    JSONObject m = JSONObject.parse( value );

    int newPaintX = int(map(m.getInt("x"), 0, 300, 0, canvasSide));
    int newPaintY = int(map(m.getInt("y"), 0, 300, 0, canvasSide)); 

    int hue = m.getInt("r");
//    int green = m.getInt("g");
//    int blue = m.getInt("b");
    //    newColor = color(m.getInt("r"), m.getInt("g"), m.getInt("b"));

    //    println("X: " + x + " Y: " + y + " R: " + red + " G: " + green + " B: " + blue);

    noStroke();
    fill(hue, 255, 255, 255 * 0.4);
    ellipse(newPaintX, newPaintY, 100, 100);
  }
}

void keyPressed(){
 
 background(0); 
  
}

void mousePressed(){
   int newPaintX = mouseX;
  int newPaintY = mouseY; 

  int hue = int(random(255));

  pushStyle();
  noStroke();
  fill(hue, 255, 255, 255 * 0.4);
  ellipse(newPaintX, newPaintY, 100, 100);
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
  popStyle();
}




