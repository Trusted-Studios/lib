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

Web.NumberModal = {}

---@class NumberModal
---@field description string
---@field confirm string
---@field rangeLabel string
---@field range {min: number, max: number}
---@field misc any


---@param data NumberModal
function Web.NumberModal:Open(data)
    Web:Open('numberModal', true, true, data)
end

---@param func fun(count: number, misc: any)
function Web.NumberModal:HandleSelection(func)
    ---@type number, any
    local count, misc = Async.Await(function(promise)
        RegisterNuiCallback('confirm:numberModal', function(data, cb)
            promise:resolve(data.count, data.misc)
            cb(true)
        end)
    end)

    if type(func) ~= 'function' then
        error('Invalid function passed to NumberModal:HandleSelection')
    end

    func(count, misc)
end

RegisterNuiCallback('close:numberModal', function(data, cb)
    Web:Close('numberModal')
    cb(true)
end)