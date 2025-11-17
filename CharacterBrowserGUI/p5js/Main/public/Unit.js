const State = {
  IDLE: 0,
  WALK: 1,
  ATTACK: 2,
  DEATH: 3
};

class Unit {
  constructor(config) {
    this.detail = new UnitDetail(
      config.detail.name,
      config.detail.description,
      config.detail.health,
      config.detail.atk,
      config.detail.def
    );
    
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

    this.healthBar = new HealthBar(this.getHealth());
  }

  // --- ASSET LOADING ---
  loadAssets(callback) {
    this.idle.loadImageData(callback);
    this.attack.loadImageData(callback);
    this.walk.loadImageData(callback);
    this.death.loadImageData(callback);
    this.healthBar.loadAssets(callback);
  }

  initialize() {
    if (this.healthBar) {
      this.healthBar.initialize();
    }

    if (this.idle.sprites && this.idle.sprites[0] && this.idle.sprites[0].width > 0) {
      let originalSprite = this.idle.sprites[0];
      originalSprite.loadPixels();
      
      this.portrait = originalSprite.get(0, 0, 100, 100);
      this.width = this.portrait.width;
      this.height = this.portrait.height;
      
      this.portrait.resize(
        this.width * this.idle.spriteScale,
        this.height * this.idle.spriteScale
      );
    } else {
      console.error("Unit has no valid idle sprite:", this.detail.getName());
      this.portrait = null;
    }
    
    this.setPosition(this.idle.posX, this.idle.posY);
  }

  // --- RENDERING ---
  displayPortrait(posX, posY) {
    if (this.portrait != null) {
      imageMode(CENTER);
      image(this.portrait, posX, posY + 25);
    }
  }

  render() {
    this.doAction();

    stroke(0);
    strokeWeight(1);
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text(this.detail.getName(), this.posX, this.posY - this.width);
    
    this.healthBar.render(this.posX, this.posY - this.width + 50);
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
        this.death.play();
        if (this.death.currentIndex >= this.death.totalSize - 1) {
          if (millis() > this.lastTime + 3000) {
            this.setIdle();
          }
        }
        break;
    }
  }

  // --- STATE MANAGEMENT ---
  setState(state) {
    this.state = state;
    this.getAnim(state).reset();
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

  setIdle() { this.setState(State.IDLE); }
  setAttack() { this.setState(State.ATTACK); }
  setWalk() { this.setState(State.WALK); }
  setDeath() {
    this.setState(State.DEATH);
    this.setLastTime();
  }

  // --- POSITIONING ---
  setPosition(posX, posY) {
    this.posX = posX;
    this.posY = posY;
    this.idle.posX = posX;
    this.attack.posX = posX;
    this.walk.posX = posX;
    this.death.posX = posX;
    this.idle.posY = posY;
    this.attack.posY = posY;
    this.walk.posY = posY;
    this.death.posY = posY;
  }

  // --- SELECTION ---
  select() {
    this.isSelected = true;
    this.setAttack();
  }

  unselect() {
    this.isSelected = false;
    this.isOpening = false;
  }

  // --- GETTERS ---
  setLastTime() { this.lastTime = millis(); }
  isSelected() { return this.isSelected; }
  getName() { return this.detail.getName(); }
  getAtk() { return this.detail.getAtk(); }
  getHealth() { return this.detail.getHealth(); }
  getDescription() { return this.detail.getDescription(); }

  toString() {
    return `{ Name: ${this.detail.name}, ATK: ${this.detail.atk}, Health: ${this.detail.health} }`;
  }
}