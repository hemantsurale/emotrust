class Coins
{
  int id;
  int ht, wt;
  boolean isSelected, locked;
  PImage coinPic;
  PVector point1, target1, basepoint;
  boolean itsMe;
  Ani aniA;
  //constructor: used to initialize the variables.
  Coins(int startX, int startY)
  {
    id = 0;
    ht = wt = 30;
    isSelected = false;
    point1 = new PVector(startX, startY);
    target1 = new PVector(startX, startY);
    basepoint = new PVector(startX, startY);
    coinPic = loadImage("coin.png");
    coinPic.resize(45, 45);
    itsMe = false;
  }
  void gotoXY(float px, float py, int x, int y)
  {
    if (itsMe)
    {
      //isSelected = true;
      target1.x = x;
      target1.y = y;
      point1.x  = px;
      point1.y  = py;
      Ani.to(point1, 1.0f, "x", target1.x);
      Ani.to(point1, 1.0f, "y", target1.y);
    }
  }
  void goBackToBase()
  {
    point1.x =  basepoint.x;
    point1.y =  basepoint.y;
  }
  void draw(float x, float y, int sizeX, int sizeY)
  {
    coinPic.resize(sizeX, sizeY);
    image(coinPic, x, y);
    aniA = new Ani(this, 2, "diaA", sizeX);
  }

  void isItMe(boolean flag)
  {
    coinPic.filter(INVERT);
    itsMe = flag;
  }

  boolean isHit(int mX, int mY, int sizeX, int sizeY)
  {
    if (mX >= point1.x && mX <= (point1.x + sizeX)
      && mY >= point1.y && mY <= (point1.y + sizeY) && !locked)
    {
      return true;
    }
    return false;
  }
  
  void changefilter(char c)
  {
    if (c == 'i')
      coinPic.filter(INVERT);
    if (c == 's')
      coinPic.filter(INVERT);
  }
  
  boolean isSelected()
  {
    if (itsMe)
      return true;
    return false;
  }

  void hide()
  {
    coinPic = null;
  }

  void show()
  {
    coinPic = loadImage("coin.png");
  }
  
  void lockUnlock(boolean lock)
  {
     locked = lock;
  }
  
}