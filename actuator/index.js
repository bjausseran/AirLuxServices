const mqtt = require("mqtt");

var client = mqtt.connect('mqtt://broker');


client.on("connect", function(){
    
    client.subscribe(`home/captor_values/${process.env.ACTUATOR_ID}/action`);

    client.on('message', function(topic, message){
        
        console.log("MQTT ACTION RECEIVED : " + (message == "1" ? 'Turning on the light' : 'Turning off the light'));

    });

});