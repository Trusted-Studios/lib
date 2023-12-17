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

---@class Scaleform 
local Scaleform <const> = {
    showMQ = false,
    showMI = false,
    showST = false,
    showPW = false,
}

function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Wait(0)
    end
    return scaleform_handle
end

function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end

---@class ScaleformTimer
ScaleformTimer = {
    ['ShowBanner'] = {isShown = false, timer = 0},
    ['ShowSplashText'] = {isShown = false, timer = 0},
    ['ShowResultsPanel'] = {isShown = false, timer = 0},
    ['showMissionQuit'] = {isShown = false, timer = 0},
    ['showPopupWarning'] = {isShown = false, timer = 0},
    ['showCountdown'] = {isShown = false, timer = 0},
    ['showMidsizeBanner'] = {isShown = false, timer = 0},
    ['showSaving'] = {isShown = false, timer = 0},
}


function ScaleformTimer.ShowBanner(_text1, _text2)
    local scaleform = Scaleform.Request('MP_BIG_MESSAGE_FREEMODE')

    Scaleform.CallFunction(scaleform, false, "SHOW_SHARD_CENTERED_MP_MESSAGE")
    Scaleform.CallFunction(scaleform, false, "SHARD_SET_TEXT", _text1, _text2, 0)

    return scaleform
end

