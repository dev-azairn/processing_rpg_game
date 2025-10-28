class Swordsman extends GameCharacter {

  Swordsman(String name, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage){
    super(name, "Swordsman", baseAtk, baseHealth, baseDefense, speed, critRate, critDamage, 
    "assets/Character/Swordsman/Swordsman/Swordsman-Idle.png", 
    "assets/Character/Swordsman/Swordsman/Swordsman-Attack01.png", 
    "assets/Character/Swordsman/Swordsman/Swordsman-Death.png", 
    "assets/Character/Swordsman/Swordsman/Swordsman-Walk.png",
    "assets/Character/Swordsman/Swordsman with shadows/Swordsman-Idle.png", 
    "assets/Character/Swordsman/Swordsman with shadows/Swordsman-Attack01.png", 
    "assets/Character/Swordsman/Swordsman with shadows/Swordsman-Death.png", 
    "assets/Character/Swordsman/Swordsman with shadows/Swordsman-Walk.png");
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
