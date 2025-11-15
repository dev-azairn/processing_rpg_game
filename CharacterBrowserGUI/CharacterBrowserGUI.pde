// Main GUI

import java.io.File;

// Universal Constant
FileManager manager;
HashMap<String, Unit> units;
CharacterBrowser characterBrowser;
CharacterDialogue characterDialogue; 

Unit oldUnit1 = null;
Unit oldUnit2 = null;

float aspectRatio = 16.0 / 9.0; // Example: 16:9 aspect ratio


void setup() {
  pixelDensity(1);  
  size(1280, 720);
  frameRate(24);
<<<<<<< Updated upstream
  manager = new FileManager("");
  manager.loadData();
  characterBrowser = new CharacterBrowser(units);
  characterDialogue = new CharacterDialogue(units);
=======
  manager = new FileManager();
  manager.test();
  characterBrowser = new CharacterBrowser();
  characterDialogue = new CharacterDialogue("data/Dialogue/config.json", units);
>>>>>>> Stashed changes
}

void draw() {
  background(255);
  
  characterBrowser.renderGUI();
  characterDialogue.update(); 
  characterDialogue.render();
  
}

void mousePressed() { 
  if (characterDialogue.isActive) {
    return; 
  }
  characterBrowser.mousePressed();
<<<<<<< Updated upstream
  Unit newUnit1 = characterBrowser.selectedUnit[0];
  Unit newUnit2 = characterBrowser.selectedUnit[1];
  if (newUnit1 != null && newUnit2 != null) {
    if (newUnit1 != oldUnit1 || newUnit2 != oldUnit2) {
      println("Checking for taunt: " + newUnit1.detail.getName() + " & " + newUnit2.detail.getName());
      characterDialogue.startTauntDialogue(newUnit1, newUnit2);
=======
  Unit unit1 = characterBrowser.selectedUnit[0];
  Unit unit2 = characterBrowser.selectedUnit[1];  
  if (unit1 != null && unit2 != null) {    
    String name1 = unit1.detail.getName().toLowerCase().replace(" rpg", "");
    String name2 = unit2.detail.getName().toLowerCase().replace(" rpg", "");
    String sceneID = "scene_" + name1 + "_" + name2;    
    if (!characterDialogue.isActive) { 
      println("Checking for dialogue: " + sceneID);
      characterDialogue.startNormalDialogue(sceneID);
      if (!characterDialogue.isActive) {
         sceneID = "scene_" + name2 + "_" + name1;
         println("Checking for dialogue: " + sceneID);
         characterDialogue.startNormalDialogue(sceneID);
      }
>>>>>>> Stashed changes
    }
  }
  else if (newUnit1 != null && newUnit2 == null) {
    if (newUnit1 != oldUnit1) {
      println("Checking for normal dialogue: " + newUnit1.detail.getName());
      characterDialogue.startNormalDialogue(newUnit1);
    }
  }
  else if (newUnit1 == null && newUnit2 != null) {
     if (newUnit2 != oldUnit2) {
      println("Checking for normal dialogue: " + newUnit2.detail.getName());
      characterDialogue.startNormalDialogue(newUnit2);
    }
  }
  else if (newUnit1 == null && newUnit2 == null) {
    if (oldUnit1 != null || oldUnit2 != null) {
      characterDialogue.endDialogue();
    }
  }
  oldUnit1 = newUnit1;
  oldUnit2 = newUnit2;
}

void mouseWheel(MouseEvent event){
  characterBrowser.mouseWheel(event);
}

void rectGradient(int x, int y, int w, int h, color c1, color c2, float radianAngle, 
int strokeWidth, color strokeColor, int borderRadius, int rectMode) {
  
  PImage image = createImage(w, h, ARGB);
  PGraphics pg = createGraphics(w, h);

  image.loadPixels();

  float dx = cos(radianAngle);
  float dy = sin(radianAngle);
  float centerX = w / 2.0;
  float centerY = h / 2.0;
  float maxDist = (abs(w * dx) + abs(h * dy)) / 2.0;

  for (int i = 0; i < h; i++) {
    for (int j = 0; j < w; j++) {
      int index = i * w + j;
      float relX = j - centerX;
      float relY = i - centerY;
      float projection = relX * dx + relY * dy;
      float amount = map(projection, -maxDist, maxDist, 0, 1);
      color c = lerpColor(c1, c2, amount);
      image.pixels[index] = c;
    }
  }

  image.updatePixels();

  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.noStroke();
  pg.rect(0, 0, w, h, borderRadius);
  pg.endDraw();
  imageMode(rectMode);
  image.mask(pg);
  
  rectMode(rectMode);
  image(image, x, y);
  noFill();
  strokeWeight(strokeWidth);
  stroke(strokeColor);
  rect(x, y, w, h, borderRadius);  
}

void pauseItem() {
  
}
