class Unit {
  UnitDetail detail;
  HealthBar healthBar;
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
  
  
  Unit(JSONObject detail, String idleConfig, String attackConfig, String deathConfig, String walkConfig, String healthBarConfig) {
     this.detail = new UnitDetail(detail.getString("name"), detail.getString("description"), detail.getFloat("health"), detail.getFloat("atk"));  
     this.idle = new Sprite(idleConfig);
     this.attack = new Sprite(attackConfig);
     this.walk = new Sprite(walkConfig);
     this.death = new Sprite(deathConfig);
     this.healthBar = new HealthBar(detail.getFloat("health"));
     idle.loadImageData();
     attack.loadImageData();
     walk.loadImageData();
     death.loadImageData();
     portrait = idle.sprites[0].get(0,0,100,100);
     this.width = portrait.width ;
     this.height = portrait.height;
     portrait.resize(portrait.width*idle.spriteScale, portrait.height*idle.spriteScale);
     
  }
  
  void setPosition(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
    idle.posX = posX;
    death.posX = posX;
    walk.posX = posX;
    attack.posX = posX;        
    idle.posY = posY + 25;
    walk.posY = posY + 25;
    death.posY = posY + 25;
    attack.posY = posY + 25;
  }
  
  
  void render() {
    
    healthBar.render(posX, posY - this.width/2);
    if (isSelected && !isOpening){
      attack.play();
      if (attack.currentIndex == attack.totalSize - 1) {
        isOpening = true;
      }
      return;
     } 
     
     idle.play();
  }
  
  void displayPortrait(int posX, int posY) {
    image(portrait, posX, posY);
  }
  
  void select() {
    isSelected = true;
  }
  
  
  void unselect() {
    isSelected = false;
    isOpening = false;
  }
  
  boolean isSelected() {
    return isSelected;
  }
  
  
  public String toString() {
     return "{ Name: " + detail.name + ", ATK:" + detail.atk + ", Health:" + detail.health + "}";
  }
}
