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
    if (currentLineIndex >= currentConversation.size()) {
      endDialogue();
      return;
    }
    JSONObject lineData = currentConversation.getJSONObject(currentLineIndex);
    String speakerName = lineData.getString("speaker", null);
    String line = lineData.getString("line", null);    
    if (speakerName != null && line != null) {
      currentSpeaker = speakerName;
      currentLine = line;
      this.activeSpeakerUnit = allUnits.get(currentSpeaker);      
      if (this.activeSpeakerUnit == null) {
        println("ERROR: Dialogue speaker '" + currentSpeaker + "' not found in units map!");
        endDialogue();
        return;
      }      
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
  }

  void render() {
    if (!isActive || activeSpeakerUnit == null) {
      return; 
    }
    int bubbleX = activeSpeakerUnit.posX;
    int bubbleY = activeSpeakerUnit.posY - activeSpeakerUnit.width - (bubbleHeight / 2) - 10; // 10px above name
    pushStyle();    
    rectMode(CENTER);
    fill(255);
    stroke(0); 
    strokeWeight(2);
    rect(bubbleX, bubbleY, bubbleWidth, bubbleHeight, 10); 
    noStroke();
    fill(255);
    triangle(bubbleX - 10, bubbleY + bubbleHeight/2,
             bubbleX + 10, bubbleY + bubbleHeight/2,
             bubbleX, bubbleY + bubbleHeight/2 + 10); 
    fill(0); 
    textSize(14);
    textAlign(LEFT, TOP);
    text(currentLine,
         bubbleX - bubbleWidth/2 + bubblePadding, 
         bubbleY - bubbleHeight/2 + bubblePadding,
         bubbleWidth - bubblePadding*2, 
         bubbleHeight - bubblePadding*2);          
    popStyle();
  }

  void mousePressed() {
    if (!isActive) {
      return; 
    }
    displayNextLine();
  }
}
