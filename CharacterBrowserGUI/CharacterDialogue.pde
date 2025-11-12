class CharacterDialogue {

  JSONObject allDialogueData; 
  JSONArray currentConversation;
  int currentLineIndex;

  boolean isActive = false; 
  String currentSpeaker = ""; 
  String currentLine = "";

  HashMap<String, Unit> allUnits;

  Unit activeSpeakerUnit = null; 

  PFont dialogueFont;
  int bubbleWidth = 220; 
  int bubbleHeight = 90;  
  int bubblePadding = 10;
  
  int lineStartTime;
  final int LINE_DELAY = 1000; 

  CharacterDialogue(String jsonFilePath, HashMap<String, Unit> units) {
    allDialogueData = loadJSONObject(jsonFilePath);     
    if (allDialogueData == null) {
      println("ERROR: Could not load dialogue file: " + jsonFilePath);
      allDialogueData = new JSONObject(); 
    }
    this.allUnits = units;
  }

  void startDialogue(String conversationID) {
    if (isActive) {
      println("Warning: Tried to start dialogue while one is already active.");
      return; 
    }    
    currentConversation = allDialogueData.getJSONArray(conversationID);
    if (currentConversation == null) {
      println("ERROR: Could not find conversation with ID: " + conversationID);
      return;
    }
    currentLineIndex = 0;
    isActive = true;
    displayNextLine(); 
  }

  void displayNextLine() {
    if (currentConversation == null || currentLineIndex >= currentConversation.size()) {
      endDialogue();
      return;
    }
    JSONObject line = currentConversation.getJSONObject(currentLineIndex);
    if (line != null) {
      currentSpeaker = line.getString("speaker");
      currentLine = line.getString("line");
      
      activeSpeakerUnit = allUnits.get(currentSpeaker);
      if (activeSpeakerUnit == null) {
        println("ERROR: Speaker '" + currentSpeaker + "' not found in units map!");
        endDialogue();
        return;
      }      
      lineStartTime = millis();           
    } else {
      println("Skipping invalid line at index: " + currentLineIndex);
      currentLineIndex++;
      displayNextLine(); 
      return;
    }
    currentLineIndex++;
  }

  void endDialogue() {
    isActive = false;
    currentConversation = null;
    currentLineIndex = 0;
    currentSpeaker = "";
    currentLine = "";
    activeSpeakerUnit = null; 
    lineStartTime = 0;
  }

  void update() {
    if (!isActive) {
      return;
    }
    if (millis() - lineStartTime > LINE_DELAY) {
      displayNextLine();
    }
  }

  void render() {
    if (!isActive || activeSpeakerUnit == null) {
      return; 
    }

    int bubbleX = activeSpeakerUnit.posX;
    int bubbleY = activeSpeakerUnit.posY - activeSpeakerUnit.width - (bubbleHeight / 2) - 10; // 10px above name

    pushStyle();    
    rectMode(CENTER);
    
    // Draw bubble
    fill(255);
    stroke(0); 
    strokeWeight(2);
    rect(bubbleX, bubbleY, bubbleWidth, bubbleHeight, 10); 
    
    // Draw triangle
    noStroke();
    fill(255);
    triangle(bubbleX - 10, bubbleY + bubbleHeight/2,
             bubbleX + 10, bubbleY + bubbleHeight/2,
             bubbleX, bubbleY + bubbleHeight/2 + 10); 
             
    // Draw text
    fill(0); 
    textSize(14);
    textAlign(CENTER, CENTER);
    text(currentLine, bubbleX, bubbleY, bubbleWidth - bubblePadding, bubbleHeight - bubblePadding);
    
    popStyle();
  }
}