function ScaleformTimer.ShowSplashText(_text1, _fadeout)
    CreateThread(function()
        local function drackSplashText(text1, fade)
            local scaleform = Scaleform.Request('SPLASH_TEXT')

            Scaleform.CallFunction(scaleform, false, "SET_SPLASH_TEXT", text1, 5000, 255, 255, 255, 255)
            Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_LABEL", text1, 255, 255, 255, 255)
            Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_COLOR", 255, 255, 255, 255)
            Scaleform.CallFunction(scaleform, false, "SPLASH_TEXT_TRANSITION_OUT", fade, 0)

            return scaleform
        end
        local scale = drackSplashText(_text1, _fadeout)
        while Scaleform.showST do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function ScaleformTimer.ShowResultsPanel(_title, _subtitle, _slots)
    local scaleform = Scaleform.Request('MP_RESULTS_PANEL')

    Scaleform.CallFunction(scaleform, false, "SET_TITLE", _title)
    Scaleform.CallFunction(scaleform, false, "SET_SUBTITLE", _subtitle)

    for i, k in ipairs(_slots) do
        Scaleform.CallFunction(scaleform, false, "SET_SLOT", i, _slots[i].state, _slots[i].name)
    end
    return scaleform
end

function ScaleformTimer.ShowMissionInfoPanel(_data, _x, _y, _width)
    CreateThread(function()
        local function drawMissionInfo(data)
            local scaleform = Scaleform.Request('MP_MISSION_NAME_FREEMODE')

            Scaleform.CallFunction(scaleform, false, "SET_MISSION_INFO", data.name, data.type, "", data.percentage, "", data.rockstarVerified, data.playersRequired, data.rp, data.cash, data.time)

            return scaleform
        end
        local scale = drawMissionInfo(_data)
        while Scaleform.showMI do
            Wait(1)
            local x = 0.5
            local y = 0.5
            local width = 0.5
            local height = width / 0.65
            DrawScaleformMovie(scale, x, y, width, height, 255, 255, 255, 255, 0)
        end
    end)
end

function ScaleformTimer.ShowMissionQuit(_title, _subtitle, _duration)
    CreateThread(function()
        local function drawScale(title, subtitle, duration)
            local scaleform = Scaleform.Request('MISSION_QUIT')

            Scaleform.CallFunction(scaleform, false, "SET_TEXT", title, subtitle)
            Scaleform.CallFunction(scaleform, false, "TRANSITION_IN", 0)
            Scaleform.CallFunction(scaleform, false, "TRANSITION_OUT", 3000)

            return scaleform
        end
        
        local scale = drawScale(_title, _subtitle, _duration)
        while Scaleform.showMQ do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function ScaleformTimer.ShowPopupWarning(_title, _subtitle, _errorCode)
    CreateThread(function()
        local function drawPopup(title, subtitle, errorCode)
            local scaleform = Scaleform.Request('POPUP_WARNING')

            Scaleform.CallFunction(scaleform, false, "SHOW_POPUP_WARNING", 500.0, title, subtitle, "", true, 0, _errorCode)

            return scaleform
        end
        local scale = drawPopup(_title, _subtitle, _errorCode)
        while Scaleform.showPW do
            Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255, 0)
        end
    end)
end

function ScaleformTimer.ShowCountdown(_number, _r, _g, _b)
    local scaleform = Scaleform.Request('COUNTDOWN')

    Scaleform.CallFunction(scaleform, false, "SET_MESSAGE", _number, _r, _g, _b, true)
    Scaleform.CallFunction(scaleform, false, "FADE_MP", _number, _r, _g, _b)

    return scaleform
end

function ScaleformTimer.ShowMidsizeBanner(_title, _subtitle, _bannerColor)
    local scaleform = Scaleform.Request('MIDSIZED_MESSAGE')

    Scaleform.CallFunction(scaleform, false, "SHOW_COND_SHARD_MESSAGE", _title, _subtitle, _bannerColor, true)

    return scaleform
end

function ScaleformTimer.ShowCredits(_role, _name, _x, _y)
    CreateThread(function()
        local function drawCredits(role, name)
            local scaleform = RequestScaleformMovie("OPENING_CREDITS")
            while not HasScaleformMovieLoaded(scaleform) do
                Wait(0)
            end

            Scaleform.CallFunction(scaleform, false, "TEST_CREDIT_BLOCK", role, name, 'left', 0.0, 50.0, 1, 5, 10, 10)
            
            return scaleform
        end
        local scale = drawCredits(_role, _name)
        ---@diagnostic disable-next-line: undefined-global
        while ShowCreditsBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovie(scale, _x, _y, 0.71, 0.68, 255, 255, 255, 255)
        end
    end)
end

function ScaleformTimer.ShowHeist(ZinitialText, Ztable, Zmoney, Zxp)
    CreateThread(function()
        local function drawHeist(_initialText, _table, _money, _xp)
            local scaleform = Scaleform.Request('HEIST_CELEBRATION')
            local scaleform_bg = Scaleform.Request('HEIST_CELEBRATION_BG')
            local scaleform_fg = Scaleform.Request('HEIST_CELEBRATION_FG')

            local scaleform_list = {
                scaleform,
                scaleform_bg,
                scaleform_fg
            }

            for key, scaleform_handle in pairs(scaleform_list) do
                Scaleform.CallFunction(scaleform_handle, false, "CREATE_STAT_WALL", 1, "HUD_COLOUR_FREEMODE_DARK", 1)
                Scaleform.CallFunction(scaleform_handle, false, "ADD_BACKGROUND_TO_WALL", 1, 80, 1)
    
                Scaleform.CallFunction(scaleform_handle, false, "ADD_MISSION_RESULT_TO_WALL", 1, _initialText.missionTextLabel, _initialText.passFailTextLabel, _initialText.messageLabel, true, true, true)
    
                if _table[1] ~= nil then
                    Scaleform.CallFunction(scaleform_handle, false, "CREATE_STAT_TABLE", 1, 10)
    
                    for i, k in pairs(_table) do
                        Scaleform.CallFunction(scaleform_handle, false, "ADD_STAT_TO_TABLE", 1, 10, _table[i].stat, _table[i].value, true, true, false, false, 0)
                    end
    
                    Scaleform.CallFunction(scaleform_handle, false, "ADD_STAT_TABLE_TO_WALL", 1, 10)
                end
    
                if _money.startMoney ~= _money.finishMoney then
                    Scaleform.CallFunction(scaleform_handle, false, "CREATE_INCREMENTAL_CASH_ANIMATION", 1, 20)
                    Scaleform.CallFunction(scaleform_handle, false, "ADD_INCREMENTAL_CASH_WON_STEP", 1, 20, _money.startMoney, _money.finishMoney, _money.topText, _money.bottomText, _money.rightHandStat, _money.rightHandStatIcon, 0)
                    Scaleform.CallFunction(scaleform_handle, false, "ADD_INCREMENTAL_CASH_ANIMATION_TO_WALL", 1, 20)
                end
    
                if _xp.xpGained ~= 0 then
                    Scaleform.CallFunction(scaleform_handle, false, "ADD_REP_POINTS_AND_RANK_BAR_TO_WALL", 1, _xp.xpGained, _xp.xpBeforeGain, _xp.minLevelXP, _xp.maxLevelXP, _xp.currentRank, _xp.nextRank, _xp.rankTextSmall, _xp.rankTextBig)
                end
    
                Scaleform.CallFunction(scaleform_handle, false, "SHOW_STAT_WALL", 1)
                Scaleform.CallFunction(scaleform_handle, false, "createSequence", 1, 1, 1)
            end

            return scaleform, scaleform_bg, scaleform_fg
        end
        local scale, scale_bg, scale_fg = drawHeist(ZinitialText, Ztable, Zmoney, Zxp)
        ---@diagnostic disable-next-line: undefined-global
        while ShowHeistBanner do
            Wait(1)
            DrawScaleformMovieFullscreenMasked(scale_bg, scale_fg, 255, 255, 255, 50)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
        ---@diagnostic disable-next-line: missing-parameter
        StartScreenEffect("HeistCelebToast")
    end)
end

function ScaleformTimer.ChangePauseMenuTitle(title)
    AddTextEntry('FE_THDR_GTAO', title)
end

function ScaleformTimer.ShowSaving(_subtitle)
    CreateThread(function()
        local function drawScale(string1)
            local scaleform = Scaleform.Request('HUD_SAVING')

            Scaleform.CallFunction(scaleform, false, "SET_SAVING_TEXT_STANDALONE", 1, string1)
            Scaleform.CallFunction(scaleform, false, "SHOW")

            return scaleform
        end
        local scale = drawScale(_subtitle)
        ---@diagnostic disable-next-line: undefined-global
        while ToggleSave do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovie(scale, 0.82, 0.95, 0.35, 0.05, 255, 255, 255, 255)
        end
    end)
end

function ScaleformTimer.ShowWarehouse()
    local scaleform = Scaleform.Request('WAREHOUSE')

    Scaleform.CallFunction(scaleform, false, "SET_WAREHOUSE_DATA", 'nameLabel', 'locationLabel', 'txd', 'large', 16, 16, 50000, 1, 0)
    Scaleform.CallFunction(scaleform, false, "SET_PLAYER_DATA", 'gamerTag', 'organizationName', 'sellerRating', 'numSales', 'totalEarnings')
    Scaleform.CallFunction(scaleform, false, "SET_BUYER_DATA", 'buyerOrganization0', 'amount0', 'offerPrice0', 'buyerOrganization1', 'amount1', 'offerPrice1', 'buyerOrganization2', 'amount2', 'offerPrice2', 'buyerOrganization3', 'amount3', 'offerPrice3')

    Scaleform.CallFunction(scaleform, false, "SHOW_OVERLAY", 'titleLabel', 'messageLabel', 'acceptButtonLabel', 'cancelButtonLabel', 'success')
    Scaleform.CallFunction(scaleform, false, "SET_MOUSE_INPUT", 0.6, 0.6)
    return scaleform
end

function ScaleformTimer.ShowMusicStudioMonitor(state)
    local scaleform = Scaleform.Request('MUSIC_STUDIO_MONITOR')

    Scaleform.CallFunction(scaleform, false, "SET_STATE", state)
    return scaleform
end

function ScaleformTimer.ShowBusySpinnerNoScaleform(_text)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(_text)
    EndTextCommandBusyspinnerOn(1)
end

function ScaleformTimer.ShowShutter()
    local scaleform = Scaleform.Request('CAMERA_GALLERY')
    Scaleform.CallFunction(scaleform, false, "CLOSE_THEN_OPEN_SHUTTER")
    Scaleform.CallFunction(scaleform, false, "SHOW_PHOTO_FRAME", 1)
    Scaleform.CallFunction(scaleform, false, "SHOW_REMAINING_PHOTOS", 1)
    Scaleform.CallFunction(scaleform, false, "FLASH_PHOTO_FRAME")
    return scaleform
end

function ScaleformTimer.ShowGameFeed(title, subtitle, textblock, textureDirectory, textureName, rightAlign)
    local scaleform = Scaleform.Request('GTAV_ONLINE')

    Scaleform.CallFunction(scaleform, false, "SETUP_BIGFEED", rightAlign)
    Scaleform.CallFunction(scaleform, false, "HIDE_ONLINE_LOGO")
    Scaleform.CallFunction(scaleform, false, "SET_BIGFEED_INFO", "footer", textblock, 0, "", "", subtitle, "URL", title, 0)

    ---@diagnostic disable-next-line: missing-parameter
    RequestStreamedTextureDict(textureDirectory)
    while not HasStreamedTextureDictLoaded(textureDirectory) do
        Wait(0)
    end
    Scaleform.CallFunction(scaleform, false, "SET_BIGFEED_IMAGE", textureDirectory, textureName)
    Scaleform.CallFunction(scaleform, false, "SET_NEWS_CONTEXT", 0)
    Scaleform.CallFunction(scaleform, false, "FADE_IN_BIGFEED")
    return scaleform
end

---@class Scaleforms
Scaleforms = {}

function Scaleforms:Banner(_title, _subtitle, _waitTime, _playSound)
    local showBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowBanner(_title, _subtitle)
    CreateThread(function()
        Wait((tonumber(_waitTime) * 1000) - 400)
        Scaleform.CallFunction(scale, false, "SHARD_ANIM_OUT", 2, 0.4, 0)
        Wait(400)
        showBanner = false
    end)
    CreateThread(function()
        while showBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:ResultsPanel(_title, _subtitle, _slots, _waitTime, _playSound)
    local showRP = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowResultsPanel(_title, _subtitle, _slots)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        showRP = false
    end)
    CreateThread(function()
        while showRP do
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
            Wait(1)
        end
    end)
end

function Scaleforms:MissionInfo(_data, _x, _y, _width, _waitTime, _playSound)
    Scaleform.showMI = true
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    ScaleformTimer.ShowMissionInfoPanel(_data, _x, _y, _width)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        Scaleform.showMI = false
    end)
