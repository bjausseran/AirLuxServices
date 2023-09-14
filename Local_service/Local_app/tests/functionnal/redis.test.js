
//Redis
'use strict';
// NOTE - Require
const redis = require('./../../src/redis/redis_client');


redis.client.on('error', function() {
  
      redis.disconnection();
  
  }).on('ready', function() {
});

describe("Testing redis.PostCaptorData", () => {

  let result = "";
  let data = ['0001', '23'];
  

  describe("Normal creation", () => {
    test("Data should be valid", async () => {
      result = await redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe("OK");
    })
  })
  
  describe("no ID creation", () => {
    test("Data shouldn't be valid", async () => {
      data = ['', '23'];
      result = await redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe("OK");
    })
  })
  
  describe("no value creation", () => {
    test("Data shouldn't be valid", async () => {
      data = ['001', ''];
      result = await redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe("OK");
    })
  })
  
  describe("ID is a integer creation", () => {
    test("Data should be valid", async () => {
      data = [1, '23'];
      result = await redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe("OK");
    })
  })
  
  
  describe("Value is a integer creation", () => {
    test("Data should be valid", async () => {
      data = ['001', 23];
      result = await redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe("OK");
      redis.disconnection();
    })
  })

  
})