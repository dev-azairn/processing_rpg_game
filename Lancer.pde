class Lancer extends GameCharacter {

  Lancer(String name, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage){
    super(name, "Archer", baseAtk, baseHealth, baseDefense, speed, critRate, critDamage, 
    "assets/Character/Lancer/Lancer/Lancer-Idle.png", 
    "assets/Character/Lancer/Lancer/Lancer-Attack01.png", 
    "assets/Character/Lancer/Lancer/Lancer-Death.png", 
    "assets/Character/Lancer/Lancer/Lancer-Walk01.png",
    "assets/Character/Lancer/Lancer with shadows/Lancer-Idle.png", 
    "assets/Character/Lancer/Lancer with shadows/Lancer-Attack01.png", 
    "assets/Character/Lancer/Lancer with shadows/Lancer-Death.png", 
    "assets/Character/Lancer/Lancer with shadows/Lancer-Walk01.png");
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
