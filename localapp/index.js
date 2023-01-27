const redis = require("./redis/redis_client");
const ws = require("./websocket/websocket");
const mqttSub = require("./mqtt/sub");
const mqttPub = require("./mqtt/pub");


mqttSub.on('message', function(topic, message){
    console.log("MQTT MESSAGE RECEIVED : " + message.toString());
    
    if(ws.client.readyState === ws.client.OPEN)
        {
            console.log("WEBSOCKET SERVER IS RUNNING");
            console.log("MQTT MESSAGE SEND TO SYNCAPI");
            ws.client.send(message.toString());
        }
        else if(ws.client.readyState === ws.client.CONNECTING)
        {
            console.log("WEBSOCKET SERVER IS CONNECTING");
            console.log("MQTT MESSAGE SEND TO REDIS DB");
            let data = message.toString().split('//');
            redis.postCaptorValue(data[0], data[1]);
        }
        else if(ws.client.readyState === ws.client.CLOSING)
        {
            console.log("WEBSOCKET SERVER IS CLOSING");
            console.log("MQTT MESSAGE SEND TO REDIS DB");
            let data = message.toString().split('//');
            redis.postCaptorValue(data[0], data[1]);
        }
        else
        {
            console.log("WEBSOCKET SERVER IS CLOSED");
            console.log("MQTT MESSAGE SEND TO REDIS DB");
            let data = message.toString().split('//');
            redis.postCaptorValue(data[0], data[1]);

            try {
                ws.client = ws.reconnect();
            } catch (error) {
                console.log("WEBSOCKET CLIENT COUNDNT RECONECT");
            }
        }
});