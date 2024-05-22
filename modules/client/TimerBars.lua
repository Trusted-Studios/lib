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
---@field exists boolean
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
function Bars:RenderProgressBar(percent)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, self.Rendering.progress.w, self.Rendering.progress.h, self.Progress.back_color.r, self.Progress.back_color.g, self.Progress.back_color.b, self.Progress.back_color.a)
    Visual.DrawProgressBar(self.Rendering.progress.x, self.Rendering.progress.y, (180 / 100) * percent, self.Rendering.progress.h, self.Progress.fore_color.r, self.Progress.fore_color.g, self.Progress.fore_color.b, self.Progress.fore_color.a)
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

---@public
---@param index number
---@return metatable
---@meta:
--- Creates a new Bar object and returns its. 
function Bars:Create(index)
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
---@meta:
--- Triggers a progressbar. Can only be used with a created object.
function Bars:ProgressBar(time)
    if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Ready(false)
    local step <const> = (self.Rendering.progress.w / time) / 100
    local percent = 0
    local elapsedTime = 0

    CreateThread(function()
        while elapsedTime ~= time do
            Wait(1000)
            elapsedTime += 1
        end
    end)
    
    CreateThread(function()
        while percent <= 100 do
            Wait(10)
            percent += step
        end

        self:Ready(true)
    end)

    CreateThread(function()
        while not self:IsReady() do
            Wait(0)
            self:Render()
            self:RenderProgressBar(percent)
        end
    end)
end

---@public
---@return boolean | nil
---@meta:
--- Returns if the progressbar has been completed.
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
---@meta:
--- Renders a simple text bar.
function Bars:TextBar(text)
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 14, 1.0, 1.0, 0.50, text, 255, 255, 255, 255, 0.98)
end

---@public 
---@param titleText string
---@param text string
---@meta:
--- Renders an info bar with an title and text content.
function Bars:InfoBar(titleText, text)
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.50, titleText, 255, 255, 255, 255, 0.88)
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 16, 1.0, 1.0, 0.50, text, 255, 255, 255, 255, 0.98)
end

---@public
---@param label string
---@param time number
---@param unit string
---@meta:
--- Renders a GTA:O timer bar.
function Bars:TimerBar(label, time, unit)
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.45, label, 255, 255, 255, 255, 0.88)
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 16, 1.0, 1.0, 0.60, tostring(time), 255, 255, 255, 255, 0.96)
    Text.DisplayText(self.Rendering.progress.x + 145, self.Rendering.progress.y - 16, 1.0, 1.0, 0.60, unit or "min.", 255, 255, 255, 255)
end

---@public
---@param label string
---@param percent number
---@meta:
--- Renders a percentbar. Looks like the Progressbar but doesnt update any values.
function Bars:PercentBar(label, percent)
     if not self.exists then
        print '^1[WARNING]^0 - Unable to call this function as no parent object has been created.'
        return
    end

    self:Render()
    Text.MinimalTextDisplay(self.Rendering.progress.x, self.Rendering.progress.y - 12, 1.0, 1.0, 0.45, label, 255, 255, 255, 255, 0.88)
    self:RenderProgressBar(percent)
end

---@public
---@param label string
---@param percent number
---@param r number
---@param g number
---@param b number
---@meta:
--- Renders a colored percentbar. Looks like the Progressbar but doesnt update any values.
function Bars:ColoredPercentBar(label, percent, r, g, b)
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
