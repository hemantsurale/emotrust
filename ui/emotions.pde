class Emotion
{
  int ht, wt;
  PImage emoPic;
  PVector point1, target1;
  boolean itsMe;
  Ani aniA;
  
  //constructor: used to initialize the variables.
  Emotion(int startX, int startY, String emoName)
  {
    ht = wt = 300;
    point1 = new PVector(startX, startY);
    target1 = new PVector(startX, startY);
    emoPic = loadImage(emoName);
    emoPic.resize(200, 200);
    itsMe = false;
  }
  
  // this will show/hide the emotion to the user
  void showOrHide()
  {
    
  }
  
  void animate()
  {
     // animation would be to slowly grow and shrink when necessary. 
  }
  
  boolean isItHit()
  {
     // this function will let the user choose desired emotion. 
     return true;
  }
  
  
  
}