import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.Random;

public class model {
  /* *VERY IMPORTANT*
   0: Participant
   1: Computer
   */

  private Table log = new Table();
  public int round;
  public int part;
  public int computerEmojiIndex;
  public int[] score= new int[2];
  public int coinsSentPreviousRound; // coins sent by the oppoenet in previous round
  public int[] coinsRecievedPreviousRound= new int[2];
  public int[] coinsSent= new int[2]; //coinsSent[0] -> number of coins sent BY opponent, coinsSent[1]-> coins sent BY Computer
  public int[] coinsReturned = new int[2]; //coinsReturned[0] -> number of coins returned BY opponent, [1]-> coins returned BY Computer
  private boolean coinsReturnedLastRound ; // did opponent return coins in last round?
  private int[]emoji = new int[2]; // keeps track of the emoji
  private String filename = "/log/log.csv"; /************ NEED TO SET THIS **************/
  private boolean TFT; // this variable specifies whther the current execution is in Tit for tat mode or random mode, need a way to set this.
  private boolean consistentEmotion; // consistent or inconsistent emotions, need a way to set all these flags while running.
  private boolean dissapointmentOverAnger; // this is to control dissapointment/anger
  private String[] emoSet = {"Happy", "Guilty", "Moderately Angry", "Very Angry", "Moderately Dissapointed", "Very Dissapointed"};

  public model() {
    //create logger
    /*
    File f = new File(dataPath(filename));
     if (!f.exists()) {
     createFile(f);
     }
     //output = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
     */
    part = 1;
    round = 1;

    for (int i=0; i<2; i++) {
      score[i]=0;
    }
    for (int i=0; i<2; i++) {
      emoji[i]=0;
    }

    //set up current sate round info
    resetCoinInfo();
    log.addColumn("round");
    log.addColumn("coinsSentByParticipant");
    log.addColumn("coinsSentByComputer");
    log.addColumn("coinsReturnedByParticipant");
    log.addColumn("coinsReturnedByComputer");
    log.addColumn("emojiSentByParticipant");
    log.addColumn("emojiSentByComputer");
    log.addColumn("TFT?");
    log.addColumn("Consistent Emotion?");
    log.addColumn("Disappointment?");
    log.addColumn("ComputerScore");
    log.addColumn("ParticipantScore");
  }


  void log() {
    TableRow roundInfo = log.addRow();
    roundInfo.setInt("round", round);
    roundInfo.setInt("coinsSentByParticipant", coinsSent[0]);
    roundInfo.setInt("coinsSentByComputer", coinsSent[1] );
    roundInfo.setInt("coinsReturnedByParticipant", coinsReturned[0]);
    roundInfo.setInt("coinsReturnedByComputer", coinsReturned[1] );
    roundInfo.setString("emojiSentByParticipant", emoSet[emoji[0]]);
    roundInfo.setString("emojiSentByComputer", emoSet[emoji[1]] );
    roundInfo.setString("TFT?", str(TFT));
    roundInfo.setString("Consistent Emotion?", str(consistentEmotion) );
    roundInfo.setString("Disappointment?", str(dissapointmentOverAnger));
    roundInfo.setInt("ComputerScore", score[1] );
    roundInfo.setInt("ParticipantScore", score[0]);
  }

  void writeFileToDisk()
  {
    saveTable(log, filename); // Change according to folder structure or whatever!
  }
  /**
   * Creates a new file including all subfolders
   I DONT KNOW WHETHER I NEED TO DO THIS, so I just commented it for now.
   private void createFile(File f) {
   File parentDir = f.getParentFile();
   try {
   parentDir.mkdirs();
   f.createNewFile();
   }
   catch(Exception e) {
   e.printStackTrace();
   }
   }
   */
  private void resetCoinInfo() {
    for (int i=0; i<2; i++) {
      coinsSent[i]=0;
      coinsReturned[i]=0;
    }
  }

  public int getCurrentRound()
  {
    return round;
  }
  /*
  //Following function takes arguments -
   // for the Part 1, isReturnCoin is always false, else true.
   // Id defines the type of the player - 0: participant 1: Bot
   // Numcoins: total coins gave
   public void giveCoin(int id, int numCoin, boolean isReturnCoin) {
   if (isReturnCoin) {
   getCoin[id]-=numCoin;
   returnCoin[(id+1)%2]+=numCoin;
   output.println("RETURN -- In round "+round+", Player "+id+" returns "+numCoin+" to Player"+((id+1)%2));
   } else {
   ownCoin[id]-=numCoin;
   getCoin[(id+1)%2]+=numCoin;
   output.println("GIVE -- In round "+round+", Player "+id+" gives "+numCoin+" to Player"+((id+1)%2));
   }
   output.println("STATUS -- Round: "+round+", Player: "+id+" owns: "+ownCoin[id]+", gets: "+getCoin[id]);
   output.println();
   }
   */
  public void updateScore() {

    if (part == 1) {
      score[0]+= coinsSent[1]; // score of participant
      score[1]+= coinsSent[0] ; // score of computer
    } else {
      score[0] = score[0] + 2*coinsReturned[1] + (10 - coinsSent[0]) ; 
      score[1] = score[1] + 2*coinsReturned[0] + (10 - coinsSent[1]) ;
    }

    println("Score Participant: " + score[0] + " Score Computer " + score[1]);
    coinsReturnedLastRound = (coinsReturned[0]!=0);
    println("Coins returned by Participant: "+ str(coinsReturnedLastRound));
  }

