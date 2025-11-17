// Example config (you would load this from '/api/units')

let myLancer;

function preload() {
  // 1. Create the unit object from the config
  myLancer = new Unit(lancerConfig);
  
  // 2. Call the new preload method
  myLancer.preloadAssets();
}

function setup() {
  createCanvas(600, 400);
  
  // 3. Call the new initialize method
  myLancer.initialize();
  
  // Now you can set its position etc.
  myLancer.setPosition(width / 2, height / 2);
}

function draw() {
  background(220);
  
  // 4. Just call render!
  myLancer.render();
}

// Example: Change state
function keyPressed() {
  if (key === 'a') {
    myLancer.setAttack();
  } else if (key === 'w') {
    myLancer.setWalk();
  } else if (key === 'd') {
    myLancer.setDeath();
  } else if (key === 'i') {
    myLancer.setIdle();
  }
}