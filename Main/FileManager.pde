

class FileManager {
  private String baseDir;
  private String contentsDir;
  private String dlcDir;
  private boolean containDLC;
  FileManager(String baseDir) {
      this.baseDir = baseDir;
      this.contentsDir = "Contents";
      this.dlcDir = "DLC";
  }
  
  
  
  HashMap<String, Unit> loadUnitData(String charactersDir, String configFileName) {
    if (!configFileName.endsWith(".json")) return null;
    JSONArray characterJson = loadJSONArray(baseDir + "/" + contentsDir + "/" + charactersDir + "/" + configFileName);
    
    if (characterJson == null) return null;
    
    HashMap<String, Unit> units = new HashMap<>();  
    for (int i = 0; i < characterJson.size(); i++) {
      JSONObject data = characterJson.getJSONObject(i);
      JSONObject detail = data.getJSONObject("detail");
      units.put(detail.getString("name"), 
        new Unit(detail, data.getString("idleConfig"), 
        data.getString("attackConfig"), 
        data.getString("walkConfig"), 
        data.getString("deathConfig")));
    }
    
    return units;
  }
  
  
}
