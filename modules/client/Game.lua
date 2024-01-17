-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
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

---@param x number | vector3
---@param y number | nil
---@param z number | nil
function Game.AddMarker(x, y, z)
    if type(x) == "vector3" or type(x) == "vector4" then
        x, y, z = table.unpack(x)
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(1, x, y, z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.5, 0, 191, 255, 100, false, true, 2, false, nil, nil, false)
end

---@param id number
---@param coords vector4
---@param r number
---@param g number
---@param b number
---@param a number
---@param rotation vector3
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

--- Useless..
---@param vehicle number
function Game.DeleteVehicle(vehicle)
    DeleteEntity(vehicle)
end

---@param ped string
---@param x number
---@param y number | boolean
---@param z number | boolean
---@param h number | nil
---@param freeze boolean | nil
---@param isNetwork boolean | nil
---@return number
function Game.SpawnPed(ped, x, y, z, h, freeze, isNetwork)
    if type(x) == 'vector4' then 
        ---@diagnostic disable-next-line: cast-local-type
        freeze, isNetwork = y, z
        x, y, z, h = table.unpack(x)
    end

    local model = GetHashKey(ped)

    RequestModel(model)
    repeat Wait(10) until HasModelLoaded(model)

    ---@diagnostic disable-next-line: param-type-mismatch
    local newPed = CreatePed(-1, ped, x, y, z - 1, h, isNetwork or false, true)
    SetBlockingOfNonTemporaryEvents(newPed, true)

    if freeze then
        FreezeEntityPosition(newPed, true)
    end

    SetEntityInvincible(newPed, true)

    return newPed
end

---@param x number
---@param y number
---@param z number
---@param type number
---@param scale number
---@param colour number
---@param enableWaypoint boolean
---@param BlipLabel string
---@param shortRange boolean
---@return number
function Game.AddBlip(x, y, z, id, scale, color, enableWaypoint, BlipLabel, shortRange)
    if type(x) == 'vector3' or type(x) == 'vector4' then
        id, scale, color, enableWaypoint, BlipLabel, shortRange = y, z, id, scale, color, enableWaypoint
        x, y, z = table.unpack(x)
    end

    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, id)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, shortRange)
    SetBlipRoute(blip, enableWaypoint)
    SetBlipRouteColour(blip, color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(BlipLabel)
    EndTextCommandSetBlipName(blip)
    return blip
end

---@param x number
---@param y number
---@param z number
---@param type number
---@param scale number
---@param colour number
---@param enableWaypoint boolean
---@param BlipLabel string 
---@param shortRange boolean
---@return number
function Game.AddRadiusBlip(x, y, z, type, scale, colour, enableWaypoint, BlipLabel, shortRange)
    local blip = AddBlipForRadius(x, y, z, 0)
    SetBlipSprite(blip, type)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, shortRange)
    SetBlipRoute(blip, enableWaypoint)
    SetBlipRouteColour(blip, colour)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(BlipLabel)
    EndTextCommandSetBlipName(blip)
    return blip
end

---@param ped number
---@param targetCoords vector3
---@param distance number
---@param reverse boolean
---@return boolean
function Game.IsNearCoords(ped, targetCoords, distance, reverse)
    local coords = GetEntityCoords(ped)
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    local dist = Vdist(coords, targetCoords)

    return reverse and (dist >= distance) or (dist <= distance)
end

---@param modelHash number
---@param x number
---@param y number
---@param z number
---@return number
function Game.SpawnObjectAtCoords(modelHash, x, y, z, h, isNetwork)
    if type(x) == "vector3" or type(x) == "vector4" then
        isNetwork = y
        x, y, z, h = table.unpack(x)

        if not h then
            h = math.random(0, 360)
        end
    end

    if type(x) == " vector4" then
        isNetwork = y
        x, y, z, h = table.unpack(x)
    end

    RequestModel(modelHash)
    repeat Wait(10) until HasModelLoaded(modelHash)

    local object <const> = CreateObjectNoOffset(modelHash, x, y, z, isNetwork, false, true)

    
    SetEntityHeading(object, h)
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object, true)
    SetModelAsNoLongerNeeded(modelHash)

    return object
end

---@param animDict string
---@param animName string
---@param flag number
function Game.PlayAnimation(animDict, animName, flag)
    local ped = GetPlayerPed(-1)
    ClearPedTasksImmediately(ped)
    RequestAnimDict(animDict)
    repeat Wait(10) until HasAnimDictLoaded(animDict)

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, flag, 0, false, false, false)
end

---@param entity number
---@return table
function Game.GetForwardField(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 1.0, y = math.sin(hr) * 1.0 }
end

---@param entity number
---@param multiplier number
---@return table
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
---@return boolean
function Game.GetDistance(ped, targetCoords, distance)
    local coords = GetEntityCoords(ped)
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local dist = Vdist(coords, targetCoords)
    return dist <= distance
end

--- returns if a ped is near Water
---@param ped? number
function Game.IsNearWater(ped)
    local ped <const> = ped or PlayerPedId()
    
    local heading = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, -25.0)
    local water, coords = TestProbeAgainstWater(heading.x, heading.y, heading.z, offset.x, offset.y, offset.z)

    return water, coords
end

Game.Location = {}

---@class Location
---@param coords vector3 | vector4
---@param firstDistance number
---@param secondDistance number
---@param marker boolean | function
---@param functions table | nil
---@param condition function | nil
---@param heavyOptimization boolean | nil (not recomended)
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
        returnedCondition = true,
        active = true
    }

    setmetatable(self, {__index = Game.Location})

    function self:isNearCoords(coord, distance)
        local playerCoords = GetEntityCoords(PlayerPedId())
        return #(playerCoords - vec3(coord.x, coord.y, coord.z)) <= distance
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

                if not self.isInside and self.isNearSecondCoord then
                    self.isInside = true
                    if self.functions and self.functions.onEnter then
                        self.functions.onEnter({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                if self.isInside then
                    if self.functions and self.functions.inside then
                        self.functions.inside({
                            coords = self.coords,
                            firstDistance = self.firstDistance,
                            secondDistance = self.secondDistance,
                            self = self
                        })
                    end
                end

                if self.isInside and not self.isNearSecondCoord then
                    self.isInside = false

                    if self.functions and self.functions.onExit then
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