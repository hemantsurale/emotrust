/* //<>// //<>//
  Affective computing project.
 Team - Shikha, Edmund, Hemant
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Minim minim;
AudioPlayer msg;
String fn;
File ddf;
PImage bg, coins, gameName;       // image objects of canvas and coins
PFont font;
Coins[] c, bc;              // object declaration ownCoins and BlueCoins.
Emotion[] e, be;            // BlueEmotions by the opponent.
model m;                    // model initialization
int i1, j, dist = ceil(0.03 * displayWidth), x, size = 50, sizeofFace = 100;
int state = 0, status = 0;              // State: 1 if coins are sent.
int time;
String[] instruction;
int faceCount = 6, BCreceived  = 0, Ereceived = -1;
int interaction_no = 0;    // to count the interaction number for part 2
int part1Rounds, totalRounds;
boolean sayOnce = true;
String[] lines, list;

void setup()
{
  setupButton();       // initialize button parameters.
  initCanvas();        // setting up the coins and emoji panel.
  initRounds(5, 10);    // part1Rounds, totalRounds.
  minim = new Minim(this);  // initialization of sound.
  fullScreen();      
  time = 1;            // screen white out time, after player has sent the coins.
  changeSetting();
}

void draw()
{
  if (m.getCurrentRound() == totalRounds + 1)
    exit(); 
  if (!doNotDraw)
  {
    if (state == 2)
    {
      for (i1 = 0; i1 < 10; i1++)
      {
        if (c[i1].isSelected())
          c[i1].isItMe(false);
        c[i1].point1.x = c[i1].basepoint.x;
        c[i1].point1.y = c[i1].basepoint.y;
      }
      state = 0;
    }
    paintCanvas();

    // draw available coins
    noStroke();
    fill(255, 0, 0, 128);
    for (j = 0; j < 10; j++)
      c[j].draw(c[j].point1.x, c[j].point1.y, size, size);

    if (BCreceived >= 10)
      BCreceived = 9;

    // Draw recieved coins and emotions
    for (j = 0; j < BCreceived /*&& BCreceived < 10*/; j++)
      bc[j].draw(bc[j].point1.x, bc[j].point1.y, size, size);

    if (Ereceived != -1)
      be[Ereceived].gotoXY(be[Ereceived].point1.x, be[Ereceived].point1.y, 
        (int) (displayWidth * 0.7), (int)(displayHeight * 0.3));

    stroke(255, 0, 0, 128);
    strokeWeight(2);
    noFill();

    // emotion panel
    fill(255);
    text("Emoji", 80, 90);
    fill(255, 20);
    stroke(0, 0);
    rect(20, 50, 
      displayWidth * 0.1, displayHeight - 150);
    for (j = 0; j < faceCount; j++)
    {
      e[j].draw(e[j].point1.x, e[j].point1.y, sizeofFace, sizeofFace);
      e[j].animate(time);
    }
  } else 
  {
    if (time != 0)
    {
      delay(time--);
      rect(0, 0, displayWidth, displayHeight);
      send_b.hide();
    } else
    {
      doNotDraw = false;
      send_b.show();
    }
  }
}

void mousePressed()
{
  boolean is_someone_hit = false;
  if (!doNotDraw)
  {
    // do the coin hit-test here.
    for (j = 0; j<10; j++)
      if (c[j].isHit(mouseX, mouseY, size, size))
      {
        if (!c[j].isSelected())
          c[j].isItMe(true);
        else
        {
          //c[j].changefilter('i');
          c[j].isItMe(false);
        }
      }

    for (j = 0; interaction_no == 1 && j<10; j++)
      if (bc[j].isHit(mouseX, mouseY, size, size))
      {
        if (!bc[j].isSelected())
          bc[j].isItMe(true);
        else
        {
          //bc[j].changefilter('i');
          bc[j].isItMe(false);
        }
      }

    // do the face hit-testing here.
    // somebodyz hit
    for (j = 0; j<faceCount; j++)
      if (e[j].isHit(mouseX, mouseY, sizeofFace, sizeofFace))
      {
        is_someone_hit = true;
        //if ( mouseX < (displayWidth * 0.2))
        //time = millis();
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
}

void keyPressed() 
{
  if (key == 27)    // ignore the escape key
    key = 0;
}

void paintCanvas()
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

  if (state == 0)
  {
    textSize(40);
    text("Round: " + m.getCurrentRound() + " " 
      + instruction[state], displayWidth * 0.35, displayHeight * 0.2); 
    sayIt(state);
  } else
  {
    textSize(40);
    text("Round: " + m.getCurrentRound() + " "
      + instruction[state], displayWidth * 0.35, displayHeight * 0.2); 
    sayIt(state);
  }
  textSize(35);

  // update player score
  text("Your score: " + m.score[0], (int)(50 + displayWidth * 0.15), 
    (int)(displayHeight * 0.61) + 90);
}

void initCanvas()
{
  Ani.init(this); 
  m = new model();
  c = new Coins[20];    // object memory allocation, ownCoins
  bc = new Coins[10];   // blue coins
  e = new Emotion[20];
  be = new Emotion[20];
  instruction = new String[10];
  instruction[0] = "Select Coins and Press Send Button.";
  instruction[1] = "Select Emoji and Press Send Button.";

  // 8 emotions in the emotion panel
  for (x = 0, j = 1; x < faceCount; x++) 
  {
    e[x] = new Emotion((int)(displayWidth * 0.03), 
      (int)(2*dist + displayHeight * 0.1), x);
    dist += ceil(0.03 * displayWidth);
    e[x].loadImages("a" + j + ".png");
    e[x].id = j;
    j++;
  }

  // 8 computer agent's emotions
  for (x = 0, j = 1; x < faceCount; x++) 
  {
    be[x] = new Emotion((int)(displayWidth * 0.2), 
      (int)(2*dist + displayHeight * 0.1), x);
    dist += ceil(0.03 * displayWidth);
    be[x].loadImages("a" + j + ".png");
    be[x].id = j;
    j++;
  }

  // 10 coins in 1st row
  for (x = 0, dist = ceil(0.03 * displayWidth); x < 10; x++) 
  {
    bc[x] = new Coins((int)(dist + displayWidth * 0.6), 
      (int)( displayHeight * 0.6));
    dist += ceil(0.03 * displayWidth);
    bc[x].changefilter('i');
  }

  // 10 coins in 2nd row
  for (x = 0, dist = 0; x < 10; x++) 
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

void initRounds(int part1, int total)
{
  part1Rounds = part1;
  totalRounds = total;
}

void changeSetting()
{
  int tft, cemotion, dovera;
  
  fn=sketchPath("data//settings.csv");
  ddf=sketchFile(fn);
  
  if (ddf.exists()) {
    println("Settings File Found!!");
    lines = loadStrings("data//settings.csv");
    list = splitTokens(lines[0], ",");
    tft = Integer.parseInt(list[0]);
    cemotion = Integer.parseInt(list[1]);
    dovera = Integer.parseInt(list[2]);
    m.TFT = m.consistentEmotion = m.dissapointmentOverAnger = false;
    if ( tft != 0)
      m.TFT = true;
    if ( cemotion != 0)
      m.consistentEmotion = true;
    if ( dovera != 0)
      m.dissapointmentOverAnger = true;
  } 
  else 
    println("Settings Not Found!!");
}