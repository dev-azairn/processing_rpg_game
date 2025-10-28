class MenuList<E extends GameElement> {
    Border elementBoxStyle;
    Border selectedBox;
    Border listAreaStyle;
    PFont font;
    int xpos;
    int ypos;
    int elementWidth;
    int elementHeight;
    int listAreaWidth;
    int listAreaHeight;
    ArrayList<E> list;
    String listStyle;
    
    MenuList(String pathImageBox, 
            String pathImageArea, 
            String pathSelectedBox,
            String fontPath,
            int xpos, int ypos,
            int elementWidth, int elementHeight, 
            int listAreaWidth, int listAreaHeight, 
            ArrayList<E> list, String listStyle) {
      elementBoxStyle = new Border(pathImageBox);
      listAreaStyle = new Border(pathImageArea);
      selectedBox = new Border(pathSelectedBox);
      font = createFont(fontPath,14);
      this.xpos = xpos;
      this.ypos = ypos;
      this.elementWidth = elementWidth;
      this.elementHeight = elementHeight;
      this.listAreaWidth = listAreaWidth;
      this.listAreaHeight = listAreaHeight;
      this.list = list;
      this.listStyle = listStyle;
      
      for (E element: list) {
        element.setSize(elementWidth, elementHeight);
      }
    }
    
    void display() {
      if (elementWidth > listAreaWidth || elementHeight > listAreaHeight) {
        System.out.println("Item is out of spacing.");
        return;
      }
     
      
      
      fill(255);
      listAreaStyle.display(xpos, ypos, listAreaWidth, listAreaHeight);
       
      
      int padding = (listAreaWidth - elementWidth*5)/6;
      int currentXPos = xpos + padding;
      int currentYPos = ypos + padding + 50;
      for (E element: list) {
         //image(elementBoxStyle, currentXPos, currentYPos, elementWidth, elementHeight);
         if (element.isSelected()) {
           selectedBox.display(currentXPos, currentYPos, elementWidth, elementHeight);
         } else {
           elementBoxStyle.display(currentXPos, currentYPos, elementWidth, elementHeight);
         }
         element.display(currentXPos, currentYPos, elementWidth, elementHeight);
         element.setX(currentXPos);
         element.setY(currentYPos);
         if(!element.getAnimationType().equals("idle") && element.isFinishedCycle() == true) {
           element.setFinishedCycle(false);
           element.loadAnimate("idle");
         }
         
         fill(255);
         textSize(14);
         textFont(font);
         textAlign(CENTER);
         text(element.getName(), currentXPos + elementWidth/2, currentYPos + elementWidth - 20);
         currentXPos += elementWidth + padding;
         if (currentXPos > listAreaWidth) {
           currentYPos += elementHeight + padding;
           currentXPos = xpos + padding;
         }
      }
      
    }
    
    
}
