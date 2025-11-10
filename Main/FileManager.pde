import java.io.File;

class FileManager {
  private String baseDir;
   
  boolean containsDLC;
  
  FileManager(String baseDir) {
      this.baseDir = baseDir;
  }
  
   void loadData(String configDirPath) {
    
    String configFileName = (configDirPath.equals(""))? "config" : connectedPath(configDirPath, "config");
    println("Path: " + configFileName);
    String fileName;
    String[] splittedLine;
    if (isExist(configFileName + ".ini")) {
        println("Hello");
        fileName = sketchPath(configFileName) + ".ini";
        String[] lines = loadStrings(fileName);
        // Optimization Configuration
        if ((splittedLine = lines[0].split("=")).length > 1) {
          configuration(configDirPath, lines);
        }
        
        // Data Config
        else if ((splittedLine = lines[0].split(" ")).length > 1) {
          if (splittedLine[0].equals("Podium")) 
          {
            
          }
        }
        else for (String line: lines) loadData(connectedPath(configDirPath, line));
    } else if(isExist(configFileName + ".json")) {
        fileName = configFileName + ".json";
        if(fileName.contains("Characters")) loadUnit(configDirPath, fileName);
    } else {
      println("No config file");
    }
  }
  
  private void loadUnit(String configDirPath, String configPath){
    
    JSONArray characterJson = loadJSONArray(configPath);
      if (characterJson == null) {
        println("Cannot initialize json object");
        return;
      }
      units = new HashMap<>();  
      for (int i = 0; i < characterJson.size(); i++) {
        JSONObject data = characterJson.getJSONObject(i);
        JSONObject detail = data.getJSONObject("detail");
        units.put(detail.getString("name"), 
          new Unit(detail, 
          connectedPath(configDirPath, data.getString("idleConfig")), 
          connectedPath(configDirPath, data.getString("attackConfig")), 
          connectedPath(configDirPath, data.getString("walkConfig")), 
          connectedPath(configDirPath, data.getString("deathConfig"))));
        // Test
        println(units.get(detail.get("name")));
      }
  }
  
  boolean isExist(String filePath) {
    println(filePath);
    return new File(sketchPath(filePath)).exists();
  }
  
  private String connectedPath(String baseDir, String filePath) {
    return baseDir + "/" + filePath;     
  }
  
  
  private void configuration(String configDirPath,String[] lines) {
    for (String line: lines) {
         String[] splittedLine = line.split("=");
         loadData(connectedPath(configDirPath, splittedLine[1]));
    }
  }
}
