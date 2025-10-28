abstract class GameCharacter implements GameElement {
  
  // Character Position and Event Information
  int x_pos;
  int y_pos;
  int char_width;
  int char_height;
  
  // Character Gameplay Infomation
  private String name;
  private String className;
  private int atk;
  private int health;
  private int defense;
  private int speed;
  private float critRate;
  private float critDamage;
  private float effectHitRate;
  private float effectRES;
  private int level;
  private int exp;
  
  private boolean isSelected;
  
  private Animation idle;
  private Animation attack;
  private Animation skill;
  private Animation death;
  private Animation walk;
  private Animation idleWithShadow;
  private Animation attackWithShadow;
  private Animation deathWithShadow;
  private Animation walkWithShadow;
  
  private char elementType;
  
  private ArrayList<Buff> buffs;
  private Animation animateModel;
  
  
  GameCharacter(String name, String className, int baseAtk, int baseHealth, int baseDefense, int speed, float critRate, float critDamage, 
                String idlePath, String attackPath, String deathPath, String walkPath,
                String idleShadowPath, String attackShadowPath, String deathShadowPath, String walkShadowPath) {
                 
     this.name = name;
     this.className = className;
     this.atk = baseAtk;
     this.health = baseHealth;
     this.defense = baseDefense;
     this.speed = speed;
     this.critRate = critRate;
     this.critDamage = critDamage;
     this.effectHitRate = 0.5f;
     this.effectRES = 0.0f;
     this.level = 1;
     this.buffs = new ArrayList<Buff>();
     idle = new Animation(idlePath);
     attack = new Animation(attackPath);
     death = new Animation(deathPath);
     walk = new Animation(walkPath);
     idleWithShadow = new Animation(idleShadowPath);
     elementType = 'F';
     animateModel = idle;
  }
  
  // ATK Management
  int getATK() {
    return this.atk;
  }
  
  void setATK(int atk) {
    this.atk = atk;
  }
  
  abstract void basicAttack(GameCharacter target);
  
  // Change to defense mode
  abstract void defense();
  
  // Using skill
  abstract void usingSkill(GameCharacter target);
  
  // Using ultimate skill
  abstract void usingUltimateSkill(GameCharacter target);
  
  String getName() {
    return this.name;
  }
  
  Character getElement() {
    return this.elementType;
  }
  
  int getHealth(){
    return this.health;
  }
  
  void setHealth(int health) {
    this.health = health;
  }
  
  int getLevel() {
    return this.level;
  }
  
  void setLevel(int level) {
    this.level = level;
  }
  
  
  // ---- Buff Manipulation
  //ArrayList<Buff> getBuff() {
  //  return buffs;
  //}
  
  //void attachBuff(Buff buff, GameCharacter target) {
  //  if (random(0, 100) < (this.getEffectHitRate() - target.getEffectRES() * 100)) {
  //    target.getBuff().add(buff);
  //    System.out.println("Attach \"" + buff.getName() + "\" Successfully!");
  //  }
  //}
  
  // ----
  
  void getDamage(int attackDamage) {
    this.health -= (attackDamage - this.defense) > 0 ? (attackDamage - this.defense) : 0;
  }
  
  
  float getEffectHitRate() {
    return this.effectHitRate;
  }
  
  float getEffectRES() {
    return this.effectRES;
  }
  
  void selected() {
    isSelected = true;
  }
  
  void deselected() {
    isSelected = false;
  }
  
  boolean isSelected() {
    return isSelected;
  }
  
  void loadAnimate(String type){
    if (type.equalsIgnoreCase("idle")) {
      animateModel = idle;
    } else if (type.equalsIgnoreCase("attack")) {
      animateModel = attack;
    }
  }
  
  void setSize(int cwidth, int cheight) {
    char_width = cwidth;
    char_height = cheight;
  }
  
  int getWidth() {
    return char_width;
  }
  
  int getHeight() {
    return char_height;
  }
  
  void display(int xpos, int ypos) {
    animateModel.display(xpos, ypos);
  }
  
  void display(int xpos, int ypos, int elementWidth, int elementHeight) {
    animateModel.display(xpos, ypos, elementWidth, elementHeight);
  }
  
  void loadPosition(int x_pos, int y_pos) {
    this.x_pos = x_pos;
    this.y_pos = y_pos;
  }
  
  String getAnimationType() {
    if (animateModel == idle) {
      return "idle";
    }
    else if (animateModel == attack) {
      return "attack";
    }
    return "";
  }
  
  void setFinishedCycle(boolean e) {
    animateModel.setFinishedCycle(e);
  }
  
  boolean isFinishedCycle() {
    return animateModel.isFinishedCycle();
  }
  
  void setX(int x) {
    this.x_pos = x;
  }
  
  void setY(int y) {
    this.y_pos = y;
  }
  
  int getX() {
    return x_pos;
  }
  
  int getY() {
    return y_pos;
  }
  
  abstract void getCharacter(GameCharacter character);
  
  Animation getIdleWithShadow() {
    return idleWithShadow;
  }
  
}
