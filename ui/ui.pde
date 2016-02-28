import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

PImage bg, coins, gameName;       // image objects of canvas and coins
PFont font;
Coins[] c;              // object declaration
int i1, j, dist = 50, x, size = 50;
int state;              // to maintain the game state
void setup()
{
  size(displayWidth, displayHeight); // fullscreen
  Ani.init(this);       
  c = new Coins[20];    // object memory allocation
  // 10 coins in 1st row
  for (x = 0; x < 10; x++) 
  {
    c[x] = new Coins((int)(dist + displayWidth * 0.2), 
    (int)( displayHeight * 0.6));
    dist += 50;
    c[x].changefilter('i');
  }
  dist = 50;
  // 10 coins in 2nd row
  for (; x < 20; x++) 
  {
    c[x] = new Coins((int)(dist + displayWidth * 0.2), 
    (int)(100 + displayHeight * 0.6));
    dist += 50;
  }
  // laptop vs desktop
  if (displayWidth == 1680)
    bg = loadImage("bkgrnd1.jpg");
  else
    bg = loadImage("bkgrnd.jpg");
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
  text("Coins recieved", (int)(50 + displayWidth * 0.15), 
    (int)( displayHeight * 0.59)); 
  text("Your coins", (int)(50 + displayWidth * 0.15), 
    (int)(80 + displayHeight * 0.61)); 
  
  // control movement here.
  //c[3].isItMe(false);
  
  // draw coins
  noStroke();
  fill(255, 0, 0, 128);
  for (j = 0; j<20; j++)
    c[j].draw(c[j].point1.x, c[j].point1.y, size, size);
  stroke(255, 0, 0, 128);
  strokeWeight(2);
  noFill();
  
  // update coin position
  for (i1 = 0; i1 < 20; i1++)
  {
    c[i1].point1.x = c[i1].target1.x;
    c[i1].point1.y = c[i1].target1.y;
  }
}

void mousePressed()
{
  // do the coin hit-test here.
  for (j = 0; j<20; j++)
  {
    //if((sq(mouseX - c[j].point1.x) + sq(mouseY - c[j].point1.y)) < sq(30))
    if(c[j].isHit(mouseX, mouseY, size, size))
     c[j].isItMe(true);
    else
      c[j].gotoXY(c[j].point1.x, c[j].point1.y, mouseX, mouseY);
  }
}