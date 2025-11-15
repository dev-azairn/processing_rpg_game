
enum State{IDLE, WALK, ATTACK, DEATH};
class Unit {
  HealthBar healthBar;
  UnitDetail detail;
  Sprite idle;
  Sprite death;
  Sprite walk;
  Sprite attack;
  boolean isSelected;
  boolean isOpening;
  PImage portrait;
  int posX;
  int posY;
  int width;
  int height;
  State state;
  CharacterDialogue dialogue;
  int lastTime;
  boolean setTime;
  Unit(JSONObject detail, String idleConfig, String attackConfig, String walkConfig, String deathConfig, String healthBarConfig) {
     this.detail = new UnitDetail(detail.getString("name"), detail.getString("description"), detail.getFloat("health"), detail.getFloat("atk"));  
     this.idle = new Sprite(idleConfig);
     this.attack = new Sprite(attackConfig);
     this.walk = new Sprite(walkConfig);
     this.death = new Sprite(deathConfig);
     this.healthBar = new HealthBar(healthBarConfig, this.detail.getHealth());
     idle.loadImageData();
     attack.loadImageData();
     walk.loadImageData();
     death.loadImageData();
     portrait = idle.sprites[0].get(0,0,100,100);
     this.width = portrait.width ;
     this.height = portrait.height;
     portrait.resize(portrait.width*idle.spriteScale, portrait.height*idle.spriteScale);
     state = State.IDLE;
  }
  
  void setPosition(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
    idle.posX = posX;
    death.posX = posX;
    walk.posX = posX;
    attack.posX = posX;        
    idle.posY = posY;
    walk.posY = posY;
    death.posY = posY;
    attack.posY = posY;
  }
  
  void setState(State state){
    this.state = state;
  }
  
  void render() {
     
    doAction();
    
     
  
  // 2. Set the stroke thickness
     stroke(0);
     strokeWeight(4);
     fill(0);
     textAlign(CENTER);
     textSize(16);
     text(detail.getName(), posX, posY - this.width);
     healthBar.render(posX, posY - this.width/2);
     
  }
  
  Sprite getAnim(State state){
    switch (state) {
      case IDLE:
        return idle;
      case ATTACK:
        return attack;
      case WALK:
        return walk;
      case DEATH:
        return death;
      default:
        return null;
    }
  }
  
  void doAction() {
    switch (state) {
      case IDLE:
        idle.play();
        break;
      case WALK:
        walk.play();
        if (walk.currentIndex >= walk.totalSize - 1) setIdle();
        break;
      case ATTACK:
        attack.play();
        if (attack.currentIndex >= attack.totalSize - 1) setIdle();
        if (!isOpening) isOpening = true;
        break;
      case DEATH:
        death.play();
        
        if(!setTime) {
          setTime = true;
          lastTime = millis();
        }
        if (death.currentIndex >= death.totalSize - 1) if (millis() > lastTime + 3000 && setTime) {
          setTime = false;
          setIdle();
        }
        break;
    }
  }
  
  void displayPortrait(int posX, int posY) {
    image(portrait, posX, posY + 25);
  }
  
  void select() {
    isSelected = true;
    setAttack();
  }
  
  
  void unselect() {
    isSelected = false;
    isOpening = false;
  }
  
  void setIdle() {
    this.state = State.IDLE;
  }
  
  void setAttack() {
    this.state = State.ATTACK;
  }
  
  void setWalk() {
    this.state = State.WALK;
  }
  
  void setDeath() {
    this.state = State.DEATH;
  }
  
  boolean isSelected() {
    return isSelected;
  }
  
  public String getName() {
    return detail.getName();
  }
  
  public float getAtk() {
    return detail.getAtk();
  }
  
  public float getHealth() {
    return detail.getHealth();
  }
  
  public String getDescription() {
    return detail.getDescription();
  }
  
  public String toString() {
     return "{ Name: " + detail.name + ", ATK:" + detail.atk + ", Health:" + detail.health + "}";
  }
}

class UnitDetail {
  private String name;
  private String description;
  private float health;
  private float atk;
   
