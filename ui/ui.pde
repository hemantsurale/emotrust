import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

PImage bg, coins;
Coins[] c;              // object declaration
int i1, j, dist = 50, x;
void setup()
{
  size(displayWidth, displayHeight);
  Ani.init(this);
  c = new Coins[20];    // object memory allocation
  for (x = 0; x < 10; x++) 
  {
    c[x] = new Coins((int)(dist + displayWidth * 0.2), 
    (int)( displayHeight * 0.6));
    dist += 50;
  }
  dist = 50;
  for (; x < 20; x++) 
  {
    c[x] = new Coins((int)(dist + displayWidth * 0.2), 
    (int)(50 + displayHeight * 0.6));
    dist += 50;
  }
  if (displayWidth == 1680)
    bg = loadImage("bkgrnd1.jpg");
  else
    bg = loadImage("bkgrnd.jpg");
}

void draw()
{
  background(bg);
  
  // control movement here.
  //c[3].isItMe(false);
  
  noStroke();
  fill(255, 0, 0, 128);
  for (j = 0; j<20; j++)
    c[j].draw(c[j].point1.x, c[j].point1.y, 50, 50);
  stroke(255, 0, 0, 128);
  strokeWeight(2);
  noFill();
  for (i1 = 0; i1 < 20; i1++)
  {
    c[i1].point1.x = c[i1].target1.x;
    c[i1].point1.y = c[i1].target1.y;
  }
}

void mousePressed()
{
  // do the circle hit-test here.
  for (j = 0; j<20; j++)
  {
    if((sq(mouseX - c[j].point1.x) + sq(mouseY - c[j].point1.y)) < sq(30))
     c[j].isItMe(true);
    else
      c[j].gotoXY(c[j].point1.x, c[j].point1.y, mouseX, mouseY);
  }
}