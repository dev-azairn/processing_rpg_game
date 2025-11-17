class Sprite {

  // constructor takes a config object (like your example)
  constructor(config) {
    // --- Configs from object ---
    this.characterFolder = config.characterFolder;
    this.characterAction = config.characterAction;
    this.imageFileName = config.imageFileName;
    this.fileExtension = config.fileExtension;
    this.totalSize = parseInt(config.totalSize);
    this.posX = parseInt(config.posX);
    this.posY = parseInt(config.posY);
    this.spriteScale = parseInt(config.scale); // Note: 'scale' from config

    // --- Runtime state ---
    this.sprites = []; // Array to hold PImage objects
    this.currentIndex = 0;
    this.isStop = false;
    this.isFlip = false;
    this.isLoop = true;

    // --- p5.js specific animation handling ---
    // Number of draw() calls before advancing a frame
    this.animationSpeed = 5; 
    this.frameCount = 0; // Local counter
  }

  // --- Image Loading ---
  // MUST BE CALLED FROM p5.js 'preload()' FUNCTION
  loadImageData() {
    this.sprites = new Array(this.totalSize);
    
    for (let i = 0; i < this.totalSize; i++) {
      // Create the filename (e.g., "Wizard_Death_1.png")
      let fileName = this.imageFileName + (i + 1) + this.fileExtension;
      
      // Create the API path
      let apiPath = `/assets/${this.characterFolder}/${this.characterAction}/${fileName}`;
      
      // Load the image using p5.js loadImage
      this.sprites[i] = loadImage(apiPath);
    }
  }

  // --- Rendering (Drawing) ---
  render() {
    // Wait until sprites are loaded
    if (!this.sprites || this.sprites.length === 0 || !this.sprites[this.currentIndex]) {
      // console.warn("Sprite images not loaded yet for", this.characterAction);
      return;
    }

    imageMode(CENTER);

    let w = this.sprites[this.currentIndex].width * this.spriteScale;
    let h = this.sprites[this.currentIndex].height * this.spriteScale;

    if (this.isFlip) {
      push();
      translate(this.posX, this.posY);
      scale(-1, 1); // Flip horizontally
      image(this.sprites[this.currentIndex], 0, 0, w, h);
      pop();
    } else {
      image(this.sprites[this.currentIndex], this.posX, this.posY, w, h);
    }
  }

  // --- Animation (Updating & Rendering) ---
  // Call this in your main draw() loop
  play() {
    // 1. Update Logic (handles frame advancement)
    if (!this.isStop) {
      this.frameCount++;
      
      // Check if it's time to advance to the next frame
      if (this.frameCount >= this.animationSpeed) {
        this.frameCount = 0; // Reset counter
        this.currentIndex++; // Advance frame

        if (this.currentIndex >= this.sprites.length) {
          if (this.isLoop) {
            this.currentIndex = 0; // Loop back to start
          } else {
            this.currentIndex = this.sprites.length - 1; // Stay on last frame
          }
        }
      }
    }
    
    // 2. Render Logic (always draw the current frame)
    this.render();
  }

  // --- Control Methods ---
  setPlayOnce(isPlayOnce) {
    if (isPlayOnce) {
      this.isLoop = false;
      this.currentIndex = 0;
      this.frameCount = 0;
    } else {
      this.isLoop = true;
      this.currentIndex = 0;
      this.frameCount = 0;
    }
  }
  
  // Helper functions
  stop() { this.isStop = true; }
  resume() { this.isStop = false; }
  flip(isFlipped) { this.isFlip = isFlipped; }
  reset() { 
    this.currentIndex = 0;
    this.frameCount = 0;
  }
  setAnimationSpeed(speed) { this.animationSpeed = speed; }
}