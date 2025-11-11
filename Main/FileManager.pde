import java.io.File;

class FileManager {
  private String baseDir;
   
  boolean containsDLC;
  
  FileManager(String baseDir) {
      this.baseDir = baseDir;
  }
  
   void loadData() {
    
    //String configFileName = (configDirPath.equals(""))? "config" : connectedPath(configDirPath, "config");
    //println("Path: " + configFileName);
    //String fileName;
    //String[] splittedLine;
    //if (isExist(configFileName + ".ini")) {
    //    println("Hello");
    //    fileName = sketchPath(configFileName) + ".ini";
    //    String[] lines = loadStrings(fileName);
    //    // Optimization Configuration
    //    if ((splittedLine = lines[0].split("=")).length > 1) {
    //      configuration(configDirPath, lines);
    //    }
        
    //    // Data Config
    //    else if ((splittedLine = lines[0].split(" ")).length > 1) {
    //      if (splittedLine[0].equals("Podium")) 
    //      {
            
    //      }
    //    }
    //    else for (String line: lines) loadData(connectedPath(configDirPath, line));
    //} else if(isExist(configFileName + ".json")) {
    //    fileName = configFileName + ".json";
    //    if(fileName.contains("Characters")) loadUnit(configDirPath, fileName);
    //} else {
    //  println("No config file");
    //}
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
        unit.setPosition(175*i + 100, height - 100);
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
  
  
  //private void configuration(String configDirPath,String[] lines) {
  //  for (String line: lines) {
  //       String[] splittedLine = line.split("=");
  //       loadData(connectedPath(configDirPath, splittedLine[1]));
  //  }
  //}
}
