const WebSocket = require('ws');

describe('WebSocket Connection', () => {
  test('should connect to WebSocket server', done => {
      const ws = new WebSocket('ws://cloud_app:6001');

    ws.on('open', () => {
      expect(ws.readyState).toBe(WebSocket.OPEN);
      done();
      ws.close();
      expect(ws.readyState).toBe(WebSocket.CLOSING || WebSocket.CLOSED);
    });

    ws.on('error', error => {
      done.fail(error);
    });

  });
});