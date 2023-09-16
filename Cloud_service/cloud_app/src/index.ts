import { RawData, WebSocket } from "ws";
import { FSM } from "./fsm/fsm";
import { GlobalContext } from "./models/globalContext";


function rawDataToString(data: RawData) {
    // console.log(typeof data);
    // if (typeof data === 'WebSocket.RawData') {
        return data.toString('utf8');
    // } else {
    //     throw new Error('Invalid input: not a WebSocket.RawData');
    // }
}

const wss = new WebSocket.Server({ port: 6001 });

console.log('wss status = ' +  wss);

const fsm = new FSM()
const gc = new GlobalContext()




wss.on('connection', (ws) => {
    console.log('Client connected');
    ws.send('Welcome to the server!');

    
    fsm.setContext('tocloud//buildings//{"name": "Grange","type": "Medium","user_id": 1}//insert', ws, gc);
    fsm.startFsm(); 

    ws.on('message', (message) => {
        console.log(`Received message: ${message}`);
        
        fsm.setContext(rawDataToString(message), ws, gc);
        fsm.startFsm(); 
            
    });

    //console.log(`SENS WS MESSAGE : 'tolocal//captor_values//0000003//1'`);
    //ws.send('tolocal//captor_values//0000003//1');
});

// let id = 9445166;
// var value = 15.4;
// let roomId = 4895623;
// let name = "captor_name"
// let data = `{"id":"${id}", "name": "${name}", "room_id": "${roomId}", "value": "${value.toString()}"}`;
// let fsm = new FSM("tocloud//captors//"+data+"//update");
// fsm.startFsm();
