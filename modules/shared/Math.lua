---@diagnostic disable: duplicate-set-field
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

    return coords + vec4(math.cos(angle) * (forwardMultiplier or 1), math.sin(angle) * (forwardMultiplier or 1), 0, 0)
end

---@param array table
---@param left number
---@param right number
---@param pivotIndex number
---@return number
function Math.Partition(array, left, right, pivotIndex)
    local pivotValue = array[pivotIndex]
	array[pivotIndex], array[right] = array[right], array[pivotIndex]

	local storeIndex = left

	for i = left, right - 1 do
    	if array[i] <= pivotValue then
	        array[i], array[storeIndex] = array[storeIndex], array[i]
	        storeIndex = storeIndex + 1
		end
		array[storeIndex], array[right] = array[right], array[storeIndex]
	end
    return storeIndex
end

---@param array table
---@param left number
---@param right number
function Math.QuickSort(array, left, right)
    if right > left then
	    local pivotNewIndex = Math.Partition(array, left, right, left)
	    Math.QuickSort(array, left, pivotNewIndex - 1)
	    Math.QuickSort(array, pivotNewIndex + 1, right)
	end
end

---@param table table
---@return table
function Math.Shuffle(table)
    local shuffledTable = {}

    for i = 1, #table do
        shuffledTable[i] = table[i]
    end

    for i = #table, 2, -1 do
        local randomIndex = math.random(i)
        shuffledTable[i], shuffledTable[randomIndex] = shuffledTable[randomIndex], shuffledTable[i]
    end

    return shuffledTable
end