---@diagnostic disable: duplicate-set-field
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


---@public:
---@class Bars 
---@field Textures table 
---@field Textures.dir string 
---@field Textures.name string
---@field Color table 
---@field Color.r number
---@field Color.g number
---@field Color.b number
---@field Color.a number
---@field Progress table
---@field Progress.back_color table
---@field Progress.back_color.r number
---@field Progress.back_color.g number
---@field Progress.back_color.b number
---@field Progress.back_color.a number
---@field Progress.fore_color table
---@field Progress.fore_color.r number
---@field Progress.fore_color.g number
---@field Progress.fore_color.b number
---@field Progress.fore_color.a number
---@field index number
---@field Rendering table
Bars = {
    Textures = {dir = "timerbars", name = "all_black_bg"},
    Color = {r = 255, g = 255, b = 255, a = 155},
    Progress = {
        back_color = {r = 0, g = 128, b = 255, a = 140},
        fore_color = {r = 0, g = 128, b = 255, a = 255}
    }
}

---@private 
function Bars:Render()
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    Visual.RenderSprite(self.Textures.dir, self.Textures.name, self.Rendering.background.x, self.Rendering.background.y, self.Rendering.background.w, self.Rendering.background.h, 0, self.Color.r, self.Color.g, self.Color.b, self.Color.a)
end

---@private
---@param percent number
function Bars:RenderProgressBars(percent)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, self.Rendering.progress.w, self.Rendering.progress.h, self.Progress.back_color.r, self.Progress.back_color.g, self.Progress.back_color.b, self.Progress.back_color.a)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, percent, self.Rendering.progress.h, self.Progress.fore_color.r, self.Progress.fore_color.g, self.Progress.fore_color.b, self.Progress.fore_color.a)
end

---@private
---@param percent number
---@param r number
---@param g number
---@param b number
function Bars:RenderCustomPercentBar(percent, r, g, b)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, self.Rendering.progress.w, self.Rendering.progress.h, r, g, b, 140)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, percent, self.Rendering.progress.h, r, g, b, 255)
end

---@private
---@param status boolean
function Bars:Ready(status)
    self.Rendering.progress.isReady = status
end

--- Registers a new Timerbar with the specified index.
---@public
---@param index number
---@return metatable
---@meta:
--- Creates a new Bar object and returns its. 
function Bars:init(index)
    local object = {}
    setmetatable(object, self)
    self.__index = self 
    object.index = index or 1
    object.Rendering = {}
    object.Rendering.background = {x = 1580, w = 320, h = 34}
    object.Rendering.progress = {x = 1700, w = 180, h = 12}
    object.Rendering.progress.isReady = false
    if object.index == 1 then
        object.Rendering.background.y = 1020
        object.Rendering.progress.y = 1031.5
    else 
        object.Rendering.background.y = 1020 - (40 * (object.index - 1))
        object.Rendering.progress.y = 1031.5 - (40 * (object.index - 1))
    end

    object.exists = true

    return object
end

---@public
---@param time number
function Bars:ProgressBar(time)
    ---@diagnostic disable-next-line: undefined-field
    if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Ready(false)
    local step = self.Rendering.progress.w / time
    local percent = 0
    if time ~= nil or time == 0 then
        CreateThread(function()
            while percent < 180 do
                Wait(0)
                self:Render()
                self:RenderProgressBars(percent)
            end
        end)
        CreateThread(function()
            while percent < 180 do
                Wait(0)
                percent = percent + (step / 60)
            end
            self:Ready(true)
        end)
    end 
end

--- Returns if the progressbar has finished.
---@public
---@return boolean | nil
function Bars:IsReady()
    ---@diagnostic disable-next-line: undefined-field
    if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    return self.Rendering.progress.isReady
end

---@public
---@param text string
function Bars:TextBar(text)
     ---@diagnostic disable-next-line: undefined-field
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 14, 1.0, 1.0, 0.50, text, 255, 255, 255, 255, 0.98)
end

---@public 
---@param text_1 string
---@param text_2 string
function Bars:InfoBar(text_1, text_2)
     ---@diagnostic disable-next-line: undefined-field
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.50, text_1, 255, 255, 255, 255, 0.88)
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 16, 1.0, 1.0, 0.50, text_2, 255, 255, 255, 255, 0.98)
end

---@public
---@param label string
---@param time number
---@param type string
function Bars:TimerBar(label, time, type)
     ---@diagnostic disable-next-line: undefined-field
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.45, label, 255, 255, 255, 255, 0.88)
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 16, 1.0, 1.0, 0.60, tostring(time), 255, 255, 255, 255, 0.96)
    Text.DisplayText(self.Rendering.progress.x + 145, self.Rendering.progress.y - 16, 1.0, 1.0, 0.60, type or "min.", 255, 255, 255, 255)
end

---@public
---@param label string
---@param percent number
function Bars:PercentBar(label, percent)
     ---@diagnostic disable-next-line: undefined-field
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.45, label, 255, 255, 255, 255, 0.88)
    self:RenderProgressBars(percent)
end

---@public
---@param label string
---@param percent number
---@param r number
---@param g number
---@param b number
function Bars:ColoredPercentBar(label, percent, r, g, b)
     ---@diagnostic disable-next-line: undefined-field
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    if label then
        Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.45, label, 255, 255, 255, 255, 0.88)
    end
    self:RenderCustomPercentBar(percent, r, g, b)
end
