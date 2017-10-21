// GameScreen 0 = Start
// GameScreen 1 = Rounds
// GameScreen 2 = End + Results (Restart?)
int gameScreen = 0;
int roundNum = 1; int whoseTurn=1; 
int stickButX = 400;
int stickButY = 300;
int stickButW = 80;
int stickButH = 30;
int boxX; int boxY; int boxW; int boxH;
int mySticks = 0;

float curStickboxX;
float curStickboxY;
float easing = 0.05;
float curfc = 0;
float diff = 120;

float[] tip1LocsX = new float[50];
float[] tip1LocsY = new float[50];
float[] tip2LocsX = new float[50];
float[] tip2LocsY = new float[50];
int[] sticksLum = new int[50];

Game currentGame; 
Player p1;
GenerousPlayer p2;
Player p3;
Player me;

PFont opensemi;
PFont openregular;

class Game {
  int[] winnersinround = new int[3];
}

class Player {
  int[] sticks = new int[4];
  boolean[] winnerofround = new boolean[4];
  int[] money = new int[4];
  void takeSticks(int currentRound) {
    this.sticks[currentRound] = int(random(1, 3));
  }
}
class GenerousPlayer{
  int[] sticks = new int[4];
  boolean[] winnerofround = new boolean[4];
  int[] money = new int[4];
  void takeSticks(int currentRound) {
    this.sticks[currentRound] = int(random(2,8));
  }
}

void newGame() {
  currentGame = new Game();
  roundNum = 1; whoseTurn=1; 
  p1 = new Player();
  p2 = new GenerousPlayer();
  p3 = new Player();
  me = new Player();
}
  
  
void setup() {
  size(500,500);
  newGame();
  curStickboxX = width/2-45;
  curStickboxY = height/2 - 165;
  for (int i=0;i<50;i++) {
    tip1LocsX[i] = random(40,60); 
    tip1LocsY[i] = random(height-120, height-25);
    tip2LocsX[i] = random(160, 200);
    tip2LocsY[i] = random(height - 120, height - 25);
    sticksLum[i] = int(random(130,200));
  }
  boxX = 20;   
  boxY = height - 130;
  boxW = 200;
  boxH = 120;
  opensemi = createFont("Open Sans Semibold", 40);
  openregular = createFont("OpenSans-Regular", 20);

}

