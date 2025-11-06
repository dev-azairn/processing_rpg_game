class CharacterBrowser {
  HashMap<String, Unit> units;
  Unit[] selectedUnit; 
  CharacterBrowser(HashMap<String, Unit> units) {
    this.units = units;
    selectedUnit = new Unit[2];
  }
  
  
  
  void renderGUI() {
    // Start_Button
    Button startBtn = new Button();
    
    
    // Stage
    
    
    // Status List
    
    
    // Border
    
    
    // Character Text
    
    
    // List Character 
    for (String unitName: units.keySet()) {
      
    }
    
    // Scroll-Bar
    
  }
  
  void mousePressed() {
   // Left-click : select unit-1
   
   // Right-click : select unit-2
  }
  
  
  
}

class Status {
   
  void render(int posX, int posY) {
  
  }
}
