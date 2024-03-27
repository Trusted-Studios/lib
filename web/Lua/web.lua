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

Web = {
    components = {}
}

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

    self.components[component] = {
        visible = true
    }
end

function Web:Trigger(component, ...)
    SendNUIMessage({
        action = 'trigger:'..component,
        data = ...
    })
end

function Web:Close(component)
    SendNUIMessage({
        action = 'close:'..component
    })

    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)

    self.components[component] = nil
end

function Web:DisableNUIEffects(component)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)

    self.components[component] = nil
end

function Web:IsComponentOpen(component)
    return self.components[component]?.visible
end

RegisterNUICallback('close', function(data, cb)

    -- Gibt gerade keinen anderen Weg.. #Web.components gibt immer nur 0 zurück.
    local lenght = 0
    for component, data in pairs(Web.components) do
        lenght += 1
    end

    if lenght <= 1 then
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(0)
    end

    Web.components[data.component] = nil

    cb(true)
end)