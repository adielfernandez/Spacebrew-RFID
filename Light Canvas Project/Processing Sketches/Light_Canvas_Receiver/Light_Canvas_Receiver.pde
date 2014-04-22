import spacebrew.*;

String server= "sandbox.spacebrew.cc";
String name="Light Canvas Controller";
String description ="Receives x,y and RGB data from phones";

Spacebrew sb;

// set up JSON to be sent!
JSONObject outgoing = new JSONObject();

int x = -50;
int y = -50;
int red, green, blue;

color newColor = color(0, 0, 0);

void setup(){
  size(500,500);
  sb = new Spacebrew( this );
//  sb.addPublish ("p5Point", "point2d", outgoing.toString());
  sb.addSubscribe ("paint", "paintval");
  sb.connect(server, name, description);
  
  background(0);

}

void draw(){


    
  
}

void onCustomMessage( String name, String type, String value ){
  
  println("we got something");
  
  if ( type.equals("paintval") ){

    println("we got a paintval");
    // parse JSON!
    JSONObject m = JSONObject.parse( value );
    
    x = int(map(m.getInt("x"), 0, 300, 0, width));
    y = int(map(m.getInt("y"), 0, 300, 0, height));
    red = m.getInt("r");
    green = m.getInt("g");
    blue = m.getInt("b");
//    newColor = color(m.getInt("r"), m.getInt("g"), m.getInt("b"));
    
    println("X: " + x + " Y: " + y + " R: " + red + " G: " + green + " B: " + blue);
    
    noStroke();
    fill(red, green, blue, 255 * 0.4);
    ellipse(x, y, 100, 100);

    
    
  }
  

}
