import controlP5.*;   //<>// //<>//
import javax.swing.JOptionPane;
import javax.swing.JDialog;
import javax.swing.JOptionPane;

ControlP5 ui;
Button send_b;
float send_b_x, button_y, salt;    // salt is used to control the position as needed
boolean doNotDraw = false;
int temp1, allcoins;

void setupButton()
{
  send_b_x = displayWidth * 0.4;
  button_y = displayHeight * 0.85;

  ui = new ControlP5( this );
  send_b = ui.addButton( "SEND" )
    .setPosition(send_b_x, button_y)
    .setSize( 400, 100 )
    .setColorBackground(#7A5230)
    .setColorActive(#AA7243);
}

void controlEvent(ControlEvent ev)
{
  int emojiId = 0, coinNo = 0, temp = 0, part1Emoji = 0;
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
        return;
      } else
      {
        if (m.getCurrentRound() <= totalRounds)
        {
          nextRound = true;
          m.increaseRound();
        }
      }

      backTobaseAllOwn();
      lockAllOwn(false);

      for (j = 0; j<faceCount; j++)
        if (e[j].isItMe())
        {
          e[j].goBackToBase(sizeofFace, sizeofFace);
          e[j].ItzMe(false);
        }
      allcoins = BCreceived = 0;
      Ereceived = temp1;
      println("Eid:" + temp1);
      interaction_no = 0;
      send_b.setLabel("RETURN");
      m.log();
      doNotDraw = true;
      time = ceil(random(1, 5));
    }

    if ( state == 0)
    {
      // start the white out screen.
      doNotDraw = true;
      time = ceil(random(1, 5));

      if (m.getCurrentRound() <= part1Rounds)
      {
        coinNo = selectCoins(1);
        if (coinNo == 0)
        {
          if (MegBoxYN("Do you really want to share 0 coins?", "Confirm") == 0)
          {
            doNotDraw = false;
            return;
          }
        }
        m.getCoinsSentByOpponent(coinNo);
        println("Coins selected: " + coinNo);
        BCreceived = m.sendCoinsToOpponent();
        println("Coins received P1: " + BCreceived);
        m.updateScore();
        deSelectAllBC();        // set received coins
        temp1 = m.sendEmoToOpponent();  // set emotions to be shown
        println("Emoji received: " + temp1);
        lockAllOwn(true);
        nextRound = false;
        state = 1;
      } else if ( m.getCurrentRound() <= totalRounds)
      {
        
        if (interaction_no == 0)
        {
          println("interaction 1");
          coinNo = selectCoins(1);
          if (coinNo == 0)
          {
            if (MegBoxYN("Do you really want to share 0 coins?", "Confirm") == 0)
            {
              doNotDraw = false;
              return;
            }
          }
          
          m.getCoinsSentByOpponent(coinNo);
          println("Coins selected I1: " + coinNo);
          BCreceived = m.determineNumberCoinGive();
          deSelectBC(BCreceived);
          deSelectAllBC();
          println("Coins received I1: " + BCreceived);
          lockAllOwn(true);
          Ereceived = -1;
          interaction_no = 1;
          send_b.setLabel("RETURN");
          lockAllBC(true);
          allcoins = BCreceived;
        } else if (interaction_no == 1)
        {
          
          println("interaction 2: ");
          //coinNo = selectCoins(2);
          //if (coinNo == 0)
          //{
          //  if (MegBoxYN("Do you really want to share 0 coins?", "Confirm") == 0)
          //  {
          //    doNotDraw = false;
          //    return;
          //  }
          //}
          //m.getCoinsReturnedByOpponent(coinNo);
          m.getCoinsReturnedByOpponent(allcoins);
          //println("Coins selected I2: " + coinNo);
          println("Coins selected I2: " + allcoins);
          BCreceived = m.determineNumCoinReturn();
          m.updateScore();
          //BCreceived = 5;  // if determineNumCoinReturn gives coins back, they are visible.
          println("Coins received I2: " + BCreceived);
          temp1 = m.sendEmoToOpponent();
          println("Emoji received I2: " + temp1);
          deSelectBC(BCreceived);
          lockAllBC(true);
          lockAllOwn(true);
          state = 1;
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

int MegBoxYN(String Msg, String Title)
{
  int response = JOptionPane.showConfirmDialog(null, Msg, Title, 
    JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
  JDialog.setDefaultLookAndFeelDecorated(true);
  if (response == JOptionPane.NO_OPTION) {
    return 0;
  } else if (response == JOptionPane.YES_OPTION) {
    return 1;
  } else if (response == JOptionPane.CLOSED_OPTION) {
    return 1;
  }
  return 2;
}


void setCoinsNEmotions(int cCount)
{
  BCreceived  = cCount;
}

int selectCoins(int flag)
{
  int coinNo = 0;
  // count number of coins selected to be sent to computer agent.
  for (j = 0; j < 10 && flag == 1; j++)
    if (c[j].isSelected())  
    {
      c[j].gotoXY(c[j].point1.x, c[j].point1.y, 
        (int)(displayWidth * 0.5), (int)button_y);
      coinNo++;
    }

  // if it is interaction_no == 1, player can send received coins too.
  for (j = 0; interaction_no == 1 & j < 10 && flag == 2; j++)
    if (bc[j].isSelected())  
    {
      bc[j].gotoXY(bc[j].point1.x, bc[j].point1.y, 
        (int)(displayWidth * 0.5), (int)button_y);
      coinNo++;
    } 
  return coinNo;
}

void deSelectAllOwn()
{
  for (j = 0; j < 10; j++)
  {
    c[j].show();
    c[j].changefilter('i');
    c[j].isItMe(false);
  }
}

void backTobaseAllOwn()
{
  for (j = 0; j < 10; j++)
    c[j].goBackToBase();
}

// flag: 1 lock all, flag: 0 unlock all.
void lockAllOwn(boolean flag)
{
  for (j = 0; j < 10; j++)
    c[j].lockUnlock(flag);
}

void unlockReceived(int no)
{
  for (j = 0; j < no; j++)
    bc[j].lockUnlock(true);
}

void deSelectBC(int no)
{
  for (j = 0; j < no; j++)
  {
    bc[j] = null;
  }

  for (x = 0, dist = ceil(0.03 * displayWidth); x < 10; x++) 
  {
    bc[x] = new Coins((int)(dist + displayWidth * 0.6), 
      (int)( displayHeight * 0.7));
    dist += ceil(0.03 * displayWidth);
    //bc[x].changefilter('i');
  }

  for (j = 0; j < no && time == 0; j++)
  {
    bc[j].draw(bc[j].point1.x, bc[j].point1.y, size, size);
  }
}

void backTobaseBC(int no)
{
  for (j = 0; j < no; j++)
    bc[j].goBackToBase();
}

void deSelectAllBC()
{
  for (j = 0; j < 10; j++)
  {
    bc[j].show();
    bc[j].changefilter('i');
    bc[j].isItMe(false);
  }
}

void lockAllBC(boolean flag)
{
  for (j = 0; j < 10; j++)
    bc[j].lockUnlock(flag);
}