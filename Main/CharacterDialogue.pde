class CharacterDialogue {

  JSONObject allDialogueData; 
  JSONArray currentConversation;

  int currentLineIndex;

  boolean isActive = false; 
  String currentSpeaker = "";
  String currentLine = "";
  
  // PImage dialogueBoxImage;
  // PFont speakerFont;
  // PFont dialogueFont; 

  CharacterDialogue(String jsonFilePath) {
    allDialogueData = loadJSONObject(jsonFilePath);     
    if (allDialogueData == null) {
      println("ERROR: Could not load dialogue file: " + jsonFilePath);
      allDialogueData = new JSONObject(); 
    }
  }

  void startDialogue(String conversationID) {
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

    String speaker = lineData.getString("speaker", null);
    String line = lineData.getString("line", null);
    
    if (speaker != null && line != null) {
      currentSpeaker = speaker;
      currentLine = line;
      
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
  }

  void render() {
    if (!isActive) {
      return;
    }

    rectMode(CENTER);
    rect(width / 2, height - 100, width - 50, 180);

    // TODO: Set your speakerFont
    // if (speakerFont != null) {
    //   textFont(speakerFont);
    // }
    
    fill(255, 200, 0); 
    textSize(24);
    textAlign(LEFT, TOP);
    text(currentSpeaker, 50, height - 180);

    // TODO: Set your dialogueFont
    // if (dialogueFont != null) {
    //   textFont(dialogueFont);
    // }
    
    fill(255); 
    textSize(18);
    textAlign(LEFT, TOP);
    // Wrap text within the box
    text(currentLine, 50, height - 140, width - 100, 120);

    fill(150);
    textSize(14);
    textAlign(RIGHT, BOTTOM);
    text("Click to continue...", width - 50, height - 20);
  }

  void mousePressed() {
    if (!isActive) {
      return; 
    }

    displayNextLine();
  }
}
