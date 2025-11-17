// A simple object to replace the Java 'enum'
const State = {
  IDLE: 0,
  WALK: 1,
  ATTACK: 2,
  DEATH: 3
};

class Unit {
  // Constructor
  constructor(config) {
    this.detail = new UnitDetail(
      config.detail.name,
      config.detail.description,
      config.detail.health,
      config.detail.atk,
      config.detail.def
    );
    
    // Create Sprite objects
    this.idle = new Sprite(config.idleConfig);
    this.attack = new Sprite(config.attackConfig);
    this.walk = new Sprite(config.walkConfig);
    this.death = new Sprite(config.deathConfig);

    this.portrait = null;
    this.posX = 0;
    this.posY = 0;
    this.width = 0;
    this.height = 0;
    this.state = State.IDLE;
    
    this.isSelected = false;
    this.isOpening = false;
    this.dialogue = null;
    this.lastTime = millis();
  }

  // MUST BE CALLED FROM p5.js 'preload()'
  preloadAssets() {
    this.idle.loadImageData();
    this.attack.loadImageData();
    this.walk.loadImageData();
    this.death.loadImageData();
    // healthBar.loadSkin() was here
  }

  // MUST BE CALLED FROM p5.js 'setup()'
  initialize() {
    // healthBar.initialize() was here
    
    this.portrait = this.idle.sprites[0].get(0, 0, 100, 100);
    this.width = this.portrait.width;
    this.height = this.portrait.height;
    
    this.portrait.resize(
      this.portrait.width * this.idle.spriteScale,
      this.portrait.height * this.idle.spriteScale
    );
    
    this.setPosition(this.idle.posX, this.idle.posY);
  }

  setPosition(posX, posY) {
    this.posX = posX;
    this.posY = posY;
    this.idle.posX = posX;
    this.death.posX = posX;
    this.walk.posX = posX;
    this.attack.posX = posX;
    this.idle.posY = posY;
    this.walk.posY = posY;
    this.death.posY = posY;
    this.attack.posY = posY;
  }

  setState(state) {
    this.state = state;
    this.getAnim(state).reset();
  }

  render() {
    this.doAction();

    stroke(0);
    strokeWeight(4);
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text(this.detail.getName(), this.posX, this.posY - this.width);
    
    // healthBar.render() was here
  }

  getAnim(state) {
    switch (state) {
      case State.IDLE: return this.idle;
      case State.ATTACK: return this.attack;
      case State.WALK: return this.walk;
      case State.DEATH: return this.death;
      default: return null;
    }
  }

  doAction() {
    switch (this.state) {
      case State.IDLE:
        this.idle.play();
        break;
      case State.WALK:
        this.walk.play();
        if (this.walk.currentIndex >= this.walk.totalSize - 1) {
          this.setIdle();
        }
        break;
      case State.ATTACK:
        this.attack.play();
        if (this.attack.currentIndex >= this.attack.totalSize - 1) {
          this.setIdle();
        }
        if (!this.isOpening) this.isOpening = true;
        break;
      case State.DEATH:
        this.death.setPlayOnce(true);
        this.death.play();
        if (this.death.currentIndex >= this.death.totalSize - 1) {
          if (millis() > this.lastTime + 3000) {
            // Respawn logic or something
            // setIdle();
          }
        }
        break;
    }
  }

  displayPortrait(posX, posY) {
    if (this.portrait) {
      image(this.portrait, posX, posY + 25);
    }
  }

  select() {
    this.isSelected = true;
    this.setAttack();
  }

  unselect() {
    this.isSelected = false;
    this.isOpening = false;
  }

  setIdle() { this.setState(State.IDLE); }
  setAttack() { this.setState(State.ATTACK); }
  setWalk() { this.setState(State.WALK); }
  setDeath() {
    this.setState(State.DEATH);
    this.setLastTime();
  }

  setLastTime() { this.lastTime = millis(); }
  isSelected() { return this.isSelected; }
  getName() { return this.detail.getName(); }
  getAtk() { return this.detail.getAtk(); }
  getHealth() { return this.detail.getHealth(); }
  getDescription() { return this.detail.getDescription(); }

  toString() {
    return `{ Name: ${this.detail.name}, ATK:${this.detail.atk}, Health:${this.detail.health}}`;
  }
}