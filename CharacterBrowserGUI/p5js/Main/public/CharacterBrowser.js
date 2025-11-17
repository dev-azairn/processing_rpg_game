class CharacterBrowser {
  constructor() {
    this.selectedUnit = [null, null]; // Replaces new Unit[2]
    this.background = null; // Will be loaded in preload()
    this.podium = null;
    this.scrollOffset = 0;
    // 'characterDialogue' removed
  }

  // --- LOADING ---
  // Call this from the main p5.js preload()
  preload() {
    // We assume your 'assets' API route can serve this
    this.background = loadImage('/assets/Scene/Scene.jpg');
    // this.podium = loadImage(...); // If you have this
  }

  // --- RENDERING ---
  // Call this from the main p5.js draw()
  renderGUI(units) { // Pass in the global 'units' array
    imageMode(CORNER);
    image(this.background, 0, 0, width, height);

    // --- Display selected unit ---
    stroke(0);
    strokeWeight(2);
    rectMode(CORNER);
    fill(0, 0, 0, 50);
    rect(width - 300, 100, 300, 400);

    for (let i = 0; i < this.selectedUnit.length; i++) {
      if (this.selectedUnit[i] == null) {
        stroke(0);
        strokeWeight(2);
        rectMode(CORNER);
        noFill();
        rect(width - 300, 100 + i * 200, 300, 200);
        fill(255);
        textSize(16);
        textAlign(CENTER);
        text("No selected character", width - 150, 200 + i * 200);
      } else {
        stroke(0);
        strokeWeight(2);
        fill(0, 0, 0, 50);
        rectMode(CORNER);
        rect(width - 300, 100 + i * 200, 300, 200);
        textAlign(CENTER);
        fill(255);
        textAlign(CENTER);
        textSize(20);
        text(this.selectedUnit[i].getName(), width - 150, 130 + i * 200);
        fill(255);
        textAlign(LEFT);
        textSize(16);
        text("Status:", width - 275, 150 + i * 200);
        text("Health: " + this.selectedUnit[i].getHealth(), width - 250, 175 + i * 200);
        text("ATK: " + this.selectedUnit[i].getAtk(), width - 125, 175 + i * 200);
        text("Action:", width - 275, 225 + i * 200);

        // Loop through our State object
        let stateKeys = Object.keys(State); // ["IDLE", "WALK", "ATTACK", "DEATH"]
        for (let k = 0; k < stateKeys.length; k++) {
          let stateName = stateKeys[k]; // "IDLE"
          let stateValue = State[stateName]; // 0
          let ordinal = k; // 0, 1, 2, 3 (replaces state.ordinal())

          rectMode(CENTER);
          fill(255);
          stroke(0);
          strokeWeight(2);
          rect(width - 235 + 60 * ordinal, 255 + i * 200, 50, 25, 10);
          fill(0);
          textAlign(CENTER);
          textSize(12);
          strokeWeight(1);
          text(stateName, width - 235 + 60 * ordinal, 258 + i * 200);
        }
        this.selectedUnit[i].render();
      }
    }

    // --- List Character ---
    rectMode(CORNER);
    fill(0, 0, 0, 50);
    stroke(0);
    strokeWeight(3);
    rect(0, height - 212.5, width, 212.5);

    fill(0, 255, 0, 100);
    stroke(0);
    strokeWeight(3);
    rect(20, height - (212.5 + 120), 200, 100, 20);
    fill(255);
    textSize(40);
    textAlign(CENTER);
    strokeWeight(1);
    text("Units: ", 100, height - (212.5 + 60));
    fill(255, 255, 0);
    text(units.length, 175, height - (212.5 + 60)); // Use units.length

    // Iterate over the 'units' array
    for (let i = 0; i < units.length; i++) {
      let unit = units[i];
      let hkey = unit.getName();

      let x = 165 * i + 100 + this.scrollOffset;
      let y = height - 100;

      // TODO: rectGradient is not a standard p5.js function.
      // Replaced with a simple rect().
      rectMode(CENTER);
      if (!unit.isSelected) {
        fill(232, 60, 145);
      } else {
        fill(150, 60, 145);
      }
      
      stroke(0);
      strokeWeight(5);
      rect(x, y, 150, 150, 25);
      
      unit.displayPortrait(x, y);
      rectMode(CENTER);
      fill(255);
      rect(x, y - 75, 90, 45, 15);
      textAlign(CENTER);
      textSize(16);
      fill(0);
      strokeWeight(1);
      text(hkey, x, y - 70);
    }

    // --- Scrolling Bar ---
    fill(255);
    strokeWeight(2);
    stroke(150);
    rectMode(CORNER);
    let maxScrollContent = units.length * 165 + 100;
    let scrollBarWidth = (width / maxScrollContent) * width;
    let scrollBarX = (-this.scrollOffset / maxScrollContent) * width + 20;
    rect(scrollBarX, height - 12, scrollBarWidth, 7, 10);
    
    // characterDialogue.update() / render() removed
  }

  // --- INPUT ---
  // Call this from the main p5.js mousePressed()
  handleMousePressed(units) {
    // --- 1. Check Unit Selection from list ---
    for (let i = 0; i < units.length; i++) {
      let unit = units[i];
      let x = 165 * i + 100 + this.scrollOffset;
      let y = height - 100;

      // Bounds for a rectMode(CENTER) rect
      let xBoundLeft = x - 150 / 2;
      let xBoundRight = x + 150 / 2;
      let yBoundTop = y - 150 / 2;
      let yBoundBottom = y + 150 / 2;

      if (mouseX >= xBoundLeft && mouseX <= xBoundRight &&
          mouseY >= yBoundTop && mouseY <= yBoundBottom) {
        
        if (mouseButton === LEFT) {
          if (this.selectedUnit[0] == unit) {
            this.selectedUnit[0].unselect();
            this.selectedUnit[0] = null;
            return;
          }
          if (this.selectedUnit[1] == unit) return;
          if (this.selectedUnit[0] != null) this.selectedUnit[0].unselect();
          unit.select();
          this.selectedUnit[0] = unit;
          this.selectedUnit[0].setPosition(350, 350);
        } else if (mouseButton === RIGHT) {
          if (this.selectedUnit[1] == unit) {
            this.selectedUnit[1].unselect();
            this.selectedUnit[1] = null;
            return;
          }
          if (this.selectedUnit[0] == unit) return;
          if (this.selectedUnit[1] != null) this.selectedUnit[1].unselect();
          unit.select();
          this.selectedUnit[1] = unit;
          this.selectedUnit[1].setPosition(450, 450);
        }
      }
    }

    // --- 2. Check State Buttons ---
    let stateKeys = Object.keys(State);
    for (let j = 0; j < this.selectedUnit.length; j++) {
      if (this.selectedUnit[j] == null) continue; // Skip if no unit selected

      for (let k = 0; k < stateKeys.length; k++) {
        let stateName = stateKeys[k];
        let stateValue = State[stateName];
        let ordinal = k;
        
        // Bounds for rectMode(CENTER) rect
        let centerX = width - 235 + 60 * ordinal;
        let centerY = 255 + j * 200;
        let btnWidth = 50;
        let btnHeight = 25;

        let xBoundLeft = centerX - btnWidth / 2;
        let xBoundRight = centerX + btnWidth / 2;
        let yBoundTop = centerY - btnHeight / 2;
        let yBoundBottom = centerY + btnHeight / 2;

        if (mouseX >= xBoundLeft && mouseX <= xBoundRight &&
            mouseY >= yBoundTop && mouseY <= yBoundBottom) {
              
          console.log("click state");
          let anim = this.selectedUnit[j].getAnim(stateValue);
          
          if (stateValue != State.IDLE) {
            anim.setPlayOnce(true);
          } else {
            anim.setPlayOnce(false);
          }
          
          if (stateValue == State.DEATH) {
            this.selectedUnit[j].setLastTime();
          }
          
          this.selectedUnit[j].setState(stateValue);
          return;
        }
      }
    }
    // characterDialogue.mousePressed() removed
  }

  // Call this from the main p5.js mouseWheel()
  handleMouseWheel(event, units) {
    if (mouseY > height - 212.5) {
      // event.deltaY is the p5.js equivalent of event.getCount()
      // The sign might be reversed, adjust * -20 if needed
      let scrollAmount = event.deltaY;
      this.scrollOffset -= scrollAmount; // Use - to scroll "naturally"

      let maxScroll = (units.length * 165) - width + 50;
      // Constrain the offset
      this.scrollOffset = constrain(this.scrollOffset, -maxScroll, 0);
    }
  }
}
