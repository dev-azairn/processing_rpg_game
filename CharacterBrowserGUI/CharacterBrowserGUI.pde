// Main GUI
import java.io.File;

// Universal Constant
FileManager manager;
HashMap<String, Unit> units;
HashMap<String, PImage> staticElements;
CharacterBrowser characterBrowser;
CharacterDialogue characterDialogue; 

float aspectRatio = 16.0 / 9.0; // Example: 16:9 aspect ratio


void setup() {
  pixelDensity(1);
  
  size(1280, 720);
  frameRate(24);
  manager = new FileManager("");
  manager.loadData();
  characterBrowser = new CharacterBrowser(units);
  characterDialogue = new CharacterDialogue("data/Dialogue/config.json", units);
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
  Unit unit1 = characterBrowser.selectedUnit[0];
  Unit unit2 = characterBrowser.selectedUnit[1];  
  if (unit1 != null && unit2 != null) {    
    String name1 = unit1.detail.getName().toLowerCase().replace(" rpg", "");
    String name2 = unit2.detail.getName().toLowerCase().replace(" rpg", "");
    String sceneID = "scene_" + name1 + "_" + name2;    
    if (!characterDialogue.isActive) { 
      println("Checking for dialogue: " + sceneID);
      characterDialogue.startDialogue(sceneID);
      if (!characterDialogue.isActive) {
         sceneID = "scene_" + name2 + "_" + name1;
         println("Checking for dialogue: " + sceneID);
         characterDialogue.startDialogue(sceneID);
      }
    }
  }
}

void windowResized() {
  if(width < 1280) {
    windowResize(800, height);
  } 
  if (height < 720) {
    windowResize(width, 450);
  }
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
