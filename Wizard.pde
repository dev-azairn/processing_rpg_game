class Wizard extends GameCharacter {

  Wizard(String name, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage){
    super(name, "Wizard", baseAtk, baseHealth, baseDefense, speed, critRate, critDamage, 
    "assets/Character/Wizard/Wizard/Wizard-Idle.png", 
    "assets/Character/Wizard/Wizard/Wizard-Attack01.png", 
    "assets/Character/Wizard/Wizard/Wizard-DEATH.png", 
    "assets/Character/Wizard/Wizard/Wizard-Walk.png",
    "assets/Character/Wizard/Wizard with shadows/Wizard-Idle.png", 
    "assets/Character/Wizard/Wizard with shadows/Wizard-Attack01.png", 
    "assets/Character/Wizard/Wizard with shadows/Wizard-DEATH.png", 
    "assets/Character/Wizard/Wizard with shadows/Wizard-Walk.png");
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
