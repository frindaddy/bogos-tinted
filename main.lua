local bogosMod = RegisterMod("Bogos Tinted", 1)

local BOGOS_SOUND = Isaac.GetSoundIdByName("BogosBintedSFX")
local trackedTintedRocks = {}

-- Visual indicator timers and flags
local showExplosionIndicator = false
local explosionTimer = 0
local EXPLOSION_DURATION = 60 -- Show the explosion message for 60 frames (1 second)

-- Step 1: Scan the room for regular and super special tinted rocks
function bogosMod:OnNewRoom()
    trackedTintedRocks = {} 
    showExplosionIndicator = false -- Clear indicator on room transition
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity and gridEntity:GetType() == GridEntityType.GRID_ROCK then
            local rock = gridEntity:ToRock()
            if rock and rock.State ~= 2 then
                if rock.Variant == 1 or rock.Variant == 2 then
                    trackedTintedRocks[i] = true
                end
            end
        end
    end
end
bogosMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, bogosMod:OnNewRoom)

-- Step 2: Monitor tracked rocks for destruction and manage timers
function bogosMod:OnUpdate()
    local room = Game():GetRoom()
    
    -- Handle the explosion indicator countdown
    if showExplosionIndicator then
        explosionTimer = explosionTimer - 1
        if explosionTimer <= 0 then
            showExplosionIndicator = false
        end
    end
    
    for gridIndex, _ in pairs(trackedTintedRocks) do
        local gridEntity = room:GetGridEntity(gridIndex)
        
        if not gridEntity or gridEntity:GetType() ~= GridEntityType.GRID_ROCK or gridEntity:ToRock().State == 2 then
            -- Play sound
            SFXManager():Play(BOGOS_SOUND, 1.0, 0, false, 1.0)
            
            -- Trigger the explosion indicator
            showExplosionIndicator = true
            explosionTimer = EXPLOSION_DURATION
            
            trackedTintedRocks[gridIndex] = nil
        end
    end
end
bogosMod:AddCallback(ModCallbacks.MC_POST_UPDATE, bogosMod:OnUpdate)

-- Step 3: Render text indicators on the screen
function bogosMod:OnRender()
    -- Check if there are any remaining tracked rocks in our table
    local rocksRemaining = 0
    for _ in pairs(trackedTintedRocks) do
        rocksRemaining = rocksRemaining + 1
    end
    
    -- Indicator 1: Tinted rock is present in the room
    if rocksRemaining > 0 then
        -- Isaac.RenderText(text, x, y, r, g, b, alpha)
        -- Draws a green alert at X: 50, Y: 50
        Isaac.RenderText("TINTED ROCK IN ROOM!", 50, 50, 0, 1, 0, 1)
    end
    
    -- Indicator 2: A rock was just blown up
    if showExplosionIndicator then
        -- Draws a flashing or bright red alert at X: 50, Y: 65
        Isaac.RenderText("BOGOS BINTED!!!", 50, 65, 1, 0, 0, 1)
    end
end
bogosMod:AddCallback(ModCallbacks.MC_POST_RENDER, bogosMod:OnRender)
