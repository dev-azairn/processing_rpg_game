class Priest extends GameCharacter {

  Priest(String name, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage){
    super(name, "Priest", baseAtk, baseHealth, baseDefense, speed, critRate, critDamage, 
    "assets/Character/Priest/Priest/Priest-Idle.png",
    "assets/Character/Priest/Priest/Priest-Attack.png",
    "assets/Character/Priest/Priest/Priest-Death.png",
    "assets/Character/Priest/Priest/Priest-Walk.png",
    "assets/Character/Priest/Priest with shadows/Priest-Idle.png",
    "assets/Character/Priest/Priest with shadows/Priest-Attack.png",
    "assets/Character/Priest/Priest with shadows/Priest-Death.png",
    "assets/Character/Priest/Priest with shadows/Priest-Walk.png");
  }
  
  @Override 
  void basicAttack(GameCharacter target){
    
  }
  
  void defense() {
  }
  
  // Using skill
  void usingSkill(GameCharacter target) {
    
  }
  
  // Using ultimate skill
  void usingUltimateSkill(GameCharacter target) {
  
  }
  
  void getCharacter(GameCharacter character) {
  
  }
}
