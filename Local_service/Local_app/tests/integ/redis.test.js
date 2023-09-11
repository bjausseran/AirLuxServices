//Redis
'use strict';
// NOTE - Require
const redis = require('redis');

// NOTE - REDIS
const client = redis.createClient({
  url: 'redis://db_local',
  port: 6379,
  socket: {
    reconnectStrategy() {
        console.log('reconnectStrategy', new Date().toJSON());
        return process.env.JEST_WORKER_ID ? 2147483647 : 5000;
    }
}
});
let isReady = false;
let data = {
    'captor_id' : "001",
    'client_id' : "q8sf651-654sdf-45s-7qd54",
    'value': "23"
};
// Send to redis DB
let data_send = JSON.stringify(data);

// handle Redis connection errors
client.on('error', function (err) {
  isReady = false;
  console.log('Redis error: ' + err);
});
// handle Redis connection errors
client.on('ready', function () {
  isReady = true;
  console.log('Redis ready');
});
let error = null;

    describe("Connect to Redis database", () => {
    beforeAll(async () => {
        await client.connect(function(err) {
        if(err)  console.log("Redis database not connected : " + err);
        })
    })
    afterAll(async () => {
        await client.disconnect(function(err) {
        if(err)  console.log(err);
        })
    })
    describe("Test connection and operation", () => {
        beforeAll(async () => {
        await client.set(Date.now().toString(), data_send, function(err, reply) {
            if (err) {
            console.error('Error setting value: ' + err);
            error = err;
            } else {
            console.log('Set value successfully: ' + reply);
            }});
        })
        test("should be connected to Redis DB", () => {
        expect(isReady).toBe(true);
        })
        test("data should be insert", () => {
        expect(error).toBeNull();
        })
    })
    })
