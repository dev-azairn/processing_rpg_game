// Note the '.promises'
const fs = require('fs').promises; 
const path = require('path');

/**
 * Loads a single sprite config file.
 * This is async because it reads a file.
 */
const loadSprite = async (filePath, sprite) => {
    try {
        // Use await and promises.readFile (instead of readFileSync)
        const configLine = await fs.readFile(filePath, 'utf-8');
        const configParams = configLine.split(" ");
        sprite["characterFolder"] = configParams[0];
        sprite["characterAction"] = configParams[1];
        sprite["imageFileName"] = configParams[2];
        sprite["fileExtension"] = configParams[3];
        sprite["totalSize"] = configParams[4];
        sprite["posX"] = configParams[5];
        sprite["posY"] = configParams[6];
        sprite["scale"] = configParams[7];
    } catch (err) {
        console.error("Cannot read sprite file:", filePath, err);
    }
}

/**
 * Loads a single unit's JSON file and all its associated sprite configs.
 * This is async because it calls other async functions.
 */
const loadUnitData = async (units, dirname, filename) => {
    

    const filePath = path.join(dirname, filename);
    if (filename.endsWith(".json")) 
        try {
            const configData = await fs.readFile(filePath, 'utf-8');
            const configObj = JSON.parse(configData);
            
            const detail = configObj["detail"];
            const idle = {}, attack = {}, walk = {}, death = {};

            // Use Promise.all to load all sprites in parallel for efficiency
            await Promise.all([
                loadSprite(path.join(dirname, configObj["idleConfig"]), idle),
                loadSprite(path.join(dirname, configObj["attackConfig"]), attack),
                loadSprite(path.join(dirname, configObj["walkConfig"]), walk),
                loadSprite(path.join(dirname, configObj["deathConfig"]), death)
            ]);

            // This push now happens *after* all data is loaded
            units.push({
                "detail": detail,
                "idleConfig": idle,
                "attackConfig": attack,
                "walkConfig": walk,
                "deathConfig": death,
            });
        } catch (err) {
            console.error("Error loading unit data:", filePath, err);
        }
    else if (filename.endsWith(".txt") || filename.endsWith(".ini"))  
        try {
            const configData = await fs.readFile(filePath, 'utf-8');
            const detail = {};
            const idle = {}, attack = {}, walk = {}, death = {};
            const lines = configData.split(/\r?\n/);
            detail["name"] = lines[0];
            detail["health"] = parseFloat(lines[1]);
            detail["atk"] = parseFloat(lines[2]);
            detail["def"] = parseFloat(lines[3]);
            detail["description"] = lines[4];
            console.log(lines);
             await Promise.all([
                loadSprite(path.join(dirname, lines[5]), idle),
                loadSprite(path.join(dirname, lines[6]), attack),
                loadSprite(path.join(dirname, lines[7]), walk),
                loadSprite(path.join(dirname, lines[8]), death)
            ]);
            units.push({
                "detail": detail,
                "idleConfig": idle,
                "attackConfig": attack,
                "walkConfig": walk,
                "deathConfig": death,
            });
        } catch (err) {
            console.error("Error loading unit data:", filePath, err);
        }
}

const loadDialogueData = async (dialogue, dataPath, filename) => {
    // You can implement this next
    if (!filename.endsWith(".json")) return;
    const filePath = path.join(dataPath,  filename); 
    let uindex = filename.indexOf("_") + 1;
    let extensionIndex = filename.indexOf(".");
    const configData = await fs.readFile(filePath, 'utf-8');
    dialogue[filename.substring(uindex, extensionIndex)] = JSON.parse(configData);
}

/**
 * Main data loading function.
 * It is now truly async and returns the loaded units.
 */
const loadData = async (units, dialogue, dataPath) => { // Make 'units' local to this function
    try {
        // 1. Await the directory read (no callback)
        const lists = await fs.readdir(dataPath);

        // 2. Process all files
        // We use Promise.all to wait for all files to be processed
        await Promise.all(lists.map(async (filename) => {
            const fullPath = path.join(dataPath, filename);
            let stats;
            try {
                // 3. Await the stats (no callback)
                stats = await fs.stat(fullPath);
            } catch (statErr) {
                console.error("Error getting stats for:", fullPath, statErr);
                return; // Skip this file
            }

            // 4. Check stats and load data (all inside the async map)
            if (stats.isFile() && filename.startsWith("Unit_")) {
                // 5. Await the unit data load
                await loadUnitData(units, dataPath, filename);
            } else if (stats.isFile() && filename.startsWith("Dialogue_")) {
                await loadDialogueData(dialogue, dataPath, filename);
            }
        }));

    } catch (err) {
        console.error("Error reading directory:", dataPath, err);
    }

    // 6. NOW this line runs *after* everything is done.
    console.log("Data loading complete. Units found:", units.length);
    
}


// Export only the main loading function
module.exports = {
    loadData
};