interface GameElement {
  String getName();
  void setSize(int cwidth, int cheight);
  int getWidth();
  int getHeight();
  void setX(int x);
  void setY(int y);
  int getX();
  int getY();
  boolean isSelected();
  String getAnimationType();
  void loadAnimate(String type);
  boolean isFinishedCycle();
  void setFinishedCycle(boolean e);
  void display(int xpos, int ypos);
  void display(int xpos, int ypos, int elementWidth, int elementHeight);
}
