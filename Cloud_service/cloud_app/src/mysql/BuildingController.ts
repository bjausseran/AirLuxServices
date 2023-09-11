import { Controller } from "./Controller";

export class BuildingController extends Controller
{
  constructor(){
    super();
    this.tableName = "buildings";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, type = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (id, name, type) VALUES (?, ?, ?)`;
  }

  getBuildingByCaptor(captorid: string): Promise<string> {
      return new Promise<string>((resolve, reject) => {
        
        console.log(`Controller, ${this.tableName} getBuildingByCaptor : captorid = ${captorid}`);
  
        this.pool.getConnection((err, connection) => {
          if (err) {
              reject(err); // Reject the promise with the error if connection fails
              return;
            }
    
          // Use the connection
          try {
            // SQL query
            let sql = `SELECT rooms.building_id FROM captors LEFT JOIN rooms ON captors.room_id = rooms.id WHERE captors.id = ${captorid} GROUP BY rooms.building_id `;
            
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
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.type;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name || !parsedData.type || !parsedData.user_id;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.id || !parsedData.name || !parsedData.type || !parsedData.type];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.name || !parsedData.type];
  }

  // Function to delete data from the captor_values table
  findByUserId(userid: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      this.pool.getConnection((err : any, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }if (!userid) {
          let err = ('Invalid input. id is a required field.');
          reject(err);
          return;
        }
  
        // Use the connection
        try {
          // SQL query using prepared statement
          let sql = 'SELECT buildings.id, buildings.name FROM buildings LEFT JOIN user_building ON buildings.id = user_building.building_id WHERE user_id = ?';
          let data = [userid];

          connection.execute(sql, data, function(err, result) {
            if (err) {
              reject(err); // Reject the promise with the query error
              return;
            }
  
            console.log('buildings select successfully');
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
  

  // Function to insert data into the buildings table
  override async insert(json: string) {
    let parsedData = JSON.parse(json);
    // Check for invalid input
    if (this.checkInsertData(parsedData)) {
      console.error('Invalid input. id, name, type and user_id are required fields.');
      return;
    }
    this.pool.getConnection(function(err, connection) {
      
      if (err) { console.log(err); return; };// not connected!
      // Use the connection
    // SQL query using prepared statement
    let sqlPivot = 'INSERT INTO user_building (building_id, user_id) VALUES (?, ?)';
    let pivotData = [parsedData.id, parsedData.user_id];
  
    connection.execute(sqlPivot, pivotData, function(err, result) {
      if (err) console.log(err);
      else console.log('user_building pivot added successfully');
    });
  
    // SQL query using prepared statement
    let sql = 'INSERT INTO buildings (id, name, type) VALUES (?, ?, ?)';
    let data = [parsedData.id, parsedData.name, parsedData.type];
  
    connection.execute(sql, data, function(err, result) {
      if (err) console.log(err);
      else console.log('Building added successfully');
    });
    connection.release();
  })
  }
  
}