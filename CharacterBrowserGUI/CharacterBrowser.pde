class CharacterBrowser {
  HashMap<String, Unit> units;
  Unit[] selectedUnit; 
  PImage background;
  PImage podium;
  CharacterBrowser(HashMap<String, Unit> units) {
    this.units = units;
    selectedUnit = new Unit[2];
    background = loadImage("data/Podium/Scene.jpg");
  }
  
  
  
    void renderGUI() {
    // stage
      imageMode(CORNER);
      image(background,0,0, width, height);

      
      // Display selected unit
      stroke(0);
      strokeWeight(2);
      rectMode(CORNER);
      fill(0,0,0,50);
      rect(width-300, 100, 300, 200);
      for (int i = 0; i < selectedUnit.length; i++) {
        
        if (selectedUnit[i] == null) {
          stroke(0);
          strokeWeight(2);
          rectMode(CORNER);
          noFill();
          rect(width-300, 100 + i*100, 300, 100);
          fill(255);
          textSize(16);
          textAlign(CENTER);
          text("No selected character", width-150, 150 + i*100);
          continue;
        }
         stroke(0);
         strokeWeight(2);
         fill(0,0,0,50);
         rectMode(CORNER);
         rect(width-300, 100 + i*100, 300, 100);
         textAlign(CENTER);
         fill(255);
         textAlign(CENTER);
         textSize(20);
         text(selectedUnit[i].getName(), width-150, 130 + i*100);
         fill(255);
         textAlign(LEFT);
         textSize(16);
         text("Status:", width-275, 150 + i*100);
         text("Health: " + selectedUnit[i].getHealth(), width-250, 175 + i*100);
         text("ATK: " + selectedUnit[i].getAtk(), width-125, 175 + i*100);
        selectedUnit[i].setPosition((i + 1)*100 + 300, (i)*100 + 350);
        selectedUnit[i].render();
        
      
     }
    
    
    // Status List
    
    // Border
    
    
    // Character Text
     
    
    // List Character
    rectMode(CORNER);
    fill(0,0,0,50);
    strokeWeight(2);
    rect(0, height - 212.5, width, 212.5);
    int i = 0;
    for (String hkey: units.keySet()) {
       Unit unit = units.get(hkey);
       if (!unit.isSelected()) {
         rectGradient(165*i + 100, height - 100, 150, 150, color(232,60, 145), color(255, 198, 157), PI/4, 5, color(0,0,0), 25, CENTER);
       } else {
         rectGradient(165*i + 100, height - 100, 150, 150, color(150,60, 145), color(150, 198, 157), PI/4, 5, color(0,0,0), 25, CENTER);
       }
       unit.displayPortrait(165*i + 100, height - 100);
       fill(255);
       text(hkey, 165*i + 100, height - 100);
       i++;
    }
    
    
   
    // Scroll-Bar
    
  }
  
  void mousePressed() {
   // Left-click : select unit-1
     int i = 0;
     for (String hkey: units.keySet()) {
       println(hkey, i);
       Unit unit = units.get(hkey);
       if (mouseX >= 165*i + 100 - 150/2 && 165*i + 100 + 150/2 >= mouseX
       && mouseY >= height - 100 - 150/2 && height - 100 + 150/2 >= mouseY) { 
         if (mouseButton == LEFT) {
           if (selectedUnit[0] == unit) {
              selectedUnit[0].unselect();
              selectedUnit[0] = null;
              return;
           }
           if (selectedUnit[1] == unit) return;
           if(selectedUnit[0] != null) selectedUnit[0].unselect();
           unit.select();
           selectedUnit[0] = unit;
           println("Selected:" + unit);
         } else if (mouseButton == RIGHT) {
           if (selectedUnit[1] == unit) {
              selectedUnit[1].unselect();
              selectedUnit[1] = null;
              return;
           }
           if (selectedUnit[0] == unit) return;
           if(selectedUnit[1] != null) selectedUnit[1].unselect();
           unit.select();
           selectedUnit[1] = unit;
           println("Selected:" + unit);
         }
       }
       i++;
     }
   }
   // Right-click : select unit-2
  
  
  void mouseWheel(){
    
  }
  
}


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