  UnitDetail(String name, String description, float health, float atk){
    this.name = name;
    this.description = description;
    this.health = health;
    this.atk = atk;
  }
  
    // Getters
    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public float getHealth() {
        return health;
    }

    public float getAtk() {
        return atk;
    }

    // Setters
    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setHealth(float health) {
        this.health = health;
    }

    public void setAtk(float atk) {
        this.atk = atk;
    }  

}


class HealthBar {
  
  // health bar skin
  String imageFileName;
  PImage healthBarSkin;
  
  // skin image size
  private float skinWidth;
  private float skinHeight;
  
  // health bar scale 
  private float scale = 2;
  
  // health bar size
  private float healthWidth;
  private float healthHeight;
  
  // HealthBar attributes
  private float healthPercent;
  private float maxHealth;
  private float currentHealth;
  
  // constructor - by loadConfig()
  public HealthBar(String configFileName, float maxHealth){
    loadConfig(configFileName);
    skinWidth = healthBarSkin.width;
    skinHeight = healthBarSkin.height;
    
    healthWidth = (skinWidth - 23.5) * scale;
    healthHeight = (skinHeight - 15.5) * scale;
    
    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
    this.healthPercent = (float) currentHealth / maxHealth;
  }
  
  // constructor - by initializing
  public HealthBar(float maxHealth){
    imageFileName = "data/HealthBar/HealthBar.png";
    healthBarSkin = loadImage(imageFileName);
    skinWidth = healthBarSkin.width; 
    skinHeight = healthBarSkin.height;
    
    healthWidth = (skinWidth - 23.5) * scale;
    healthHeight = (skinHeight - 15.5) * scale;
    
    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
    this.healthPercent = (float) currentHealth / maxHealth;
  }
  
  // getters
  public float getMaxHealth(){
    return this.maxHealth;
  }
  
  public float getCurrrentHealth(){
    return this.currentHealth;
  }
  
  // update current health
  public void updateCurrentHealth(float newCurrentHealth){
    if(newCurrentHealth <= maxHealth && newCurrentHealth >= 0){
      this.currentHealth = newCurrentHealth;
      healthPercent = (float) currentHealth / maxHealth; //update healthPercent
    }
    if(healthPercent > 1){
      healthPercent = 1.0;
    }
    else if(healthPercent < 0){
      healthPercent = 0;
    }
  }
  
  // render the health bar
  public void render(int spritePosX, int spritePosY){
    
    // set health bar SKIN position
    int healthBarSkinPosX = spritePosX - 10;
    int healthBarSkinPosY = spritePosY - 35;
    
    // set health bar (RECTANGLE) position
    float healthBarPosX = healthBarSkinPosX - (19 * scale);
    float healthBarPosY = healthBarSkinPosY + (-2 * scale);
    
    //// render health bar 
    rectMode(CORNER);
    noStroke();
    fill(184, 73, 73); // red (same color with hearth on health bar skin)
    rect(healthBarPosX, healthBarPosY, (healthWidth * healthPercent), healthHeight);
    textMode(CENTER);
    textSize(10);
    fill(255);
    text(healthPercent*100 + "%", (healthBarPosX + (healthWidth * healthPercent)/2), (healthBarPosY + (healthHeight + 5)/2));
    // render health bar skin
    imageMode(CENTER);
    image(healthBarSkin, healthBarSkinPosX, healthBarSkinPosY, 
    skinWidth * scale, skinHeight * scale);
  }
  
  public void loadConfig(String configFileName){
    String[] StringLines = loadStrings(configFileName);
    String[] configParams = split(StringLines[0], " ");
    String skinFolder = configParams[0];
    String skinFile = configParams[1];
    this.scale = int(configParams[2]);
    imageFileName = "data/" + skinFolder + "/" + skinFile;
    healthBarSkin = loadImage(imageFileName);
  }
  
  public void setHealthBarScale(float scale){
    this.scale = scale;
    healthWidth = (skinWidth - 23.5) * scale;
    healthHeight = (skinHeight - 15.5) * scale;
  }
}