end

function Scaleforms:SplashText(_title, _waitTime, _playSound)
    Scaleform.showST = true
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    ScaleformTimer.ShowSplashText(_title, _waitTime * 1000)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        Scaleform.showST = false
    end)
end

function Scaleforms:PopupWarning(_title, _subtitle, _errorCode, _waitTime, _playSound)
    Scaleform.showPW = true
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    ScaleformTimer.showPopupWarning(_title, _subtitle, _errorCode)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        Scaleform.showPW = false
    end)
end

function Scaleforms:Countdown(_r, _g, _b, _waitTime, _playSound)
    local showCD = true
    local time = _waitTime
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowCountdown(time, _r, _g, _b)
    CreateThread(function()
        while showCD do
            Wait(1000)
            if time > 1 then
                time = time - 1
                scale = ScaleformTimer.ShowCountdown(time, _r, _g, _b)
            elseif time == 1 then
                time = time - 1
                scale = ScaleformTimer.ShowCountdown("GO", _r, _g, _b)
            else
                showCD = false
            end
        end
    end)
    CreateThread(function()
        while showCD do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:MidsizeBanner(_title, subtitle, _bannerColor, _waitTime, _playSound)
    local showMidBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowMidsizeBanner(_title, subtitle, _bannerColor)
    CreateThread(function()
        Wait((_waitTime * 1000) - 1000)
        Scaleform.CallFunction(scale, false, "SHARD_ANIM_OUT", 2, 0.3, true)
        Wait(1000)
        showMidBanner = false
    end)
    CreateThread(function()
        while showMidBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:Credits(_role, _nameString, _x, _y, _waitTime, _playSound)
    ShowCreditsBanner = true
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    ScaleformTimer.ShowCredits(_role, _nameString, _x, _y)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        ShowCreditsBanner = false
    end)
end

function Scaleforms:HeistFinale(_initialText, _table, _money, _xp, _waitTime, _playSound)
    ShowHeistBanner = true
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    ScaleformTimer.ShowHeist(_initialText, _table, _money, _xp)
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        ShowHeistBanner = false
    end)
