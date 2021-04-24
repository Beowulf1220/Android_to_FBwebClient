import P5ireBase.library.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;
float accelerometerY;
int numberPlayer;
int score;

int playerAvailablePlayer1;
int playerAvailablePlayer2;

P5ireBase fire;

void setup() {
  
  numberPlayer = 0;
  score = 0;
  playerAvailablePlayer1 = 0;
  playerAvailablePlayer2 = 0;
  
  size(400, 400);
  textSize(24);
  textAlign(CENTER,CENTER);
  
  oscP5 = new OscP5(this, 12000, OscP5.UDP);
  remoteLocation = new NetAddress("192.168.1.74", 12000); //IP Android
  fire = new P5ireBase(this, "https://temp-804eb-default-rtdb.firebaseio.com/");
  
  fire.setValue("Pong/Player1/available","1");
  fire.setValue("Pong/Player2/available","1");
  
  fire.setValue("Pong/Player1/aceleration","0");
  fire.setValue("Pong/Player2/aceleration","0");
}

void draw(){
  background(0);
  String dato1 = fire.getValue("Pong/Player1/available");
  String dato2 = fire.getValue("Pong/Player2/available");
  
  if(dato1 != null && dato1.charAt(0) == '1') playerAvailablePlayer1 = 1;
  else playerAvailablePlayer1 = 0;
  
  if(dato2 != null && dato2.charAt(0) == '1') playerAvailablePlayer2 = 1;
  else playerAvailablePlayer2 = 0;
  
  if(numberPlayer != 0)
  {
    if(numberPlayer==1) score = parseInt(fire.getValue("Pong/Player1/score"));
    else score = parseInt(fire.getValue("Pong/Player2/score"));
  } 
  
  OscMessage myMessage = new OscMessage("infoAndroid");
  myMessage.add(playerAvailablePlayer1);
  myMessage.add(playerAvailablePlayer2);
  myMessage.add(score);
  oscP5.send(myMessage, remoteLocation);
  
  if(numberPlayer != 0)
  {
    text("Player " + numberPlayer + " AcelerometroY: "+nfp(accelerometerY, 1, 3),0,50,width,height/2);
    fire.setValue("Pong/Player"+numberPlayer+"/available","0");
    fire.setValue("Pong/Player"+numberPlayer+"/aceleration",String.valueOf(accelerometerY));
  }
  else{
    text("Select a player",0,50,width,height/2);
  }
}

void oscEvent(OscMessage theOscMessage) {
  accelerometerY =  theOscMessage.get(0).floatValue();
  numberPlayer = theOscMessage.get(1).intValue();
}
