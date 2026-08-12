# Bogos Tinted 👽

A mod for The Binding of Isaac: Repentance+ that plays the "Bogos Binted" meme audio when a tinted rock or super special tinted rock is destroyed.

## Function

This mod utilizes the official Binding of Isaac Lua API:

1. **Room Scanning (`MC_POST_NEW_ROOM`)**:
   Upon entering any room, `scanRoomForTintedRocks()` scans all grid entities in the room and registers the grid index of any tinted rock or super special tinted rock into a tracking table.

2. **Destruction Checking (`MC_POST_UPDATE`)**:
   On every frame update, tracked grid indices are evaluated:
   - If the grid entity is removed (`nil`), replaced, or its state changes to destroyed (`state == 2`), the mod triggers `SFXManager():Play(...)` with the `"Bogos Binted"` sound ID.
   - The destroyed grid index is immediately removed from the tracking list so the sound only plays once.

## License

This project is licensed under the [MIT License](LICENSE).
