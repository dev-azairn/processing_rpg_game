class FileManager {
 
   
  boolean containsDLC;
  
  FileManager() {
      
  }
  
  void test() {
    String dataDirectoryPath = sketchPath("data");
    File directory = new File(dataDirectoryPath);
    println(directory.getName());
    File[] files = directory.listFiles();
    if (files != null)
    for (File file: files) {
      if (!file.isFile()) continue;
      String fileName = file.getName(); 
      int extensionIndex = fileName.indexOf('.');
      println(fileName);
      if (fileName.startsWith("Unit")) {
        loadUnitData(dataDirectoryPath, fileName);
        loadDialogueData(dataDirectoryPath, "Dialogue_" + fileName.substring(5, extensionIndex) + ".json");
      }
      else if (fileName.startsWith("Scene")) loadSceneData(dataDirectoryPath, fileName);
       
    }
    String dlcPath = sketchPath("DLC");
    
  }

 
  private void loadUnitData(String configDir, String fileName) {
    if (units == null) units = new HashMap<>();  
    String healthBarConfigPath = connectedPath(configDir, "HealthBar.txt");
    println(healthBarConfigPath);
    if (!isExist(healthBarConfigPath)) {
      println("No healthbar config");
      exit();
    }
    JSONObject data = loadJSONObject(connectedPath(configDir, fileName));
    if (data == null) {
        println("Cannot initialize json object");
        return;
     }
     JSONObject detail = data.getJSONObject("detail");
     Unit unit = new Unit(detail, 
          connectedPath(configDir, data.getString("idleConfig")), 
          connectedPath(configDir, data.getString("attackConfig")), 
          connectedPath(configDir, data.getString("walkConfig")), 
          connectedPath(configDir, data.getString("deathConfig")),
          healthBarConfigPath);
     units.put(detail.getString("name"), unit);
        
        // Test
     println(units.get(detail.get("name")));
     
  }
  
  private void loadSceneData(String configDir, String fileName) {
    
  }
  
  private void loadDialogueData(String configDir, String fileName){
    println(fileName);
    if(!isExist(connectedPath(configDir, fileName))) println("No file read");
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
