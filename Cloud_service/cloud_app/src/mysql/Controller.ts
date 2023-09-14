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
    tableName = "";
    
    updateStatement = `UPDATE ${this.tableName} SET name = ?, type = ? WHERE id = ?`;
    insertStatement = `INSERT INTO ${this.tableName} (captor_id, value) VALUES (?, ?)`;

    constructor(){
        this.pool = mysql.createPool({
            host: 'db_cloud',
            //host: 'localhost',
            user: 'root',
            password: 'admin',
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
            const err = ('Invalid input. id is a required field.');
            reject(err);
            return;
          }
    
          // Use the connection
          try {
            // SQL query using prepared statement
            const sql = `SELECT * FROM ${this.tableName} WHERE id = ?`;
            const data = [id];
          
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
      const parsedData = JSON.parse(json);
      // Check for invalid input
      if (this.checkInsertData(parsedData)) {
        console.error('Invalid input, some fields are required.');
        return;
      }
      
          this.pool.getConnection(async (err, connection) => {
            if (err) { console.log(err); return; }// not connected!
            // Use the connection
            try {
              // SQL query using prepared statement
              const sql = this.insertStatement;
              const data = this.getInsertData(parsedData);

              console.log('sql = ' + sql);
              console.log('data = ' + data);
            
              await connection.execute(sql, data, (err, result) => {
                if (err) console.log(err);
                else console.log(`${this.tableName} added successfully, result = ${result}`);
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
      const parsedData = JSON.parse(json);
      this.pool.getConnection((err, connection) => {
          if (err) throw err; // not connected!
          // Use the connection
      
      // Check for invalid input
      if (this.checkUpdateData(parsedData)) {
        console.error('Invalid input. id, name, type and user_id are required fields.');
        return;
      }
    
      // SQL query using prepared statement
      const sql = this.updateStatement;
      const data = this.getUpdateData(parsedData);
    
      connection.execute(sql, data, function(err, result) {
        if (err) throw err;
        console.log('item updated successfully, result = ' + result);
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
      const sql = `DELETE FROM ${this.tableName} WHERE id = ?`;
      const data = [id];
    
      connection.execute(sql, data, (err, result) => {
        if (err) throw err;
        console.log(`${this.tableName} deleted successfully, reuslt = ${result}`);
      });
      connection.release();
    })
    }

   checkUpdateData(parsedData: any) : boolean{
    console.log(`${this.tableName} check update, parsedData = ${parsedData}`);
       return false;
    }
   checkInsertData(parsedData: any) : boolean{
    console.log(`${this.tableName} check insert, parsedData = ${parsedData}`);
        return false;
    }
  
    getUpdateData(parsedData: any) : any{
        return [parsedData.name, parsedData.type, parsedData.id]
    }
    getInsertData(parsedData: any) : any{
        return [parsedData.name, parsedData.type]
    }
}

