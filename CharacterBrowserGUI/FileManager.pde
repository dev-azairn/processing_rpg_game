class FileManager {
  private String baseDir;
   
  boolean containsDLC;
  
  FileManager(String baseDir) {
      this.baseDir = baseDir;
  }
  
void loadData() {    
    String dataDir = "data";
    JSONObject unitConfig = loadJSONObject(connectedPath(dataDir, "config.json"));    
    JSONArray unitsArray = null;
    if (unitConfig != null) {
      unitsArray = unitConfig.getJSONArray("units");
    } else {
      println("ERROR: Could not load main unit config file 'data/config.json'");
    }
    loadUnit(unitsArray, dataDir);
    if(isExist("DLC/config.json"))
    {
      println("Starting DLC implementation");
    }
    
 }
  
  private void loadUnit(JSONArray characterJson, String configDir){    
    units = new HashMap<>();    
      if (characterJson == null) {
        println("Cannot initialize json object");
        return;
      }
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
