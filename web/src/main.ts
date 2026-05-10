import "./app.pcss";
import App from "./App.svelte";

const target = document.getElementById("app");

if (!target) {
  throw new Error("Missing app root element");
}

const app = new App({
  target,
});

export default app;
