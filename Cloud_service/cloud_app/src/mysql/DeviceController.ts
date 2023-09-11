import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";


export class DeviceController extends Controller
{
  constructor(){
    super();
    this.tableName = "devices";
    this.updateStatement = `UPDATE ${this.tableName} SET apns_token = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (id, apns_token) VALUES (?, ?)`;
  }
    
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.apns_token;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.apns_token;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.apns_token, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.id, parsedData.apns_token];
  }


}


