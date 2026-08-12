# Bogos Tinted 👽
<img width="1024" height="768" alt="BogosBinted" src="https://github.com/user-attachments/assets/85bbd22b-dfc9-4a75-91f7-e8042cb2f125" />


A mod for **The Binding of Isaac: Repentance+** that plays the "Bogos Binted?" meme audio clip whenever a tinted rock or super special tinted rock is destroyed.

## Installation

1. Subscribe to the mod on the [Steam Workshop](#), or manually copy the repo contents into:
   ```
   steamapps\common\The Binding of Isaac Rebirth\mods\bogos_tinted
   ```
2. Launch the game and enable **Bogos Tinted** from the Mods menu.

## How It Works

The mod hooks into two game callbacks via the Isaac Lua API:

| Callback | Purpose |
|---|---|
| `MC_POST_NEW_ROOM` | Scans all grid entities in the new room and records the indices of any tinted rocks (`GRID_ROCKT`) and super special tinted rocks (`GRID_ROCK_SS`). |
| `MC_POST_UPDATE` | Checks every tracked index each frame. When a rock is gone (`nil`) or its state is `2` (destroyed), the "Bogos Binted?" audio plays once via `SFXManager():Play(...)`, and the index is removed from tracking. |

## Project Structure

```
bogos-tinted/
├── main.lua              # Core mod logic
├── metadata.xml          # Mod metadata (name, version, visibility)
├── content/
│   └── sounds.xml        # Sound entry definition
└── resources/
    └── sfx/
        └── bogos_binted.wav  # Bogos Binted audio clip
```

## License

This project is licensed under the [MIT License](LICENSE).
