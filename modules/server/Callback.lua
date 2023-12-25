-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[SERVER - DEBUG] ^0: "..filename()..".lua gestartet");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Callback = {
    serverCallbacks = {}
}

function Callback:Register(eventName, callback)
    self.serverCallbacks[eventName] = callback
end

RegisterNetEvent('Trusted:TriggerServerCallback', function(eventName, requestId, invoker, ...)
    if not Callback.serverCallbacks[eventName] then
        return print(('[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end

    local source = source

    Callback.serverCallbacks[eventName](source, function(...)
        TriggerClientEvent('Trusted:RegisterServerCallback', source, requestId, invoker, ...)
    end, ...)
end)