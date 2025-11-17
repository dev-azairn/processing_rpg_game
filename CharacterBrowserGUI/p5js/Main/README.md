# p5.js Character Browser

This is a full-stack web application that uses a Node.js/Express.js backend to serve and power a p5.js frontend. The application functions as a dynamic character browser, loading unit data, sprites, and dialogue from the server and rendering them in an interactive interface.

![Screenshot of the Character Browser UI](image_47b8fb.jpg)

---

## 🚀 Features

* **Dynamic Data Loading:** All game data (units, stats, dialogue) is loaded from the Node.js backend via API endpoints.
* **Sprite Animation:** Units are rendered with animated sprites (Idle, Attack, Walk, Death) using a custom `Sprite` class.
* **Interactive UI:** A `CharacterBrowser` class manages the UI, including:
    * A horizontally scrolling list of all available units.
    * Click-to-select functionality (left-click for player 1, right-click for player 2).
    * A "stage" area where selected units are displayed and animated.
    * A unit details panel showing stats and action buttons.
* **Health Bars:** A custom `HealthBar` class renders health bars above units.
* **Dialogue System:** A `CharacterDialogue` class handles interactions.
    * Units can have "normal" (random) dialogue.
    * Units can have specific "taunt" lines when paired against other specific units.
* **Server-Side Asset Handling:** The backend reads `.json`, `.txt`, and `.ini` files to configure units and serves all assets (images, sprites) through a dynamic API.

---

## 💻 Tech Stack

* **Frontend:** [p5.js](https://p5js.org/)
* **Backend:** [Node.js](https://nodejs.org/) & [Express.js](https://expressjs.com/)
* **Deployment:** [Vercel](https://vercel.com/)

---

## 🔧 Setup & Installation (Local)

To run this project on your local machine:

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd p5js-characterbrowser
    ```

2.  **Install backend dependencies:**
    ```bash
    npm install
    ```
    *(This will install `express` and any other required modules.)*

3.  **Run the server:**
    ```bash
    node server.js
    ```

4.  **Open the application:**
    Open your web browser and go to `http://localhost:3000`.

---

## 📂 Key Files & Structure

* `/server.js`: The main Express.js server. It starts the app, loads data using `utils.js`, and defines all API routes.
* `/utils.js`: A Node.js helper module that uses `fs.promises` to read and parse all game data from the `public/assets` folder.
* `/vercel.json`: The Vercel deployment configuration, which is crucial for including data files in the serverless build.
* `/public`: The static folder served to the client.
    * `/index.html`: The main HTML file that hosts the p5.js sketch.
    * `/sketch.js` (or similar): The main p5.js file that handles `preload()`, `setup()`, and `draw()`, and manages the loading state.
    * `/CharacterBrowser.js`: The class that draws and manages the UI.
    * `/Unit.js`: The class for individual unit logic, stats, and states.
    * `/Sprite.js`: The class that handles loading, animating, and rendering sprite sheets.
    * `/HealthBar.js`: The class for drawing the health bar UI.
    * `/CharacterDialogue.js`: The class for managing and displaying speech bubbles.
    * `/assets`: Contains all game data, including unit configs (`.json`, `.txt`), dialogue (`.json`), and all image assets.