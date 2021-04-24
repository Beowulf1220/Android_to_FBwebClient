import netP5.*;
import oscP5.*;
import ketai.net.*;
import ketai.sensors.*;

OscP5 oscP5;
KetaiSensor sensor;

NetAddress remoteLocation;
float myAccelerometerY;
String remoteAddress = "192.168.1.76";

byte window;

int player1Enabled;
int player2Enabled;

Player player;

void setup() {

  player1Enabled = 0;
  player2Enabled = 0;
  myAccelerometerY = 0;
  window = 0;
  player = null;
  
  sensor = new KetaiSensor(this);
  orientation(PORTRAIT);
  textSize(48);
  initNetworkConnection();
  sensor.start();
  textAlign(CENTER);
  rectMode(CENTER);
}

void draw() {
  background(0);
  switch(window){
    case 0:
      mainMenu();
      break;
    case 1:
      play();
      break;
  }
}

void mainMenu(){
  
  //select text
  fill(255);
  text("Select a player", width/2, height/6);
  
  println("Player 1: "+player1Enabled);
  println("Player 2: "+player1Enabled);
  
  //Button 1
  fill(255);
  rect(width/2,height/2-200,width/1.5,200); //Border
  
  if(player1Enabled == 1)
  {
    fill(0);
    rect(width/2,height/2-200,width/1.5-5,200-5);
    fill(0,255,0);
    text("Player 1", width/2,height/2-176);
  }
  else
  {
    fill(150);
    rect(width/2,height/2-200,width/1.5-5,200-5);
    fill(255);
    text("Player 1\n(not available)", width/2,height/2-220);
  }
  
  //Button 2
  fill(255);
  rect(width/2,height/2+200,width/1.5,200); //Border
  
  if(player2Enabled == 1)
  {
    fill(0);
    rect(width/2,height/2+200,width/1.5-5,200-5);
    fill(0,255,0);
    text("Player 2", width/2,height/2+200);
  }
  else
  {
    fill(150);
    rect(width/2,height/2+200,width/1.5-5,200-5);
    fill(255);
    text("Player 2\n(not available)", width/2,height/2+200);
  }
}

void play(){
  text("Player " + player.getNumberPlayer() + " score: "+player.getScore(), width/2, 50);
  text("Accelerometer Y: " + nfp(myAccelerometerY, 1, 3), width/2, height/2);

  OscMessage myMessage = new OscMessage("accelerometerData");
  myMessage.add(myAccelerometerY);
  myMessage.add(player.getNumberPlayer());
  oscP5.send(myMessage, remoteLocation);
}

void onAccelerometerEvent(float x, float y, float z)
{
  //myAccelerometerX = x;
  myAccelerometerY = y;
  //myAccelerometerZ = z;
}

void initNetworkConnection()
{
  oscP5 = new OscP5(this, 12000);
  remoteLocation = new NetAddress(remoteAddress, 12000);
}

void oscEvent(OscMessage theOscMessage) {
  player1Enabled = theOscMessage.get(0).intValue();
  player2Enabled = theOscMessage.get(1).intValue();
  if(player != null) player.setScore(theOscMessage.get(2).intValue());
}

void mousePressed()
{
  if(window==0)
  {
    //Button 1 Event 
    if((mouseX >=  width/2-(width/1.5)/2 && mouseX <= width/2+(width/1.5)/2) &&
       ((mouseY >= height/2-300) && (mouseY <= height/2-100)))
    {
      player = new Player(1);
      window = 1;
    }
    //Button 2 Event
    else if((mouseX >=  width/2-(width/1.5)/2 && mouseX <= width/2+(width/1.5)/2) &&
       ((mouseY >= height/2+100) && (mouseY <= height/2+300)))
    {
      player = new Player(2);
      window = 1;
    }
  }
}
