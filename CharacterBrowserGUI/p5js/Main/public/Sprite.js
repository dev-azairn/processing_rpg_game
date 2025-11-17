class Sprite {
  constructor(config) {
    this.characterFolder = config.characterFolder;
    this.characterAction = config.characterAction;
    this.imageFileName = config.imageFileName;
    this.fileExtension = config.fileExtension;
    this.totalSize = parseInt(config.totalSize);
    this.posX = parseInt(config.posX);
    this.posY = parseInt(config.posY);
    this.spriteScale = parseInt(config.scale);

    this.sprites = [];
    this.currentIndex = 0;
    this.isStop = false;
    this.isFlip = false;
    this.isLoop = true;

    this.animationSpeed = 5;
    this.frameCount = 0;
  }

  // --- IMAGE LOADING ---
  loadImageData(callback) {
    this.sprites = new Array(this.totalSize);
    assetsToLoad += this.totalSize;
    
    for (let i = 0; i < this.totalSize; i++) {
      ((index) => {
        let fileName = this.imageFileName + (index + 1) + this.fileExtension;
        let apiPath = `/assets/${this.characterFolder}/${this.characterAction}/${fileName}`;

        loadImage(
          apiPath,
          (img) => {
            this.sprites[index] = img;
            callback();
          },
          (err) => {
            console.error("Failed to load image:", apiPath, err);
            callback();
          }
        );
      })(i);
    }
  }

  // --- RENDERING ---
  render() {
    if (!this.sprites || this.sprites.length === 0 || !this.sprites[this.currentIndex]) {
      return;
    }

    imageMode(CENTER);
    let w = this.sprites[this.currentIndex].width * this.spriteScale;
    let h = this.sprites[this.currentIndex].height * this.spriteScale;

    if (this.isFlip) {
      push();
      translate(this.posX, this.posY);
      scale(-1, 1);
      image(this.sprites[this.currentIndex], 0, 0, w, h);
      pop();
    } else {
      image(this.sprites[this.currentIndex], this.posX, this.posY, w, h);
    }
  }

  // --- ANIMATION ---
  play() {
    if (!this.isStop) {
      this.frameCount++;
      
      if (this.frameCount >= this.animationSpeed) {
        this.frameCount = 0;
        this.currentIndex++;

        if (this.currentIndex >= this.sprites.length) {
          this.currentIndex = this.isLoop ? 0 : this.sprites.length - 1;
        }
      }
    }
    
    this.render();
  }

  // --- CONTROL ---
  setPlayOnce(isPlayOnce) {
    this.isLoop = !isPlayOnce;
    this.currentIndex = 0;
    this.frameCount = 0;
  }

  stop() { this.isStop = true; }
  resume() { this.isStop = false; }
  flip(isFlipped) { this.isFlip = isFlipped; }
  reset() {
    this.currentIndex = 0;
    this.frameCount = 0;
  }
  setAnimationSpeed(speed) { this.animationSpeed = speed; }
}