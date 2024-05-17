-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted?.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[SHARED - DEBUG] ^0: "..filename()..".lua started");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

---@class Math
Math = {}

---@param int number
---@return string
function Math.DecimalsToMinutes(int)
    local ms = tonumber(int)
    local sec = ms % 60
    if sec < 10 then
        return math.floor(ms / 60) .. ":0" .. sec
    else
        return math.floor(ms / 60) .. ":" .. sec
    end
end

---@param int number
---@return integer
function Math.Round(int)
    return int >= 0 and math.floor(int + 0.5) or math.ceil(int - 0.5)
end


local angles <const> = {
    ['front'] = 90.0,
    ['back'] = 270.0,
    ['right'] = 0.0,
    ['left'] = 180.0
}

---@param coords vector4
---@param forwardMultiplier number
---@param angleMultiplier? number | string
---@return vector4
function Math.GetForwardFromCoords(coords, forwardMultiplier, angleMultiplier)
    local x, y, z, h
    if type(coords) == 'vector4' then
        x, y, z, h = table.unpack(coords)
    end

    if not x and not y and not z and not h then
        print '^1[WARNING]^0 - Unable to unpack given coords.'
        return coords
    end

    local angledHeading = h + (angles[angleMultiplier] or angleMultiplier or 90.0)

    if angledHeading < 0.0 then
        angledHeading += 360.0
    end

    local angle <const> = angledHeading * (math.pi / 180.0)

    return coords + vector4(math.cos(angle) * (forwardMultiplier or 1), math.sin(angle) * (forwardMultiplier or 1), 0, 0)
end

---@param pos vector3 | vector4
---@param angle number
---@param distance number
---@return vector3
function Math.GetOffsetPositionByAngle(pos, angle, distance)
    local angleRad = angle * 2.0 * math.pi / 360.0
    return vector3(
        pos.x - distance * math.sin(angleRad),
        pos.y + distance * math.cos(angleRad),
        pos.z
    )
end

---@param vec3 vector3
---@param h number?
---@return vector4
function Math.Vec3ToVec4(vec3, h)
    return vector4(vec3.x, vec3.y, vec3.z, h or 0)
end

---@param vec4 vector4
---@return vector3
function Math.Vec4ToVec3(vec4)
    return vector3(vec4.x, vec4.y, vec4.z)
end