class CharacterBrowser {
  constructor() {
    this.selectedUnit = [null, null];
    this.background = null;
    this.scrollOffset = 0;
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

    this.displaySelectedUnits();
    this.displayUnitList(units);
    this.displayScrollBar(units);
  }

  displaySelectedUnits() {
    stroke(0);
    strokeWeight(2);
    rectMode(CORNER);
    fill(0, 0, 0, 50);
    rect(width - 300, 100, 300, 400);

    for (let i = 0; i < this.selectedUnit.length; i++) {
      if (this.selectedUnit[i] == null) {
        this.displayEmptySlot(i);
      } else {
        this.displayUnitDetails(i);
      }
    }
  }

  displayEmptySlot(slotIndex) {
    stroke(0);
    strokeWeight(2);
    rectMode(CORNER);
    noFill();
    rect(width - 300, 100 + slotIndex * 200, 300, 200);
    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("No selected character", width - 150, 200 + slotIndex * 200);
  }

  displayUnitDetails(slotIndex) {
    stroke(0);
    strokeWeight(2);
    fill(0, 0, 0, 50);
    rectMode(CORNER);
    rect(width - 300, 100 + slotIndex * 200, 300, 200);
    
    let unit = this.selectedUnit[slotIndex];
    let baseY = 100 + slotIndex * 200;

    fill(255);
    textAlign(CENTER);
    textSize(20);
    text(unit.getName(), width - 150, baseY + 30);
    
    fill(255);
    textAlign(LEFT);
    textSize(16);
    text("Status:", width - 275, baseY + 50);
    text("Health: " + unit.getHealth(), width - 250, baseY + 75);
    text("ATK: " + unit.getAtk(), width - 125, baseY + 75);
    text("Action:", width - 275, baseY + 125);

    this.displayStateButtons(slotIndex);
    unit.render();
  }

  displayStateButtons(slotIndex) {
    let stateKeys = Object.keys(State);
    let baseY = 255 + slotIndex * 200;

    for (let k = 0; k < stateKeys.length; k++) {
      let stateName = stateKeys[k];
      let buttonX = width - 235 + 60 * k;

      rectMode(CENTER);
      fill(255);
      stroke(0);
      strokeWeight(2);
      rect(buttonX, baseY, 50, 25, 10);
      
      fill(0);
      textAlign(CENTER);
      textSize(12);
      strokeWeight(1);
      text(stateName, buttonX, baseY + 3);
    }
  }

  displayUnitList(units) {
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
      this.displayUnitCard(units[i], i);
    }
  }

  displayUnitCard(unit, index) {
    let x = 165 * index + 100 + this.scrollOffset;
    let y = height - 100;

    rectMode(CENTER);
    if (!unit.isSelected) {
      fill(232, 60, 145);
    } else {
      fill(150, 60, 145);
    }
    
    stroke(0);
    strokeWeight(5);
    rect(x, y, 150, 150, 25);
    
    // Display portrait for ALL units (now initialized during preload)
    unit.displayPortrait(x, y);
    
    rectMode(CENTER);
    fill(255);
    rect(x, y - 75, 90, 45, 15);
    textAlign(CENTER);
    textSize(16);
    fill(0);
    strokeWeight(1);
    text(unit.getName(), x, y - 70);
  }

  displayScrollBar(units) {
    fill(255);
    strokeWeight(2);
    stroke(150);
    rectMode(CORNER);
    let maxScrollContent = units.length * 165 + 100;
    let scrollBarWidth = (width / maxScrollContent) * width;
    let scrollBarX = (-this.scrollOffset / maxScrollContent) * width + 20;
    rect(scrollBarX, height - 12, scrollBarWidth, 7, 10);
  }

  // --- INPUT HANDLING ---
  // Call this from the main p5.js mousePressed()
  handleMousePressed(units) {
    this.checkUnitSelection(units);
    this.checkStateButtons();
  }

  checkUnitSelection(units) {
    for (let i = 0; i < units.length; i++) {
      let unit = units[i];
      let x = 165 * i + 100 + this.scrollOffset;
      let y = height - 100;

      let xBoundLeft = x - 75;
      let xBoundRight = x + 75;
      let yBoundTop = y - 75;
      let yBoundBottom = y + 75;

      if (mouseX >= xBoundLeft && mouseX <= xBoundRight &&
          mouseY >= yBoundTop && mouseY <= yBoundBottom) {
        this.selectUnit(unit);
      }
    }
  }

  selectUnit(unit) {
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

  checkStateButtons() {
    let stateKeys = Object.keys(State);
    
    for (let j = 0; j < this.selectedUnit.length; j++) {
      if (this.selectedUnit[j] == null) continue;

      for (let k = 0; k < stateKeys.length; k++) {
        let stateName = stateKeys[k];
        let stateValue = State[stateName];
        
        let centerX = width - 235 + 60 * k;
        let centerY = 255 + j * 200;
        let btnWidth = 50;
        let btnHeight = 25;

        let xBoundLeft = centerX - btnWidth / 2;
        let xBoundRight = centerX + btnWidth / 2;
        let yBoundTop = centerY - btnHeight / 2;
        let yBoundBottom = centerY + btnHeight / 2;

        if (mouseX >= xBoundLeft && mouseX <= xBoundRight &&
            mouseY >= yBoundTop && mouseY <= yBoundBottom) {
          this.triggerStateChange(this.selectedUnit[j], stateValue);
          return;
        }
      }
    }
  }

  triggerStateChange(unit, stateValue) {
    let anim = unit.getAnim(stateValue);
    
    if (stateValue != State.IDLE) {
      anim.setPlayOnce(true);
    } else {
      anim.setPlayOnce(false);
    }
    
    if (stateValue == State.DEATH) {
      unit.setLastTime();
    }
    
    unit.setState(stateValue);
  }

  // Call this from the main p5.js mouseWheel()
  handleMouseWheel(event, units) {
    if (mouseY > height - 212.5) {
      this.scrollOffset -= event.deltaY;
      let maxScroll = (units.length * 165) - width + 50;
      this.scrollOffset = constrain(this.scrollOffset, -maxScroll, 0);
    }
  }
}
