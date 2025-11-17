import java.util.Set;
class FileManager {
 
  String baseDir;
  String dlcPath;
  String dataPath;
  boolean containsDLC;
  String[] allowedExtension = {".json", ".txt", ".ini"};
  String healthBarConfigPath;
  HashMap<String, JSONObject> dialogueData;
  FileManager() {
      
  }
  
  void test() {
    String[] config = loadStrings(sketchPath("config.ini"));
    if (config == null) {
      println("No config.ini, please initialize the config.ini on the project folder with this format:");
      println("dataFolder=data");
      println("DLCFolder=DLC");
      println("DLC=true");
      exit();
    }
    HashMap<String, String> configMap = new HashMap<>();
    for (String line: config) {
      String[] pair = line.split("=");
      if(pair.length != 2) {
        println("Key error at line: "  + line);
        exit();
      }
      configMap.put(pair[0], pair[1]);
    }
    dataPath = configMap.get("dataFolder");
    baseDir = dataPath;
    if (dataPath == null) {
      println("No key dataFolder at config.ini");
    } 
    String dataDirectoryPath = sketchPath(dataPath);
    File directory = new File(dataDirectoryPath);
    File[] files = directory.listFiles();
    if (files != null) {
      healthBarConfigPath = connectedPath(dataPath, "HealthBar.txt");
      dialogueData = new HashMap<>();
      for (File file: files) {
        if (!file.isFile()) continue;
        String fileName = file.getName();         
        if (fileName.startsWith("Unit_") && fileName.endsWith(".json")) {
          loadUnitJSONData(dataPath, fileName); 
          String className = fileName.substring(5, fileName.lastIndexOf('.'));
          loadDialogueData(dataPath, className);
        }
      } 
    }
    else {
      println("Cannot find the valid data folder. Reassign value at dataFolder in config.ini");
    }
    
    // Read DLC
    dlcPath = configMap.get("DLCFolder");
    boolean useDLC = Boolean.parseBoolean(configMap.get("DLC"));
    if (!isExist(dlcPath) || !useDLC) {
      println("No DLC Implementation");
      return;
    }
    File dlcDirectory = new File(sketchPath(dlcPath));
    File[] dlcFiles = dlcDirectory.listFiles();
    if (dlcFiles == null) { 
      println("No file in DLC folder");
      return;
    }
    baseDir = dlcDirectory.getName();
    //JSONArray dlcConfig = loadJSONArray(connectedPath(sketchPath(dlcPath), "dlc-config.json"));
    //HashMap<String, JSONArray> keyLists = new HashMap<>();
    
    //for (int i = 0; i < dlcConfig.size(); i++) {
    //  JSONObject obj = dlcConfig.getJSONObject(i);
    //  keyLists.put(obj.getString("type"), obj.getJSONArray("keyLists"));  loading
    //  println(obj);
    //}
    
    for (File file: dlcFiles) {
      if (!file.getName().equals("dlc-config.json")) {
        loadDLCData(file);
      }
    }
    
    
  }
  private void loadDLCData(File file) {
    if (file.isDirectory()) {
      for (File inDir: file.listFiles()) {
        baseDir = dlcPath + "/" +  file.getName();
        loadDLCData(inDir);
      }
    }
    
    String fileName = file.getName();
    String dirPath = file.getParentFile().getAbsolutePath();
    println(fileName);
    boolean isCheck = false;
    for (String extension: allowedExtension) {
      if (fileName.endsWith(extension)) {
        isCheck = true;
        break;
      }
    }
    if(!isCheck) return;
    if (fileName.startsWith("Unit_") && fileName.endsWith(".json")) {
      String className = fileName.substring(5, fileName.lastIndexOf('.'));
      loadUnitJSONData(baseDir, fileName);
      loadDialogueData(baseDir, className);     
    } 
    else if (fileName.startsWith("Skin_")) {
      loadSkinData(baseDir, fileName);
    }
  }
   
  private void loadSkinData(String configDir, String fileName) {
     if (fileName.endsWith(".json")) {
         
     } else if (fileName.endsWith(".txt") || fileName.endsWith(".ini")) {
     
     }
  }
   
  private void loadUnitJSONData(String configDir, String fileName) {
    if (units == null) units = new HashMap<>();  
    println(fileName);
    if (!isExist(healthBarConfigPath)) {
      println("No healthbar config");
      exit();
    }
    String className = fileName.substring(5, fileName.lastIndexOf('.'));
    
    JSONObject data = loadJSONObject(connectedPath(configDir, fileName));
    if (data == null) {
        println("Cannot initialize json object");
        return;
     }
     
     
     JSONObject detail = data.getJSONObject("detail");
     if (units.get(detail.get("name")) != null) {
       println("Already initialized!!");
       return;
     }
     Unit unit;
       
     unit = new Unit(detail, 
          connectedPath(configDir, data.getString("idleConfig")), 
          connectedPath(configDir, data.getString("attackConfig")), 
          connectedPath(configDir, data.getString("walkConfig")), 
          connectedPath(configDir, data.getString("deathConfig")),
          healthBarConfigPath);
      
     units.put(detail.getString("name"), unit);
        // Test   
     loadDialogueData(configDir, className);
  }
  
  private void loadUnitTextData(String configDir, String fileName) {
    String[] lines = loadStrings(connectedPath(configDir,fileName));
    if (lines == null) return;
    if (units == null) units = new HashMap<>();  
    if (units.get(lines[0]) != null) {
      println("Already Initialize!!!!");
      return;
    }
    JSONObject detail = new JSONObject();
    detail.setString("name", lines[0]);
    detail.setFloat("health", Float.parseFloat(lines[1]));
    detail.setFloat("atk", Float.parseFloat(lines[2]));
    detail.setFloat("def", Float.parseFloat(lines[3]));
    detail.setString("description", lines[4]);
    Unit unit = new Unit(detail, 
    connectedPath(configDir,lines[5]), 
    connectedPath(configDir,lines[6]), 
    connectedPath(configDir,lines[7]), 
    connectedPath(configDir,lines[8]), 
    healthBarConfigPath);
    units.put(lines[0], unit);
    String className = fileName.substring(5, fileName.lastIndexOf('.')); 
    loadDialogueData(configDir, className);
  }
  
  private void loadDialogueData(String configDir, String unitName) {
    String path = connectedPath(configDir, "Dialogue_" + unitName + ".json");
    JSONObject data = loadJSONObject(path);
    if (data != null) {
      println("Successfully loaded dialogue for: " + unitName);
      dialogueData.put(unitName, data);
    } 
    else {
      println("WARNING: No dialogue file found at " + path);
      JSONObject emptyData = new JSONObject();
      emptyData.setJSONArray("normal", new JSONArray());
      emptyData.setJSONArray("taunt", new JSONArray());
      dialogueData.put(unitName, emptyData);
    }
  }
  
  boolean isExist(String filePath) {
    println(filePath);
    return new File(sketchPath(filePath)).exists();
  }
  
  private String connectedPath(String baseDir, String filePath) {
    return baseDir + "/" + filePath;     
  }
  
  String getBaseDir() {
    return baseDir;
  }
  
}
