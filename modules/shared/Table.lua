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