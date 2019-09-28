import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Space_WarsV0_2 extends PApplet {

ArrayList<Character> keysIn;

Player player1;

Player player2;

boolean gameIsOver = false;

public void setup() {
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER,CENTER);
  textSize(40);
  
  //fullScreen();

  keysIn = new ArrayList<Character>();

  player1 = new Player();

  player2 = new Player();

  //player init so the beams have an enemy player to tag to
  player1.initPlayer(50, 50, 30, 'w', 's', 'a', 'd', color(0,255,0), player2);
  player2.initPlayer(width - 50, 50, 30, 'i', 'k', 'j', 'l', color(255,255,0), player1);
}

public void draw() {
  background(90, 80);

  if(!gameIsOver){
    player1.runPlayer();
    player2.runPlayer();
  } else {
    gameOver();
  }
  //println();
}

public void gameOver(){
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

public void reset(){
  //resets full game & sets all scores to 0
  player1.reset();
  player2.reset();
  gameIsOver = false;
}

public void roundReset(){
  //resets the round, keeps the scores the same
  player1.roundReset();
  player2.roundReset();
  gameIsOver = false;
}

public void keyTyped() {
  if (!keysIn.contains(key)) {
    keysIn.add(key);
  }
}

public void keyReleased() {
  if (keysIn.contains(key)) {
    keysIn.remove(new Character(key));
  }
}
class Beam {

  float xBeam;
  float yBeam;
  float xBeamSpeed = 0;
  float yBeamSpeed = 0;
  Player friendlyPlayer;    //all player vars can be used
  Player enemyPlayer;       //for collision
  float beamRotation;       //Permanant angle for when the player shoots the beam it takes that angle and keeps it

  int beamWidth = 10;
  int beamHeight = 40;

  int loopCount = 0;
  Beam() {
  }

  public void initBeam(float _x, float _y, Player _player, Player _enemy) {
    xBeam = _x;
    yBeam = _y;
    friendlyPlayer = _player;
    enemyPlayer = _enemy;
    findRotation();

		//ahha
  }

  public void runBeam() {
    drawBeam();
    moveBeam();
    //loopBeam();
  }

  public void drawBeam() {
    strokeWeight(0);
    fill(255, 0, 0);
    pushMatrix();
    translate(xBeam, yBeam);
    rotate(-beamRotation);
    rect(0, 0, beamWidth, beamHeight, 30);
    popMatrix();
  }

  public void findRotation() {
    if (keysIn.contains(friendlyPlayer.down)) {

      beamRotation = friendlyPlayer.rotation; //sets beam's rotation to the players

      yBeamSpeed = 9*cos(beamRotation); //finds the angle to move at
      xBeamSpeed = 9*sin(beamRotation);
      xBeam = friendlyPlayer.x; //keeps it at the players position until released
      yBeam = friendlyPlayer.y;
    }
  }

  public void moveBeam() {
    xBeam += xBeamSpeed; //moves beam
    yBeam += yBeamSpeed;
  }

  public boolean collision() {
    //via the process of elimation, if its not outside, its inside

    // If beam is to the left of Player, then there is no collision.
    if (xBeam + beamWidth/2 < enemyPlayer.x - enemyPlayer.diameter/2) return false;

    // If beam is  to the right of Player, then there is no collision.
    if (xBeam - beamWidth/2 > enemyPlayer.x + enemyPlayer.diameter/2) return false;

    // If beam is  above Player, then there is no collision.
    if (yBeam + beamHeight/2 < enemyPlayer.y - enemyPlayer.diameter/2) return false;

    // If beam is  below Player, then there is no collision.
    if (yBeam - beamHeight/2 > enemyPlayer.y + enemyPlayer.diameter/2) return false;

    //if its not outside its inside, collision
    return true;
  }

  public boolean outOfBounds() {

    //checks to see if the beam is out of bounds

    if (yBeam < -20)         return true;
    if (yBeam > height + 20) return true;
    if (xBeam < -20)         return true;
    if (xBeam > width + 20)  return true;

    return false;
  }
}
class Player {
  float x;
  float y;
  float _x;
  float _y;
  float topSpeed;
  float xMoveSpeed;
  float yMoveSpeed;
  float xGravitySpeed;
  float yGravitySpeed;
  float xAcceleration;
  float yAcceleration;
  int diameter;
  float rotation;

  char up;
  char down;
  char left;
  char right;

  int pColor;

  ArrayList<Beam> beamList;

  Player enemyPlayer;

  int cooldown = 0;
  int cooldownMax = 30;

  int health = 10;

  int pastSecond = 0;

  int score = 0;
  Player() {
  }

  public void initPlayer(float $x, float $y, int _diameter, char _up, char _down, char _left, char _right, int _pColor, Player otherPlayer) {
    //becasue the player uses other player classes this is run after other classes are delcared
    x = $x;
    y = $y;
    _x = $x; //stores the default position for the player
    _y = $y;
    diameter = _diameter;

    up = _up;
    down = _down;
    left = _left;
    right = _right;
    pColor = _pColor;

    topSpeed = 6;
    rotation = 0;
    xAcceleration = 0;
    yAcceleration = 0;
    enemyPlayer = otherPlayer;

    beamList = new ArrayList<Beam>();
    println("init " + this);
  }

  public void runPlayer() {
    drawPlayer();
    gravityWell();
    movePlayer();
    loopPlayer();

    beamRun();
  }

  public void drawPlayer() {

    if (health == 0) {
      if (pastSecond != second()) {
        pastSecond = second();
        fill(255,0,0);
      } else {
        fill(pColor);
      }
    } else {
      fill(pColor);
    }

    stroke(88, 255, 226);
    strokeWeight(health); //looks like a sheild, decreases everytime you get hit
    pushMatrix();
    translate(x, y);
    rotate(-rotation);
    rect(0, 0, diameter, diameter, 0, 0, 70, 70);
    popMatrix();
  }

  public void gravityWell() {
    float xDist = x - width/2;
    float yDist = y - height/2;
    xGravitySpeed -= xDist/5000;
    yGravitySpeed -= yDist/5000;

    x += xGravitySpeed;
    y += yGravitySpeed;
  }

  public void movePlayer() {
    if (keysIn.contains(left)) {
      rotation += 0.13f;
    }
    if (keysIn.contains(right)) {
      rotation -= 0.13f;
    }

    //finds what direction to move in depending on what angle you are pointing at
    yMoveSpeed = topSpeed*cos(rotation);
    xMoveSpeed = topSpeed*sin(rotation);

    if (keysIn.contains(up)) {
      x += xMoveSpeed;
      y += yMoveSpeed;
    }
  }

  public void loopPlayer() {
    if (x - diameter > width) {
      x = 0 - diameter;
    }
    if (y - diameter > height) {
      y = 0 - diameter;
    }
    if (x + diameter < 0) {
      x = width + diameter;
    }
    if (y + diameter < 0) {
      y = height + diameter;
    }
  }

  public void hit() {
    if (health == 0) {
      //gameover
      gameIsOver = true;
      enemyPlayer.addScore();
    }

    if (health == 5) {
      health = 0;
    }

    if (health == 10) {
      health = 5;
    }
  }

  public void addScore(){
    //adds score through the enemyPlayer
    score++;
  }

  public void reset(){
    health = 10;
    rotation = 0;
    xAcceleration = 0;
    yAcceleration = 0;
    x = _x;
    y = _y;
    xMoveSpeed = 0;
    yMoveSpeed = 0;
    xGravitySpeed = 0;
    yGravitySpeed = 0;

    for (int i = beamList.size()-1; i > 0; i--) { //for loop goes down instead of up so it dosnt skip over beams and potentally cause errors
        beamList.remove(i);
    }
  }

  public void roundReset(){
    score = 0;
    health = 10;
    rotation = 0;
    xAcceleration = 0;
    yAcceleration = 0;
    x = _x;
    y = _y;
    xMoveSpeed = 0;
    yMoveSpeed = 0;
    xGravitySpeed = 0;
    yGravitySpeed = 0;

    for (int i = beamList.size()-1; i > 0; i--) { //for loop goes down instead of up so it dosnt skip over beams and potentally cause errors
        beamList.remove(i);
    }
  }

  //playerBeam stuff

  public void beamRun() {
    for (int i = 0; i < beamList.size(); i++) {
      beamList.get(i).runBeam();
    }
    if (keysIn.contains(down) && cooldown > cooldownMax) {
      beamAdd();
      beamInit();
      cooldown = 0;
    }
    beamRemove();
    cooldown++;
  }

  public void beamAdd() {
    beamList.add(new Beam());
  }

  public void beamInit() {
    beamList.get(beamList.size()-1).initBeam(x, y, this, enemyPlayer); //always gets the last one
  }

  public void beamRemove() {
    for (int i = beamList.size()-1; i > 0; i--) { //for loop goes down instead of up so it dosnt skip over beams and potentally cause errors
      if (beamList.get(i).collision()) { //checks if it is
        beamList.remove(i);

        //EnemyPlayer is hit
        enemyPlayer.hit();
        break;
      }
      if (beamList.get(i).outOfBounds()) { //checks if it is
        beamList.remove(i);
      }
    }
  }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Space_WarsV0_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
