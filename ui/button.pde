import controlP5.*;

ControlP5 ui;
Button send_b;
float send_b_x, button_y, salt;    // salt is used to control the position as needed
boolean doNotDraw = false;

void setupButton()
{
  send_b_x = displayWidth * 0.4;
  button_y = displayHeight * 0.9;
  ui = new ControlP5( this );
  send_b = ui.addButton( "SEND   >>>>>" )
    .setPosition(send_b_x, button_y)
    .setSize( 400, 100 )
    .setColorBackground(#007F00);
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
      } else
      {
        if (m.getCurrentRound() <= totalRounds)
          m.increaseRound();
      }

      // reset the flags of previously selected coins
      for (j = 0; j < 10; j++)
      {
        c[j].lockUnlock(false);
        if (c[j].isSelected()) 
          c[j].isItMe(false);
      }

      for (j = 0; j<faceCount; j++)
        if (e[j].isItMe())
        {
          e[j].goBackToBase(sizeofFace, sizeofFace);
          e[j].ItzMe(false);
        }
      BCreceived = 0;
      Ereceived = -1;
    }

    if (state == 0)
    {
      // count number of coins selected to be sent to computer agent.
      for (j = 0; j < 10; j++)
        if (c[j].isSelected())  
        {
          c[j].gotoXY(c[j].point1.x, c[j].point1.y, 
            (int)(displayWidth * 0.5), (int)button_y);
          coinNo++;
        }
        
      // if it is interaction_no == 1, player can send received coins too.
      for (j = 0; interaction_no == 1 & j < 10; j++)
        if (bc[j].isSelected())  
        {
          bc[j].gotoXY(bc[j].point1.x, bc[j].point1.y, 
            (int)(displayWidth * 0.5), (int)button_y);
          coinNo++;
        }
        
      // start the white out screen.
      doNotDraw = true;

      // Player may choose zero coins, so we could skip the coin# checks.
      if (m.getCurrentRound() <= part1Rounds)
      {
        state = 1;                // meaning player can select coins to be sent to computer.  
        m.getCoinsSentByOpponent(coinNo);
        // Get Coin Count and Emotion ID from edmund
        setCoinsNEmotions(m.sendCoinsToOpponent(), m.sendEmoToOpponent()); 
       
        // lock all the coins, as in part1, player should only send emoji after sending the coins.
        for (j = 0; j < 10; j++)
          c[j].lockUnlock(true); 
          
      } else if (m.getCurrentRound() <= totalRounds)
      {
        if (interaction_no == 0)
        {
          interaction_no = 1;
          m.getCoinsSentByOpponent(coinNo);
          setCoinsNEmotions(m.sendCoinsToOpponent(), m.sendEmoToOpponent()); 
      
          // unlock all the coins received by the player.
          for (j = 0; j < 10; j++)
          {
            bc[j].lockUnlock(false); 
            bc[j].changefilter('i');
          }
          //for (j = 0; j < 10; j++)
          //  c[j].isItMe(false); // unlock all the coins, as player should send emoji only.
        } else if (interaction_no == 1)
        {
          m.getCoinsReturnedByOpponent(coinNo);
          setCoinsNEmotions(m.sendCoinsToOpponent(), m.sendEmoToOpponent()); 
          for (j = 0; j < 10; j++)
          {
            bc[j].lockUnlock(true); // unlock all the coins, as player should send emoji only.

            if (bc[j].isSelected())
              bc[j].changefilter('i');
            bc[j].goBackToBase();

            // send the previously selected set of coins backToBase
            // Also, deselect and unclock them.
            if (c[j].isSelected())
            {
              c[j].isItMe(false);
              c[j].show();
              c[j].goBackToBase();
              c[j].lockUnlock(false);
            }
          }
          state = 1;            // player can select the emoji.
          interaction_no = 0;   // reset the interaction_no.
        }
      }
    }
    sayOnce = true;
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