---@diagnostic disable: duplicate-set-field, redefined-local
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[CLIENT - DEBUG] ^0: "..filename()..".lua started");
end

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Web = {}

function Web:Open(component, bluredBackground, focus, ...)
    if bluredBackground then
        TriggerScreenblurFadeIn(0)
    end

    if focus then
        SetNuiFocus(true, true)
    end

    SendNUIMessage({
        action = "open:"..component,
        data = ...
    })

    self[component] = {
        visible = true
    }
end

function Web:Close(component)
    SendNUIMessage({
        action = 'close:'..component
    })

    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)

    self[component] = nil
end

function Web:DisableNUIEffects(component)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)

    self[component] = nil
end

function Web:IsComponentOpen(component)
    return self[component]?.visible
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)

    Web[data.component] = nil

    cb(true)
end)