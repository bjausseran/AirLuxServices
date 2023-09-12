function parseData(message){
  return message.split("//");
}

describe("Testing websocket file", () => {

  let message = "tolocal//captor_values//2//24";
  let array = parseData(message);
  describe("Normal data", () => {
    beforeAll(() => {
    })
    test("Array[0] should be tolocal", () => {
      expect(array[0]).toBe("tolocal");
    })
    
    test("Array[1] should be captor_values", () => {
      expect(array[1]).toBe("captor_values");
    })
    
    test("Array[2] should be 2", () => {
      expect(array[2]).toBe("2");
    })
    
    test("Array[3] should be 24", () => {
      expect(array[3]).toBe("24");
    })
  })
});
