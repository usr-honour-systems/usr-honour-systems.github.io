// GameScreen 0 = Start
// GameScreen 1 = Rounds
// GameScreen 2 = End + Results (Restart?)
int gameScreen = 0;
int roundNum = 1; int whoseTurn=1; 
int stickButX = 400;
int stickButY = 450;
int stickButW = 80;
int stickButH = 30;
int mySticks = 0;

float curStickboxX;
float curStickboxY;
float easing = 0.05;

Game currentGame; 
Player p1;
Player p2;
Player p3;
Player me;

class Game {
  int r1winners;
  int r2winners;
  int r3winners;
}

class Player {
  int[] sticks = new int[3];
  boolean r1winner;
  boolean r2winner;
  boolean r3winner;
  void takeSticks(int currentRound) {
    this.sticks[currentRound] = int(random(0, 10));
  }
}
  
void setup() {
  size(500,500);
  currentGame = new Game();
  p1 = new Player();
  p2 = new Player();
  p3 = new Player();
  me = new Player();
  curStickboxX = width/2-45;
  curStickboxY = height/2 - 165;
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    roundScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

void initScreen() {
  background(0);
  textAlign(CENTER);
  text("Click to start", height/2, width/2);
}
void readyButton() {
  fill(100,210,100); noStroke();
  rect(stickButX, stickButY, stickButW, stickButH);
  fill(255);
  text("I'M DONE", stickButX + 39, stickButY + 20);
}
void roundText() {
  textSize(16);
  fill(0);
  text("Round  " + roundNum, 50, 30);
  textSize(11);
  fill(50,100,200);
  if (roundNum == 2) { 
    text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.r1winners + " winners.", width/2+110, 20); 
  } else if (roundNum == 3) {
    text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.r1winners + " winners.", width/2+110, 20); 
    text("Round 2: You took " + me.sticks[0] + " sticks. There were " + currentGame.r2winners + " winners.", width/2+110, 32); 
  }
}
void drawPlayers() {
  textSize(12);
  int playerRad = 60;
  int[] playerlocX = {width/2 + 80, width/2-20, width/2 - 120, width/2-20 };
  int[] playerlocY = {height/2 - 20, height/2 - 120, height/2 - 20, height/2 + 80 };
  for (int i=0; i<4; i++) {
    if (i == 0) { fill(150, 255, 150); } else { fill(100, 205, 100); }
    ellipse(playerlocX[i], playerlocY[i], playerRad, playerRad);
    fill(0); String playr = i==0? "YOU" : "Player " + i; 
    text(playr, playerlocX[i], playerlocY[i]+2);
  }
//  fill(150, 200, 255); ellipse(width/2-100, height/2-150, 55, 55);
//  fill(0); text("Tham", width/2-100, height/2-145);
}
void drawSticksBox() {
  int[] boxlocX =  {width/2 + 55, width/2-45, width/2 - 145, width/2-45 };
  int[] boxlocY = {height/2 - 10, height/2 - 165, height/2 - 10,height/2 + 90 };
  fill(255); stroke(0);
  float rectTargetX = float(boxlocX[whoseTurn]);
  float rectTargetY = float(boxlocY[whoseTurn]);
  float dx = rectTargetX - curStickboxX;
  float dy = rectTargetY - curStickboxY;
  curStickboxX += dx * easing; curStickboxY += dy * easing;
  rect(curStickboxX, curStickboxY, 50, 30);
  println(curStickboxX, curStickboxY);
  fill(0); noStroke(); 
  text("sticks", curStickboxX+25, curStickboxY+20); 
}
void roundScreen() {
  background(230);
  roundText();
  readyButton();
  drawPlayers();
  drawSticksBox();
  if (whoseTurn == 0) {
    fill(255);
    rect(20, height - 140, 200, 120);
    for (int i=0; i<50; i++) {
      //draw sticks
    }
  }
}
void gameOverScreen() {
}
void otherPlayersTurn(int currentRound) {
  whoseTurn = (whoseTurn+1)%4;
  if (whoseTurn == 1) {
    p1.takeSticks(currentRound-1);
  } else if (whoseTurn == 2) {
    p2.takeSticks(currentRound-1);
  } else if (whoseTurn == 3) {
    p3.takeSticks(currentRound-1);
  }
  redraw();
  println(whoseTurn);
}

void advanceRound(int currentRound) {
  me.sticks[currentRound-1] = mySticks;
  whoseTurn++;
  mySticks = 0; 
  roundNum ++;
}

public void mousePressed() {
  if (gameScreen == 0) {
    gameScreen =1;
  } else if (gameScreen == 1) {
    if (whoseTurn == 0) {
      if (mouseX > stickButX && mouseX < stickButX+stickButW && mouseY > stickButY && mouseY < stickButY+stickButH) {
        advanceRound(roundNum);
      } else {
        mySticks ++;
      }
    } else {
      otherPlayersTurn(roundNum);
    }
  }
}