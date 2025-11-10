// Universal App

FileManager manager;
HashMap<String, Unit> units;
CharacterBrowser characterBrowser;

void setup() {
  size(500, 500);
  frameRate(10);
  manager = new FileManager("");
  manager.loadData("");
  characterBrowser = new CharacterBrowser(units);
}

void draw() {
  background(255);
  characterBrowser.renderGUI();
}

void mousePressed() {
  characterBrowser.mousePressed();
}
