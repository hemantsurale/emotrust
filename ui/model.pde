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
  
  public model(){
    //create logger
    File f = new File(dataPath(filename));
    if(!f.exists()){
      createFile(f);
    }
    output = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    
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
  
  public int EmojiFromComputer(){
    return computerEmojiIndex;
  }
  
  //TODO: write algo
  private int determineNumberCoinGive(){
    return 10;
  }
  
  //TODO: write algo
  private int determineNumCoinReturn(){
    if(round<10){
      return 0;
    }else{
      return 10;
    }
  }
  
  public int CoinGiveFromComputer(){
    int give = determineNumberCoinGive();
    giveCoin(0,10,false);
    giveCoin(0,10,true);
    
    //TODO: determine emoji to send
    computerEmojiIndex = 0;
  }
  
  public void closeLogger(){
    output.close();
  }
}