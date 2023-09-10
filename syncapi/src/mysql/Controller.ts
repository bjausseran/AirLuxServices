import mysql, { Pool } from "mysql2";

export interface Controller{
    select(where: string | undefined, join: string | undefined) : Promise<string>;
    find(id: string) : Promise<string>;
    insert(json: string) : void;
    update(json: string) : void;
    remove(id: string) : void;
}



export class Controller{

    pool!: Pool;
    tableName: string = "";
    
    updateStatement: string = `UPDATE ${this.tableName} SET name = ?, type = ? WHERE id = ?`;
    insertStatement: string = `INSERT INTO ${this.tableName} (captor_id, value) VALUES (?, ?)`;

    constructor(){
        this.pool = mysql.createPool({
            //host: 'dbcloud',
            host: 'localhost',
            user: 'root',
            password: 'password',
            database: 'AirLuxDB',
            connectionLimit: 10,
        })
    }
    

    // Function to select data from the buildings table
    select(where: string | undefined, join: string | undefined): Promise<string> {
      return new Promise<string>((resolve, reject) => {
        
        console.log(`Controller, select : where = ${where}, join = ${join}`);
  
        this.pool.getConnection((err, connection) => {
          if (err) {
              reject(err); // Reject the promise with the error if connection fails
              return;
            }
    
          // Use the connection
          try {
            // SQL query
            let sql = `SELECT * FROM ${this.tableName}`;
            sql = join === undefined ? sql : `${sql} LEFT JOIN ${join}`;
            sql = where === undefined ? sql : `${sql} WHERE ${where}`;
            
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
    find(id: string): Promise<string> {
      return new Promise<string>((resolve, reject) => {
        this.pool.getConnection((err, connection) => {
          if (err) {
            reject(err); // Reject the promise with the error if connection fails
            return;
          }if (!id) {
            let err = ('Invalid input. id is a required field.');
            reject(err);
            return;
          }
    
          // Use the connection
          try {
            // SQL query using prepared statement
            let sql = `SELECT * FROM ${this.tableName} WHERE id = ?`;
            let data = [id];
          
            connection.execute(sql, data, function(err, result) {
              if (err) {
                reject(err); // Reject the promise with the query error
                return;
              }
    
              console.log(`result = ${result}`);
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
    // Function to insert data into the captor_values table
    async insert(json: string) {
      let parsedData = JSON.parse(json);
      // Check for invalid input
      if (this.checkInsertData(parsedData)) {
        console.error('Invalid input. captor_id and value are required fields.');
        return;
      }
      console.log('captor_id = ' + parsedData.captor_id + ', value = ' + parsedData.value + ' are required fields.');
      
          this.pool.getConnection(async (err, connection) => {
            if (err) { console.log(err); return; };// not connected!
            // Use the connection
            try {
              // SQL query using prepared statement
              let sql = this.insertStatement;
              let data = this.getInsertData(parsedData);
            
              let caca = await connection.execute(sql, data, (err, result) => {
                if (err) console.log(err);
                else console.log(`${this.tableName} added successfully`);
              });
            }
                
            catch (error) {
              console.log(error);
            }
            finally{
              connection.release();
            }
          })
        
      }
    
    
    // Function to update data in the buildings table
    update(json: string) {
      let parsedData = JSON.parse(json);
      this.pool.getConnection((err, connection) => {
          if (err) throw err; // not connected!
          // Use the connection
      
      // Check for invalid input
      if (this.checkUpdateData(parsedData)) {
        console.error('Invalid input. id, name, type and user_id are required fields.');
        return;
      }
    
      // SQL query using prepared statement
      let sql = this.updateStatement;
      let data = this.getUpdateData(parsedData);
    
      connection.execute(sql, data, function(err, result) {
        if (err) throw err;
        console.log('building updated successfully');
      });
      connection.release();
    })
    }
    
    // Function to delete data from the buildings table
    remove(id: string) {
      // Check for invalid input
      if (!id) {
        console.error('Invalid input. id is a required field.');
        return;
      }
      this.pool.getConnection((err, connection) => {
        if (err) throw err; // not connected!
        // Use the connection
    
    
      // SQL query using prepared statement
      let sql = `DELETE FROM ${this.tableName} WHERE id = ?`;
      let data = [id];
    
      connection.execute(sql, data, (err, result) => {
        if (err) throw err;
        console.log(`${this.tableName} deleted successfully`);
      });
      connection.release();
    })
    }

   checkUpdateData(parsedData: any) : boolean{
       return false;
    }
   checkInsertData(parsedData: any) : boolean{
        return false;
    }
  
    getUpdateData(parsedData: any) : any{
        return [parsedData.name, parsedData.type, parsedData.id]
    }
    getInsertData(parsedData: any) : any{
        return [parsedData.name, parsedData.type]
    }
}

