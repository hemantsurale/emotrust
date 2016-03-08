import java.io.FileWriter;
import java.io.BufferedWriter;

public class model{
  //0-participant, 1-computer
  public int round;
  public int computerEmojiIndex;
  public int[] score= new int[2];
  public int[] ownCoin= new int[2];
  public int[] getCoin= new int[2];
  public int[] returnCoin = new int[2];
  private PrintWriter  output;
  private String filename = "";
  private boolean TFT; // this variable specifies whther the current execution is in Tit for tat mode or random mode, need a way to set this.
  private int coinsReceived; // coins recieieved in part 1
  private int coinsReturned; // coins returned in part 2
  
  public model(){
    //create logger
    File f = new File(dataPath(filename));
    if(!f.exists()){
      createFile(f);
    }
    //output = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    
    round = 0;
    
    for(int i=0;i<2;i++){
      score[i]=0;
    }
    
    //set up current sate round info
    resetCoinInfo();
  }
  
  /**
   * Creates a new file including all subfolders
   */
  private void createFile(File f){
    File parentDir = f.getParentFile();
    try{
      parentDir.mkdirs(); 
      f.createNewFile();
    }catch(Exception e){
      e.printStackTrace();
    }
  }   
  
  private void resetCoinInfo(){
    for (int i=0;i<2;i++){
      ownCoin[i]=10;
      getCoin[i]=0;
      returnCoin[i]=0;
    }
  }
  
  //Following function takes arguments -
    // for the Part 1, isReturnCoin is always false, else true.
    // Id defines the type of the player - 0: participant 1: Bot
    // Numcoins: total coins gave
  public void giveCoin(int id, int numCoin, boolean isReturnCoin){
    if(isReturnCoin){
      getCoin[id]-=numCoin;
      returnCoin[(id+1)%2]+=numCoin;
      output.println("RETURN -- In round "+round+", Player "+id+" returns "+numCoin+" to Player"+((id+1)%2));
    }else{
      ownCoin[id]-=numCoin;
      getCoin[(id+1)%2]+=numCoin;
      output.println("GIVE -- In round "+round+", Player "+id+" gives "+numCoin+" to Player"+((id+1)%2));
    }
    output.println("STATUS -- Round: "+round+", Player: "+id+" owns: "+ownCoin[id]+", gets: "+getCoin[id]);
    output.println();
  }
  
  public void updateScore(){
    for(int i=0;i<2;i++){
      score[i]=score[i]+ownCoin[i]+getCoin[i]*2+returnCoin[i]*4;
    }
  }
  
  public void increaseRound(){
    round+=1;
    
    resetCoinInfo();
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
  private boolean consistentEmotion = true; // consistent or inconsistent emotions, need a way to set all these flags while running.
  private boolean dissapointmentOverAnger = true; // this is to control dissapointment/anger

  public int EmojiFromComputer(int coinsSent){
    int computerEmojiIndex=0;
    if(consistentEmotion){
      int difference = coinsSent - coinsReceived;
      if(difference>=-2 && difference<=0) computerEmojiIndex = 0; // happy
      else if(difference<-2) computerEmojiIndex = 1; // guilty
      else if(difference<=3 && difference>0){ // moderate anger or dissapointment
        if(dissapointmentOverAnger) computerEmojiIndex = 2; 
        else computerEmojiIndex = 4;
      }
      else if(difference>3){ // intense anger or dissapointment
        if(dissapointmentOverAnger) computerEmojiIndex = 3;
        else computerEmojiIndex = 5;
      }
    }
    else{ // inconsistent(random) emotions
    computerEmojiIndex = int (random(6));
    }
      
    return computerEmojiIndex;
  }
 
 //function to get the number of coins sent by the opponent
 int getCoinsSentByOpponent(){
   coinsReceived = 10; // assigned an arbitary value as a placeholder, logic must be changed according to interfaces.
   coinsReturned = 10;
   return coinsReceived;
 }
   
 
  /*
  This is for part 1
  Two modes of operation here:
  1. Tit for tat (TFT)
  2. Random 
  */
 private int determineNumberCoinGive(){
   int coinsRecieved = getCoinsSentByOpponent();
   int[] TFT_random_values = {-2,-1,0,1,2};
   int[] random_values ={0,1,2,3,4,5,6,7,8,9,10};
   int index, sendCoins;
   if(TFT){
     index = int (random(6));
     int add_value = TFT_random_values[index];
     sendCoins = add_value + coinsRecieved;
     if( sendCoins<0)
       sendCoins = max(0, sendCoins);
     else
       sendCoins = min(10, sendCoins);
     }
   else{
     index = int (random(11));
     sendCoins =  random_values[index];
   }
   return sendCoins;
  }
  
 //This is for part 2
 /*
  private int determineNumCoinReturn(){
    if(round<=10) return 0;
    int coinsReturn = 0;
    if(TFT){
      if(coinsReturned)
    }
    else{
    }
  }
  */
  public int CoinGiveFromComputer(){
    int give = determineNumberCoinGive();
    giveCoin(0,10,false);
    giveCoin(0,10,true);
    
    //TODO: determine emoji to send
    computerEmojiIndex = EmojiFromComputer(give);
    return 1;
  }
  
  public void closeLogger(){
    output.close();
  }
}