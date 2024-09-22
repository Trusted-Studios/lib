-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua started");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

---@class Callback
---@meta:
--- credits: https://github.com/esx-framework/esx_core/blob/main/%5Bcore%5D/es_extended/client/modules/callback.lua
Callback = {
    requestId = 0,
    serverRequests = {}
}

---@param eventName string
---@param callback function
---@param ... any
function Callback:Trigger(eventName, callback, ...)
    self.serverRequests[self.requestId] = callback

    TriggerServerEvent('Trusted:TriggerServerCallback', eventName, self.requestId, GetCurrentResourceName() or "unknown", ...)

    self.requestId += 1
end

RegisterNetEvent('Trusted:RegisterServerCallback', function(requestId, invoker, ...)

    if GetCurrentResourceName() ~= invoker then
        return
    end

    if not Callback.serverRequests[requestId] then
        return print(('[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
    end

    Callback.serverRequests[requestId](...)
    Callback.serverRequests[requestId] = nil
end)