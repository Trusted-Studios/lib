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
    ---@type string | number, string | number, any
    local data = Async.Await(function(promise)
        RegisterNuiCallback('confirm:table', function(data, cb)
            promise:resolve(data)
            cb(true)
        end)
    end)

    if type(func) ~= 'function' then
        error('Invalid function passed to Table:HandleSelection')
    end

    func(data.item, data.index, data.misc)
end

function Web.Table:Close()
    Web:Close('table')
end

RegisterNuiCallback('close:table', function(data, cb)
    Web:Close('table')
    cb(true)
end)