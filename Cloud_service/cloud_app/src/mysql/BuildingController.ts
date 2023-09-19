import { debug } from "console";
import { Controller } from "./Controller";
import { OkPacket, ResultSetHeader } from 'mysql2';

export class BuildingController extends Controller
{
  constructor(){
    super();
    this.selectField = `buildings.id, buildings.name, buildings.type`;
    this.tableName = "buildings";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, type = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (name, type) VALUES (?, ?)`;
  }
  
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.type;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name || !parsedData.type || !parsedData.user_id;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.name, parsedData.type, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.name, parsedData.type, parsedData.user_id];
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
            const sql = `SELECT rooms.building_id FROM captors LEFT JOIN rooms ON captors.room_id = rooms.id WHERE captors.id = ${captorid} GROUP BY rooms.building_id `;
            
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
    

  // Function to delete data from the captor_values table
  findByUserId(userid: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      this.pool.getConnection((err : any, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }if (!userid) {
          const err = ('Invalid input. id is a required field.');
          reject(err);
          return;
        }
  
        // Use the connection
        try {
          // SQL query using prepared statement
          const sql = 'SELECT buildings.id, buildings.name FROM buildings LEFT JOIN user_building ON buildings.id = user_building.building_id WHERE user_id = ?';
          const data = [userid];

          connection.execute<ResultSetHeader>(sql, data, function(err, result) {
            if (err) {
              reject(err); // Reject the promise with the query error
              return;
            }
  
            console.log('buildings select successfully');
            const jsonString = JSON.stringify(result);
            resolve('{"id": ' + result.insertId + '}'); // Resolve the promise with the JSON string
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
  override async insert(json: string) : Promise<string>{
    return new Promise<string>((resolve, reject) => {
    const parsedData = JSON.parse(json);
    
    console.log(`Add building : parsedData name = ${parsedData.name}`);
    console.log(`Add building : parsedData type = ${parsedData.type}`);
    console.log(`Add building : parsedData user_id = ${parsedData.user_id}`);
    // Check for invalid input
    if (this.checkInsertData(parsedData)) {
      console.error('Invalid input name, type, user_id are required fields.');
      return;
    }
    
    const sql = this.insertStatement;
    this.pool.getConnection(function(err, connection) {
      
      if (err) { console.log(err); return; }// not connected!

      // SQL query using prepared statement
    const data = [parsedData.name, parsedData.type];
    
    connection.execute<ResultSetHeader>(sql, data, async function(err, result) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else 
      {
        console.log(`Building added successfully, new building id = ${result.insertId}`);
         const sqlPivot = 'INSERT INTO user_building (building_id, user_id) VALUES (?, ?)';
        const pivotData = [result.insertId, parsedData.user_id];
      
        connection.execute(sqlPivot, pivotData, function(err, result) {
          if (err) {
            console.log(err);
            reject(err);
          }
          else console.log('user_building pivot added successfully, result = ' + result);
        });

        resolve('{"id": ' + result.insertId + "}");
      }
    });
    
    connection.release();
  })
  })}
  
  // Function to insert data into the buildings table
  async insertConnection(json: string) {
    const parsedData = JSON.parse(json);
    
    console.log(`Add building : parsedData building_id = ${parsedData.building_id}`);
    console.log(`Add building : parsedData user_id = ${parsedData.user_id}`);
    // Check for invalid input
    if (!parsedData.user_id || !parsedData.building_id) {
      console.error('Invalid input building_id, user_id are required fields.');
      return;
    }
    
    const sql = this.insertStatement;
    this.pool.getConnection(function(err, connection) {
      
      if (err) { console.log(err); return; }// not connected!
      
    
    const sqlPivot = 'INSERT INTO user_building (building_id, user_id) VALUES (?, ?)';
    const pivotData = [parsedData.building_id, parsedData.user_id];
 
   connection.execute<ResultSetHeader>(sqlPivot, pivotData, function(err, result) {
     if (err) console.log(err);
     else console.log('user_building pivot added successfully, result = ' + result.insertId);
   });
    
    connection.release();
  })
  }
  
}