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

Web.ItemContainer = {}

---@class ContainerListItem
---@field [string] string | number

---@class RawContainerItem
---@field [string|number] {label: string, image: string?, list: ContainerListItem[]?, description: string?}

---@class ContainerItem
---@field id string
---@field title string
---@field image string
---@field list string[]

---@param data RawContainerItem[]
function Web.ItemContainer:Open(data, ...)
    
    ---@type ContainerItem[]
    local ContainerItems = {}

    for item, _data in pairs(data) do
        local newItem = {}

        newItem.id = item
        newItem.title = _data.label
        newItem.image = _data.image
        newItem.list = self:CreateStringListFromTable(_data.required)

        table.insert(ContainerItems, newItem)
    end

    Web:Open('itemContainer', true, true, {
        items = ContainerItems,
        other = ...
    })
end


---@param list ContainerListItem[]
---@return table<string>
function Web.ItemContainer:CreateStringListFromTable(list)
    local convertedList = {}

    for item, amount in pairs(list) do
        if type(amount) ~= "number" or type(amount) ~= "string" then
            print('^2[WARNING]^0 - number or string expected, got '..type(amount)..' from item: '..item..' instead. Skipping item.')
            goto continue
        end
        
        table.insert(convertedList, item.." x"..amount)
        ::continue::
    end

    return convertedList
end

---@param func fun(item: ContainerItem, misc: any)
function Web.ItemContainer:HandleSelection(func)
    ---@type ContainerItem, any
    local item, misc = Async.Await(function(promise)
        RegisterNuiCallback('handle:itemContainer', function(data, cb)
            promise:resolve(data.item, data.other)
            cb(true)
        end)
    end)

    if type(func) ~= "function" then
        error('Function expected, got '..type(func)..' instead.')
    end

    func(item, misc)
end

RegisterNUICallback('close:itemContainer', function(data, cb)
    Web:Close('itemContainer')
    cb(true)
end)