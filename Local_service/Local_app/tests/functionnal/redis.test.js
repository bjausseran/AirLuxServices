
//Redis
'use strict';
// NOTE - Require
const redis = require('redis');
const redisCli = require('../../src/redis/redis_client');

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
      await client.set("key", data_send, function(err, reply) {
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
  })
  
describe("Testing redis.PostCaptorData", () => {
  let result = false;
  let data = ['0001', '23'];

  describe("Normal creation", () => {
    beforeAll(() => {
      result = redisCli.postCaptorValue(data[0], data[1]);
    })
    test("Data should be valid", () => {
      expect(result).toBe(true);
    })
  })
  
  describe("no ID creation", () => {
    beforeAll(() => {
      data = ['', '23'];
      result = redisCli.postCaptorValue(data[0], data[1]);
    })
    test("Data shouldn't be valid", () => {
      expect(result).toBe(false);
    })
  })
  
  describe("no value creation", () => {
    beforeAll(() => {
      data = ['001', ''];
      result = redisCli.postCaptorValue(data[0], data[1]);
    })
    test("Data shouldn't be valid", () => {
      expect(result).toBe(false);
    })
  })
  
  describe("ID is a integer creation", () => {
    beforeAll(() => {
      data = [1, '23'];
      result = redisCli.postCaptorValue(data[0], data[1]);
    })
    test("Data should be valid", () => {
      expect(result).toBe(true);
    })
  })
  
  
  describe("Value is a integer creation", () => {
    beforeAll(() => {
      data = ['001', 23];
      result = redis.postCaptorValue(data[0], data[1]);
    })
    test("Data should be valid", () => {
      expect(result).toBe(true);
    })
  })
})
})

