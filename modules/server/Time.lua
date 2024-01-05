-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

if Trusted.Debug then
    local filename = function()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("^.*/(.*).lua$") or str
    end
    print("^6[SERVER - DEBUG] ^0: "..filename()..".lua started");
end
-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Time = {}

function Time.GetCurrentTime()
    local time = os.date("*t")
    return string.format("%d/%d/%d %d:%d:%d", time.month, time.day, time.year, time.hour, time.min, time.sec)
end

--- returns if the target time has been passed. The return value is based on the minutes passed.
---@param startTime number
---@param targetTime number
---@return boolean
function Time.HasTargetTimeBeenReached(startTime, targetTime)
    return os.time() >= startTime + targetTime * 60
end