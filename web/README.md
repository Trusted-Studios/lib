# Trusted Studios Lib NUI

Svelte/Vite frontend used by the Lua NUI helpers in this library.

## Scripts

```bash
npm install
npm run dev
npm run check
npm run build
```

`npm run check` runs `svelte-check` against `tsconfig.json`. `npm run build` writes the production bundle to `dist/`.
The `dist/` directory is committed because FiveM resources need the built NUI files at runtime.

## Structure

- `src/lib/components`: reusable NUI components such as tables, toasts, warnings, item containers, and number modals.
- `src/lib/utils/FetchNui.ts`: helper for posting data back to the current FiveM resource.
- `src/lib/utils/NuiEvents.ts`: Svelte helper for receiving `window.message` events from Lua.
- `Lua/`: Lua wrappers that open and control the NUI components.
