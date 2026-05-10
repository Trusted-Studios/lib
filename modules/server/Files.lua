-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted?.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[SERVER - DEBUG] ^0: "..filename()..".lua started");
end
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Files = {}

---@param fileName string
---@return table | nil, string | nil
function Files.ReadJSON(fileName)
    local fileContent = LoadResourceFile(GetCurrentResourceName(), fileName)

    if not fileContent then
        return nil, ('File not found: %s'):format(fileName)
    end

    local success, data = pcall(json.decode, fileContent)

    if not success or not data then
        return nil, ('Invalid JSON in file: %s'):format(fileName)
    end

    return data, nil
end

---@param fileName string
---@param content table
---@return boolean, string | nil
function Files.WriteJSON(fileName, content)
    local success = SaveResourceFile(GetCurrentResourceName(), fileName, json.encode(content), -1)

    if not success then 
        local errorMessage = ('File could not be saved: %s'):format(fileName)
        print(('[ERROR] - %s'):format(errorMessage))
        return false, errorMessage
    end

    return true, nil
end
