export function getBluetoothList(app) {
  let options = {};
  options.acceptAllDevices = true;

  let responseObj = {};
  console.log("Requesting Bluetooth Device...");
  console.log("with " + JSON.stringify(options));
  navigator.bluetooth
    .requestDevice(options)
    .then((device) => {
      console.log("> Name:             " + device.name);
      console.log("> Id:               " + device.id);
      console.log("> Connected:        " + device.gatt.connected);
      responseObj.name = "SOME Default";
      responseObj.id = device.id;
      responseObj.status = device.gatt.connected;
      console.log(responseObj);
      if (app.ports?.incoming?.send) {
        // console.log(app.ports);
        // console.log("Argh! Got him");
        app.ports.incoming.send(responseObj);
        app.ports.receivingString.send("Hello This pushed from JS TO ELM!");
      }
    })
    .catch((error) => {
      console.log("Argh! " + error);
    });
}
