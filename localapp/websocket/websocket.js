const WebSocket = require('ws');

const ws = new WebSocket('ws://syncapi:6001');




function start(){
  try {
    const ws = new WebSocket('ws://syncapi:6001');
  
    ws.on('open', function open() {
        console.log(`Client connected to websocket port 6001`);
        ws.send('Hello server!');
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

