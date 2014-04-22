import spacebrew.*;

String server= "sandbox.spacebrew.cc";
String name="Light Canvas Controller";
String description ="Receives x,y and RGB data from phones";

Spacebrew sb;

// set up JSON to be sent!
JSONObject outgoing = new JSONObject();

int x = 0;
int y = 0;
int red, green, blue;

color newColor = color(0, 0, 0);

void setup(){
  size(800,600);
  sb = new Spacebrew( this );
//  sb.addPublish ("p5Point", "point2d", outgoing.toString());
  sb.addSubscribe ("paint", "paintval");
  sb.connect(server, name, description);
}

void draw(){
  background(255);

  noStroke();
//  fill(newColor);
  fill(red, green, blue);
  ellipse(x, y, 50, 50);
    
  
}

void onCustomMessage( String name, String type, String value ){
  
  println("we got something");
  
  if ( type.equals("paintval") ){

    println("we got a paintval");
    // parse JSON!
    JSONObject m = JSONObject.parse( value );
    
    x = m.getInt("x");
    y = m.getInt("y");
    red = m.getInt("r");
    green = m.getInt("g");
    blue = m.getInt("b");
//    newColor = color(m.getInt("r"), m.getInt("g"), m.getInt("b"));
    
    println("X: " + x + " Y: " + y + " R: " + red + " G: " + green + " B: " + blue);
    
  }
  

}
