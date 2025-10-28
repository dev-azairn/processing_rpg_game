static int characterNo = 0;
Animation a1, a2;

JSONObject playerData;
Player player;
// -- Scene Definition --
Scene characterBrowser;



void setup() {                      
  fullScreen();
  frameRate(10);
  // Load Character Data
  loadPlayerData();
  loadScene();
  player.setCurrentScene(characterBrowser);
  surface.setTitle("Turn-based Game");
  surface.setResizable(true);
  surface.setIcon(loadImage("assets/Character/Archer/Archer/Archer-Idle.png").get(40,40,20,20));
  // load playerData
}

void draw() {
  run();
}

// Tester
void loadPlayerData() {
  player = new Player("Petch");
}

void loadScene() {
  characterBrowser = new CharacterBrowser(player);
}

void run() {
  characterBrowser.run();
}

void mousePressed() {
   characterBrowser.click();
}
