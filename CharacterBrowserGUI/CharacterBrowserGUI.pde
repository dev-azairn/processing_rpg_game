// Main GUI
import java.io.File;

// Universal Constant
FileManager manager;
HashMap<String, Unit> units;
HashMap<String, PImage> staticElements;
CharacterBrowser characterBrowser;

float aspectRatio = 16.0 / 9.0; // Example: 16:9 aspect ratio


void setup() {
  pixelDensity(1);
  
  size(1280, 720);
  windowResizable(true);
  frameRate(24);
  manager = new FileManager("");
  manager.loadData();
  characterBrowser = new CharacterBrowser(units);
}

void draw() {
  background(255);
  
  characterBrowser.renderGUI();
}


void mousePressed() {
  characterBrowser.mousePressed();
}

void windowResized() {
  if(width < 1280) {
    windowResize(800, height);
  } 
  if (height < 720) {
    windowResize(width, 450);
  }
}

void rectGradient(int x, int y, int w, int h, color c1, color c2, float radianAngle, 
int strokeWidth,
color strokeColor,
int borderRadius,
int rectMode) {
  
  PImage image = createImage(w, h, ARGB);
  PGraphics pg = createGraphics(w, h);

  image.loadPixels();

  float dx = cos(radianAngle);
  float dy = sin(radianAngle);

  float centerX = w / 2.0;
  float centerY = h / 2.0;

  float maxDist = (abs(w * dx) + abs(h * dy)) / 2.0;

  for (int i = 0; i < h; i++) {
    for (int j = 0; j < w; j++) {

      int index = i * w + j;

      float relX = j - centerX;
      float relY = i - centerY;
      
      float projection = relX * dx + relY * dy;

      float amount = map(projection, -maxDist, maxDist, 0, 1);

      color c = lerpColor(c1, c2, amount);
      
      image.pixels[index] = c;
    }
  }

  image.updatePixels();

  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.noStroke();
  pg.rect(0, 0, w, h, borderRadius);
  pg.endDraw();
  imageMode(rectMode);
  image.mask(pg);
  
  rectMode(rectMode);
  image(image, x, y);
  noFill();
  strokeWeight(strokeWidth);
  stroke(strokeColor);
  rect(x, y, w, h, borderRadius);
  
}


class FileManager {
  private String baseDir;
   
  boolean containsDLC;
  
  FileManager(String baseDir) {
      this.baseDir = baseDir;
  }
  
   void loadData() {
    
    if (!isExist("config.ini")) {
      println("No configuration file!!!");
      return;
    }
    
    String[] configLines = loadStrings("config.ini");
    HashMap<String, String> config = new HashMap<>();
    for(String line: configLines)
    {
      String[] splitted = line.split("=");
      config.put(splitted[0], splitted[1]);
    }
    
    String dataDir = config.get("data");
    JSONObject dataConfig = loadJSONObject(connectedPath(dataDir, "config.json"));
    if (dataConfig != null) {
      // Load unit by units
      loadUnit(dataConfig.getJSONArray("units"), dataDir);
      // Load elements from registered directory
      
    }
    
    // loadDLC
    if(Boolean.parseBoolean(config.get("isDLC")))
    {
      
    }
    
 }
  
  private void loadUnit(JSONArray characterJson, String configDir){
    
      if (characterJson == null) {
        println("Cannot initialize json object");
        return;
      }
      units = new HashMap<>();  
      for (int i = 0; i < characterJson.size(); i++) {
        JSONObject data = characterJson.getJSONObject(i);
        JSONObject detail = data.getJSONObject("detail");
        Unit unit = new Unit(detail, 
          connectedPath(configDir, data.getString("idleConfig")), 
          connectedPath(configDir, data.getString("attackConfig")), 
          connectedPath(configDir, data.getString("walkConfig")), 
          connectedPath(configDir, data.getString("deathConfig")),
          connectedPath(configDir + "/HealthBar", "config.ini"));
        units.put(detail.getString("name"), unit);
        
        // Test
        println(units.get(detail.get("name")));
      }
  }
  
  private void loadElements(JSONArray elements, String configDir, String element) {
    
  }
  
  boolean isExist(String filePath) {
    println(filePath);
    return new File(sketchPath(filePath)).exists();
  }
  
  private String connectedPath(String baseDir, String filePath) {
    return baseDir + "/" + filePath;     
  }
  
  
}
