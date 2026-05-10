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

Random = {
    numberCharset = {},
    charset = {},
    seeded = false
}

function Random:init()
    if self.seeded then
        return
    end

    math.randomseed(GetGameTimer and GetGameTimer() or os.time())

    for i = 48, 57 do 
        table.insert(self.numberCharset, string.char(i)) 
    end
    
    for i = 65, 90 do 
        table.insert(self.charset, string.char(i)) 
    end
    
    for i = 97, 122 do 
        table.insert(self.charset, string.char(i)) 
    end

    self.seeded = true
end

---@param charset table
---@param length number
---@return string
function Random:FromCharset(charset, length)
    local result = {}

    for i = 1, length do
        result[i] = charset[math.random(1, #charset)]
    end

    return table.concat(result)
end

---@param length number
---@return string
function Random:Letter(length)
    return self:FromCharset(self.charset, length)
end

---@param length number
---@return string
function Random:Number(length)
    return self:FromCharset(self.numberCharset, length)
end

Random:init()
