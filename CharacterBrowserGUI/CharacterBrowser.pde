class CharacterBrowser {
  Unit[] selectedUnit; 
  CharacterDialogue characterDialogue; 
  PImage background;
  PImage podium;
  float scrollOffset = 0;
  CharacterBrowser() {
    selectedUnit = new Unit[2];
    background = loadImage("data/Podium/Scene.jpg");
    characterDialogue = new CharacterDialogue(units);
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
      rect(width-300, 100, 300, 400);
      for (int i = 0; i < selectedUnit.length; i++) {
        
        if (selectedUnit[i] == null) {
          stroke(0);
          strokeWeight(2);
          rectMode(CORNER);
          noFill();
          rect(width-300, 100 + i*200, 300, 200);
          fill(255);
          textSize(16);
          textAlign(CENTER);
          text("No selected character", width-150, 200 + i*200);
          
        } else {
         stroke(0);
         strokeWeight(2);
         fill(0,0,0,50);
         rectMode(CORNER);
         rect(width-300, 100 + i*200, 300, 200);
         textAlign(CENTER);
         fill(255);
         textAlign(CENTER);
         textSize(20);
         text(selectedUnit[i].getName(), width-150, 130 + i*200);
         fill(255);
         textAlign(LEFT);
         textSize(16);
         text("Status:", width-275, 150 + i*200);
         text("Health: " + selectedUnit[i].getHealth(), width-250, 175 + i*200);
         text("ATK: " + selectedUnit[i].getAtk(), width-125, 175 + i*200);
         text("Action:", width-275, 225 + i*200);
         
         for (State state: State.values()) {
           rectMode(CENTER);
           fill(255);
           stroke(0);
           strokeWeight(2);
           rect(width-235 + 60*state.ordinal(), 255 + i*200, 50, 25, 10);
           fill(0);
           String text;
           switch (state) {
             case IDLE:
               text = "IDLE";
               break;
             case WALK:
               text = "WALK";
               break;
             case ATTACK:
               text = "ATTACK";
               break;
             case DEATH:
               text = "DEATH";
               break;
             default:
               text = "NO";
           }
           textAlign(CENTER);
           textSize(12);
           text(text,width-235 + 60*state.ordinal(), 258 + i*200);
          
         } 
        selectedUnit[i].render();
        }
      
     }
    
    
    // List Character
    rectMode(CORNER);
    fill(0,0,0,50);
    stroke(0);
    strokeWeight(3);
    rect(0, height - 212.5, width, 212.5);
    
  
  int i = 0;
  for (String hkey : units.keySet()) {
    Unit unit = units.get(hkey);
    
   
    int x = 165 * i + 100 + (int) scrollOffset;
    int y = height - 100;
    
    if (!unit.isSelected()) {
      rectGradient(x, y, 150, 150, color(232, 60, 145), color(255, 198, 157), PI / 4, 5, color(0, 0, 0), 25, CENTER);
    } else {
      rectGradient(x, y, 150, 150, color(150, 60, 145), color(150, 198, 157), PI / 4, 5, color(0, 0, 0), 25, CENTER);
    }
    unit.displayPortrait(x, y);
    textSize(16);
    fill(255);
    text(hkey, x, y);
    i++;
  }
    // Scrolling Bar
    
    fill(255);
    strokeWeight(2);
    stroke(150);
    rectMode(CORNER);
    rect(20 - scrollOffset * width/(units.size()*165 + 100), height-12, width * width/(units.size()*165 + 100), 7, 10);
    characterDialogue.update(); 
    characterDialogue.render();
  }
  
  void mousePressed() {
   // Left-click : select unit-1
     int i = 0;
     for (String hkey: units.keySet()) {
       Unit unit = units.get(hkey);
       float xBoundLeft = 165*i + 100 - 150/2 + scrollOffset;
       float xBoundRight = 165*i + 100 + 150/2 + scrollOffset;
        println(xBoundLeft, xBoundRight);
       
       if (mouseX >= xBoundLeft && xBoundRight >= mouseX
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
           selectedUnit[0].setPosition(350, 350);
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
           selectedUnit[1].setPosition(450, 450);
           println("Selected:" + unit);
         }
       }
       i++;
     }
     
     for (int j = 0; j < selectedUnit.length; j++) {
       for (State state: State.values())
       {
            if (mouseX >= width-245 + 60*state.ordinal() && mouseX <= width-245 + 50*(state.ordinal()+1)
           && mouseY >= 240 + j*200 && mouseY <= 240 + j*200 + 25) {
             println("click");
             Sprite anim = selectedUnit[j].getAnim(state);
             if (state != State.IDLE) anim.setPlayOnce(true);
             else anim.setPlayOnce(false);
             if (state == State.DEATH) selectedUnit[j].setLastTime();
             selectedUnit[j].setState(state);
             return;
           }
       }
     }
     
     characterDialogue.mousePressed(selectedUnit);
     
   }
  
  
  void mouseWheel(MouseEvent event) {

  println(event);
  if (mouseY > height - 212.5) {
    float scrollAmount = event.getCount(); 
    scrollOffset += scrollAmount * 20; 
    println(scrollOffset);
   
    float maxScroll = (units.size() * 165) - width + 50; 
    scrollOffset = constrain(scrollOffset, -maxScroll, 0);
  }
}
  
}
