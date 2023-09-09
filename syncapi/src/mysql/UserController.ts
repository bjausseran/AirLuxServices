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

export class UserController implements Controller
{
// @ device_id field missing
connect(email: string, password: string): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    pool.getConnection((err, connection) => {
      if (err) {
        reject(err); // Reject the promise with the error if connection fails
      }

      // Use the connection
      try {
        const sql = 'SELECT * FROM users WHERE email = ? AND password = ?';
        connection.query(sql, [email, password], (queryErr: Error | null, results: any[]) => {
          if (queryErr) {
            reject(queryErr); // Reject the promise with the query error
          }
          console.log('try to connect, results length = ' + results.length);
          // Check if a user with the provided email and password was found
          if (results.length === 0) {
            reject(undefined); // Resolve with null if no user was found
          } else {
            console.log('try to connect, results = ' + results[0]['name']);
            resolve(results[0]['id']); // Resolve with the first user found
          }
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
  // Function to select data from the buildings table
  select(where: string | undefined): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      pool.getConnection((err, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
          return;
        }
  
        // Use the connection
        try {
          // SQL query
          const sql = where === undefined ? 'SELECT * FROM users' : `SELECT * FROM users WHERE ${where}`;
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
            let sql = 'SELECT * FROM users WHERE id = ?';
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
  
  // Function to insert data into the users table
  insert(json: string) {
    let parsedData = JSON.parse(json);
    console.log('id = ' + parsedData.id + ', name = ' + parsedData.name + ', email = ' + parsedData.email+ ', password = ' + parsedData.password + ' are required fields.');
  // Check for invalid input
  if (!parsedData.id || !parsedData.name || !parsedData.email || !parsedData.password) {
    console.error('Invalid input. id, name, email and password are required fields.');
    return;
  }
  pool.getConnection(function(err, connection) {
    if (err) { console.log(err); return; };// not connected!
    // Use the connection

  // SQL query using prepared statement
  let sql = 'INSERT INTO users (id, name, email, password) VALUES (?, ?, ?, ?)';
  let data = [parsedData.id, parsedData.name, parsedData.email, parsedData.password];

  connection.execute(sql, data, function(err, result) {
    if (err) console.log(err);
    else console.log('User added successfully');
  });
  connection.release();
  })
  }
  
  // Function to update data in the users table
  update(json: string) {
    let parsedData = JSON.parse(json);
    pool.getConnection(function(err, connection) {
      if (err) throw err; // not connected!
      // Use the connection
  
      // Check for invalid input
      if (!parsedData.id || !parsedData.name || !parsedData.email || !parsedData.password) {
        console.error('Invalid input. id, name, email and password are required fields.');
        return;
      }

      // SQL query using prepared statement
      let sql = 'UPDATE users SET name = ?, email = ?, password = ? WHERE id = ?';
      let data = [parsedData.name, parsedData.email, parsedData.password, parsedData.id];

      connection.execute(sql, data, function(err, result) {
        if (err) throw err;
        console.log('User updated successfully');
      });
      connection.release();
    })
  }
  // Function to delete data from the users table
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
      let sql = 'DELETE FROM users WHERE id = ?';
      let data = [id];

      connection.execute(sql, data, function(err, result) {
        if (err) throw err;
        console.log('User deleted successfully');
      });
      connection.release();
    })
  }
}