end

function Scaleforms:ChangePauseMenuTitle(_title)
    ScaleformTimer.ChangePauseMenuTitle(_title)
end

function Scaleforms:Saving(_subtitle, _type, _waitTime, _playSound)
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    if _type == 1 then
        ToggleSave = true
        ScaleformTimer.ShowSaving(_subtitle)
    else
        ScaleformTimer.ShowBusySpinnerNoScaleform(_subtitle)
    end
    CreateThread(function()
        Wait(tonumber(_waitTime) * 1000)
        if _type == 1 then
            ToggleSave = false
        else
            BusyspinnerOff()
        end
    end)
end

function Scaleforms:Shutter(_waitTime, _playSound)
    local showBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowShutter()
    CreateThread(function()
        Wait((tonumber(_waitTime) * 1000) - 1000)
        Scaleform.CallFunction(scale, false, "CLOSE_THEN_OPEN_SHUTTER")
        Wait(1000)
        showBanner = false
    end)
    CreateThread(function()
        while showBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:Warehouse(_waitTime, _playSound)
    local showBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowWarehouse()
    CreateThread(function()
        Wait(2000)
        --Scaleform.CallFunction(scale, false, "SET_INPUT_EVENT", 2)
        
        Wait(2000)
        local ret = Scaleform.CallFunction(scale, true, "GET_CURRENT_SELECTION") --we get the scaleform return
        while true do
            if IsScaleformMovieMethodReturnValueReady(ret) then --scaleform takes it's sweet time, so we need to wait for the value to be registered, or calculated or something, idk
                break
            end
            Wait(0)
        end
        Wait((tonumber(_waitTime) * 1000) - 4000)
        showBanner = false
    end)
    CreateThread(function()
        while showBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:MusicStudioMonitor(_state, _waitTime)
    local scale = 0
    local showMonitor = true

    scale = ScaleformTimer.ShowMusicStudioMonitor(_state)

    CreateThread(function()
        Wait(_waitTime * 1000)
        showMonitor = false
    end)

    CreateThread(function()
        while showMonitor do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end

function Scaleforms:GameFeed(_title, _subtitle, _textblock, _textureDict, _textureName, _rightAlign, _waitTime, _playSound)
    local showBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        ---@diagnostic disable-next-line: param-type-mismatch
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    scale = ScaleformTimer.ShowGameFeed(_title, _subtitle, _textblock, _textureDict, _textureName, _rightAlign)
    CreateThread(function()
        Wait(_waitTime * 1000)
        showBanner = false
    end)
    CreateThread(function()
        while showBanner do
            Wait(1)
            ---@diagnostic disable-next-line: missing-parameter
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end