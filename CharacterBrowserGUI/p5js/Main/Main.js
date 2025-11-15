let configData;
let sprite;

function preload() {
  // Preload all config files - this runs before setup()
  configData = loadStrings('/data/Archer_Attack.txt');
  
}

function setup() {
  createCanvas(1280, 720);
  if (configData) console.log("Data loaded");
  background(200);
  sprite = new Sprite(configData);
}

function draw() {
  sprite.play();
}
