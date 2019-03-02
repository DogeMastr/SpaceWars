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

  void initBeam(float _x, float _y, Player _player, Player _enemy) {
    xBeam = _x;
    yBeam = _y;
    friendlyPlayer = _player;
    enemyPlayer = _enemy;
    findRotation();
  }

  void runBeam() {
    drawBeam();
    moveBeam();
    //loopBeam();
  }

  void drawBeam() {
    fill(255, 0, 0);
    pushMatrix();
    translate(xBeam, yBeam);
    rotate(-beamRotation);
    rect(0, 0, beamWidth, beamHeight, 30);
    popMatrix();
  }

  void findRotation() {
    if (keysIn.contains(friendlyPlayer.down)) {

      beamRotation = friendlyPlayer.rotation; //sets beam's rotation to the players

      yBeamSpeed = 9*cos(beamRotation); //finds the angle to move at
      xBeamSpeed = 9*sin(beamRotation);
      xBeam = friendlyPlayer.x; //keeps it at the players position until released
      yBeam = friendlyPlayer.y;
    }
  }

  void moveBeam() {
    xBeam += xBeamSpeed; //moves beam
    yBeam += yBeamSpeed;
  }

  boolean collision() {
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

  boolean outOfBounds() {
   
    //checks to see if the beam is out of bounds
    
    if (yBeam < -20)         return true;
    if (yBeam > height + 20) return true;
    if (xBeam < -20)         return true;
    if (xBeam > width + 20)  return true;

    return false;
  }
}
