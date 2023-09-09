import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

let pool =  mysql.createPool({
  host: 'dbcloud',
  user: 'root',
  password: 'password',
  database: 'AirLuxDB',
  connectionLimit: 10,
});

export class DeviceController implements Controller
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
        const sql = 'SELECT * FROM devices';
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
          let sql = 'SELECT * FROM devices WHERE id = ?';
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
  
// Function to insert data into the devices table
insert(json: string) {
  let parsedData = JSON.parse(json);
  console.log('id = ' + parsedData.id + ', apns_token = ' + parsedData.apns_token + ' are required fields.');
// Check for invalid input
if (!parsedData.id || !parsedData.apns_token) {
  console.error('Invalid input. id, and apns_token are required fields.');
  return;
}
pool.getConnection(function(err, connection) {
  if (err) { console.log(err); return; };// not connected!
  // Use the connection

// SQL query using prepared statement
let sql = 'INSERT INTO devices (id, apns_token) VALUES (?, ?)';
let data = [parsedData.id, parsedData.apns_token];

connection.execute(sql, data, function(err, result) {
  if (err) console.log(err);
  else console.log('Device added successfully');
});
connection.release();
})
}

// Function to update data in the devices table
update(json: string) {
  let parsedData = JSON.parse(json);
    pool.getConnection(function(err, connection) {
      if (err) throw err; // not connected!
      // Use the connection
  
  // Check for invalid input
  if (!parsedData.id || !parsedData.apns_token) {
    console.error('Invalid input. id and apns_token are required fields.');
    return;
  }

  // SQL query using prepared statement
  let sql = 'UPDATE devices SET apns_token = ? WHERE id = ?';
  let data = [parsedData.apns_token, parsedData.id];

  connection.execute(sql, data, function(err, result) {
    if (err) throw err;
    console.log('Device updated successfully');
  });
    connection.release();
})
}
// Function to delete data from the devices table
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
  let sql = 'DELETE FROM devices WHERE id = ?';
  let data = [id];

  connection.execute(sql, data, function(err, result) {
    if (err) throw err;
    console.log('Device deleted successfully');
  });
  connection.release();
})
}

}


