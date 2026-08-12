local bogosTinted = RegisterMod("Bogos Tinted", 1)
local bogoSound = Isaac.GetSoundIdByName("bogos_binted")
local trackedTintedRocks = {}

local function OnNewRoom()
    trackedTintedRocks = {} 
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity then
            local gType = gridEntity:GetType()
            local rockObj = gridEntity:ToRock()
            local isIntact = not rockObj or (rockObj.State ~= 2)
            
            if isIntact then
                if gType == GridEntityType.GRID_ROCKT or gType == GridEntityType.GRID_ROCK_SS then
                    trackedTintedRocks[i] = true
                end
            end
        end
    end
end
bogosTinted:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnNewRoom)

local function OnUpdate()
    local room = Game():GetRoom()
    
    for gridIndex, _ in pairs(trackedTintedRocks) do
        local gridEntity = room:GetGridEntity(gridIndex)
        local hasBlownUp = false
        
        if not gridEntity then
            hasBlownUp = true
        else
            local rockObj = gridEntity:ToRock()
            if rockObj and rockObj.State == 2 then
                hasBlownUp = true
            end
        end
        
        if hasBlownUp then
            if bogoSound and bogoSound ~= -1 then
                SFXManager():Play(bogoSound, 1.0, 0, false, 1.0)
            end
            trackedTintedRocks[gridIndex] = nil
        end
    end
end
bogosTinted:AddCallback(ModCallbacks.MC_POST_UPDATE, OnUpdate)
