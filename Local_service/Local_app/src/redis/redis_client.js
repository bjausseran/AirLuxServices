//Redis
'use strict';

var isReady = false;
var isError = false;
// NOTE - Require
const redis = require('redis');

// NOTE - REDIS
const client = redis.createClient({
  url: 'redis://db_local',
  //url: 'redis://localhost',
  port: 6379
});
async function connection() {
  
  console.log('Redis try connect');
  const result = await client.connect(function(err) {
    if(err) throw err;
    console.log("Redis database connected!")
  })
  console.log('Redis connected ? '  + result);
}
function disconnection() {
  client.disconnect(function(err) {
    if(err) throw err;
    console.log("Redis database connected!")
  })
}
// --------------------

// NOTE - Redis connection
console.log('Redis try connect');
connection();


function getTimestamp() {
  return Date.now().toString();
}

async function postData(data){
    let time = getTimestamp();
    
    console.log("Try post value at " + time);

    return await client.set(time, data);
}

async function postCaptorValue(captorid, value){
  let data = {
      'captor_id' : captorid,
      'value': value
  };
  // Send to redis DB
  let data_send = JSON.stringify(data);

  // Filter data in redis DB
  let json = JSON.parse(data_send);
  if(json.value && json.captor_id) {
      console.log("value type is OK");
      const result = await postData(data_send);
      return result;
  } else {
      console.log("ERROR value type in database");
      return "ERROR"
  }
}
  

client.on('error', function() {
  if (! isReady && ! isError) {
    // perform your MySQL setup here
  }
  isError = true;
}).on('ready', function() {
  isReady = true;
});

module.exports = {
  client: client,
  isReady: isReady,
  connection: connection,
  disconnection: disconnection,
  postCaptorValue: postCaptorValue
}
