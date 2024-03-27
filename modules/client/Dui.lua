---@diagnostic disable: duplicate-set-field, duplicate-doc-field
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
-- Legal
-- ════════════════════════════════════════════════════════════════════════════════════ --

--[[
Copyright 2023 [Mycroft Studios](https://github.com/Mycroft-Studios)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the “Software”), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

---@class DUI
---@field renderTarget table
---@field renderDistance number 
---@field url string
---@field draw boolean
---@field object number
---@field handle string
---@field controls boolean
---@field txt any
---@field lastCursorX number
---@field lastCursorY number
---@field txd any
---@field isInteracting boolean
---@field metadata table
DUI = {}

---@param data table
---@return table
function DUI:Register(data)
    local DuiObject = {}

    DuiObject.renderTarget = {
        model = data.model or "",
        modelHash = joaat(data.model),
        target = data.target or "",
        resolution = data.resolution or {x = 1920, y = 1080},
    }
    DuiObject.renderDistance = data.renderDistance or 15.0
    DuiObject.url = data.url
    DuiObject.draw = false
    DuiObject.object = 0
    DuiObject.handle = ""
    DuiObject.controls = false
    DuiObject.txt = nil
    DuiObject.lastCursorX, DuiObject.lastCursorY = 0, 0
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    DuiObject.txd = CreateRuntimeTexture(DuiObject.RenderTarget.model)
    DuiObject.isInteracting = false
    DuiObject.metadata = {}

    return DuiObject
end

function DUI:RegisterRenderTarget()
    if not IsNamedRendertargetRegistered(self.renderTarget.target) then
        RegisterNamedRendertarget(self.renderTarget.target, false)

        if not IsNamedRendertargetLinked(self.renderTarget.modelHash) then
            LinkNamedRendertarget(self.renderTarget.modelHash)
        end

        self.renderTarget.handle = GetNamedRendertargetRenderId(self.renderTarget.target)
    end
end

---@param url string
function DUI:SetUrl(url)
    self.url = url
    SetDuiUrl(self.object, self.url)
end

---@return number | nil
function DUI:GetClosestRender()
    local ped <const> = PlayerPedId()
    ---@type table
    local pedCoords <const> = GetEntityCoords(ped)
    local object <const> = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 15.0, self.renderTarget.modelHash, false, false, false)

    return object or nil
end

function DUI:Create()
    self.object = CreateDui(self.url, self.renderTarget.resolution.x, self.renderTarget.resolution.y)
    self.handle = GetDuiHandle(self.object)

    if not self.txt then
        self.txt = CreateRuntimeTextureFromDuiHandle(self.txd, "dui", self.handle)
    end
end

---@param draw boolean
---@param thisFrame boolean
function DUI:Draw(draw, thisFrame)
    self.draw = draw

    if thisFrame then
        SetTextRenderId(self.renderTarget.handle)
        SetScriptGfxDrawOrder(4)
        SetScriptGfxDrawBehindPausemenu(true)
        DrawSprite(self.renderTarget.model, "dui", 0.5, 0.5, 0.5, 0.5, 0.0, 255, 255, 255, 1.0)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        self.nearestRender = self:GetClosestRender()
        
        return
    end

    CreateThread(function()
        while self.draw do
            local sleep = true
            if self.nearestRender then
                if IsEntityOnScreen(self.nearestRender) and not IsEntityOccluded(self.nearestRender) then
                    sleep = false
                    SetTextRenderId(self.renderTarget.handle)
                    SetScriptGfxDrawOrder(4)
                    SetScriptGfxDrawBehindPausemenu(true)
                    DrawSprite(self.renderTarget.model, "dui", 0.5, 0.5, 0.5, 0.5, 0.0, 255, 255, 255, 1.0)
                    
                    if self.controls then
                        self:ProcessControls()
                    end
                end
            end
            Wait(sleep and 500 or 0)
        end
    end)
end

---@param action string
---@param messageData table
function DUI:SendMessage(action, messageData)
    sendDuiMessage(self.object, jons.encode({
        action = action,
        data = messageData,
    }))
end

function DUI:Destroy()
    if self.object then
        DestroyDui(self.object)
        self.object = nil
    end

    if IsNamedRendertargetRegistered(self.renderTarget.target) then
        ReleaseNamedRendertarget(self.renderTarget.target)
    end

    self.controls = false
end

function DUI:GetCursor()
    local sx, sy = self.renderTarget.resolution.x, self.renderTarget.resolution.y
    local cx, cy = GetNuiCursorPosition()

    cx, cy = (cx / sx), (cy / sy)
    return cx, cy
end

function DUI:ProcessControls()
    DisableControlActions(0)
    DisableControlActions(1)

    local cursorX, cursorY self:GetCursor()
    if cursorX ~= self.lastCursorX or cursorY ~= self.lastCursorY then
        self.lastCursorX = cursorX
        self.lastCursorY = cursorY

        local duiX, duiY = math.floor(cursorX * self.renderTarget.resolution.x + 0.5), math.floor(cursorY * self.renderTarget.resolution.y + 0.5)
        SendDuiMouseMove(self.object, duiX, duiY)
    end

    DrawSprite("desktop_pc", "arrow", cursorX, cursorY, 0.05 / 4.5, 0.035, 0, 255, 255, 255, 255)
    if IsDisabledControlJustPressed(0, 24) then -- LEFT CLICK press
        SendDuiMouseDown(self.object, "left")
    end
    if IsDisabledControlJustReleased(0, 24) then -- LEFT CLICK release
        SendDuiMouseUp(self.object, "left")
    end
    if IsDisabledControlJustPressed(0, 25) then -- Right CLICK press
        SendDuiMouseDown(self.object, "right")
    end
    if IsDisabledControlJustReleased(0, 25) then -- RIGHT CLICK release
        SendDuiMouseUp(self.object, "right")
    end
    if IsDisabledControlJustPressed(0, 180) then -- SCROLL DOWN
        SendDuiMouseWheel(self.object, -150, 0.0)
    end
    if IsDisabledControlJustPressed(0, 181) then -- SCROLL UP
        SendDuiMouseWheel(self.object, 150, 0.0)
    end
end

function DUI:ToogleFocus()
    if not self.isInteracting then
        local object = self.nearestRender
        SetNuiFocus(true, true)

        if  not object or object < 1 then
            return
        end

        SetFocusEntity(object)
    else
        SetNuiFocus(false, false)
        SetFocusEntity(0)
        ClearFocus()
        self:SetControlEnabled(false)
    end

    self.isInteracting = not self.isInteracting
end

---@param enabled boolean
function DUI:SetControlEnabled(enabled)
    self.controls = enabled
end