class Emotion
{
  int ht, wt;
  PImage emoPic;
  PVector point1, target1, basepoint;
  boolean itsMe;
  Ani aniA;

  //constructor: used to initialize the variables.
  Emotion(int startX, int startY, String emoName)
  {
    ht = wt = 300;
    point1 = new PVector(startX, startY);
    basepoint = new PVector(startX, startY);
    target1 = new PVector(startX, startY);
    emoPic = loadImage(emoName);
    emoPic.resize(200, 200);
    itsMe = false;
  }

  void gotoXY(float px, float py, int x, int y)
  {
    target1.x = x;
    target1.y = y;
    point1.x  = px;
    point1.y  = py;
    Ani.to(point1, 1.0f, "x", target1.x);
    Ani.to(point1, 1.0f, "y", target1.y);
    //emoPic.resize(200, 200);
    //image(emoPic,target1.x,target1.y,300,300);
    
  }

  void draw(float x, float y, int sizeX, int sizeY)
  {
    emoPic.resize(sizeX, sizeY);
    image(emoPic, x, y);
  }

  // this will show/hide the emotion to the user
  void showOrHide()
  {
    
  }

  void animate()
  {
    // animation would be to slowly grow and shrink when necessary.
  }

  boolean isHit(int mX, int mY, int sizeX, int sizeY)
  {
    if (mX >= point1.x && mX <= (point1.x + sizeX)
      && mY >= point1.y && mY <= (point1.y + sizeY))
    {
      return true;
    }
    return false;
  }

  void ItzMe(boolean flag)
  {
    itsMe = flag;
  }

  boolean isItMe()
  {
    return itsMe;
  }

  void goBackToBase(int sizeX, int sizeY)
  {
    Ani.to(point1, 1.0f, "x", basepoint.x);
    Ani.to(point1, 1.0f, "y", basepoint.y);
    emoPic.resize(sizeX, sizeY);
  }
}