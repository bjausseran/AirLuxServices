import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";
import { json } from "stream/consumers";


export class CaptorValueController extends Controller
{
  constructor(){
    super();
    this.tableName = "captor_values";
    this.updateStatement = `UPDATE ${this.tableName} SET captor_id = ?, value = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (captor_id, value) VALUES (?, ?)`;
  }
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.captor_id || !parsedData.value;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.captor_id || !parsedData.value;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.captor_id, parsedData.value, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.captor_id, parsedData.value];
  }
}






