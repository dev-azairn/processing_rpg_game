class HealthBar {
  // Java constructor with config file is removed.
  // We use a simpler constructor and a hardcoded path.
  constructor(maxHealth) {
    this.imageFileName = '/assets/HealthBar/HealthBar/HealthBar.png'; // Using your API path
    this.healthBarSkin = null; // Will be loaded in preload

    this.skinWidth = 100; // Default values before image loads
    this.skinHeight = 20;
    this.scale = 2; // Default scale

    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;

    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
    this.healthPercent = 1.0;
  }

  // MUST BE CALLED FROM p5.js 'preload()'
  loadSkin() {
    this.healthBarSkin = loadImage(this.imageFileName);
  }

  // Call this from p5.js 'setup()' AFTER preload
  initialize() {
    // Now that the image is loaded, get its real size
    this.skinWidth = this.healthBarSkin.width;
    this.skinHeight = this.healthBarSkin.height;

    // Recalculate health bar size
    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;
  }

  // Getters
  getMaxHealth() { return this.maxHealth; }
  getCurrrentHealth() { return this.currentHealth; }

  // Update current health
  updateCurrentHealth(newCurrentHealth) {
    if (newCurrentHealth <= this.maxHealth && newCurrentHealth >= 0) {
      this.currentHealth = newCurrentHealth;
      this.healthPercent = this.currentHealth / this.maxHealth;
    }
    if (this.healthPercent > 1) {
      this.healthPercent = 1.0;
    } else if (this.healthPercent < 0) {
      this.healthPercent = 0;
    }
  }

  // Render the health bar
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
    fill(184, 73, 73); // Red
    rect(healthBarPosX, healthBarPosY, (this.healthWidth * this.healthPercent), this.healthHeight);

    // Render health bar skin
    imageMode(CENTER);
    image(this.healthBarSkin, healthBarSkinPosX, healthBarSkinPosY,
      this.skinWidth * this.scale, this.skinHeight * this.scale);
  }

  setHealthBarScale(scale) {
    this.scale = scale;
    this.healthWidth = (this.skinWidth - 23.5) * this.scale;
    this.healthHeight = (this.skinHeight - 15.5) * this.scale;
  }
}