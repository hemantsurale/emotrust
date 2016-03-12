import controlP5.*;

ControlP5 ui;
Button send_b, reset_b;
float send_b_x, reset_b_x, button_y, salt;    // salt is used to control the position as needed
boolean doNotDraw = false;

void setupButton()
{
  send_b_x = displayWidth * 0.4;
  reset_b_x = displayWidth * 0.3;
  button_y = displayHeight * 0.9;
  ui = new ControlP5( this );
  send_b = ui.addButton( "SEND   >>>>>" )
    .setPosition(send_b_x, button_y)
    .setSize( 400, 100 )
    .setColorBackground(#007F00);
  //reset_b = ui.addButton( "<<<<<   RESET" )
  //  .setPosition(reset_b_x, button_y)
  //  .setSize( 400, 100 )
  //  .setColorBackground(#007F00);
}

void controlEvent(ControlEvent ev)
{
  int emojiId = 0, coinNo = 0;
  boolean emo_selected = false;
  if (ev.isFrom(send_b))
  {
    if (state  == 1)
    {
      for (int j1 = 0; j1 < faceCount; j1++)
        if (e[j1].isItMe())
        {
          emo_selected = true;
          emojiId = e[j1].getType();
        }
      state = 2;
      //send_b.lock();
      if (!emo_selected)
      {
        MsgBox("Did you forget Emoji?", "Error!!");
        state = 1;              // if emoji is not selected go back to the same state.
      }

      // reset the flags of previously selected coins
      for (j = 0; j < 10; j++)
      {
        if (c[j].isSelected()) 
          c[j].isItMe(false);  
        c[j].lockUnlock(false); 
      }
          
      for (j = 0; j<faceCount; j++)
        if (e[j].isItMe())
        {
          e[j].goBackToBase(sizeofFace, sizeofFace);
          e[j].ItzMe(false);
        }
    }

    if (state == 0)
    {
      for (j = 0; j < 10; j++)
        if (c[j].isSelected())  
        {
          c[j].gotoXY(c[j].point1.x, c[j].point1.y, 
            (int)(displayWidth * 0.5), (int)button_y);
          coinNo++;
        }
      doNotDraw = true;
      state = 1;
      // Get Coin Count and Emotion ID from edmund
      setCoinsNEmotions(ceil(random(0, faceCount - 1)), ceil(random(0, faceCount - 1))); 
      for (j = 0; j < 10; j++)
        c[j].lockUnlock(true); 
    }

    // uncomment following code to get emotion ID and Total coins shared.
    //if (emo_selected)
    //MsgBox("emotion Id: " + String.valueOf(emojiId) +
    //  ", totalCoins:" + String.valueOf(coinNo), "Success!!");
    // send to edmund // get parameter list to be sent from here.
  }

  if (ev.isFrom(reset_b))
    for (j = 0; j < 10; j++)
      if (c[j].isSelected())
      {
        c[j].gotoXY((int)send_b_x, (int)button_y, 
          (int)c[j].basepoint.x, (int)c[j].basepoint.y);
        c[j].isItMe(true);
      }
}

// Fire messages
void MsgBox(String Msg, String Title) 
{
  javax.swing.JOptionPane.showMessageDialog (
    null, Msg, Title, javax.swing.JOptionPane.INFORMATION_MESSAGE);
}

void setCoinsNEmotions(int cCount, int eId)
{
  BCreceived  = cCount;
  Ereceived = eId;
}