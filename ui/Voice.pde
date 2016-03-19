 //<>//
void sayIt(int index)
{  
  if(sayOnce)
  {
  if (index == 0)
    song = minim.loadFile("data/selectCoins.mp3");
  else if (index == 1)
    song = minim.loadFile("data/selectEmoji.mp3");
  song.play();
  sayOnce = false;
  }
  song = null;
}