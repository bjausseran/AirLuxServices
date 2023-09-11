const mqtt = require("mqtt");
var client = mqtt.connect('mqtt://broker');

client.on("connect", function(){
    
});

module.exports = client;