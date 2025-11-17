// --- GLOBAL VARIABLES ---
let units = [];
let browser;

let unitsConfigData;
let assetsToLoad = 0;
let assetsLoaded = 0;
let isInitialized = false;

// --- 1. PRELOAD ---
function preload() {
  browser = new CharacterBrowser();
  browser.preload(); 

  loadJSON('/api/units', (data) => {
    unitsConfigData = data;
    console.log("JSON loaded.");
  });
}

// --- 2. SETUP ---
function setup() {
  createCanvas(1280, 720);
  frameRate(60);
  
  // Create units and *start* loading assets
  for (let unitConfig of unitsConfigData) {
    let newUnit = new Unit(unitConfig);
    newUnit.loadAssets(assetLoadCallback); // Pass the global callback
    units.push(newUnit);
  }
}

// --- 3. ASSET CALLBACK ---
function assetLoadCallback() {
  assetsLoaded++;
}

// --- 4. DRAW ---
function draw() {
  
  // --- STATE 1: LOADING ---
  if (assetsLoaded < assetsToLoad) {
    background(0);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text(`Loading Assets... ${assetsLoaded} / ${assetsToLoad}`, width / 2, height / 2);
    return;
  }

  // --- STATE 2: INITIALIZE (THIS IS THE FIX) ---
  // This 'if' check is the most important part.
  // We MUST check 'assetsToLoad > 0' to prevent
  // this from running on the very first frame.
  if (assetsLoaded === assetsToLoad && !isInitialized && assetsToLoad > 0) {
    console.log("All assets loaded. Initializing units...");
    
    // Initialize ALL units (not just selected ones)
    for (let unit of units) {
      unit.initialize(); // <-- Portraits are created here for ALL units
    }
    
    isInitialized = true; // Set the flag
    console.log("Initialization complete. Starting app.");
  }

  // --- STATE 3: RUNNING ---
  if (isInitialized) {
    background(255);
    browser.renderGUI(units);
  }
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
// No use more for too much element,
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