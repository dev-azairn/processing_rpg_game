class UnitDetail {
  constructor(name, description, health, atk, def) {
    this.name = name;
    this.description = description;
    this.health = health;
    this.atk = atk;
    this.def = def;
  }

  // Getters
  getName() { return this.name; }
  getDescription() { return this.description; }
  getHealth() { return this.health; }
  getAtk() { return this.atk; }
  getDef() { return this.def; }

  // Setters
  setName(name) { this.name = name; }
  setDescription(description) { this.description = description; }
  setHealth(health) { this.health = health; }
  setAtk(atk) { this.atk = atk; }
  setDef(def) { this.def = def; }
}