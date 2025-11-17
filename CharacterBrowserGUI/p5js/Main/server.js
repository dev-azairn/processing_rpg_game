const express = require("express");
const utils = require("./utils.js");
const path = require("path");

const app = express();
const port = 3000;


app.use(express.static('public'));
const assetsDir = path.join(__dirname, 'public','assets');

const startServer = async () => {
  let config;
  try {
    config = require('./config.json');
  } catch (e) {
    console.error("Error: Could not load config.json.", e);
    return;
  }

  const dataPath = config["assets"];

  if (!dataPath) {
    console.error("Error: 'assets' key not found in config.json");
    return;
  }

  const units = await utils.loadData(dataPath);
  
  console.log(units);
  
  app.get('/api/units', (req, res) => {
    res.json(units);
  })

  app.get('/assets/:element/:fileName', (req, res) => {
    const { element, fileName } = req.params;

    // Create the full, absolute path
    const filePath = path.join(assetsDir, element, fileName);

    // Security check
    if (!filePath.startsWith(assetsDir)) {
      return res.status(403).send('Forbidden');
    }

    // Send the file
    res.sendFile(filePath, (err) => {
      if (err) {
        console.log(`File not found: ${req.path}`);
        res.status(404).send("File not found");
      } else {
        console.log(`Sent file: ${req.path}`);
      }
    });
  });
  
  app.get('/assets/:unitName/:unitAction/:fileName', (req, res) => {
    const unitName = req.params.unitName;
    const unitAction = req.params.unitAction;
    const fileName = req.params.fileName;
    console.log(unitName, unitAction, fileName);
    const filePath = path.join(assetsDir, unitName, unitAction, fileName);
    res.sendFile(filePath, (err) => {
      if (err) {
        console.log(`File not found: ${filePath}`);
        res.status(404).send("File not found");
      } else {
        console.log(`Send file: ${filePath}`);
      }
    });
    
  })
  app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
  })
}

startServer();


