class Player{
  
  //Attributes
  int numberPlayer;
  String name;
  int score;
  
  //Builder
  Player(int numberPlayer){
    this.numberPlayer = numberPlayer;
    score = 0;
  }
  
  //Builder
  Player(){
    this.numberPlayer = 0;
    score = 0;
  }
  
  //Get methods
  int getNumberPlayer(){
    return numberPlayer;
  }
  
  String getName(){
    return name;
  }
  
  int getScore(){
    return score;
  }
  
  //Set methods
  void setScore(int score){
    this.score = score;
  }
}
