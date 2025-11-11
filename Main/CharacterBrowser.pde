class CharacterBrowser {
  HashMap<String, Unit> units;
  Unit[] selectedUnit; 
  CharacterBrowser(HashMap<String, Unit> units) {
    this.units = units;
    selectedUnit = new Unit[2];
  }
  
  
  
  void renderGUI() {
    // Start_Button
    // Button startBtn = new Button();
    
    
    // Stage Podium
    
    
    // Status List
    
    
    // Border
    
    
    // Character Text
     
    
    // List Character
    rectGradient(0, height-250, width, 250, color(125, 88, 57), color(170, 132, 90), 90, 0, color(0,0,0), 0, CORNER);
    int i = 0;
    for (Unit unit: units.values()) {
       rectGradient(165*i + 100, height - 100, 150, 150, color(255,162,57), color(254,238,145), 45, 5, color(0,0,0), 25, CENTER);
       unit.setPosition(165*i + 100, height - 100);
       unit.render();
       i++;
    }
   
    // Scroll-Bar
    
  }
  
  void mousePressed() {
   // Left-click : select unit-1
   
   // Right-click : select unit-2
  }
  
  void mouseWheel(){
    for (Unit unit: units.values()) {
       unit.render();
    }
  }
  
  
}

class Status {
   
  void render(int posX, int posY) {
  
  }
}
