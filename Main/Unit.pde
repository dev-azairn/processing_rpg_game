class Unit {
  UnitDetail detail;
  HealthBar healthBar;
  Sprite idle;
  Sprite death;
  Sprite walk;
  Sprite attack;
  
  int xpos;
  int ypos;
  
  Unit(JSONObject detail, String idleConfig, String attackConfig, String deathConfig, String walkConfig) {
     this.detail = new UnitDetail(detail.getString("name"), detail.getString("description"), detail.getFloat("health"), detail.getFloat("atk"));  
     idle = new Sprite(idleConfig);
     attack = new Sprite(attackConfig);
     walk = new Sprite(walkConfig);
     death = new Sprite(deathConfig);
     idle.loadImageData();
     attack.loadImageData();
     walk.loadImageData();
     death.loadImageData();
  }
  
  void render() {
      idle.play();
  }
  
    public String toString() {
       return "{ Name: " + detail.name + ", ATK:" + detail.atk + ", Health:" + detail.health + "}";
    }
}
