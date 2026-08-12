local bogosMod = RegisterMod("Bogos Tinted", 1)

local regularTintedCount = 0
local superSpecialCount = 0

local function OnNewRoom()
    regularTintedCount = 0
    superSpecialCount = 0
    local room = Game():GetRoom()
    
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity then
            local gType = gridEntity:GetType()
            
            -- Only count active, unbroken structures (State 0 = Normal, State 1 = Damaged)
            if gridEntity.State == 0 or gridEntity.State == 1 then
                -- Match the exact Repentance Plus specific grid type enums
                if gType == GridEntityType.GRID_ROCKT then
                    regularTintedCount = regularTintedCount + 1
                elseif gType == GridEntityType.GRID_ROCK_SS then
                    superSpecialCount = superSpecialCount + 1
                end
            end
        end
    end
end
bogosMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnNewRoom)

local function OnRender()
    local screenYOffset = 40
    
    if regularTintedCount > 0 then
        Isaac.RenderText("TINTED ROCK DETECTED! (" .. regularTintedCount .. ")", 150, screenYOffset, 0, 1, 0, 255)
        screenYOffset = screenYOffset + 12
    end
    
    if superSpecialCount > 0 then
        Isaac.RenderText("SUPER SPECIAL ROCK DETECTED! (" .. superSpecialCount .. ")", 150, screenYOffset, 1, 0.8, 0, 255)
    end
end
bogosMod:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)
