//Redis
'use strict';

// NOTE - Require
const redis = require('redis');

// NOTE - REDIS
const client = redis.createClient({
  url: 'redis://db_local',
  port: 6379
});

async function redis_connection() {
  client.connect(function(err) {
    if(err) throw err;
    console.log("Redis database connected!")
  })
}
// --------------------

// NOTE - Redis connection
redis_connection();


function getTimestamp() {
  return Date.now().toString();
}

async function postData(data){
    let time = getTimestamp();
    
    console.log("Try post value at " + time);

    await client.set(time, data);
}
module.exports = {
 postCaptorValue: function (captorid, value)
    {
        let data = {
            'captor_id' : captorid,
            'client_id' : process.env.CLIENT_ID,
            'value': value
        };
        // Send to redis DB
        let data_send = JSON.stringify(data);

        // Filter data in redis DB
        let json = JSON.parse(data_send);
        if(json.value && json.captor_id && json.client_id) {
            console.log("value type is OK");
            postData(data_send);
        } else {
            console.log("ERROR value type in database");
        }
        
        
    }
}

function sum(a, b) {
  return a + b;
}

function min(a, b) {
  return a - b;
}
module.exports = {
  sum,
  min
};