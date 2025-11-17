class HealthBar {
  constructor(maxHealth) {
    this.imageFileName = '/assets/HealthBar/HealthBar.png';
    this.healthBarSkin = null;

    this.skinWidth = 100;
    this.skinHeight = 20;
    this.scale = 2;

    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;

    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
    this.healthPercent = 1.0;
  }

  // --- ASSET LOADING ---
  loadAssets(callback) {
    assetsToLoad++;
    
    loadImage(
      this.imageFileName,
      (img) => {
        this.healthBarSkin = img;
        callback();
      },
      (err) => {
        console.error("Failed to load skin:", this.imageFileName, err);
        callback();
      }
    );
  }

  initialize() {
    this.skinWidth = this.healthBarSkin.width;
    this.skinHeight = this.healthBarSkin.height;

    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;
  }

  // --- RENDERING ---
  render(spritePosX, spritePosY) {
    if (!this.healthBarSkin) {
      console.warn("HealthBar skin not loaded!");
      return;
    }

    let healthBarSkinPosX = spritePosX - 10;
    let healthBarSkinPosY = spritePosY - 35;
    let healthBarPosX = healthBarSkinPosX - (19 * this.scale);
    let healthBarPosY = healthBarSkinPosY + (-2 * this.scale);

    rectMode(CORNER);
    noStroke();
    fill(184, 73, 73);
    rect(healthBarPosX, healthBarPosY, (this.healthWidth * this.healthPercent), this.healthHeight);

    imageMode(CENTER);
    image(this.healthBarSkin, healthBarSkinPosX, healthBarSkinPosY,
      this.skinWidth * this.scale, this.skinHeight * this.scale);
  }

  // --- HEALTH UPDATE ---
  updateCurrentHealth(newCurrentHealth) {
    this.currentHealth = constrain(newCurrentHealth, 0, this.maxHealth);
    this.healthPercent = this.currentHealth / this.maxHealth;
  }

  // --- GETTERS & SETTERS ---
  getMaxHealth() { return this.maxHealth; }
  getCurrentHealth() { return this.currentHealth; }
  setHealthBarScale(scale) {
    this.scale = scale;
    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;
  }
}