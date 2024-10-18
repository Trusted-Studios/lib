-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted?.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua started");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

---@class Game
Game = {}

---@param x number | vector3 | vector4
---@param y number | nil
---@param z number | nil
---@meta:
--- Adds a simple GTA:O Marker to the world at the given coords.
function Game.AddMarker(x, y, z)
    if type(x) == "vector3" or type(x) == "vector4" then
        x, y, z = table.unpack(x)
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(1, x, y, z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.5, 0, 191, 255, 100, false, true, 2, false, nil, nil, false)
end

---@param id number
---@param coords vector3 | vector4
---@param r number
---@param g number
---@param b number
---@param a number
---@param rotation vector3
---@meta:
--- Adds a marker to the world at the given coords. Can be customized a bit more than Game.AddMarker.
function Game.AddAdvancedMarker(id, coords, r, g, b, a, rotation)
    local x, y, z = table.unpack(coords)
    local rotX, rotZ, rotY = type(rotation) == 'vector3' and table.unpack(rotation) or 0, 0, 0

    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(id, x, y, z - 1, 0.0, 0.0, 0.0, rotX, rotY, rotZ, 0.6, 0.6, 0.5, r, g, b, a, false, true, 2, false, nil, nil, false)
end

---@param name string
---@param inVeh boolean
---@param coords vector3 | vector4
---@return number
---@meta:
--- Creates a new vehicle and returns its entity id.
function Game.SpawnVehicle(name, inVeh, coords)
    local ped = PlayerPedId()
    local model = GetHashKey(name)
    local x, y, z, h = table.unpack(coords)

    RequestModel(model)
    repeat Wait(10) until HasModelLoaded(model)

    local newVehicle = CreateVehicle(name, x, y, z, h or GetEntityHeading(ped), true, false)

    if inVeh then
        SetPedIntoVehicle(ped, newVehicle, -1)
    end

    SetVehicleOnGroundProperly(newVehicle)
    SetModelAsNoLongerNeeded(model)
    SetVehicleHasBeenOwnedByPlayer(newVehicle, true)

    local id = NetworkGetNetworkIdFromEntity(newVehicle)
    SetNetworkIdCanMigrate(id, true)

    return newVehicle
end

---@param vehicle number
---@meta:
--- Checks if the passed entity is a vehicle and deletes it if true.
function Game.DeleteVehicle(vehicle)
    if not IsEntityAVehicle(vehicle) then
        print "^1[Warning]^0 - Can't delete a non-vehicle entity. If you wanted to do so, proceed to use DeleteEntity(entity)"
        return
    end

    DeleteEntity(vehicle)
end

---@param ped string
---@param x number | vector4
---@param y number | boolean
---@param z number | boolean
---@param h number | nil
---@param freeze boolean | nil
---@param isNetwork boolean | nil
---@return number | nil
---@meta:
--- Spawns a new ped and returns its entity id.
function Game.SpawnPed(ped, x, y, z, h, freeze, isNetwork)
    if type(x) == 'vector4' then 
        ---@diagnostic disable-next-line: cast-local-type
        freeze, isNetwork = y, z
        x, y, z, h = table.unpack(x)
    end

    local model = GetHashKey(ped)
    RequestModel(model)

    local timeout = false
    SetTimeout(1e4, function()
        timeout = true
    end)

    repeat Wait(10) until HasModelLoaded(model) or timeout

    if timeout then
        print '^1[WARNING]^0 - Unable to load ped model!'
        return
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local newPed = CreatePed(-1, ped, x, y, z - 1, h, isNetwork or false, true)
    SetBlockingOfNonTemporaryEvents(newPed, true)

    if freeze then
        FreezeEntityPosition(newPed, true)
    end

    SetEntityInvincible(newPed, true)

    return newPed
end

---@param x number | vector3 | vector4
---@param y number
---@param z number
---@param id number
---@param scale number
---@param color number
---@param enableWaypoint boolean | any
---@param blipLabel string | any
---@param shortRange boolean | any
---@return number
---@meta:
--- Creates a new blip and returns its id.
function Game.AddBlip(x, y, z, id, scale, color, enableWaypoint, blipLabel, shortRange)
    if type(x) == 'vector3' or type(x) == 'vector4' then
        id, scale, color, enableWaypoint, blipLabel, shortRange = y, z, id, scale, color, enableWaypoint
        x, y, z = table.unpack(x)
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local blip <const> = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, id)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, shortRange)
    SetBlipRoute(blip, enableWaypoint)
    SetBlipRouteColour(blip, color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipLabel)
    EndTextCommandSetBlipName(blip)
    return blip
end

