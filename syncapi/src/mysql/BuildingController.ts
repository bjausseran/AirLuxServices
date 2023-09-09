import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

let pool =  mysql.createPool({
  //host: 'dbcloud',
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'AirLuxDB',
  connectionLimit: 10,
});

export class BuildingController implements Controller
{
  // Function to select data from the buildings table
  // Function to select data from the buildings table
  select(where: string | undefined, join: string | undefined): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      
      console.log(`BuildingController, select : where = ${where}, join = ${join}`);

      pool.getConnection((err, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }
  
        // Use the connection
        try {
          // SQL query
          let sql = 'SELECT buildings.id, buildings.name FROM buildings';
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
  findByUserId(userid: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      pool.getConnection((err, connection) => {
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
  
            console.log('captorValues select successfully');
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
      pool.getConnection((err, connection) => {
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
          let sql = 'SELECT * FROM buildings WHERE id = ?';
          let data = [id];
        
          connection.execute(sql, data, function(err, result) {
            if (err) {
              reject(err); // Reject the promise with the query error
              return;
            }
  
            console.log('captorValues select successfully');
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
  insert(json: string) {
    let parsedData = JSON.parse(json);
    // Check for invalid input
    if (!parsedData.id || !parsedData.name || !parsedData.type) {
      console.error('Invalid input. id, name, type and user_id are required fields.');
      return;
    }
    pool.getConnection(function(err, connection) {
      
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
  
  // Function to update data in the buildings table
  update(json: string) {
    let parsedData = JSON.parse(json);
    pool.getConnection(function(err, connection) {
        if (err) throw err; // not connected!
        // Use the connection
    
    // Check for invalid input
    if (!parsedData.id || !parsedData.name || !parsedData.type) {
      console.error('Invalid input. id, name, type and user_id are required fields.');
      return;
    }
  
    // SQL query using prepared statement
    let sql = 'UPDATE buildings SET name = ?, type = ? WHERE id = ?';
    let data = [parsedData.name, parsedData.type, parsedData.id];
  
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
    pool.getConnection(function(err, connection) {
      if (err) throw err; // not connected!
      // Use the connection
  
  
    // SQL query using prepared statement
    let sql = 'DELETE FROM buildings WHERE id = ?';
    let data = [id];
  
    connection.execute(sql, data, function(err, result) {
      if (err) throw err;
      console.log('building deleted successfully');
    });
    connection.release();
  })
  }
}