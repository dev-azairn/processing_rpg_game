class Archer extends GameCharacter {
  Archer(String name, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage){
    super(name, "Archer", baseAtk, baseHealth, baseDefense, speed, critRate, critDamage, 
    "assets/Character/Archer/Archer/Archer-Idle.png", 
    "assets/Character/Archer/Archer/Archer-Attack01.png", 
    "assets/Character/Archer/Archer/Archer-Death.png", 
    "assets/Character/Archer/Archer/Archer-Walk.png",
    "assets/Character/Archer/Archer with shadows/Archer-Idle.png",
    "assets/Character/Archer/Archer with shadows/Archer-Attack01.png",
    "assets/Character/Archer/Archer with shadows/Archer-Death.png",
    "assets/Character/Archer/Archer with shadows/Archer-Walk.png");
  }
  
  @Override 
  void basicAttack(GameCharacter target){
    //this.attachBuff(new AtkBoost("Fury!", "Buff", 0.5, "When the archer attack the enemy, will boost the ATK 50% for themselves 3 turns.", 3),
    //target);
  }
  
  @Override
  void defense() {
  }
  
  // Using skill
  @Override
  void usingSkill(GameCharacter target) {
    
  }
  
  // Using ultimate skill
  @Override
  void usingUltimateSkill(GameCharacter target) {
  
  }
  
  void getCharacter(GameCharacter character) {
  
  }
}