---@param x number
---@param y number
---@param z number
---@param id number
---@param scale number
---@param color number
---@param enableWaypoint boolean
---@param blipLabel string 
---@param shortRange boolean
---@return number
---@meta:
--- Creates a new radius blip and returns its id.
function Game.AddRadiusBlip(x, y, z, id, scale, color, enableWaypoint, blipLabel, shortRange)
    local blip <const> = AddBlipForRadius(x, y, z, 0)
    SetBlipSprite(blip, id)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, shortRange)
    SetBlipRoute(blip, enableWaypoint)
    SetBlipRouteColour(blip, color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipLabel)
    EndTextCommandSetBlipName(blip)
    return blip
end

---@param modelHash number
---@param x number
---@param y number | boolean
---@param z number | boolean
---@param h number | nil
---@param isNetwork boolean | nil
---@param freeze? boolean | nil
---@return number | nil
---@meta:
--- Spawns a new object and returns it entity id.
function Game.SpawnObjectAtCoords(modelHash, x, y, z, h, isNetwork, freeze)
    if type(x) == "vector3" or type(x) == "vector4" then
        isNetwork = y --[[@as boolean]]
        x, y, z, h = table.unpack(x)

        if not h then
            h = math.random(0, 360)
        end
    end

    if type(x) == " vector4" then
        isNetwork = y --[[@as boolean]]
        x, y, z, h = table.unpack(x)
    end

    RequestModel(modelHash)

    local timeout = false
    SetTimeout(1e4, function()
        timeout = true
    end)

    repeat Wait(10) until HasModelLoaded(modelHash) or timeout

    if timeout then
        print '^1[WARNING]^0 - Unable to load ped model!'
        return
    end

    local object <const> = CreateObjectNoOffset(modelHash, x, y --[[@as number]], z --[[@as number]], isNetwork --[[@as boolean]], false, true)
 
    SetEntityHeading(object, h --[[@as number]])
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object, freeze --[[@as boolean]])
    SetEntityAsMissionEntity(object, true, false)
    SetModelAsNoLongerNeeded(modelHash)

    return object
end

---@param animDict string
---@param animName string
---@param flag number
---@meta:
--- Plays an animation to the player ped.
function Game.PlayAnimation(animDict, animName, flag, ped)
    local ped = ped or PlayerPedId()
    ClearPedTasksImmediately(ped)
    RequestAnimDict(animDict)


    local timeout = false
    SetTimeout(1e4, function()
        timeout = true
    end)

    repeat Wait(10) until HasAnimDictLoaded(animDict) or timeout

    if timeout then
        print '^1[WARNING]^0 - Unable to load ped model!'
        return
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, flag, 0, false, false, false)
end

---@param entity number
---@return table
---@meta:
--- Calculates the foward field of an entity.
function Game.GetForwardField(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 1.0, y = math.sin(hr) * 1.0 }
end

---@param entity number
---@param multiplier number
---@return table
---@meta:
---@deprecated
--- Calculates the foward field of an entity and with an multiplier.
function Game.GetAdvancedForwardField(entity, multiplier)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * multiplier, y = math.sin(hr) * multiplier }
end

---@param entity number
---@param side string
---@param multiplier number
---@return table
---@meta:
--- Calculates the side field of an entity with an optional multiplier.
function Game.GetAdvancedSideField(entity, side, multiplier)
    local add
    if side == 'left' then
        add = 180.0
    elseif side == 'right' then
        add = 0.0
    end
    local hr = GetEntityHeading(entity) + add
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * multiplier, y = math.sin(hr) * multiplier }
end

---@param h number
---@param side string
---@param multiplier number
---@return table
---@meta: 
--- Calculates the side field based on a givin heading and returns it with an optional multiplier.
function Game.GetAdvancedSideFieldFromHeading(h, side, multiplier)
    local add
    if side == 'left' then
        add = 180.0
    elseif side == 'right' then
        add = 0.0
    end
    local hr = h + add
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * multiplier, y = math.sin(hr) * multiplier }
end

---@param ped number
---@param targetCoords vector3
---@param distance number
---@param reverse boolean?
---@return boolean
---@meta:
--- Returns if the given ped is near the target coords based on the rquired distance. 
function Game.IsNearCoords(ped, targetCoords, distance, reverse)
    local coords = GetEntityCoords(ped)
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    local dist = Vdist(coords, targetCoords)

    return reverse and (dist >= distance) or (dist <= distance)
end

---@param ped number
---@param targetCoords vector3
---@param distance number
---@return boolean
---@deprecated
--- DO NOT USE THIS FUNCTION
function Game.GetDistance(ped, targetCoords, distance)
    local coords = GetEntityCoords(ped)
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local dist = Vdist(coords, targetCoords)
    return dist <= distance
