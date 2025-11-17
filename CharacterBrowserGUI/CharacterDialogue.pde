class CharacterDialogue {

  JSONArray currentConversation; 
  int currentLineIndex;

  boolean isActive = false; 
  String currentSpeaker = ""; 
  String currentLine = "";

  HashMap<String, Unit> allUnits;
  Unit activeSpeakerUnit = null; 

  int bubbleWidth = 220; 
  int bubbleHeight = 90;  
  int bubblePadding = 10;
  
  int lineStartTime;
  final int LINE_DELAY = 2000; 
  
  CharacterDialogue(HashMap<String, Unit> units) {
    this.allUnits = units;
    currentConversation = new JSONArray();
  }

  String getDialoguePath(Unit u) {
    String folderPath = u.idle.characterFolder; 
    String[] parts = split(folderPath, '/');
    String className = parts[parts.length - 1]; 
    return "data/Dialogue_" + className + ".json";
  }


  void startNormalDialogue(Unit selectedUnit) {
    if (isActive) endDialogue(); 
    String dialoguePath = getDialoguePath(selectedUnit);
    JSONObject data = loadJSONObject(dialoguePath);    
    if (data == null) {
      println("ERROR: Could not find " + dialoguePath);
      return;
    }    
    JSONArray allNormalLines = data.getJSONArray("normal");    
    if (allNormalLines == null || allNormalLines.size() == 0) {
       println("No 'normal' lines found in " + dialoguePath);
       return;
    }
    int randomIndex = int(random(allNormalLines.size()));
    JSONObject randomLine = allNormalLines.getJSONObject(randomIndex);
    currentConversation = new JSONArray();
    currentConversation.append(randomLine); 
    startPlaying();
  }

  void startTauntDialogue(Unit unit1, Unit unit2) {
    if (isActive) endDialogue();
    String name1 = unit1.detail.getName();
    String name2 = unit2.detail.getName();
    String path1 = getDialoguePath(unit1);
    String path2 = getDialoguePath(unit2);
    JSONObject data1 = loadJSONObject(path1);
    JSONObject data2 = loadJSONObject(path2);
    if (data1 == null || data2 == null) {
      println("ERROR: Missing dialogue file for " + name1 + " ("+path1+") or " + name2 + " ("+path2+")");
      return;
    }
    JSONArray taunts1 = data1.getJSONArray("taunt");
    JSONArray taunts2 = data2.getJSONArray("taunt");   
    currentConversation = new JSONArray();
    JSONObject line1 = findLineWithTo(taunts1, name2);
    JSONObject line2 = findLineWithTo(taunts2, name1); 
    if (line1 != null && line2 != null) {
      println("Special interaction triggered between " + name1 + " and " + name2 + "!");
      currentConversation.append(line1);
      currentConversation.append(line2);
    } 
    else {
      println("Generic taunt triggered!");
      JSONObject genericLine1 = findRandomGenericLine(taunts1);
      if (genericLine1 != null) currentConversation.append(genericLine1);
      
      JSONObject genericLine2 = findRandomGenericLine(taunts2);
      if (genericLine2 != null) currentConversation.append(genericLine2);
    }
    if (currentConversation.size() > 0) {
      startPlaying();
    } else {
      println("No matching taunt lines found for " + name1 + " and " + name2);
    }
  }

  void startPlaying() {
    if (currentConversation == null || currentConversation.size() == 0) {
      println("No dialogue lines to play.");
      isActive = false;
      return;
    }
    currentLineIndex = 0;
    isActive = true;
    displayNextLine(); 
  }  
  
  JSONObject findLineWithTo(JSONArray array, String targetName) {
    if (array == null) return null;
    for (int i = 0; i < array.size(); i++) {
      JSONObject line = array.getJSONObject(i);
      if (line.hasKey("to") && line.getString("to").equals(targetName)) {
        return line;
      }
    }
    return null; 
  }
  
  JSONObject findRandomGenericLine(JSONArray array) {
    if (array == null) return null;
    JSONArray genericLines = new JSONArray();
    for (int i = 0; i < array.size(); i++) {
      JSONObject line = array.getJSONObject(i);
      if (!line.hasKey("to")) {
        genericLines.append(line);
      }
    }    
    if (genericLines.size() > 0) {
      int randomIndex = int(random(genericLines.size()));
      return genericLines.getJSONObject(randomIndex);
    }
    return null;
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
    int bubbleY = activeSpeakerUnit.posY - activeSpeakerUnit.width - (bubbleHeight / 2) - 10; 
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
    textAlign(CENTER, CENTER);
    text(currentLine, bubbleX, bubbleY, bubbleWidth - bubblePadding, bubbleHeight - bubblePadding);    
    popStyle();
  }
  
  
  void mousePressed(Unit[] selectedUnit) {
    
    Unit newUnit1 = selectedUnit[0];
    Unit newUnit2 = selectedUnit[1];

    // Case 1: Two units are selected. Start a taunt.
    if (newUnit1 != null && newUnit2 != null) {
      println("Checking for taunt: " + newUnit1.detail.getName() + " & " + newUnit2.detail.getName());
      startTauntDialogue(newUnit1, newUnit2);
    }
    // Case 2: Only the first unit is selected. Start normal dialogue.
    else if (newUnit1 != null && newUnit2 == null) {
      println("Checking for normal dialogue: " + newUnit1.detail.getName());
      startNormalDialogue(newUnit1);
    }
    // Case 3: Only the second unit is selected. Start normal dialogue.
    else if (newUnit1 == null && newUnit2 != null) {
      println("Checking for normal dialogue: " + newUnit2.detail.getName());
      startNormalDialogue(newUnit2);
    }
    // Case 4: Nothing is selected (clicked on empty space).
    // End any dialogue that is currently active.
    else if (newUnit1 == null && newUnit2 == null) {
      if (isActive) {
        endDialogue();
      }
    }
  
  }
}
