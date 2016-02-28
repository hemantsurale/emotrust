class Coins
{
  int id;
  int ht, wt;
  boolean ggo;
  PImage coinPic;
  PVector point1, target1;
  boolean itsMe;

  //constructor: used to initialize the variables.
  Coins(int startX, int startY)
  {
    id = 0;
    ht = wt = 30;
    ggo = false;
    point1 = new PVector(startX, startY);
    target1 = new PVector(startX, startY);
    coinPic = loadImage("coin.png");
    coinPic.resize(45, 45);
    itsMe = false;
  }
  void gotoXY(float px, float py, int x, int y)
  {
    if (itsMe)
    {
      ggo = true;
      target1.x = x;
      target1.y = y;
      point1.x  = px; 
      point1.y  = py;
      Ani.to(point1, 1.0f, "x", target1.x);
      Ani.to(point1, 1.0f, "y", target1.y);
    }
  }
  void draw(float x, float y, int sizeX, int sizeY)
  {
    coinPic.resize(sizeX, sizeY);
    image(coinPic, x, y);
  }

  void isItMe(boolean flag)
  {
    itsMe = flag;
  }
}