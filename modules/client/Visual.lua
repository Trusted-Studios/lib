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

---@class Visual
Visual = {}

---@param text string
---@meta:
--- Is used with ShowHelpLongString to increase the string length.
function Visual.AddLongString(text)
    for i = 100, string.len(text), 99 do
        local sub = string.sub(text, i, i + 99)
        AddTextComponentSubstringPlayerName(sub)
    end
end

---@param text string
---@param bleep boolean
---@meta:
--- Adds a basic GTA help notification in the top left side of screen.
function Visual.ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

---@param text string
---@param bleep boolean
---@meta:
--- Adds a basic GTA help notification in the top left side of screen. Can display an infinite string length.
function Visual.ShowHelpLongString(text, bleep)
    BeginTextCommandDisplayHelp("jamyfafi")
    AddTextComponentSubstringPlayerName(text)
    Visual.AddLongString(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

---@param text string
---@param time number
---@meta:
--- Adds a basic GTA bottom print.
function Visual.BottomText(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

---@param displayText string
---@param bitLenght number
---@return string | nil
---@meta:
--- Basic GTA input field.
function Visual.InputBox(displayText, bitLenght)
    AddTextEntry(displayText, displayText)
    DisplayOnscreenKeyboard(1, displayText, "", "", "", "", "", bitLenght)
    
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0);
        DisableAllControlActions(0);
    end

    return GetOnscreenKeyboardResult()
end

---@param text string
---@meta:
--- Simple GTA notification without any fancy stuff. Just text.
function Visual.Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

---@param textureDict string
---@param textureName string
---@param title string
---@param subtitle string
---@param text string
---@meta:
--- Displays GTA notification with an icon.
function Visual.IconNotify(textureDict, textureName, title, subtitle, text)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(text);
	SetNotificationMessage(textureDict, textureName, false, 0, title, subtitle);
	DrawNotification(false, true);
end

---@param message string
---@param gainedRP number
---@param color number
---@meta:
--- Displays GTA notification with a mugshot of the player.
function Visual.MugNotify(message, gainedRP, color)
    local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end
    local txd = GetPedheadshotTxdString(handle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentString(message)
    EndTextCommandThefeedPostAward(txd, txd, gainedRP, color, "FM_GEN_UNLOCK")
    UnregisterPedheadshot(handle)
end

---@param txdDict string
---@param txdName string
---@param x number
---@param y number
---@param width number
---@param height number
---@param heading number
---@param r number
---@param g number
---@param b number
---@param a number
---@meta:
--- Renders new sprite.
function Visual.RenderSprite(txdDict, txdName, x, y, width, height, heading, r, g, b, a)
    local x, y, width, height = (tonumber(x) or 0) / 1920, (tonumber(y) or 0) / 1080, (tonumber(width) or 0) / 1920, (tonumber(height) or 0) / 1080
    if not HasStreamedTextureDictLoaded(txdDict) then
        RequestStreamedTextureDict(txdDict, true)
    end
    DrawSprite(txdDict, txdName, x + width * 0.5, y + height * 0.5, width, height, heading or 0, tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255, tonumber(a) or 255)
end

---@param x number
---@param y number
---@param width number
---@param height number
---@param r number
---@param g number
---@param b number
---@param a number
---@meta:
--- Draws a new progress bar.
function Visual.DrawProgressBar(x, y, width, height, r, g, b, a)
    local x, y, width, height = (tonumber(x) or 0) / 1920, (tonumber(y) or 0) / 1080, (tonumber(width) or 0) / 1920, (tonumber(height) or 0) / 1080
    DrawRect(x + width * 0.5, y + height * 0.5, width, height, tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255, tonumber(a) or 255)
end

---@param text string
---@param coords table | vec3
---@meta:
--- Renders 3d text.
function Visual.Draw3DText(text, coords)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)

    local scale = 200 / (GetGameplayCamFov() * dist)

    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    local x, y, z = table.unpack(coords)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

---@param offsetX number
---@return number
--- Is used to properly set the screen x coordinates of an native element based on the active screen resolution.
function Visual.DynamicScreen(offsetX)
    local ScreenWidth, ScreenHeight = GetActiveScreenResolution()
    local x = offsetX
    if ScreenWidth <= 1920 and ScreenHeight <= 1080 then
        x = (ScreenWidth * (offsetX / ScreenWidth))
    else
        x = 1920 * (offsetX / ScreenWidth)
    end
    return x
end