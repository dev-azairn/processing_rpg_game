abstract class Scene {
  
  Player player;
  
  Scene(Player player) {
    this.player = player;
  }
  
  abstract void run();
  abstract void click(); 
}