end

---@param ped any
---@return boolean, vector3
---@meta:
--- credits: https://github.com/wasabirobby/wasabi_fishing/blob/main/client/functions.lua
--- Checks of the ped is near a water source.
function Game.IsNearWater(ped)
    ---@diagnostic disable-next-line: redefined-local
    local ped <const> = ped or PlayerPedId()
    
    local heading = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, -25.0)
    ---@diagnostic disable-next-line: undefined-field
    local water, coords = TestProbeAgainstWater(heading.x, heading.y, heading.z, offset.x, offset.y, offset.z)

    return water, coords
end

---@class Location
---@field coords vector3 | vector4
---@field firstDistance number
---@field secondDistance number
---@field marker boolean | function | nil
---@field functions table?
---@field condition function?
---@field heavyOptimization boolean?
---@field isNearFirstCoord boolean
---@field isNearSecondCoord boolean
---@field isInside boolean
---@field approaching boolean
---@field returnedCondition boolean
---@field active boolean
---@field start fun(): nil
---@field destroy fun(): nil
Game.Location = {}

---@class Location
---@param coords vector3 | vector4
---@param firstDistance number
---@param secondDistance number
---@param marker boolean | function
---@param functions {onApproaching: function, onLeaving: function, onEnter: function, inside: function, onExit: function} | nil
---@param condition function | nil
---@param heavyOptimization boolean | nil
---@return Location
---@meta: Creates a new location object.
function Game.Location.Create(coords, firstDistance, secondDistance, marker, functions, condition, heavyOptimization)
    local self = {
        coords = coords,
        firstDistance = firstDistance,
        secondDistance = secondDistance,
        marker = marker,
        functions = functions,
        condition = condition,
        heavyOptimization = heavyOptimization,
        isNearFirstCoord = false,
        isNearSecondCoord = false,
        isInside = false,
        approaching = false,
        returnedCondition = true,
        active = true
    }

    setmetatable(self, {__index = Game.Location})

    function self:isNearCoords(coord, distance)
        local playerCoords = GetEntityCoords(PlayerPedId())
        return #(playerCoords - vector3(coord.x, coord.y, coord.z)) <= distance
    end

    function self:start()
        CreateThread(function()
            if self.condition and type(self.condition) == "function" then
                while true do
                    Wait(self.heavyOptimization and 500 or 250)
                    self.returnedCondition = self.condition()
                end
            end
        end)

        CreateThread(function()
            while self.active do
                self.isNearFirstCoord = self:isNearCoords(self.coords, self.firstDistance)
                self.isNearSecondCoord = self:isNearCoords(self.coords, self.secondDistance)
                Wait(self.heavyOptimization and 800 or 500)
            end
        end)

        CreateThread(function()
            while self.active do
                Wait(0)

                if (self.isNearFirstCoord or self.isNearSecondCoord) and self.returnedCondition then
                    if self.marker and type(self.marker) ~= "function" then
                        Game.AddMarker(self.coords)
                    elseif self.marker and type(self.marker) == "function" then
                        self.marker()
                    end
                else
                    Wait(self.heavyOptimization and 800 or 500)
                end
            end
        end)

        CreateThread(function()
            while self.active do
                Wait(0)

                if not self.returnedCondition then
                    Wait(self.heavyOptimization and 800 or 500)
                    goto continue
                end

                ---@onApproaching
                if not self.approaching and self.isNearFirstCoord then
                    self.approaching = true
                    if self.functions?.onApproaching then
                        self.functions.onApproaching({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                ---@onLeaving
                if self.approaching and not self.isNearFirstCoord then
                    self.approaching = false
                    if self.functions?.onLeaving then
                        self.functions.onLeaving({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                ---@onEnter
                if not self.isInside and self.isNearSecondCoord then
                    self.isInside = true
                    if self.functions?.onEnter then
                        self.functions.onEnter({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                ---@inside
                if self.isInside then
                    if self.functions?.inside then
                        self.functions.inside({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                ---@onExit
                if self.isInside and not self.isNearSecondCoord then
                    self.isInside = false

                    if self.functions?.onExit then
                        self.functions.onExit({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                if not self.isNearSecondCoord then
                    Wait(self.heavyOptimization and 800 or 500)
                    goto continue
                end

                ::continue::
            end
        end)
    end

    function self:destroy()
        self.returnedCondition = false
        self.isNearFirstCoord = false
        self.isNearSecondCoord = false
        self.isInside = false
        self.active = false
        self = nil
    end

    self:start()

    return self
end