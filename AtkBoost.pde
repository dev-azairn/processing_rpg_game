class AtkBoost extends Buff {
  private float boost;
  AtkBoost(String name, String className, float boost,String description, int turnTaken) {
    super(name, className, description, turnTaken);
    this.boost = boost;  
  }
  
  void activateBuff(GameCharacter target, String arg) {
    int targetATK = target.getATK();
    target.setATK(int(targetATK * (1 + boost)));
    }
}
