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

Table = {}

---@param _table table
---@param keysToKeep table<string>
---@return table
function Table.RemoveAllExcept(_table, keysToKeep)
    local remainingData = {}

    for key, value in pairs(_table) do
        local shouldRemove = true
        for _, keepKey in ipairs(keysToKeep) do
            if key == keepKey then
                shouldRemove = false
                break
            end
        end
        if not shouldRemove then
            remainingData[key] = value
        end
    end

    return remainingData
end

---@param array table
---@param left number
---@param right number
---@param pivotIndex number
---@return number
function Table.Partition(array, left, right, pivotIndex)
    local pivotValue = array[pivotIndex]
    array[pivotIndex], array[right] = array[right], array[pivotIndex]

    local storeIndex = left

    for i = left, right - 1 do
        if array[i] <= pivotValue then
            array[i], array[storeIndex] = array[storeIndex], array[i]
            storeIndex = storeIndex + 1
        end
    end
    array[storeIndex], array[right] = array[right], array[storeIndex]
    return storeIndex
end

---@param array table
---@param left number
---@param right number
function Table.QuickSort(array, left, right)
    if right > left then
        local pivotNewIndex = Table.Partition(array, left, right, left)
        Table.QuickSort(array, left, pivotNewIndex - 1)
        Table.QuickSort(array, pivotNewIndex + 1, right)
    end

    return array
end

---@param table table
---@return table
function Table.Shuffle(table)
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