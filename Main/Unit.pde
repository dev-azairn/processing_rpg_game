class Unit {
  UnitDetail detail;
  HealthBar healthBar;
  Sprite idle;
  Sprite death;
  Sprite walk;
  Sprite attack;
  
  int posX;
  int posY;
  
  Unit(JSONObject detail, String idleConfig, String attackConfig, String deathConfig, String walkConfig, String healthBarConfig) {
     this.detail = new UnitDetail(detail.getString("name"), detail.getString("description"), detail.getFloat("health"), detail.getFloat("atk"));  
     this.idle = new Sprite(idleConfig);
     this.attack = new Sprite(attackConfig);
     this.walk = new Sprite(walkConfig);
     this.death = new Sprite(deathConfig);
     this.healthBar = new HealthBar(detail.getInt("health"));
     idle.loadImageData();
     attack.loadImageData();
     walk.loadImageData();
     death.loadImageData();
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
      idle.play();
  }
  
    public String toString() {
       return "{ Name: " + detail.name + ", ATK:" + detail.atk + ", Health:" + detail.health + "}";
    }
}
