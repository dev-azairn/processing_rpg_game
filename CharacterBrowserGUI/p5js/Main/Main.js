let configData;

function preload() {
  // Preload all config files - this runs before setup()
  configData = loadStrings('YourConfigFile.txt');
}

function setup() {
  spriteName = new Sprite(configData);
}

function draw() {

}
