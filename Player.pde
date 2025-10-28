class Player {
  ArrayList<GameCharacter> ownedCharacter;
  private String name;
  private Scene currentScene;
  
  Player(String name) {
    this.name = name;
  }
  
  String getName() {
    return this.name;
  }
  
  void setName(String name) {
     this.name = name;
  }
  
  void addNewCharacter(GameCharacter character) {
    if (!ownedCharacter.contains(character)) ownedCharacter.add(character);
  }
  
  Scene getCurrentScene() {
    return currentScene;
  }
  
  void setCurrentScene(Scene scene) {
    this.currentScene = scene;
  }
  
}
