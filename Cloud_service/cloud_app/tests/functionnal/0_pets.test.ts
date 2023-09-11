import request from "supertest"

const apiUrl = `${process.env.API_HOST || "localhost"}:${process.env.API_PORT || 6800}`

describe("Functionnal testing for Pets", () => {
  let inserted: any
  describe("Adding a pet", () => {
    describe("Ivalid payload", () => {
      let response: any
      let duration: number
      test("Is should return an error", async () => {
        let start = new Date().getTime()
        response = await request(apiUrl)
          .post('/pets')
          .send({ kind: "dog" })
          .expect(400)
        let end = new Date().getTime()
        duration = end - start
      })
      test("It should specify that keys are missing", () => {
        expect(response.text).toMatch(/Missing keys/)
      })
      test("It should take less than 100 ms", () => {
        expect(duration).toBeLessThan(100)
      })
    })
    describe("Valid payload", () => {
      let response: any
      let duration: number
      let pasteque = { name: "Pastèque", kind: "dog", vetId: 1, birthDate: "2020-08-07T10:00:00.000Z" }
      test("Is should return 201", async () => {
        let start = new Date().getTime()
        response = await request(apiUrl)
          .post('/pets')
          .send(pasteque)
          .expect(201)
        let end = new Date().getTime()
        duration = end - start
      })
      test("It should specify that keys are missing", () => {
        expect(response.body).toMatchObject(pasteque)
      })
      test("It should take less than 100 ms", () => {
        expect(duration).toBeLessThan(100)
      })
    })
  })
})