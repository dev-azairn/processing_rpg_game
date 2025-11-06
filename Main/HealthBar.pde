class HealthBar {
  // health bar skin
  PImage healthBarSkin = loadImage("Contents/HealthBar.png");
  
  // skin image size
  private int skinWidth = 70;
  private int skinHeight = 20;
  
  //health bar scale (default = 1)
  private float scale = 1;
  
  // health bar size
  private float healthWidth = (skinWidth - 28) * scale;
  private float healthHeight = (skinHeight - 16) * scale;
  
  // HealthBar attributes
  private float healthPercent;
  private int maxHealth;
  private int currentHealth;
  
  // constructor - by initializing
  public HealthBar(int maxHealth){
    this.maxHealth = 100;
    this.currentHealth = maxHealth;
    this.healthPercent = (float) currentHealth / maxHealth;
  }
  
  // getters
  public int getMaxHealth(){
    return this.maxHealth;
  }
  
  public int getCurrrentHealth(){
    return this.currentHealth;
  }
  
  // update current health
  public void updateCurrentHealth(int newCurrentHealth){
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
    // render health bar skin
    imageMode(CENTER);
    image(healthBarSkin, healthBarSkinPosX, healthBarSkinPosY, 
    skinWidth * scale, skinHeight * scale);
    
    //set health bar (RECTANGLE) position
    int healthBarPosX = healthBarSkinPosX - 18;
    int healthBarPosY = healthBarSkinPosY + 1;
    //render health bar
    rectMode(CORNER);
    fill(255, 0, 0); // red
    rect(healthBarPosX, healthBarPosY, healthWidth * healthPercent, healthHeight);
  }
}
