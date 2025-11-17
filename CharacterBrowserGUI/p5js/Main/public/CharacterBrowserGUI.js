// --- Global Variables ---
let units = []; // Replaces HashMap<String, Unit>
let browser; // Replaces CharacterBrowser

let oldUnit1 = null;
let oldUnit2 = null;

const aspectRatio = 16.0 / 9.0;

// --- 1. PRELOAD (Handles all loading) ---
function preload() {
  // Create the browser object so its preload method can be called
  browser = new CharacterBrowser();
  
  // Call the browser's own preload method
  browser.preload();

  // Load the unit data using the callback pattern
  loadJSON('/api/units', dataLoaded);
}

// --- 2. DATA LOADED (Callback from preload) ---
// This runs after loadJSON finishes, but *before* setup()
function dataLoaded(data) {
  console.log("JSON loaded:", data);
  
  // Loop through the unit configs from the server
  for (let unitConfig of data) {
    let newUnit = new Unit(unitConfig);
    
    // Tell the unit to load its own images
    // p5.js's preload will wait for these too
    newUnit.preloadAssets();
    
    units.push(newUnit);
  }
}

// --- 3. SETUP (Runs once after preload) ---
function setup() {
  pixelDensity(1);
  createCanvas(1280, 720);
  frameRate(60);

  // Initialize all units (which are now fully loaded)
  for (let unit of units) {
    unit.initialize();
  }
  
  // Disable the right-click context menu
  document.oncontextmenu = () => false;
}

// --- 4. DRAW (Runs 24 times per second) ---
function draw() {
  background(255);
  
  // Render the character browser GUI
  // We pass 'units' so it can access the list
  browser.renderGUI(units);
}

// --- 5. GLOBAL INPUT HANDLERS ---
function mousePressed() {
  // Pass the event to the browser's handler
  browser.handleMousePressed(units);
}

function mouseWheel(event) {
  // Pass the event to the browser's handler
  browser.handleMouseWheel(event, units);
}

// --- 6. CUSTOM GRADIENT FUNCTION ---
// The p5.js port of your rectGradient function
// No use more for too much element, causing low fps
function rectGradient(x, y, w, h, c1, c2, radianAngle, 
  strokeWidth, strokeColor, borderRadius, rectModeVal = CORNER) {

  // Create an image to hold the gradient
  let gradientImage = createImage(w, h);
  gradientImage.loadPixels();

  // Calculate the gradient direction
  let dx = cos(radianAngle);
  let dy = sin(radianAngle);
  let centerX = w / 2.0;
  let centerY = h / 2.0;
  let maxDist = (abs(w * dx) + abs(h * dy)) / 2.0;

  // Fill the pixels of the image with the gradient
  for (let i = 0; i < h; i++) {
    for (let j = 0; j < w; j++) {
      let index = (i * w + j) * 4;
      let relX = j - centerX;
      let relY = i - centerY;
      let projection = relX * dx + relY * dy;
      let amount = map(projection, -maxDist, maxDist, 0, 1);
      
      let c = lerpColor(c1, c2, amount);
      
      gradientImage.pixels[index] = red(c);
      gradientImage.pixels[index + 1] = green(c);
      gradientImage.pixels[index + 2] = blue(c);
      gradientImage.pixels[index + 3] = alpha(c);
    }
  }
  gradientImage.updatePixels();

  // Create a mask (a PGraphics object)
  let pg = createGraphics(w, h);
  pg.background(0); // Mask is black (transparent)
  pg.fill(255);     // Shape is white (opaque)
  pg.noStroke();
  pg.rect(0, 0, w, h, borderRadius);

  // Apply the mask to the gradient image
  gradientImage.mask(pg);

  // Draw the final masked image
  imageMode(rectModeVal);
  image(gradientImage, x, y);

  // Draw the border on top
  noFill();
  strokeWeight(strokeWidth);
  stroke(strokeColor);
  rectMode(rectModeVal);
  rect(x, y, w, h, borderRadius);
}