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
---@field dismissable boolean
---@field misc any

---@param data WarningItem
function Web.Warning:Open(data)
    Web:Open('warning', true, true, data)
end

---@param func fun(accepted: boolean, misc: any)
function Web.Warning:HandleSelection(func)
    if type(func) ~= 'function' then
        error('Invalid function passed to Warning:HandleSelection')
    end

    ---@type boolean, any
    RegisterNuiCallback('handle:warning', function(data, cb)
        CreateThread(function()
            func(data.accepted, data.other)
        end)

        cb(true)
    end)
end

RegisterNuiCallback('close:warning', function(data, cb)
    Web:Close('warning')
    cb(true)
end)