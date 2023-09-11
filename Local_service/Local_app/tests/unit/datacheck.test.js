const redis = require("./../../src/redis/redis_client");


describe("Testing redis.PostCaptorData", () => {
  let result = false;
  let data = ['0001', '23'];

  describe("Normal creation", () => {
    beforeAll(() => {
      result = redis.postCaptorValue(data[0], data[1]);
    })
    test("Data should be valid", () => {
      expect(result).toBe(true);
    })
  })
  
  describe("no ID creation", () => {
    beforeAll(() => {
      data = ['', '23'];
      result = redis.postCaptorValue(data[0], data[1]);
    })
    test("Data shouldn't be valid", () => {
      expect(result).toBe(false);
    })
  })
  
  describe("no value creation", () => {
    beforeAll(() => {
      data = ['001', ''];
      result = redis.postCaptorValue(data[0], data[1]);
    })
    test("Data shouldn't be valid", () => {
      expect(result).toBe(false);
    })
  })
  
  describe("ID is a integer creation", () => {
    beforeAll(() => {
      data = [1, '23'];
      result = redis.postCaptorValue(data[0], data[1]);
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