class UnitDetail {
  private String name;
  private String description;
  private Float health;
  private Float atk;
   
  public UnitDetail(String name, String description, Float health, Float atk){
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
