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
---@return table | string
function Files.ReadJSON(fileName)
    local fileContent = LoadResourceFile(GetCurrentResourceName(), fileName)

    return json.decode(fileContent) or 'File not found'
end

---@param fileName string
---@param content table
function Files.WriteJSON(fileName, content)
    local success = SaveResourceFile(GetCurrentResourceName(), fileName, json.encode(content), -1)

    if not success then 
        print('[ERROR] - file could not be saved')
    end
end