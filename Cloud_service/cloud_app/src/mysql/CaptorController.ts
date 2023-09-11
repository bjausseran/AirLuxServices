import { Controller } from "./Controller";








export class CaptorController extends Controller
{
  constructor(){
    super();
    this.tableName = "captors";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, type = ?, room_id = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (name, type, room_id) VALUES (?, ?, ?)`;
  }
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.room_id || !parsedData.type;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name || !parsedData.room_id || !parsedData.type;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.name, parsedData.type, parsedData.room_id, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.name, parsedData.type, parsedData.room_id];
  }

  getCaptorWithLastData(roomsId: string){
    return new Promise<string>((resolve, reject) => {
        
    //console.log(`Controller, select : where = ${where}, join = ${join}`);

    this.pool.getConnection((err, connection) => {
      if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }

      // Use the connection
      try {
        // SQL query
        let sql = `SELECT u.id, u.name, u.type, u.room_id, h.value
        FROM (
            SELECT u.*, MAX(h.id) as hid
            FROM captors u
            LEFT JOIN captor_values h ON u.id = h.captor_id
            GROUP BY u.id
        ) u
        LEFT JOIN captor_values h ON h.id = u.hid 
        WHERE ${roomsId};`;
        
        console.log('BuildingController, select : sql = ' + sql);
        
        connection.query(sql, (queryErr, result) => {
          if (queryErr) {
            reject(queryErr); // Reject the promise with the query error
            return;
          }

          const jsonString = JSON.stringify(result);
          resolve(jsonString); // Resolve the promise with the JSON string
        });
      } catch (error) {
        console.log(error);
        reject(error); // Reject the promise with any other errors
      } finally {
        connection.release();
      }
    });
  });
}

}






