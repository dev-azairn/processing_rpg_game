// Universal App

FileManager manager;
HashMap<String, Unit> units;
CharacterBrowser characterBrowser;

void setup() {
  size(100,100);
  frameRate(10);
  manager = new FileManager("");
  units = manager.loadUnitData("Characters","config.json");
  characterBrowser = new CharacterBrowser(units);
}

void draw() {
  characterBrowser.renderGUI();
}

void mousePressed() {
  characterBrowser.mousePressed();
}
