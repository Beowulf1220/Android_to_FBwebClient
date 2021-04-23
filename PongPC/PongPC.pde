import P5ireBase.library.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;
float accelerometerY;

P5ireBase fire;

void setup() {
  size(200, 200);
  textSize(32);
  textAlign(CENTER);
  oscP5 = new OscP5(this, 12000, OscP5.UDP);
  remoteLocation = new NetAddress("192.168.1.74", 12000);
  fire = new P5ireBase(this, "https://temp-804eb-default-rtdb.firebaseio.com/");
}

void draw(){
  background(0);
  text("AcelerometroY: "+nfp(accelerometerY, 1, 3),0,50,width,height);
  //text(""+fire.getValue("Nombre"),0,50,width,height);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkTypetag("f")){
    accelerometerY =  theOscMessage.get(0).floatValue();
  }
}
