
//Redis
'use strict';
// NOTE - Require
const redis = require('./../../src/redis/redis_client');

describe("Testing redis.PostCaptorData", () => {
  let result = false;
  let data = ['0001', '23'];
  

   afterAll(() => {
     redis.disconnection();
   })
  

  describe("Normal creation", () => {
    test("Data should be valid", () => {
      result = redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe(true);
    })
  })
  
  describe("no ID creation", () => {
    test("Data shouldn't be valid", () => {
      data = ['', '23'];
      result = redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe(false);
    })
  })
  
  describe("no value creation", () => {
    test("Data shouldn't be valid", () => {
      data = ['001', ''];
      result = redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe(false);
    })
  })
  
  describe("ID is a integer creation", () => {
    test("Data should be valid", () => {
      data = [1, '23'];
      result = redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe(true);
    })
  })
  
  
  describe("Value is a integer creation", () => {
    test("Data should be valid", () => {
      data = ['001', 23];
      result = redis.postCaptorValue(data[0], data[1]);
      expect(result).toBe(true);
    })
  })
  
  redis.disconnection();
})

