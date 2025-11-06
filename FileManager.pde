

class FileManager {
  private String baseDir;
  private String contentsDir;
  private String dlcDir;
  private String charactersDir;
  FileManager(String baseDir) {
      this.baseDir = baseDir;
      this.contentsDir = "Contents";
      this.dlcDir = "DLC";
  }
  
  HashMap<String, Unit> loadUnitData(String configFileName) {
    if (!configFileName.endsWith(".json")) return null;
    JSONArray json = loadJSONArray(baseDir + "/" + contentsDir + "/" + charactersDir + "/" + configFileName);
    if (json == null) return null;
    
    HashMap<String, Unit> units = new HashMap<>();  
    for (int i = 0; i < json.size(); i++) {
      JSONObject data = json.getJSONObject(i);
      JSONObject detail = data.getJSONObject("detail");
      units.put(detail.get("name"), new Unit());
    }
    return units;
  }
  
  
  
  // use when needed
}
