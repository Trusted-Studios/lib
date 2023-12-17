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

---@class Node 
Node = {}

---@param array table
---@param target number
---@return boolean | nil
function Node.BinarySearch(array, target)
    local root <const> = array
    local firstIndex = 1
    local lastIndex = #root
    local midIndex = math.floor((firstIndex + lastIndex) / 2)
    while firstIndex <= lastIndex do
        if root[midIndex] < target then
            firstIndex = midIndex + 1
        elseif root[midIndex] == target then
            return true
        elseif root[midIndex] > target then
            lastIndex = midIndex - 1
        end
        midIndex = math.floor((firstIndex + lastIndex) / 2)
    end
    if firstIndex > lastIndex then
        return false
    end
end

---@param array table
---@param target number 
---@return number | nil
function Node.GetIndexFromValue(array, target)
    local root <const> = array
    local firstIndex = 1
    local lastIndex = #root
    local midIndex = math.floor((firstIndex + lastIndex) / 2)
    while firstIndex <= lastIndex do
        if root[midIndex] < target then
            firstIndex = midIndex + 1
        elseif root[midIndex] == target then
            return midIndex
        elseif root[midIndex] > target then
            lastIndex = midIndex - 1
        end
        midIndex = math.floor((firstIndex + lastIndex) / 2)
    end
    if firstIndex > lastIndex then
        return nil
    end
end
