class SpriteConfigEditor {
  String characterFolder;
  String characterAction;
  String imageFileName;
  String fileExtension;
  int totalSize;
  int posX;
  int posY;
  int spriteScale;


  String currentConfigFileName = "";
  String dataFolder = "data/";
  

  final int TEXT_SIZE = 16;
  final int LINE_HEIGHT = 30;

  SpriteConfigEditor() {
    simulateNewAction();
  }


  void renderGUI() {
    rectMode(CORNER);
    fill(240);
    rect(0, 0, width, height); 
    displayConfig();
    fill(50);

    text("1. Press 'A' to Simulate new Action Config data.", 10, height - 3 * LINE_HEIGHT);
    text("2. Press 'S' to Save Config", 10, height - 2 * LINE_HEIGHT);
    text("3. Press 'E' to Exit Editor.", 10, height - 1 * LINE_HEIGHT);
  }

  void displayConfig() {
    fill(0);
    textSize(TEXT_SIZE);
    textAlign(LEFT,TOP);

    text("LODING NEW CONFIGURATION: ",10,10+LINE_HEIGHT);
    text(characterFolder+" "+
        characterAction+" "+
        imageFileName+" "+
        fileExtension+" "+
        totalSize+" "+
        posX+" "+
        posY+" "+
        spriteScale,
        10, 10 + 2 * LINE_HEIGHT
);

  }
  

boolean keyPressed(char keyChar) {
  if (keyChar == 's' || keyChar == 'S') {
    saveConfigToFile(currentConfigFileName);
    return true;
  } else if (keyChar == 'A' || keyChar == 'a') {
    simulateNewAction();
    return true;
  } 
  return false;
}
  
void saveConfigToFile(String fileName) {
    String outputString = characterFolder + " " +
                          characterAction + " " +
                          imageFileName + " " +
                          fileExtension + " " +
                          totalSize + " " +
                          posX + " " +
                          posY + " " +
                          spriteScale;

    saveStrings(dataFolder + fileName, new String[]{outputString});

    println("SUCCESS: Saved new config to " + fileName);
    println("Output: " + outputString);
  }


 void simulateNewAction() {
    String characterName = "Archer"; 

    characterFolder = characterName;
    characterAction = "Run";
    imageFileName = characterName + "_Run_"; 
    fileExtension = ".png";
    totalSize = 8;
    posX = 300;
    posY = 200;
    spriteScale = 5;
    
    currentConfigFileName = characterName + "_Run.txt"; 

}

}
