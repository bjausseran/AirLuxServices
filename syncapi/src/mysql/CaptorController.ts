import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

let pool =  mysql.createPool({
  host: 'dbcloud',
  user: 'root',
  password: 'password',
  database: 'AirLuxDB',
  connectionLimit: 10,
});

export class CaptorController implements Controller
{

  // Function to select data from the buildings table
  select(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }
  
        // Use the connection
        try {
          // SQL query
          const sql = 'SELECT * FROM captors';
          connection.query(sql, (queryErr, result) => {
            if (queryErr) {
              reject(queryErr); // Reject the promise with the query error
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
            let sql = 'SELECT * FROM captors WHERE id = ?';
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
  
// Function to insert data into the captors table
insert(json: string) {
  let parsedData = JSON.parse(json);
  console.log('id = ' + parsedData.id + ', name = ' + parsedData.name + ', room_id = ' + parsedData.room_id + ' are required fields.');
  // Check for invalid input
  if (!parsedData.id || !parsedData.name || !parsedData.room_id) {
    console.error('Invalid input. id, name and room_id are required fields.');
    return;
  }
  pool.getConnection(function(err, connection) {
    if (err) { console.log(err); return; };// not connected!
    // Use the connection

  // SQL query using prepared statement
  let sql = 'INSERT INTO captors (id, name, room_id, value) VALUES (?, ?, ?, ?)';
  let data = [parsedData.id, parsedData.name, parsedData.room_id, parsedData.value];

  connection.execute(sql, data, function(err, result) {
    if (err) console.log(err);
    else console.log('Captor added successfully');
  });
  connection.release();
  })
  }

  // Function to update data in the captors table
  update(json: string) {
    let parsedData = JSON.parse(json);
    pool.getConnection(function(err, connection) {
      if (err) throw err; // not connected!
      // Use the connection

  // Check for invalid input
  if (!parsedData.id || !parsedData.name || !parsedData.room_id || !parsedData.value) {
    console.error('Invalid input. id, name and room_id are required fields.');
    return;
  }

  // SQL query using prepared statement
  let sql = 'UPDATE captors SET name = ?, room_id = ?, value = ? WHERE id = ?';
  let data = [parsedData.name, parsedData.room_id, parsedData.value, parsedData.id];

  connection.execute(sql, data, function(err, result) {
    if (err) throw err;
    console.log('Captor updated successfully');
  });
  connection.release();
  })
  }
  
  // Function to delete data from the captors table
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
    let sql = 'DELETE FROM captors WHERE id = ?';
    let data = [id];

    connection.execute(sql, data, function(err, result) {
      if (err) throw err;
      console.log('Captor deleted successfully');
    });
    connection.release();
  })
  }
}






