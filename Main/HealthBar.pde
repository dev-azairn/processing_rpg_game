class HealthBar {
  
  // health bar skin
  String imageFileName;
  PImage healthBarSkin;
  
  // skin image size
  private float skinWidth;
  private float skinHeight;
  
  // health bar scale (default = 1)
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
    healthBarSkin = loadImage(imageFileName);
    skinWidth = healthBarSkin.width;
    skinHeight = healthBarSkin.height;
    
    healthWidth = (skinWidth - 20) * scale;
    healthHeight = (skinHeight - 22) * scale;
    
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
    
    healthWidth = (skinWidth - 20) * scale;
    healthHeight = (skinHeight - 22) * scale;
    
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
    // render health bar skin
    imageMode(CENTER);
    image(healthBarSkin, healthBarSkinPosX, healthBarSkinPosY, 
    skinWidth * scale, skinHeight * scale);
    
    // set health bar (RECTANGLE) position
    float healthBarPosX = healthBarSkinPosX - (19 * scale);
    float healthBarPosY = healthBarSkinPosY + (1 * scale);
    // render health bar
    rectMode(CORNER);
    fill(255, 0, 0); // red
    rect(healthBarPosX, healthBarPosY, (healthWidth * healthPercent), healthHeight);
  }
  
  public void loadConfig(String configFileName){
    String[] StringLines = loadStrings(configFileName);
    String[] configParams = split(StringLines[0], " ");
    imageFileName = configParams[0];
  }
  
  public void setHealthBarScale(float scale){
    this.scale = scale;
  }
}
