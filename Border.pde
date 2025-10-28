class Border {
  
  PImage topLeftCorner;
  PImage topRightCorner;
  PImage bottomLeftCorner;
  PImage bottomRightCorner;
  PImage top;
  PImage bottom;
  PImage left;
  PImage right;
  PImage center;
  int padding = 16;
  int imageSize = 64;
  int cutting = imageSize - padding;
  int sectionSize = 32;
  Border(String path) {
    
    PImage temp = loadImage(path).get(0,0,imageSize,imageSize);
    
    topLeftCorner = temp.get(0,0,padding,padding);
    topRightCorner = temp.get(cutting,0,padding,padding);
    bottomLeftCorner = temp.get(0,cutting,padding,padding);
    bottomRightCorner = temp.get(cutting, cutting,padding,padding);
    top = temp.get(padding, 0, padding, padding);
    bottom = temp.get(padding, cutting, padding, padding);
    left = temp.get(0, padding, padding, padding);
    right = temp.get(cutting, padding, padding, padding);
    center = temp.get(padding, padding,padding, padding);
    // 
    
  }
  
  Border(PImage temp) {
    topLeftCorner = temp.get(0,0,padding,padding);
    topRightCorner = temp.get(cutting,0,padding,padding);
    bottomLeftCorner = temp.get(0,cutting,padding,padding);
    bottomRightCorner = temp.get(cutting, cutting,padding,padding);
    top = temp.get(padding, 0, padding, padding);
    bottom = temp.get(padding, cutting,padding, padding);
    left = temp.get(0, padding, padding, padding);
    right = temp.get(cutting, padding, padding, padding);
    center = temp.get(padding, padding,padding, padding);
    // 
    
  }
  
  void display(int x, int y, int borderWidth, int borderHeight) {
    
    int currentHeight = 0;
    while (currentHeight < borderHeight) {
      int currentWidth = 0; 
      while (currentWidth < borderWidth) {
        if (currentWidth == 0 && currentHeight == 0) {
          image(topLeftCorner, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentWidth + sectionSize >= borderWidth && currentHeight + sectionSize >= borderHeight) {
          image(bottomRightCorner, x + currentWidth, y + currentHeight , sectionSize, sectionSize);
          
        } else if (currentWidth + sectionSize >= borderWidth && currentHeight == 0) {
          image(topRightCorner, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentHeight + sectionSize >= borderHeight && currentWidth == 0) {
          image(bottomLeftCorner, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentHeight == 0) {
          image(top, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentWidth == 0) {
          image(left, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentWidth + sectionSize >= borderWidth) {
          image(right, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else if (currentHeight + sectionSize >= borderHeight) {
          image(bottom, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        } else {
          image(center, x + currentWidth, y + currentHeight, sectionSize, sectionSize);
          
        }
        currentWidth +=  sectionSize;
      }
      currentHeight += sectionSize;
    }
  } 

}
