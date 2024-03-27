---@diagnostic disable: duplicate-set-field, redefined-local
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

---@class Text
Text = {}

---@param x number
---@param y number
---@param width number
---@param height number
---@param scale number
---@param text string
---@param r number
---@param g number
---@param b number
---@param a number
---@meta:
--- Renders basic text on the screen.
function Text.DisplayText(x, y, width, height, scale, text, r, g, b, a)
    local x, y, width, height = (tonumber(x) or 0) / 1920, (tonumber(y) or 0) / 1080, (tonumber(width) or 0) / 1920, (tonumber(height) or 0) / 1080
    SetTextFont(4)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x + width * 0.5, y + height * 0.5)
end

---@param x number
---@param y number
---@param width number
---@param height number
---@param scale number
---@param text string
---@param r number
---@param g number
---@param b number
---@param a number
---@param textWrap number
---@meta:
--- Renders basic text on the screen with a set text wrap.
function Text.MinimalTextDisplay(x, y, width, height, scale, text, r, g, b, a, textWrap)
    local x, y, width, height = (tonumber(x) or 0) / 1920, (tonumber(y) or 0) / 1080, (tonumber(width) or 0) / 1920, (tonumber(height) or 0) / 1080
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow()
    SetTextEntry("STRING")
    SetTextWrap(0.0, textWrap)
    SetTextJustification(2)
    AddTextComponentString(text)
    DrawText(x + width, y + height)
end
