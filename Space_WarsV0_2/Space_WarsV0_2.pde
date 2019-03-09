ArrayList<Character> keysIn;

Player player1;

Player player2;

boolean gameIsOver = false;

void setup() {
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER,CENTER);
  textSize(40);
  //size(800, 800);
  fullScreen();

  keysIn = new ArrayList<Character>();

  player1 = new Player();

  player2 = new Player();

  //player init so the beams have an enemy player to tag to
  player1.initPlayer(50, 50, 30, 'w', 's', 'a', 'd', color(0,255,0), player2);
  player2.initPlayer(width - 50, 50, 30, 'i', 'k', 'j', 'l', color(255,255,0), player1);
}

void draw() {
  background(90, 80);

  if(!gameIsOver){
    player1.runPlayer();
    player2.runPlayer();
  } else {
    gameOver();
  }
  //println();
}

void gameOver(){
  /*
  contains the gameover screen
  allows players to reset the game
  add to the winning players score
  */
  if(gameIsOver){
    //replace with bars or stars on each side, first to 5 wins
    if(player1.score == 5  || player2.score == 5){
      if(player1.score == 5){ //player 1 has won the best of 5
        fill(player1.pColor);
        text("Green is the winner!",width/2,height/3);

        fill(0);
        text("Press Space to start the next game!",width/2,(height/3)*2);
        if(keysIn.contains(' ')){
          roundReset();
        }
      }
      if(player2.score == 5){ //player 2 has won the best of 5
        fill(player2.pColor);
        text("Yellow is the winner!",width/2,height/3);
        fill(0);
        text("Press Space to start the next game!",width/2,(height/3)*2);
        if(keysIn.contains(' ')){
          roundReset();
        }
      }
    } else { //no current winner
      fill(player1.pColor);
      text(player1.score,width/4,height/2);
      fill(player2.pColor);
      text(player2.score,(width/4)*3,height/2);

      fill(0);
      text("Press Space to start the next round!",width/2,(height/3)*2);
      if(keysIn.contains(' ')){
        reset();
      }
    }
  }
}

void reset(){
  //resets full game & sets all scores to 0
  player1.reset();
  player2.reset();
  gameIsOver = false;
}

void roundReset(){
  //resets the round, keeps the scores the same
  player1.roundReset();
  player2.roundReset();
  gameIsOver = false;
}

void keyTyped() {
  if (!keysIn.contains(key)) {
    keysIn.add(key);
  }
}

void keyReleased() {
  if (keysIn.contains(key)) {
    keysIn.remove(new Character(key));
  }
}
