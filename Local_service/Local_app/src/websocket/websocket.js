const WebSocket = require('ws');

const IP = "cloud_app";
//const IP = "localhost";

const ws = new WebSocket(`ws://${IP}:6001`);
console.log(`Try connect to ws://${IP}:6001`);

function start(){
  try {
    const ws = new WebSocket(`ws://${IP}:6001`);
  
    
    ws.on('open', function open() {
        console.log(`Client connected to websocket port 6001`);
        ws.send(`boxconnect//${process.env.BUILDING_ID == undefined ? 1 : process.env.BUILDING_ID}`);
    });
  
    ws.on('message', function message(data) {
      console.log('%s', data);
    });
  
    ws.on('error', function message(data) {
      console.log('error', data);
    });
    return ws;
  
  }
  catch (error) {
    console.log(`Error connecting to server: ${error.message}`);
    return null;
  }
}

exports.client = ws;
exports.reconnect = start;

