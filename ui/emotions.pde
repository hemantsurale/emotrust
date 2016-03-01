class Emotion //<>//
{
  int ht, wt, id;      // id reflects the emotion type
  PImage emoPic;
  PVector point1, target1, basepoint;
  boolean itsMe;
  Ani aniA;

  //constructor: used to initialize the variables.
  Emotion(int startX, int startY, int type)
  {
    ht = wt = 300;
    point1 = new PVector(startX, startY);
    basepoint = new PVector(startX, startY);
    target1 = new PVector(startX, startY);
    itsMe = false;
    id = type;
  }

  void loadImages(String path)
  {
    emoPic = loadImage(path);
    emoPic.resize(200, 200);
  }

  void gotoXY(float px, float py, int x, int y)
  {
    target1.x = x;
    target1.y = y;
    point1.x  = px;
    point1.y  = py;
    Ani.to(point1, 1.0f, "x", target1.x);
    Ani.to(point1, 1.0f, "y", target1.y);
    image(emoPic, target1.x - 100, target1.y - 100, 300, 300);
    //emoPic.resize(200, 200);
    //image(emoPic,target1.x,target1.y,300,300);
  }

  void draw(float x, float y, int sizeX, int sizeY)
  {
    emoPic.resize(sizeX, sizeY);
    image(emoPic, x, y);
  }

  // this will show/hide the opponent's emotion to the user
  void showOrHide()
  {
  }

  void animate(int time)
  {
    // animation would be to slowly grow and shrink when necessary.
    if (isItMe() && (millis() - time) > 1000)  // make it large
      image(emoPic, target1.x - 100, target1.y - 100, 300, 300);
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

  int getType()
  {
    return id;
  }
}