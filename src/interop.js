import * as bt from "./bluetooth.js";

export const flags = ({ env }) => {
  return {
    message: "Hello, from JS flags",
  };
};

export const onReady = ({ app, env }) => {
  if (app.ports && app.ports.outgoing && app.ports.incoming) {
    app.ports.outgoing.subscribe(({ tag, data }) => {
      switch (tag) {
        case "OPEN_WINDOW_DIALOG":
          bt.getBluetoothList(app);
          return;
        default:
          console.warn(`Unhandled outgoing port:"${tag}"`);
      }
    });
  }
};
