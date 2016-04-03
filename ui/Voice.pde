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
   else if (index == 3)
     msg = minim.loadFile("data/ReturnDecision.mp3");
   else if (index == 4)
     msg = minim.loadFile("data/continue.mp3");
   msg.play();
   delay(10);
   sayOnce = false;
 }
 msg = null;
}