class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  boolean isFinishedCycle;
  Animation(String imagePath) {
    PImage temp = loadImage(imagePath);
    imageCount = temp.width/100;
    images = new PImage[imageCount];
    for (int i = 0; i < imageCount; i++) {
      images[i] = temp.get(i*100 + 10, 10, 80, 80);
      System.out.println("Load Frame " + (i + 1));
    }
    System.out.println("Load Animate Successfully");
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, 100, 100);
    if (frame == imageCount - 1 && !isFinishedCycle) isFinishedCycle = !isFinishedCycle; 
  }
  
  void display(float xpos, float ypos, int elementWidth, int elementHeight) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, elementWidth, elementHeight);
    if (frame == imageCount - 1 && !isFinishedCycle) isFinishedCycle = !isFinishedCycle; 
  }
  
  boolean isFinishedCycle() {
    return isFinishedCycle;
  }
  
  void setFinishedCycle(boolean e) {
    isFinishedCycle = e;
  }
  
  int getWidth() {
    return images[0].width;
  }
}
