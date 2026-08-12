-- Bogos Tinted Mod for The Binding of Isaac
-- Plays bogos_binted.wav whenever a Tinted Rock or Super Special Tinted Rock is destroyed.

local mod = RegisterMod("Bogos Tinted", 1)

local soundId = -1
local trackedRocks = {}

-- Helper to safely get the sound ID
local function getBogosSoundId()
    if soundId == nil or soundId == -1 then
        soundId = Isaac.GetSoundIdByName("Bogos Binted")
    end
    return soundId
end

-- Scan current room and store grid indices of tinted rocks
local function scanRoomForTintedRocks()
    trackedRocks = {}
    local room = Game():GetRoom()
    local gridSize = room:GetGridSize()

    for i = 0, gridSize - 1 do
        local grid = room:GetGridEntity(i)
        if grid ~= nil then
            local gType = grid:GetType()
            -- Check for both standard Tinted Rocks (GRID_ROCKT) and Super Special Tinted Rocks (GRID_ROCK_SS)
            if gType == GridEntityType.GRID_ROCKT or gType == GridEntityType.GRID_ROCK_SS then
                trackedRocks[i] = gType
            end
        end
    end
end

-- Callback when entering a room or loading into the game
function mod:OnNewRoom()
    scanRoomForTintedRocks()
end

-- Callback every frame update to check if tracked rocks have been destroyed
function mod:OnPostUpdate()
    if next(trackedRocks) == nil then
        return
    end

    local room = Game():GetRoom()

    for gridIndex, originalType in pairs(trackedRocks) do
        local grid = room:GetGridEntity(gridIndex)

        local isDestroyed = false
        if grid == nil then
            -- Grid entity removed
            isDestroyed = true
        elseif grid:GetType() ~= originalType then
            -- Grid entity replaced or turned to pit/rubble
            isDestroyed = true
        else
            -- Check grid entity state (State 2 indicates rubble/destroyed rock)
            local state = grid.State
            if state == nil and grid.GetState then
                state = grid:GetState()
            end
            if state == 2 then
                isDestroyed = true
            end
        end

        if isDestroyed then
            local sfxId = getBogosSoundId()
            if sfxId ~= nil and sfxId ~= -1 then
                SFXManager():Play(sfxId, 1.0, 0, false, 1.0)
                print("[Bogos Tinted] Tinted rock destroyed! Sound played.")
            else
                print("[Bogos Tinted Warning] Sound 'Bogos Binted' not loaded (-1). Check content/sounds.xml.")
            end

            -- Remove from tracked rocks list so sound plays exactly once
            trackedRocks[gridIndex] = nil
        end
    end
end

-- Register callbacks
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnPostUpdate)

print("[Bogos Tinted Mod] Loaded successfully!")