  public void increaseRound() {
    round+=1;
    //resetCoinInfo();
  }


  /*
  Assumming the folowing emoji table:
   0. Slightly Happy
   1. Guilty
   2. Moderately Angry
   3. Very Angry
   4. Moderately Dissapointed
   5. Very Dissapointed
   */


  public int EmojiFromComputer(int part) {
    int computerEmojiIndex=0, difference;
    if ( part ==1 ) { 
      difference = coinsSent[1] - coinsSent[0];
      if (consistentEmotion) {
        if (difference>=-2 && difference<=0) computerEmojiIndex = 0; // happy
        else if (difference<-2) computerEmojiIndex = 1; // guilty
        else if (difference<=3 && difference>0) { // moderate anger or dissapointment
          if (dissapointmentOverAnger) computerEmojiIndex = 2;
          else computerEmojiIndex = 4;
        } else if (difference>3) { // intense anger or dissapointment
          if (dissapointmentOverAnger) computerEmojiIndex = 3;
          else computerEmojiIndex = 5;
        }
      } else { // inconsistent(random) emotions
        computerEmojiIndex = int (random(6));
      }
    } else { //part 2
      if (coinsReturned[0]==0) {
        if (dissapointmentOverAnger) computerEmojiIndex = 2;
        else computerEmojiIndex = 4;
      } else {
        computerEmojiIndex = 0;
      }
    }
    emoji[1]= computerEmojiIndex;
    return computerEmojiIndex;
  }
  /*
  Helper functions for transferring data to UI
   */
  //function to get the number of coins sent by the opponent, call this in part 2 for the first interaction
  void getCoinsSentByOpponent(int coinsFromPlayer) {
    coinsSent[0] = coinsFromPlayer; // assigned an arbitary value as a placeholder, logic must be changed according to interfaces.
  }
  int sendCoinsToOpponent() {
    determineNumberCoinGive();
    return coinsSent[1];
  }
  // call this in part 2 for the 2nd interaction
  void getCoinsReturnedByOpponent(int coinsFromPlayer) {
    coinsReturned[0] = coinsFromPlayer;
  }

  int sendEmoToOpponent() {
    if (part == 1) return EmojiFromComputer(1);
    else return EmojiFromComputer(2);
  }

  /*
  Helper functions for getting random noise in TFT and random values for random Case(non TFT)
   */
  private int getNoiseTFT() {
    int index;
    int[] TFT_random_values = {-2, -1, 0, 1, 2};
    index = int (random(TFT_random_values.length));
    return TFT_random_values[index];
  }
  private int getRandomValue() {
    int index;
    int[] random_values ={1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    index = int (random(random_values.length));
    return random_values[index];
  }

  /*
  This is for part 1
   Two modes of operation here:
   1. Tit for tat (TFT)
   2. Random
   */

  private int determineNumberCoinGive() {
    if (round==1) coinsSent[1] = getRandomValue() ;
    else if (TFT) {
      int add_value = getNoiseTFT();
      coinsSent[1] = add_value + coinsSentPreviousRound;
      if ( coinsSent[1]<0)
        coinsSent[1] = max(0, coinsSent[1]);
      else
        coinsSent[1] = min(10, coinsSent[1]);
    } else {
      coinsSent[1] = getRandomValue() ;
    }
    coinsSentPreviousRound = coinsSent[0];
    return coinsSent[1];
  }

  /*
   This is for part 2
   this function will determine the number of coins to return
   */
  //private int determineNumCoinReturn() {
  //  int[] tentativeScore= new int[2];
  //  if (coinsReturnedLastRound) { // if coins were returned in last round
  //    tentativeScore[0] = score[0] + 10 + coinsSent[0]; // + 2*coinsReturned[1]
  //    tentativeScore[1] = score[1] + 10 + coinsSent[1];
  //  } else {
  //    tentativeScore[0] = score[0]+ 2*coinsSent[0] + 10 - coinsSent[0];
  //    tentativeScore[1] = score[1] + 10 - coinsSent[1];
  //  }
  //  println("Tentative Scores P, C "+ tentativeScore[0]+" "+ tentativeScore[1]);
  //  if (float(tentativeScore[0]) < tentativeScore[1]) coinsReturned[1] = coinsSent[0];
  //  else coinsReturned[1] = 0;
  //  return coinsReturned[1];
  //}
  private int determineNumCoinReturn() {
    if ((0 + (int)(Math.random() * ((1 - 0) + 1))) == 1) { // if coins were returned in last round
      coinsReturned[1] = coinsSent[0];
    } else {
      coinsReturned[1] = 0;
    }
    return coinsReturned[1];
  }

  private void getEmotionFromOpponent(int emoId)
  {
    emoji[0] = emoId;
  }
}