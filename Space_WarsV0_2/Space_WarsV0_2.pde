ArrayList<Character> keysIn;

Player player1;

Player player2;

void setup() {
  noStroke();
  rectMode(CENTER);
  size(800, 800);

  keysIn = new ArrayList<Character>();

  player1 = new Player();

  player2 = new Player();

  //player init so the beams have an enemy player to tag to
  player1.initPlayer(50, 50, 30, 'w', 's', 'a', 'd', 0, player2);
  player2.initPlayer(width - 50, 50, 30, 'i', 'k', 'j', 'l', 255, player1);
}

void draw() {
  background(90, 80);
  player1.runPlayer();

  player2.runPlayer();

  fill(0,0,255);
  strokeWeight(0);
  ellipse(width/2, height/2, 50, 50);

  //println();
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
