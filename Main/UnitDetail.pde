class UnitDetail {

String name;
  String description;
  float health;
  float atk;
   
  UnitDetail(String name, String description, float health, float atk){
    this.name = name;
    this.description = description;
    this.health = health;
    this.atk = atk;
  }
  
  // Getters
  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  float getHealth() {
    return health;
  }

  float getAtk() {
    return atk;
  }

  // Setters
  void setName(String name) {
    this.name = name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setHealth(float health) {
    this.health = health;
  }

  void setAtk(float atk) {
    this.atk = atk;
  }  
}
