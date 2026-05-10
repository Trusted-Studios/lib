# Trusted-Studios Lib

Trusted-Studios Lib is a small FiveM helper library used by Trusted Studios resources. It contains shared Lua utilities, client/server helpers, and a Svelte/Vite NUI frontend.

For broad, general-purpose FiveM utilities, [ox_lib](https://github.com/overextended/ox_lib) is still more complete. This library is focused on the helpers used by this codebase.

## Modules

- `modules/shared`: async helpers, math/vector utilities, table helpers, binary search, and random string/number generation.
- `modules/client`: game entity helpers, callbacks, DUI rendering, scaleforms, timer bars, text, and visual utilities.
- `modules/server`: callbacks, JSON file helpers, and time helpers.
- `web`: Svelte/Vite NUI components with matching Lua wrappers.

## Callback Example

Server:

```lua
Callback:Register('inventory:getItems', function(source, cb)
    cb({ 'water', 'bread' })
end)
```

Client:

```lua
Callback:Trigger('inventory:getItems', function(items)
    print(json.encode(items))
end)
```

Client callback requests time out after 15 seconds and are removed from the pending request table.

## JSON File Helpers

```lua
local data, err = Files.ReadJSON('data/items.json')

if not data then
    print(err)
    return
end

local ok, writeErr = Files.WriteJSON('data/items.json', data)
```

`Files.ReadJSON` returns `nil, errorMessage` when the file is missing or invalid.

## NUI Development

```bash
cd web
npm install
npm run check
npm run build
```
