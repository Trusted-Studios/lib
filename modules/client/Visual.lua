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

function Visual.AddLongString(str)
    for i = 100, string.len(str), 99 do
        local sub = string.sub(str, i, i + 99)
        AddTextComponentSubstringPlayerName(sub)
    end
end

function Visual.ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

function Visual.ShowHelpLongString(text, bleep)
    BeginTextCommandDisplayHelp("jamyfafi")
    AddTextComponentSubstringPlayerName(text)
    Visual.AddLongString(text) 
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

function Visual.ShowHelpAdvanced(text, text_2, text_3, bleep)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    AddTextComponentSubstringPlayerName(text_2)
    AddTextComponentSubstringPlayerName(text_3)
    EndTextCommandDisplayHelp(0, false, bleep, 0)
end

function Visual.BottomText(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

function Visual.InputBox(DisplayText, bitLenght)
    AddTextEntry(DisplayText, DisplayText)
    DisplayOnscreenKeyboard(1, DisplayText, "", "", "", "", "", bitLenght)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    local result
    if (GetOnscreenKeyboardResult()) then
        result = GetOnscreenKeyboardResult()
    end
    return result
end

function Visual.Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function Visual.NewNotify(image, title, subtitle, text)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(text);
	SetNotificationMessage(image, image, false, 0, title, subtitle);
	DrawNotification(false, true);
end

function Visual.MugNotify(message, GainedRP, color)
    local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Wait(0)
    end
    local txd = GetPedheadshotTxdString(handle)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentString(message)
    EndTextCommandThefeedPostAward(txd, txd, GainedRP, color, "FM_GEN_UNLOCK")
    UnregisterPedheadshot(handle)
end

function Visual.ScreenFade(time)
    DoScreenFadeOut(1000)
    Wait(time)
    DoScreenFadeIn(1000)
end

function Visual.RenderSprite(TextureDictionary, TextureName, X, Y, Width, Height, Heading, R, G, B, A)
    local X, Y, Width, Height = (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080, (tonumber(Width) or 0) / 1920, (tonumber(Height) or 0) / 1080
    if not HasStreamedTextureDictLoaded(TextureDictionary) then
        RequestStreamedTextureDict(TextureDictionary, true)
    end
    DrawSprite(TextureDictionary, TextureName, X + Width * 0.5, Y + Height * 0.5, Width, Height, Heading or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

function Visual.drawProgressBar(x, y, width, height, colour, percent)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)
    local w = width * (percent / 100)
    local x = (x - (width * (percent / 100)) / 2) - width / 2
    DrawRect(x + w, y, w, height, colour[1], colour[2], colour[3], colour[4])
end

function Visual.DrawProgressBar(x, y, width, height, r, g, b, a)
    local x, y, width, height = (tonumber(x) or 0) / 1920, (tonumber(y) or 0) / 1080, (tonumber(width) or 0) / 1920, (tonumber(height) or 0) / 1080
    DrawRect(x + width * 0.5, y + height * 0.5, width, height, tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255, tonumber(a) or 255)
end

function Visual.draw3dText(text, coords)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)

    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    ---@diagnostic disable-next-line: missing-parameter
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

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
