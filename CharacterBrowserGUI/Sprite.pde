class Sprite {
  //configs
  String characterFolder;
  String characterAction;
  String imageFileName;
  String fileExtension;
  int totalSize;
  int currentIndex;
  int spriteScale;
  
  //runtime
  PImage[] sprites;
  boolean isStop;
  boolean isFlip;
  boolean isLoop;
  
  //position
  int posX; 
  int posY;
  
  public Sprite(String configFileName){
    loadConfig(configFileName);
    currentIndex = 0;
    isStop = false;
    isFlip = false;
    isLoop = true;
  }
  
  //constructor
  public Sprite(
  String characterFolder, 
  String characterAction, 
  String fileExtension,
  int totalSize
  ){
    this.characterFolder = characterFolder;
    this.characterAction = characterAction;
    this.imageFileName = characterFolder + "_" + characterAction + "_";
    this.fileExtension = fileExtension;
    this.totalSize = totalSize;
    this.currentIndex = 0;
    this.spriteScale = 1;
    this.isStop = false;
    this.isFlip = false;
    this.isLoop = true;
  }
  
  void loadImageData(){
    //get the filepaths
    String[] fileNames = new String[this.totalSize];
    String path = this.characterFolder + "/" + this.characterAction + "/";
    //set array of img size
    sprites = new PImage[this.totalSize];
    for(int index = 0; index < this.totalSize; index++){
      fileNames[index] = this.imageFileName + (index+1) + fileExtension;
      sprites[index] = loadImage("data/" + path + fileNames[index]);
    }
  }
   
  
  void loadConfig(String configFileName){
    String[] configLines = loadStrings(configFileName);
    String[] configParams = split(configLines[0], ' ');
    for(int i = 0; i < configParams.length; i++){
      println("["+ i + "] " + configParams[i]);
    }
    this.characterFolder = configParams[0];
    this.characterAction = configParams[1];
    this.imageFileName = configParams[2];
    this.fileExtension = configParams[3];
    this.totalSize = int(configParams[4]);
    this.posX = int(configParams[5]);
    this.posY = int(configParams[6]);
    this.spriteScale = int(configParams[7]);
  }
  
  
  void render(){
    imageMode(CENTER);
    if(isFlip){
      pushMatrix();
      translate(posX, posY);
      scale(-1, 1);
      image(sprites[this.currentIndex], 0, 0,
      sprites[currentIndex].width * spriteScale,
      sprites[currentIndex].height * spriteScale);
      popMatrix();
    } 
    else {
      image(sprites[this.currentIndex], posX, posY,
      sprites[currentIndex].width * spriteScale,
      sprites[currentIndex].height * spriteScale);
    }
  }
  
  void renderNext(){
    if(isStop == false){
      currentIndex++;
      if(currentIndex >= sprites.length){
        currentIndex = 0;
      }
    }
    render();
  }
  
  void play(){
    if(isLoop){
      renderNext();
    }
    else{
      if(currentIndex == sprites.length - 1){
        render();
      }
      else{
        renderNext();
      }
    }
  }
  
  void setPlayOnce(boolean isPlayOnce) {
    if(isPlayOnce)
    {
      isLoop = false;
      currentIndex = 0;
    } else {
      isLoop = true;
      currentIndex = 0;
    }
  }
}
