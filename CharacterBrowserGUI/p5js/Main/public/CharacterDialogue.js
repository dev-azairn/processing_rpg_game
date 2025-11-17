class CharacterDialogue {

  /**
   * @param {Unit[]} unitsArray - The global array of all Unit objects.
   * @param {Object} allDialogueData - The loaded dialogue.json file.
   */
  constructor(unitsArray, allDialogueData) {
    // We convert the units array into a Map for fast name lookups
    console.log(allDialogueData);
    this.allUnits = new Map();
    for (const unit of unitsArray) {
      this.allUnits.set(unit.getName(), unit);
    }
    
    this.allDialogueData = allDialogueData;
    
    this.currentConversation = [];
    this.currentLineIndex = 0;

    this.isActive = false;
    this.currentSpeaker = "";
    this.currentLine = "";
    this.activeSpeakerUnit = null;

    this.bubbleWidth = 220;
    this.bubbleHeight = 90;
    this.bubblePadding = 10;

    this.lineStartTime = 0;
    this.LINE_DELAY = 3000; // 3 seconds
  }

  /**
   * Starts a random "normal" dialogue for a single unit.
   */
  startNormalDialogue(selectedUnit) {
    if (this.isActive) this.endDialogue();

    const unitName = selectedUnit.getName(); // Use name from UnitDetail
    const data = this.allDialogueData[unitName];

    if (!data) {
      console.log("No dialogue data found for " + unitName);
      return;
    }

    const allNormalLines = data.normal;
    if (!allNormalLines || allNormalLines.length === 0) {
      console.log("No 'normal' lines found for " + unitName);
      return;
    }

    const randomIndex = floor(random(allNormalLines.length));
    const randomLine = allNormalLines[randomIndex];

    this.currentConversation = [randomLine]; // Put the single line in an array
    this.startPlaying();
  }

  /**
   * Starts a two-unit "taunt" dialogue.
   */
  startTauntDialogue(unit1, unit2) {
    if (this.isActive) this.endDialogue();

    const name1 = unit1.getName();
    const name2 = unit2.getName();

    const data1 = this.allDialogueData[name1];
    const data2 = this.allDialogueData[name2];

    if (!data1 || !data2) {
      console.log("Missing dialogue data for " + name1 + " or " + name2);
      return;
    }

    const taunts1 = data1.taunt;
    const taunts2 = data2.taunt;

    this.currentConversation = [];

    const line1 = this.findLineWithTo(taunts1, name2);
    const line2 = this.findLineWithTo(taunts2, name1);

    if (line1 && line2) {
      // Special interaction
      this.currentConversation.push(line1);
      this.currentConversation.push(line2);
    } else {
      // Generic taunts
      const genericLine1 = this.findRandomGenericLine(taunts1);
      if (genericLine1) this.currentConversation.push(genericLine1);

      const genericLine2 = this.findRandomGenericLine(taunts2);
      if (genericLine2) this.currentConversation.push(genericLine2);
    }

    if (this.currentConversation.length > 0) {
      this.startPlaying();
    } else {
      console.log("No matching taunt lines found for " + name1 + " and " + name2);
    }
  }

  /**
   * Finds a line specifically targeted at another unit.
   */
  findLineWithTo(array, targetName) {
    if (!array) return null;
    for (const line of array) {
      if (line.to === targetName) {
        return line;
      }
    }
    return null;
  }

  /**
   * Finds a random line that has no "to" target.
   */
  findRandomGenericLine(array) {
    if (!array) return null;
    
    const genericLines = array.filter(line => !line.to);
    
    if (genericLines.length > 0) {
      const randomIndex = floor(random(genericLines.length));
      return genericLines[randomIndex];
    }
    return null;
  }

  /**
   * Resets and begins playing the currentConversation array.
   */
  startPlaying() {
    if (!this.currentConversation || this.currentConversation.length === 0) {
      this.isActive = false;
      return;
    }
    this.currentLineIndex = 0;
    this.isActive = true;
    this.displayNextLine();
  }

  /**
   * Loads the next line from the conversation into the active variables.
   */
  displayNextLine() {
    if (this.currentLineIndex >= this.currentConversation.length) {
      this.endDialogue();
      return;
    }

    const line = this.currentConversation[this.currentLineIndex];
    if (line) {
      this.currentSpeaker = line.speaker;
      this.currentLine = line.line;
      
      this.activeSpeakerUnit = this.allUnits.get(this.currentSpeaker);
      
      if (!this.activeSpeakerUnit) {
        console.error("Speaker '" + this.currentSpeaker + "' not found in units map!");
        this.endDialogue();
        return;
      }
      this.lineStartTime = millis();
    } else {
      console.warn("Skipping invalid line at index: " + this.currentLineIndex);
    }
    this.currentLineIndex++;
  }

  endDialogue() {
    this.isActive = false;
    this.currentConversation = [];
    this.currentLineIndex = 0;
    this.currentSpeaker = "";
    this.currentLine = "";
    this.activeSpeakerUnit = null;
    this.lineStartTime = 0;
  }

  /**
   * Call this in the main p5.js draw() loop.
   */
  update() {
    if (!this.isActive) {
      return;
    }
    if (millis() - this.lineStartTime > this.LINE_DELAY) {
      this.displayNextLine();
    }
  }

  /**
   * Call this in the main p5.js draw() loop.
   */
  render() {
    if (!this.isActive || !this.activeSpeakerUnit) {
      return;
    }
    
    push(); // Use p5.js's push()
    
    const bubbleX = this.activeSpeakerUnit.posX;
    const bubbleY = this.activeSpeakerUnit.posY - this.activeSpeakerUnit.width - (this.bubbleHeight / 2) - 10;
    
    rectMode(CENTER);
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(bubbleX, bubbleY, this.bubbleWidth, this.bubbleHeight, 10);
    
    // Speech bubble tail
    noStroke();
    fill(255);
    triangle(
      bubbleX - 10, bubbleY + this.bubbleHeight / 2,
      bubbleX + 10, bubbleY + this.bubbleHeight / 2,
      bubbleX, bubbleY + this.bubbleHeight / 2 + 10
    );
    
    // Text
    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(
      this.currentLine, 
      bubbleX, bubbleY, 
      this.bubbleWidth - this.bubblePadding, 
      this.bubbleHeight - this.bubblePadding
    );
    
    pop(); // Use p5.js's pop()
  }

  /**
   * Call this from the main p5.js mousePressed() function.
   * @param {Unit[]} selectedUnit - The [unit1, unit2] array.
   */
  handleMousePressed(selectedUnit) {
    const newUnit1 = selectedUnit[0];
    const newUnit2 = selectedUnit[1];

    // Case 1: Two units are selected. Start a taunt.
    if (newUnit1 && newUnit2) {
      this.startTauntDialogue(newUnit1, newUnit2);
    }
    // Case 2: Only the first unit is selected.
    else if (newUnit1 && !newUnit2) {
      this.startNormalDialogue(newUnit1);
    }
    // Case 3: Only the second unit is selected.
    else if (!newUnit1 && newUnit2) {
      this.startNormalDialogue(newUnit2);
    }
    // Case 4: Nothing is selected.
    else if (!newUnit1 && !newUnit2) {
      if (this.isActive) {
        this.endDialogue();
      }
    }
  }
}