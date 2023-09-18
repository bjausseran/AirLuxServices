import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

export class UserController extends Controller
{
  constructor(){
    super();
    this.selectField = `users.id, users.name, users.email`;
    this.tableName = "users";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, email = ?, password = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (name, email, password) VALUES (?, ?, ?)`;
  }
    
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.email || !parsedData.password;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name || !parsedData.email || !parsedData.password;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.name, parsedData.email, parsedData.password, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.name, parsedData.email, parsedData.password];
  }
// @ device_id field missing
connect(email: string, password: string): Promise<string> {
  return new Promise<string>((resolve, reject) => {
      this.pool.getConnection((err, connection) => {
        if (err) {
          reject(err); // Reject the promise with the error if connection fails
        }

        // Use the connection
        try {
          const sql = 'SELECT * FROM users WHERE email = ? AND password = ?';
          connection.query(sql, [email, password], (queryErr, results: any[]) => {
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
}