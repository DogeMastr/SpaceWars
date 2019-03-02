class Player {
  float x;
  float y;
  float topSpeed;
  float xMoveSpeed;
  float yMoveSpeed;
  float xGravitySpeed;
  float yGravitySpeed;
  float xAcceleration;
  float yAcceleration;
  int diameter;
  float rotation;

  int fuel;

  char up;
  char down;
  char left;
  char right;

  int pColor;

  ArrayList<Beam> beamList;

  Player enemyPlayer;

  int cooldown = 0;
  int cooldownMax = 30;


  Player() {
  }

  void initPlayer(float _x, float _y, int _diameter, char _up, char _down, char _left, char _right, int _pColor, Player otherPlayer) {
    //becasue the player uses other player classes this is run after other classes are delcared
    x = _x;
    y = _y;
    diameter = _diameter;

    up = _up;
    down = _down;
    left = _left;
    right = _right;
    pColor = _pColor;

    fuel = 5000;

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
    fill(pColor, fuel/5, 0);
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
      rotation += 0.05;
    }
    if (keysIn.contains(right)) {
      rotation -= 0.05;
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
      }
      if (beamList.get(i).outOfBounds()) { //checks if it is
        beamList.remove(i);
      }
    }
  }
}
