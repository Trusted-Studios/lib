---@diagnostic disable: duplicate-set-field
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted?.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[SHARED - DEBUG] ^0: "..filename()..".lua started");
end
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

--- @class Async 
Async = {}

---@param TargetFunction function
function Async.Task(TargetFunction)
    if TargetFunction ~= nil then
        CreateThread(function()
            TargetFunction()
        end)
    end
end

--- func desc
---@param errorHandle string
function Async.RaiseError(errorHandle)
    CreateThread(function()
        if errorHandle ~= nil then
            print("^2[DEBUG]^0 : Error ->^1" .. errorHandle)
        end
    end)
end

---@param func function 
---@return promise | nil | any
function Async.Await(func)
    if not func then 
        return
    end
    local promise = promise.new()
    func(promise)
    return Citizen.Await(promise)
end