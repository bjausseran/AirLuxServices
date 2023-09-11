const mqtt = require("mqtt");

const crypto = require('crypto');
var client = mqtt.connect('mqtt://broker');

function getRandomTemp(min, max) {
    return Math.random() * (max - min) + min;
  }

client.on("connect", function(){
    setInterval(function(){
        var value = getRandomTemp(15, 30);
        console.log(value);
        client.publish('home/captor_values/create', `"captor_id":"${process.env.PULSOR_ID}", "value": "${value.toString()}"`)
    }, 3000), 30000;
});