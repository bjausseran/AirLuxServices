const WebSocket = require('ws');

describe('WebSocket Connection', () => {
  test('should connect to WebSocket server', done => {
      const ws = new WebSocket('ws://cloud_app:6001');

      
    ws.on('message', message => {
      let response = message.toString('utf8');

      if(response === 'Welcome to the server!'){
        console.log('Response for message is : ' + response);
        expect(response).toBe('Welcome to the server!');
        done();
        ws.close();
      }
    });

    ws.on('open', () => {
      ws.send(`tocloud//captor_values//{"captor_id": "0001", "value": "23", "created_at": "${new Date().getTime()}"}//insert`);
    });


    ws.on('error', error => {
      done.fail(error);
    });

    //await new Promise((r) => setTimeout(r, 5000));
    //ws.close();
  });
});