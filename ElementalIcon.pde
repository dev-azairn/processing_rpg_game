

class ElementalIcon {
    HashMap<Character, String> icons;
    
    ElementalIcon () {
      icons = new HashMap<>();
      icons.put('F', "assets/Element/[3] Fire.png");
    }
   
   void displayElement(Character e, int xpos, int ypos, int size) {
     try {
       if (icons.get(e) != null)
       image(loadImage(icons.get(e)), xpos, ypos, size, size);
     } catch (Exception err) {
     }
   }
   
   
  

}
