## Plant and Prosper 🌱

<img width="640" height="480" alt="godot-farming screenshot" src="screenshot-rc-godot-farm-rpg.png" />

Farming game built at [The Recurse Center](https://recurse.com) using [Godot](https://godotengine.org/) as a learning project.

The player can prepare the soil, plant seeds, water crops, and harvest them once they are fully grown. Harvested crops are sold automatically, earning money that can be used to buy more seeds.

Each day has a limited number of actions to encourage planning and progression. A day–night overlay provides visual feedback as time advances, and the currently selected item is highlighted in the UI. Try out the game [here](https://forgepixel.itch.io/plant-and-prosper).


## Running the game

Clone the repo:
```bash
git clone https://github.com/nadia-nh/rc-godot-farm-rpg.git
cd rc-godot-farm-rpg
```

Run with Godot 4:

Import the project, and run the main scene with the run project button or by pressing `F5`.

Controls - Keyboard based:
- WASD / arrow keys – Move the player
- e / enter / spacebar - Use the selected item
- 1 - Select the hoe tool
- 2 - Select the scythe tool
- 3 - Select the watering can tool
- 4 - Select the potato seeds
- 5 - Select the turnip seeds
- n – Advance to the next day

Controls - Mouse based:
- WASD / arrow keys – Move the player
- Clicking on the grass - Use the selected item
- Clicking on an item button – Select a tool or seed
- Clicking on the next Day button – Advance to the next day

## How the Game Works

The game is structured around a few core systems:

- **GameManager (autoload)**  
  Tracks global game state such as the current day, money, and selected item, and declares signals used across the system.

- **FarmManager**  
  Coordinates high-level farm interactions, such as planting crops, buying seeds, and translating player actions into tile updates.

- **Grass / GrassTileData / CropNode / CropData**  
  Handle the tile-based farming logic:
  - `Grass` manages the tile map
  - `GrassTileData` stores per-tile state (tilled, watered, crop reference)
  - `CropNode` applies crop growth logic and updates sprites
  - `CropData` stores crop state values

- **InputDispatcher**  
  Handles keyboard input and notifies the GameManager about relevant state updates (item selection, item use, day advancement).

- **UILayer**  
  Updates UI elements in response to game state changes, including item buttons, money display, and the next-day button.

The project uses signals for communication to keep systems loosely coupled.

For a visual overview of the game systems, see the demo slides:
[Nodes All The Way Down](https://docs.google.com/presentation/d/1H5dE7Q7C5M8nXLOsPcTTX8NFD__V1pt10A7oRtl6uXc/edit?usp=sharing)

## Resources

- [Zenva Godot Farming RPG Course](https://academy.zenva.com/course/godot-farm-rpg-course/)  
  Loosely followed this tutorial as a starting point for building a complete game.
  Modified the farming tool assets, UI, and most of the code structure.

- [Godot Documentation – Creating a 2D Game](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html)  
  Used as a reference for learning core 2D game concepts in Godot.

### Assets

- **Crops, icons, and growth images**  
  Creator: [josehzz](https://opengameart.org/users/josehzz)  
  Source: [Farming crops 16x16](https://opengameart.org/content/farming-crops-16x16)  
  License: CC0

- **Character sprites**  
  Creator: [Fleurman](https://opengameart.org/users/fleurman)  
  Source: [Tiny Characters Set](https://opengameart.org/content/tiny-characters-set)  
  License: CC0

- **Button and display backgrounds**  
  Creator: [Kenney](https://www.kenney.nl/)  
  Source: [UI Pack – Pixel Adventure](https://www.kenney.nl/assets/ui-pack-pixel-adventure)  
  License: CC0

- **Menu icons**  
  Creator: [Crusenho](https://crusenho.itch.io/)  
  Source: [Bookstyles Complete UI Pack](https://crusenho.itch.io/complete-ui-book-styles-pack)  
  License: Free to use, share, distribute, copy, adapt, remix, and transform  
  *(Assets recolored to match the game’s tone.)*

- **Farming tools**  
  Created by me for this project.

---

Made with <3 at [The Recurse Center](https://recurse.com).  
This project is for educational purposes only.

