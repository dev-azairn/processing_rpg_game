class CharacterBrowser extends Scene {
  
  ArrayList<GameCharacter> allCharacters;
  MenuList<GameCharacter> menu;
  Border background;
  Tilemap tileset;
  GameCharacter charOverviewInfo;
  Animation charOverview;
  Border overView;
  ArrayList<PImage> enviSprite;
  PImage titleBorder;
  PImage elementBorder;
  PImage nameBorder;
  ElementalIcon elementPlayer;
  CharacterBrowser(Player player) {
    super(player);
    allCharacters = new ArrayList<>();
    allCharacters.add(new Archer("Emiya Shirou", 15, 100, 20, 100, 0.5, 0.7));
    allCharacters.add(new Swordsman("Arthur", 10, 100, 50, 50, 0.5, 0.5));  
    allCharacters.add(new Priest("Sakura", 10, 100, 50, 50, 0.5, 0.5)); //<>//
    allCharacters.add(new Lancer("Cu Chulian", 15, 100, 5, 150, 0.6, 0.5));
    allCharacters.add(new Wizard("Gilgamesh", 10, 100, 30, 100, 0.5, 1));
    allCharacters.add(new Wizard("Iliya", 10, 100, 30, 100, 0.5, 1));
    
    tileset = new Tilemap("Sample Forest");
    tileset.addTileMap(loadImage("assets/Tilemap/TileGround01a.png"), 16, 16);
    tileset.addTileMap(loadImage("assets/Tilemap/TileGrass01a.png"), 16, 16);
    tileset.addTileMap(loadImage("assets/Tilemap/GrassPatern02b.png"), 13, 13);
    tileset.addTileMap(loadImage("assets/Tilemap/GrassPatern04b.png"), 14, 14);
    menu = new MenuList("border/01 Border 01.png",
                                     "border/01 Border 01.png",
                                     "border/06 Border 01.png",
                                     "font/CallimathyDemo-8MWXg.ttf",
                                     30,200,
                                     125,125,
                                     800,450,
                                     allCharacters, "");
    background = new Border(loadImage("border/01 Border 01.png").get(0,64*3, 64, 64));
    overView = new Border(loadImage("border/01 Border 01.png").get(64*3,64*2, 64, 64));
    titleBorder = loadImage("border/01.png").get(160,144,96, 32);
    elementBorder = loadImage("border/01.png").get(160,112, 96,32);
    nameBorder = loadImage("border/01.png").get(0,176, 80,32);
    elementPlayer = new ElementalIcon();
  }
  //
  void run() {
      background(255);
      //for (GameCharacter character: allCharacters) {
      //  character.animate(xpos, ypos);
      //  character.loadPosition(xpos, ypos);
        
      //  if (character.isFinishedCycle() && !character.getAnimationType().equals("idle")) {
      //    character.setFinishedCycle(false);
      //    character.loadAnimate("idle");
      //  }
      //  xpos += character.getWidth();
      //}
      background.display(0,0,displayWidth,displayHeight);
     
      menu.display();
      //tileset.showMapGuide(20,20,0);
      //tileset.showMapGuide(200,20,1);
      
      //tileset.showMapGuide(468,20,2);
      int[][] map = new int[12][10];
      for (int i = 0; i < 12; i++) {
        for (int j = 0; j < 10; j++) {
          map[i][j] = 12;
        }
      }
      overView.display(888,200, 390, 468);
      tileset.displayMap(map, 916, 225, 1, 432/12);
      for (int i = 0; i < 12; i++) {
        for (int j = 0; j < 10; j++) {
          map[i][j] = 0;
        }
      }
      tileset.displayMap(map, 916, 225, 3, 432/12);
      image(titleBorder, 237, 144, 96 * 4, 32*4);
      image(elementBorder, 948, 160, 96 * 3, 32* 3);
      image(nameBorder, 948, 616, 96 * 3, 32 *3);
      if (charOverview != null) {
        charOverview.display(930, 275, 300, 300);
        elementPlayer.displayElement(charOverviewInfo.getElement(), 1060, 176, 64);
        fill(0);
        textSize(29);
        text(charOverviewInfo.getName(), 1087, 664);
        
        fill(255);
        textSize(28);
        text(charOverviewInfo.getName(), 1088, 664);
      }
      
     
        
      stroke(0);
      fill(0);
      textSize(41);
      rectMode(CENTER);
      text("Character", 237 + 96*2 - 1, 144 + 32*2.5 - 1);
      
      fill(255);
      textSize(40);
      text("Character", 237 + 96*2, 144 + 32*2.5);
  }
  
  void click() {
      System.out.println("Click");
      for (GameCharacter character: allCharacters) {
        int x = character.getX();
        int y = character.getY();
        int cWidth = character.getWidth();
        if (mouseX >= x && mouseX <= x + cWidth && mouseY >= y && mouseY <= y + cWidth) {
          if(charOverviewInfo != null) charOverviewInfo.deselected();
          charOverviewInfo = character;
          character.loadAnimate("attack");
          character.selected();
          charOverview = character.getIdleWithShadow();
        }
      }
  }
}
