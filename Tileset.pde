class Tilemap {
  
  ArrayList<PImage[][]> tileSet;
  String name;
  
  Tilemap(String name) {
     this.name = name;
     tileSet = new ArrayList<>();
  }
  
  void addTileMap(PImage img, int pixelX, int pixelY) {
    PImage[][] tileImg = new PImage[img.height/pixelY][img.width/pixelY];
     for (int i = 0; i < img.height/pixelY; i++) {
       for (int j = 0; j < img.width/pixelY; j++) {
         tileImg[i][j] = img.get(j*16, i*16, 16, 16);
       }
     }
     tileSet.add(tileImg);
  }
  
  void displayMap(int[][] tileArray, int xpos, int ypos, int tileMapIndex, int tileSize) {
    PImage[][] tileMap = tileSet.get(tileMapIndex);
    for (int i = 0; i < tileArray.length; i++) {
      for (int j = 0; j < tileArray[0].length; j++) {
        if (tileArray[i][j] >= tileMap[0].length*tileMap.length || tileArray[i][j] < 0) continue;
        image(tileMap[tileArray[i][j]/tileMap[0].length][tileArray[i][j] % tileMap[0].length], xpos + j*tileSize, ypos + i*tileSize, tileSize, tileSize);
      }
    }
  }
  
  void showMapGuide(int xpos, int ypos, int index) {
    PImage[][] tileImg = tileSet.get(index);
    for (int i = 0; i < tileImg.length; i++) {
      for (int j = 0; j < tileImg[0].length; j++) {
                
        image(tileImg[i][j], xpos + j*16, ypos + i*16);
        textSize(6);
        text(i*tileImg[0].length +j, xpos + j*16 + 9, ypos + i*16 + 9);
        noFill();
        stroke(255);
        rect(xpos + j*16, ypos + i*16, 16,16);
        
      }
    }
  }

}
