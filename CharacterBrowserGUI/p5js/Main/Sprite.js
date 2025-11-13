class Sprite {
  // Constructor using loadConfig
  constructor(configData) {
    // configs
    this.characterFolder = '';
    this.characterAction = '';
    this.imageFileName = '';
    this.fileExtension = '';
    this.totalSize = 0;
    this.currentIndex = 0;
    this.spriteScale = 0;
    
    // runtime
    this.sprites = [];
    this.isStop = false;
    this.isFlip = false;
    this.isLoop = true;
    
    // position
    this.posX = 0;
    this.posY = 0;
    
    this.loadConfig(configData);
    this.currentIndex = 0;
    this.isStop = false;
    this.isFlip = false;
    this.isLoop = true;
  }
  
  loadImageData() {
    // get the filepaths
    let fileNames = new Array(this.totalSize);
    let path = this.characterFolder + "/" + this.characterAction + "/";
    
    // set array of img size
    this.sprites = new Array(this.totalSize);
    for (let index = 0; index < this.totalSize; index++) {
      fileNames[index] = this.imageFileName + (index + 1) + this.fileExtension;
      this.sprites[index] = loadImage("data/" + path + fileNames[index]);
    }
  }
  
  loadConfig(configData) {
    let configParams = configData[0].split(' ');
    for (let i = 0; i < configParams.length; i++) {
      console.log("[" + i + "] " + configParams[i]);
    }
    

    this.characterFolder = configParams[0];
    this.characterAction = configParams[1];
    this.imageFileName = configParams[2];
    this.fileExtension = configParams[3];
    this.totalSize = int(configParams[4]);
    this.posX = int(configParams[5]);
    this.posY = int(configParams[6]);
    this.spriteScale = int(configParams[7]);
  }
  
  render() {
    imageMode(CENTER);
    if (this.isFlip) {
      pushMatrix();
      translate(this.posX, this.posY);
      scale(-1, 1);
      image(this.sprites[this.currentIndex], 0, 0,
        this.sprites[this.currentIndex].width * this.spriteScale,
        this.sprites[this.currentIndex].height * this.spriteScale);
      popMatrix();
    } else {
      image(this.sprites[this.currentIndex], this.posX, this.posY,
        this.sprites[this.currentIndex].width * this.spriteScale,
        this.sprites[this.currentIndex].height * this.spriteScale);
    }
  }
  
  renderNext() {
    if (this.isStop === false) {
      this.currentIndex++;
      if (this.currentIndex >= this.sprites.length) {
        this.currentIndex = 0;
      }
    }
    this.render();
  }
  
  play() {
    if (this.isLoop) {
      this.renderNext();
    } else {
      if (this.currentIndex === this.sprites.length - 1) {
        this.render();
      } else {
        this.renderNext();
      }
    }
  }
}
