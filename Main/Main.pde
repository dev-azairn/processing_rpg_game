// Universal App

// Universal Constant
FileManager manager;
HashMap<String, Unit> units;
HashMap<String, PImage> staticElements;
CharacterBrowser characterBrowser;



void setup() {
  size(1600, 900);
  windowResizable(true);
  frameRate(5);
  manager = new FileManager("");
  manager.loadData();
  characterBrowser = new CharacterBrowser(units);
}

void draw() {
  background(255);
  characterBrowser.renderGUI();
}

void mousePressed() {
  characterBrowser.mousePressed();
}

void rectGradient(int x, int y, int w, int h, color c1, color c2, float radianAngle, 
int strokeWidth,
color strokeColor,
int borderRadius,
int rectMode) {
  
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
