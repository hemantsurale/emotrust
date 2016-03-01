import de.looksgood.ani.*; //<>//
import de.looksgood.ani.easing.*;

PImage bg, coins, gameName;       // image objects of canvas and coins
PFont font;
Coins[] c, bc;              // object declaration ownCoins and BlueCoins.
Emotion[] e, be;            // BlueEmotions by the opponent.
int i1, j, dist = ceil(0.03 * displayWidth), x, size = 50, sizeofFace = 100;
int state;              // to maintain the game state - start Screen, play game, end Game.
int time;
int faceCount = 7;

void setup()
{
  setupButton();

  size(displayWidth, displayHeight); // fullscreen
  Ani.init(this);           
  c = new Coins[10];    // object memory allocation, ownCoins
  bc = new Coins[10];   // blue coins
  e = new Emotion[20];
  j = 1;
  // 8 emotions in the emotion panel
  for (x = 0; x < faceCount; x++) 
  {
    e[x] = new Emotion((int)(displayWidth * 0.03), 
      (int)(2*dist + displayHeight * 0.1), x);
    dist += ceil(0.03 * displayWidth);
    e[x].loadImages("a" + j + ".png");
    e[x].id = j;
    j++;
  }

  dist = ceil(0.03 * displayWidth);
  // 10 coins in 1st row
  for (x = 0; x < 10; x++) 
  {
    bc[x] = new Coins((int)(dist + displayWidth * 0.6), 
      (int)( displayHeight * 0.6));
    dist += ceil(0.03 * displayWidth);
    bc[x].changefilter('i');
  }
  dist = 0;
  // 10 coins in 2nd row
  for (x = 0; x < 10; x++) 
  {
    c[x] = new Coins((int)(dist + displayWidth * 0.2), 
      (int)( displayHeight * 0.6));
    dist += ceil(0.03 * displayWidth);
  }
  // laptop vs desktop
  //if (displayWidth == 1680)
  bg = loadImage("bkgrnd1.jpg");
  bg.resize(displayWidth, displayHeight);
  gameName = loadImage("emotrust.png");
  gameName.resize(800, 300);
  font  = loadFont("customs.vlw");
  textFont(font, 32);
}

void draw()
{
  // static UI part
  background(bg);  // paint the canvas with image
  fill(255);
  image(gameName, displayWidth * 0.3, 0);
  textSize(35);
  text("Coins recieved", (int)(180 + displayWidth * 0.51), 
    (int)(displayHeight * 0.61) - 30);
  text("Your coins", (int)(50 + displayWidth * 0.15), 
    (int)(displayHeight * 0.61) - 30);

  // draw coins
  noStroke();
  fill(255, 0, 0, 128);
  for (j = 0; j<10; j++)
    c[j].draw(c[j].point1.x, c[j].point1.y, size, size);
  for (j = 0; j<10; j++)
    bc[j].draw(bc[j].point1.x, bc[j].point1.y, size, size);
  stroke(255, 0, 0, 128);
  strokeWeight(2);
  noFill();

  // update coin position
  for (i1 = 0; i1 < 10; i1++)
  {
    c[i1].point1.x = c[i1].target1.x;
    c[i1].point1.y = c[i1].target1.y;
  }

  // emotion panel
  fill(255);
  text("Select", 60, 90);
  fill(255, 20);
  stroke(0, 0);
  rect(20, 50, 
    displayWidth * 0.1, displayHeight - 150);
  for (j = 0; j < faceCount; j++)
  {
    e[j].draw(e[j].point1.x, e[j].point1.y, sizeofFace, sizeofFace);
    e[j].animate(time);
  }
}

void mousePressed()
{
  boolean is_someone_hit = false;
  // do the coin hit-test here.
  for (j = 0; j<10; j++)
  {
    if (c[j].isHit(mouseX, mouseY, size, size))
      c[j].isItMe(true);
    //else
    //  c[j].gotoXY(c[j].point1.x, c[j].point1.y, mouseX, mouseY);
  }

  // do the face hit-testing here.
  // somebodyz hit
  for (j = 0; j<faceCount; j++)
    if (e[j].isHit(mouseX, mouseY, sizeofFace, sizeofFace))
    {
      is_someone_hit = true;
      if( mouseX < (displayWidth * 0.2))
        time = millis();
    }

  for (j = 0; j<faceCount; j++)
  {
    if (e[j].isHit(mouseX, mouseY, sizeofFace, sizeofFace))
    {
      e[j].ItzMe(true);
      e[j].gotoXY(e[j].point1.x, e[j].point1.y, 
        (int) (displayWidth * 0.4), (int)(displayHeight * 0.3));
    } else if (e[j].isItMe() && is_someone_hit)
    {
      e[j].goBackToBase(sizeofFace, sizeofFace);
      e[j].ItzMe(false);
    }
  }
}