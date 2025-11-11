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
          continue;
        }
        stroke(0);
         strokeWeight(2);
         rectMode(CORNER);
         fill(255);
         rect(width-300, 100 + i*200, 300, 200);
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
    for (Unit unit: units.values()) {
       unit.render();
    }
  }
  
  
}
