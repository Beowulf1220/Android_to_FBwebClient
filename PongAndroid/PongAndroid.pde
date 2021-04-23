import P5ireBase.library.*;

P5ireBase fire;
void setup() {
  size(400, 400);
  fire = new P5ireBase(this, "put here ur DB link created in firebase console");
}

void draw(){
  
}

void mousePressed() {
  //fire.setValue("Nombre", "Juan");//Set info to specific key in FireBase
  println(fire.getValue("Nombre"));//Get info from specific key
}
