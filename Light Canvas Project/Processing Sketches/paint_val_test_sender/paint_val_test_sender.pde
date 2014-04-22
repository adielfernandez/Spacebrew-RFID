import spacebrew.*;

String server= "sandbox.spacebrew.cc";
String name="paintVal test sender";
String description ="";

Spacebrew sb;

// set up JSON to be sent!
JSONObject outgoing = new JSONObject();


color thisCol = color(0, 0, 0);
int lastX, lastY;


void setup(){
  size(200,200);
  sb = new Spacebrew( this );
  sb.addPublish ("paint", "paintval", outgoing.toString());
  sb.connect(server, name, description);
}

void draw(){
  background(255);

  noStroke();
  fill(thisCol);

  ellipse(lastX, lastY, 50, 50);

}

//void onCustomMessage( String name, String type, String value ){
//  if ( type.equals("point2d") ){
//    // parse JSON!
//    JSONObject m = JSONObject.parse( value );
//    remotePoint.set( m.getInt("x"), m.getInt("y"));
//  }
//}


void mouseClicked(){
  
  int r = (int)random(255);
  int g = (int)random(255);
  int b = (int)random(255);
  lastX = (int)mouseX;
  lastY = (int)mouseY;
  
  
  thisCol = color(r, g, b);
  
  
   // build JSON object with an x and a y
  outgoing.setInt("x", lastX);
  outgoing.setInt("y", lastY);
  outgoing.setInt("r", r);
  outgoing.setInt("g", g);
  outgoing.setInt("b", b);
  
  sb.send("paint", "paintval", outgoing.toString());
 
  
  
}
