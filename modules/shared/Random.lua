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
    charset = {}
}

function Random:init()
    for i = 48, 57 do 
        table.insert(self.numberCharset, string.char(i)) 
    end
    
    for i = 65, 90 do 
        table.insert(self.charset, string.char(i)) 
    end
    
    for i = 97, 122 do 
        table.insert(self.charset, string.char(i)) 
    end
end

function Random:Letter(length)
    math.randomseed(GetGameTimer())
    return (length > 0) and (self:Letter(length - 1) .. self.charset[math.random(1, #self.charset)]) or ''
end

function Random:Number(length)
    math.randomseed(GetGameTimer())
    return (length > 0) and (self:Number(length - 1) .. self.numberCharset[math.random(1, #self.numberCharset)]) or ''
end

Random:init()