void draw() {
  if (gameScreen == 0) {
    initScreen();
    curfc+=1;
  } else if (gameScreen == 1) {
    roundScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
  if (frameCount - curfc == diff) {
    if (whoseTurn != 0) {
      otherPlayersTurn(roundNum);
    } else { diff += 1; }
    curfc += 120;
  }
}

void initScreen() {
  background(0);
  textAlign(CENTER);
  textFont(opensemi);
  text("CLICK TO START", height/2, width/2);
}
void readyButton() {
  if (whoseTurn == 0) {  fill(100,210,100); } 
  else { fill(200, 200, 200); }
  noStroke();
  rect(stickButX, stickButY, stickButW, stickButH);
  fill(255); textFont(opensemi); textSize(16);
  text("I'M DONE", stickButX + 39, stickButY + 20);
  textFont(openregular); textSize(12);
}
void roundText() {
  textSize(12); textFont(opensemi);
  fill(0);
  text("ROUND  " + roundNum, 100, 40);
   textFont(openregular); textSize(11);
  fill(50,100,200);
  if (roundNum == 2) { 
    if (currentGame.winnersinround[0] == 1) {
    text("Round 1: You took " + me.sticks[0] + " sticks. There was " + currentGame.winnersinround[0] + " winner.", width/2+110, 20); 
    } else {
      text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.winnersinround[0] + " winners.", width/2+110, 20); 
    }
  } else if (roundNum == 3) {
    if (currentGame.winnersinround[0] == 1) {
    text("Round 1: You took " + me.sticks[0] + " sticks. There was " + currentGame.winnersinround[0] + " winner.", width/2+110, 20); 
    } else {
      text("Round 1: You took " + me.sticks[0] + " sticks. There were " + currentGame.winnersinround[0] + " winners.", width/2+110, 20); 
    } 
    if (currentGame.winnersinround[1] == 1) {
      text("Round 2: You took " + me.sticks[1] + " sticks. There was " + currentGame.winnersinround[1] + " winner.", width/2+110, 32);
    } else {
      text("Round 2: You took " + me.sticks[1] + " sticks. There were " + currentGame.winnersinround[1] + " winners.", width/2+110, 32); 
    }
  }
}
void drawPlayers() {
  int playerRad = 60;
  int[] playerlocX = {width/2 + 80, width/2-20, width/2 - 120, width/2-20 };
  int[] playerlocY = {height/2 - 60, height/2 - 160, height/2 - 60, height/2 + 40 };
  for (int i=0; i<4; i++) {
    if (i == 0) { fill(150, 255, 150); } else { fill(134, 219, 247); }
    ellipse(playerlocX[i], playerlocY[i], playerRad, playerRad);
    fill(0); String playr = i==0? "YOU" : "Player " + i; 
    text(playr, playerlocX[i], playerlocY[i]+2);
  }
//  fill(150, 200, 255); ellipse(width/2-100, height/2-150, 55, 55);
//  fill(0); text("Tham", width/2-100, height/2-145);
}
void drawSticksBox() {
  int[] boxlocX =  {width/2 + 55, width/2-45, width/2 - 145, width/2-45 };
  int[] boxlocY = {height/2 - 50, height/2 - 205, height/2 - 50,height/2 + 50 };
  fill(255); stroke(0);
  float rectTargetX = float(boxlocX[whoseTurn]);
  float rectTargetY = float(boxlocY[whoseTurn]);
  float dx = rectTargetX - curStickboxX;
  float dy = rectTargetY - curStickboxY;
  curStickboxX += dx * easing; curStickboxY += dy * easing;
  rect(curStickboxX, curStickboxY, 50, 30);
  fill(0); noStroke();textFont(opensemi); textSize(13);
  text("STICKS", curStickboxX+25, curStickboxY+20); 
  textFont(openregular); textSize(12);
}
void roundScreen() {
  background(230);
  roundText();
  readyButton();
  drawPlayers();
  drawSticksBox();
  if (whoseTurn == 0) {
    fill(255);
    rect(boxX, boxY, boxW, boxH);
    fill(230);
    rect(30, height - 120, 180, 100);
    colorMode(HSB);
    for (int i=0; i<50-mySticks; i++) {
      //draw sticks
      strokeWeight(10); stroke(30,100,sticksLum[i], 160);
      line(tip1LocsX[i], tip1LocsY[i], tip2LocsX[i], tip2LocsY[i]);
    }
    for (int i=50-mySticks; i<50; i++) {
      strokeWeight(10); stroke(30,100,sticksLum[i], 160);
      line(tip1LocsX[i]+220, tip1LocsY[i], tip2LocsX[i]+220, tip2LocsY[i]);
    }
    strokeWeight(1);
    colorMode(RGB);   fill(50,100,200); textSize(12);
    text("Click the ice cream stick box to take sticks. Press the DONE button when ready.", width/2 , height - 140);
    text("You have taken " + mySticks + " sticks.", width/2+100, height-120);
  } else {
    text("The other players are taking their sticks. Wait your turn!", width/2 , height - 140);
  }
  
}
void gameOverScreen() {
  background(0);
  fill(255);
  textFont(opensemi); textSize(50);
  text("Game Results", width/2, 80);
  textFont(openregular); textSize(16);
  text("Round 1 - Number of winners: " + currentGame.winnersinround[0], width/2, height/2-100);
  textSize(12);
  String mewin = me.winnerofround[0]? "won $" + me.money[0] : "didn't win";
  String p1win = p1.winnerofround[0]? "won $" + p1.money[0]: "didn't win";
  String p2win = p2.winnerofround[0]? "won $" + p2.money[0]: "didn't win";
  String p3win = p3.winnerofround[0]? "won $" + p3.money[0]: "didn't win";
  text("you took " + me.sticks[0] + " sticks and " + mewin, width/2, height/2-80);
  text("p1 took "+ p1.sticks[0] + " sticks and " + p1win, width/2, height/2-68);
  text("p2 took "+ p2.sticks[0] + " sticks and " + p2win, width/2, height/2-56);
  text("p3 took "+ p3.sticks[0] + " sticks and " + p3win, width/2, height/2-44);
  textSize(16);
  text("Round 2 - Number of winners: " + currentGame.winnersinround[1], width/2, height/2-24);
  textSize(12);
  mewin = me.winnerofround[1]? "won $" + me.money[1]: "didn't win";
  p1win = p1.winnerofround[1]? "won $" + p1.money[1]: "didn't win";
  p2win = p2.winnerofround[1]? "won $" + p2.money[1]: "didn't win";
  p3win = p3.winnerofround[1]? "won $" + p3.money[1] : "didn't win";
  text("you took " + me.sticks[1] + " sticks and " + mewin, width/2, height/2-4);
  text("p1 took "+ p1.sticks[1] + " sticks and " + p1win, width/2, height/2+8);
  text("p2 took "+ p2.sticks[1] + " sticks and " + p2win, width/2, height/2+20);
  text("p3 took "+ p3.sticks[1] + " sticks and " + p3win, width/2, height/2+32);
  textSize(16);
  text("Round 3 - Number of winners: " + currentGame.winnersinround[2], width/2, height/2+52);
  textSize(12);
  mewin = me.winnerofround[2]? "won $" + me.money[2]: "didn't win";
  p1win = p1.winnerofround[2]? "won $" + p1.money[2]: "didn't win";
  p2win = p2.winnerofround[2]? "won $" + p2.money[2]: "didn't win";
  p3win = p3.winnerofround[2]? "won $" + p3.money[2]: "didn't win";
  text("you took " + me.sticks[2] + " sticks and " + mewin, width/2, height/2+72);
  text("p1 took "+ p1.sticks[2] + " sticks and " + p1win, width/2, height/2+84);
  text("p2 took "+ p2.sticks[2] + " sticks and " + p2win, width/2, height/2+96);
  text("p3 took "+ p3.sticks[2] + " sticks and " + p3win, width/2, height/2+108);
  textSize(16);
  int myMoney = me.money[0] + me.money[1] + me.money[2];
  text("You won $" + myMoney +  "! Let's go on to the next section.", width/2, height - 60);
}
void otherPlayersTurn(int currentRound) {
  print(whoseTurn);
  if (whoseTurn == 1) {
    p1.takeSticks(currentRound-1);
  } else if (whoseTurn == 2) {
    p2.takeSticks(currentRound-1);
  } else if (whoseTurn == 3) {
    p3.takeSticks(currentRound-1);
  }
  whoseTurn = (whoseTurn+1)%4;
  redraw();
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
    int winAmt = 0;
    if (numOfWinners == 0) { 
      winAmt = 0;
    } else if (numOfWinners == 1) {
      winAmt = 6;
    } else if (numOfWinners == 2) {
      winAmt = 3;
    } else if (numOfWinners == 3) {
      winAmt = 2;
    } else if (numOfWinners == 4) {
      winAmt =1;
    }
    
    if (p1.winnerofround[currentRound-1]) p1.money[currentRound-1] = winAmt;
    if (p2.winnerofround[currentRound-1]) p2.money[currentRound-1] = winAmt;
    if (p3.winnerofround[currentRound-1]) p3.money[currentRound-1] = winAmt;
    if (me.winnerofround[currentRound-1]) me.money[currentRound-1] = winAmt;
   
  }
  if (roundNum == 3) gameScreen = 2;
  whoseTurn = 1;
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
      } else if (mouseX > boxX && mouseX < boxX+boxW && mouseY > boxY && mouseY < boxY+boxH) {
        mySticks ++;
      }
    }
  }
}