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

float[] tip1LocsX = new float[50];
float[] tip1LocsY = new float[50];
float[] tip2LocsX = new float[50];
float[] tip2LocsY = new float[50];
int[] sticksLum = new int[50];

Game currentGame; 
Player p1;
Player p2;
Player p3;
Player me;

class Game {
  int[] winnersinround = new int[3];
}

class Player {
  int[] sticks = new int[3];
  boolean[] winnerofround = new boolean[3];
  void takeSticks(int currentRound) {
    this.sticks[currentRound] = int(random(0, 10));
  }
}

void newGame() {
  currentGame = new Game();
  roundNum = 1; whoseTurn=1; 
  p1 = new Player();
  p2 = new Player();
  p3 = new Player();
  me = new Player();
}
  
void setup() {
  size(500,500);
  newGame();
  curStickboxX = width/2-45;
  curStickboxY = height/2 - 165;
  for (int i=0;i<25;i++) {
    tip1LocsX[i] = random(40,60); 
    tip1LocsY[i] = random(height-120, height-70);
    tip2LocsX[i] = random(160, 200);
    tip2LocsY[i] = random(height - 120, height - 70);
    sticksLum[i] = int(random(130,200));
  }
  for (int i=0;i<25;i++) {
    tip1LocsX[25+i] = random(40,60); 
    tip1LocsY[25+i] = random(height-80, height-25);
    tip2LocsX[25+i] = random(160, 200);
    tip2LocsY[25+i] = random(height - 80, height - 25);
    sticksLum[25+i] = int(random(130,200));
  }
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
    text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.winnersinround[0] + " winners.", width/2+110, 20); 
  } else if (roundNum == 3) {
    text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.winnersinround[0] + " winners.", width/2+110, 20); 
    text("Round 2: You took " + me.sticks[1] + " sticks. There were " + currentGame.winnersinround[1] + " winners.", width/2+110, 32); 
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
    colorMode(HSB);
    for (int i=0; i<50; i++) {
      //draw sticks
      strokeWeight(10); stroke(30,100,sticksLum[i], 160);
      line(tip1LocsX[i], tip1LocsY[i], tip2LocsX[i], tip2LocsY[i]);
    }
    strokeWeight(1);
    colorMode(RGB);
    text("You have taken " + mySticks + " sticks.", width/2, height-20);
  }
  
}
void gameOverScreen() {
  background(0);
  fill(255);
  textSize(20);
  text("Game Results", width/2, 80);
  textSize(16);
  text("Round 1 - Number of winners: " + currentGame.winnersinround[0], width/2, height/2-100);
  textSize(11);
  text("you took: " + me.sticks[0] + ". Winner? " + me.winnerofround[0], width/2, height/2-80);
  text("p1 took: "+ p1.sticks[0] + ". Winner? " + p1.winnerofround[0], width/2, height/2-68);
  text("p2 took: "+ p2.sticks[0] + ". Winner? " + p2.winnerofround[0], width/2, height/2-56);
  text("p3 took: "+ p3.sticks[0] + ". Winner? " + p3.winnerofround[0], width/2, height/2-44);
  textSize(16);
  text("Round 2 - Number of winners: " + currentGame.winnersinround[1], width/2, height/2-24);
  textSize(11);
  text("you took: " + me.sticks[1] + ". Winner? " + me.winnerofround[1], width/2, height/2-4);
  text("p1 took: "+ p1.sticks[1] + ". Winner? " + p1.winnerofround[1], width/2, height/2+8);
  text("p2 took: "+ p2.sticks[1] + ". Winner? " + p2.winnerofround[1], width/2, height/2+20);
  text("p3 took: "+ p3.sticks[1] + ". Winner? " + p3.winnerofround[1], width/2, height/2+32);
  textSize(16);
  text("Round 3 - Number of winners: " + currentGame.winnersinround[2], width/2, height/2+52);
  textSize(11);
  text("you took: " + me.sticks[2] + ". Winner? " + me.winnerofround[2], width/2, height/2+72);
  text("p1 took: "+ p1.sticks[2] + ". Winner? " + p1.winnerofround[2], width/2, height/2+84);
  text("p2 took: "+ p2.sticks[2] + ". Winner? " + p2.winnerofround[2], width/2, height/2+96);
  text("p3 took: "+ p3.sticks[2] + ". Winner? " + p3.winnerofround[2], width/2, height/2+108);
  textSize(16);
  text("Replay?", width/2, height - 60);
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
  int totalSticks = p1.sticks[currentRound-1] + p2.sticks[currentRound-1] + p3.sticks[currentRound-1] + me.sticks[currentRound-1];
  if (totalSticks < 8) { currentGame.winnersinround[currentRound-1] = 0; }
  else {
    int numOfWinners = 0;
    int minSticks = min(min(p1.sticks[currentRound-1], p2.sticks[currentRound-1]), min(p3.sticks[currentRound-1], me.sticks[currentRound-1]));
    if (p1.sticks[currentRound-1] == minSticks) {
      p1.winnerofround[currentRound-1] = true;
      numOfWinners ++;
    }
    if (p2.sticks[currentRound-1] == minSticks) {
      p2.winnerofround[currentRound-1] = true;
      numOfWinners ++;
    }
    if (p3.sticks[currentRound-1] == minSticks) {
      p3.winnerofround[currentRound-1] = true;
      numOfWinners ++;
    }
    if (me.sticks[currentRound-1] == minSticks) {
      me.winnerofround[currentRound-1] = true;
      numOfWinners ++;
    }
    currentGame.winnersinround[currentRound-1] = numOfWinners;
  }
  whoseTurn++;
  mySticks = 0; 
  roundNum ++;
  if (roundNum > 3) gameScreen = 2;
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
  } else {
    newGame();
    gameScreen = 1;  
  }
}