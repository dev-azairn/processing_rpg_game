class Unit {
  UnitDetail detail;
  HealthBar healthBar;
  Sprite idle;
  Sprite death;
  Sprite walk;
  Sprite attack;
  
  Unit(JSONObject detail, String idleConfig, String attackConfig, String deathConfig, String walkConfig) {
     this.detail = new UnitDetail(detail.getString("name"), detail.getString("description"), detail.getFloat("health"), detail.getFloat("atk"));  
     idle = new Sprite(idleConfig);
     attack = new Sprite(attackConfig);
     walk = new Sprite(walkConfig);
     death = new Sprite(deathConfig);
  }
  
  void render() {
    
  }
  
    public String toString() {
       return "{ Name: " + detail.name + ", ATK:" + detail.atk + ", Health:" + detail.health + "}";
    }
}
