// vite.config.ts
import { defineConfig } from "file:///C:/Users/Jeremy/Desktop/FiveM-fx-dev/resources/[Trusted]/[Custom]/ts_esx-Dealer/lib/web/node_modules/vite/dist/node/index.js";
import { svelte } from "file:///C:/Users/Jeremy/Desktop/FiveM-fx-dev/resources/[Trusted]/[Custom]/ts_esx-Dealer/lib/web/node_modules/@sveltejs/vite-plugin-svelte/src/index.js";
import { resolve } from "path";
var __vite_injected_original_dirname = "C:\\Users\\Jeremy\\Desktop\\FiveM-fx-dev\\resources\\[Trusted]\\[Custom]\\ts_esx-Dealer\\lib\\web";
var vite_config_default = defineConfig({
  plugins: [svelte()],
  base: "./",
  resolve: {
    alias: {
      $utils: resolve(__vite_injected_original_dirname, "src/lib/utils"),
      $store: resolve(__vite_injected_original_dirname, "src/lib/store"),
      $lib: resolve(__vite_injected_original_dirname, "src/lib")
    }
  },
  build: {
    emptyOutDir: true,
    rollupOptions: {
      output: {
        assetFileNames: "assets/[name].[ext]",
        chunkFileNames: "js/[name].js",
        entryFileNames: "js/[name].js"
      }
    }
  }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcudHMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCJDOlxcXFxVc2Vyc1xcXFxKZXJlbXlcXFxcRGVza3RvcFxcXFxGaXZlTS1meC1kZXZcXFxccmVzb3VyY2VzXFxcXFtUcnVzdGVkXVxcXFxbQ3VzdG9tXVxcXFx0c19lc3gtRGVhbGVyXFxcXGxpYlxcXFx3ZWJcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZmlsZW5hbWUgPSBcIkM6XFxcXFVzZXJzXFxcXEplcmVteVxcXFxEZXNrdG9wXFxcXEZpdmVNLWZ4LWRldlxcXFxyZXNvdXJjZXNcXFxcW1RydXN0ZWRdXFxcXFtDdXN0b21dXFxcXHRzX2VzeC1EZWFsZXJcXFxcbGliXFxcXHdlYlxcXFx2aXRlLmNvbmZpZy50c1wiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9pbXBvcnRfbWV0YV91cmwgPSBcImZpbGU6Ly8vQzovVXNlcnMvSmVyZW15L0Rlc2t0b3AvRml2ZU0tZngtZGV2L3Jlc291cmNlcy9bVHJ1c3RlZF0vW0N1c3RvbV0vdHNfZXN4LURlYWxlci9saWIvd2ViL3ZpdGUuY29uZmlnLnRzXCI7aW1wb3J0IHsgZGVmaW5lQ29uZmlnIH0gZnJvbSBcInZpdGVcIjtcclxuaW1wb3J0IHsgc3ZlbHRlIH0gZnJvbSBcIkBzdmVsdGVqcy92aXRlLXBsdWdpbi1zdmVsdGVcIjtcclxuaW1wb3J0IHsgcmVzb2x2ZSB9IGZyb20gXCJwYXRoXCI7XHJcbi8vIGh0dHBzOi8vdml0ZWpzLmRldi9jb25maWcvXHJcbmV4cG9ydCBkZWZhdWx0IGRlZmluZUNvbmZpZyh7XHJcbiAgICBwbHVnaW5zOiBbc3ZlbHRlKCldLFxyXG4gICAgYmFzZTogXCIuL1wiLFxyXG4gICAgcmVzb2x2ZToge1xyXG4gICAgICAgIGFsaWFzOiB7XHJcbiAgICAgICAgICAgICR1dGlsczogcmVzb2x2ZShfX2Rpcm5hbWUsIFwic3JjL2xpYi91dGlsc1wiKSxcclxuICAgICAgICAgICAgJHN0b3JlOiByZXNvbHZlKF9fZGlybmFtZSwgXCJzcmMvbGliL3N0b3JlXCIpLFxyXG4gICAgICAgICAgICAkbGliOiByZXNvbHZlKF9fZGlybmFtZSwgXCJzcmMvbGliXCIpLFxyXG4gICAgICAgIH0sXHJcbiAgICB9LFxyXG4gICAgYnVpbGQ6IHtcclxuICAgICAgICBlbXB0eU91dERpcjogdHJ1ZSxcclxuICAgICAgICByb2xsdXBPcHRpb25zOiB7XHJcbiAgICAgICAgICAgIG91dHB1dDoge1xyXG4gICAgICAgICAgICAgICAgYXNzZXRGaWxlTmFtZXM6IFwiYXNzZXRzL1tuYW1lXS5bZXh0XVwiLFxyXG4gICAgICAgICAgICAgICAgY2h1bmtGaWxlTmFtZXM6IFwianMvW25hbWVdLmpzXCIsXHJcbiAgICAgICAgICAgICAgICBlbnRyeUZpbGVOYW1lczogXCJqcy9bbmFtZV0uanNcIixcclxuICAgICAgICAgICAgfSxcclxuICAgICAgICB9LFxyXG4gICAgfSxcclxufSk7Il0sCiAgIm1hcHBpbmdzIjogIjtBQUE2YyxTQUFTLG9CQUFvQjtBQUMxZSxTQUFTLGNBQWM7QUFDdkIsU0FBUyxlQUFlO0FBRnhCLElBQU0sbUNBQW1DO0FBSXpDLElBQU8sc0JBQVEsYUFBYTtBQUFBLEVBQ3hCLFNBQVMsQ0FBQyxPQUFPLENBQUM7QUFBQSxFQUNsQixNQUFNO0FBQUEsRUFDTixTQUFTO0FBQUEsSUFDTCxPQUFPO0FBQUEsTUFDSCxRQUFRLFFBQVEsa0NBQVcsZUFBZTtBQUFBLE1BQzFDLFFBQVEsUUFBUSxrQ0FBVyxlQUFlO0FBQUEsTUFDMUMsTUFBTSxRQUFRLGtDQUFXLFNBQVM7QUFBQSxJQUN0QztBQUFBLEVBQ0o7QUFBQSxFQUNBLE9BQU87QUFBQSxJQUNILGFBQWE7QUFBQSxJQUNiLGVBQWU7QUFBQSxNQUNYLFFBQVE7QUFBQSxRQUNKLGdCQUFnQjtBQUFBLFFBQ2hCLGdCQUFnQjtBQUFBLFFBQ2hCLGdCQUFnQjtBQUFBLE1BQ3BCO0FBQUEsSUFDSjtBQUFBLEVBQ0o7QUFDSixDQUFDOyIsCiAgIm5hbWVzIjogW10KfQo=
