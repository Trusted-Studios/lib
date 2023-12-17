---@diagnostic disable: duplicate-set-field
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
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

---@param h number
---@param multiplier number
---@return table
function Math.GetForwardFieldWithHeading(h, multiplier)
    local hr = h + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * (multiplier or 1.0), y = math.sin(hr) * 1.0 }
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

---@param t table
---@return table
function Math.Shuffle(t)
    local s = {}
    for i = 1, #t do s[i] = t[i] end
    for i = #t, 2, -1 do
        local j = math.random(i)
        s[i], s[j] = s[j], s[i]
    end
    return s
end