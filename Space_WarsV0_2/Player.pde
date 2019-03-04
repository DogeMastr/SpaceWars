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

  color pColor;

  ArrayList<Beam> beamList;

  Player enemyPlayer;

  int cooldown = 0;
  int cooldownMax = 30;

  int health = 10;

  int pastSecond = 0;

  int score = 0;
  Player() {
  }

  void initPlayer(float $x, float $y, int _diameter, char _up, char _down, char _left, char _right, color _pColor, Player otherPlayer) {
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

  void runPlayer() {
    drawPlayer();
    gravityWell();
    movePlayer();
    loopPlayer();

    beamRun();
  }


  void drawPlayer() {

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

  void gravityWell() {
    float xDist = x - width/2;
    float yDist = y - height/2;
    xGravitySpeed -= xDist/5000;
    yGravitySpeed -= yDist/5000;

    x += xGravitySpeed;
    y += yGravitySpeed;
  }

  void movePlayer() {
    if (keysIn.contains(left)) {
      rotation += 0.1;
    }
    if (keysIn.contains(right)) {
      rotation -= 0.1;
    }

    //finds what direction to move in depending on what angle you are pointing at
    yMoveSpeed = topSpeed*cos(rotation);
    xMoveSpeed = topSpeed*sin(rotation);

    if (keysIn.contains(up)) {
      x += xMoveSpeed;
      y += yMoveSpeed;
    }
  }

  void loopPlayer() {
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

  void hit() {
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

  void addScore(){
    //adds score through the enemyPlayer
    score++;
  }

  void reset(){
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

  void roundReset(){
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

  void beamRun() {
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

  void beamAdd() {
    beamList.add(new Beam());
  }

  void beamInit() {
    beamList.get(beamList.size()-1).initBeam(x, y, this, enemyPlayer); //always gets the last one
  }

  void beamRemove() {
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
