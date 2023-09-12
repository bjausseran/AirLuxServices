
import getMongoDb from "../../src/services/storage"
import PetRepositoryMongo from "../../src/repositories/pets/mongo"
import { Collection, Db, MongoClient, ObjectId } from "mongodb"
import Pet from "../../src/models/Pet"
import { MongoConf } from "../../src/config"
import logger from "../../src/services/logger"

const mongoConf: MongoConf = {
  host: process.env.DBHOST || "localhost",
  port: 27017,
  db: "userpets",
  authSource: "userpets"
}

const cat: Pet = new Pet(1, 'Donkey', 'cat', new Date("2013-01-01T00:00:00Z"))
let insertedId: string
const catUpdated: Pet = new Pet(1, 'Donkey', 'cat', new Date("2013-07-17T23:00:00Z"))
describe("Testing Pet Mongo", () => {
  let DB: Db
  let client: MongoClient
  let PetStorage: PetRepositoryMongo
  beforeAll(async () => {
    [DB, client] = await getMongoDb(mongoConf)
    const collections = await DB.collections()
    await Promise.all(collections.map(collection => collection.drop()))
    PetStorage = new PetRepositoryMongo(DB)
  })
  afterAll(async () => {
    client.close()
  })
  describe("Normal creation", () => {
    let inserted: Pet
    let duration: number
    beforeAll(async () => {
      const start = new Date().getTime()
      inserted = await PetStorage.add(cat)
      const end = new Date().getTime()

      duration = end - start

      insertedId = inserted.id
    })
    describe("Should write data into DB", () => {
      let fromStorage: any
      beforeAll(async () => {
        fromStorage = await DB.collection("pets").findOne({ vetId: cat.vetId })
      })
      test("should actually insert data", () => {
        const expectedFromDb = {
          _id: new ObjectId(insertedId),
          birthDate: cat.birthDate,
          kind: cat.kind,
          name: cat.name,
          vetId: cat.vetId
        }
        expect(fromStorage).toMatchObject(expectedFromDb)
      })
      test("should take less than 40 ms", () => {
        expect(duration).toBeLessThan(40)
      })
    })
  })
  describe("Update", () => {
    let inserted: Pet
    beforeAll(async () => {
      inserted = await PetStorage.update(catUpdated)
    })
    describe("Should update data in DB", () => {
      let fromStorage: any
      beforeAll(async () => {
        fromStorage = await DB.collection("pets").findOne({ vetId: cat.vetId })
      })
      test("should actually update values", () => {
        const expectedFromDb = {
          _id: new ObjectId(insertedId),
          birthDate: catUpdated.birthDate,
          kind: catUpdated.kind,
          name: catUpdated.name,
          vetId: catUpdated.vetId
        }
        expect(fromStorage).toMatchObject(expectedFromDb)
      })
    })
  })
  describe("Delete", () => {
    beforeAll(async () => {
      await PetStorage.remove(insertedId)
    })
    describe("Should remove data from DB", () => {
      let fromStorage: any
      beforeAll(async () => {
        fromStorage = await DB.collection("pets").findOne({ vetId: cat.vetId })
      })
      test("should actually update values", () => {
        expect(fromStorage).toBeNull()
      })
    })
  })
})