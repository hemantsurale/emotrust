 //<>//
void sayIt(int index)
{  
  if (sayOnce)
  {
    if (index == 0)
      msg = minim.loadFile("data/selectCoins.mp3");
    else if (index == 1)
      msg = minim.loadFile("data/selectEmoji.mp3");
    else if (index == 2)
      msg = minim.loadFile("data/nextpart.mp3");
    msg.play();
    sayOnce = false;
  }
  msg = null;
}