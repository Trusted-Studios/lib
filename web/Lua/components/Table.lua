-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted?.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua started");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Web.Table = {}

---@class TableItem
---@field text {header: string, description: string}
---@field tableData {header: string[], body: string[]}
---@field items table<string | number>
---@field searchItem string
---@field misc any

---@param data TableItem
function Web.Table:Open(data)
    Web:Open('table', true, true, data)
end

---@param func fun(item: string | number, index: string | number, misc: any)
function Web.Table:HandleSelection(func)
    if type(func) ~= 'function' then
        error('Invalid function passed to Table:HandleSelection')
    end
    
    RegisterNuiCallback('confirm:table', function(data, cb)
        func(data.item, data.index, data.misc)
        cb(true)
    end)
end

function Web.Table:Close()
    Web:Close('table')
end

RegisterNuiCallback('close:table', function(data, cb)
    Web:Close('table')
    cb(true)
end)