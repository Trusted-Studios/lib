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

Web.Warning = {}

---@class WarningItem
---@field description string
---@field accept string
---@field decline string
---@field misc any

---@param data WarningItem
function Web.Warning:Open(data)
    Web:Open('warning', true, true, data)
end

---@param func fun(accepted: boolean, misc: any)
function Web.Warning:HandleSelection(func)
    ---@type boolean, any
    local accepted, misc = Async.Await(function(promise)
        RegisterNuiCallback('confirm:warning', function(data, cb)
            promise:resolve(data.accepted, data.misc)
            cb(true)
        end)
    end)

    if type(func) ~= 'function' then
        error('Invalid function passed to Warning:HandleSelection')
    end

    func(accepted, misc)
end