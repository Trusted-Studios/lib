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

---@param coords vector4
---@param forwardMultiplier number
---@param angleMultiplier? number
---@return vector3 | vector4
function Math.GetForwardFromCoords(coords, forwardMultiplier, angleMultiplier)
    local x, y, z, h
    if type(coords) == 'vector4' then
        x, y, z, h = table.unpack(coords)
    end

    if not x and not y and not z and not h then
        print '^1[WARNING]^0 - Unable to unpack given coords.'
        return coords
    end

    local headingRightOffset = h + (angleMultiplier or 90.0)

    if headingRightOffset < 0.0 then
        headingRightOffset += 360.0
    end

    local angle <const> = headingRightOffset * 0.0174533

    return coords + vector4(math.cos(angle) * (forwardMultiplier or 1), math.sin(angle) * (forwardMultiplier or 1), 0, 0)
end