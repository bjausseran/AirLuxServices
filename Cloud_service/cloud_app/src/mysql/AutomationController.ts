import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

export class AutomationController extends Controller
{
  constructor(){
    super();
    this.tableName = "automations";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, user_id = ?, is_scheduled = ?, frequency = ?, start_date = ?, enabled = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (name, user_id, is_scheduled, frequency, start_date, enabled) VALUES (?, ?, ?, ?, ?, ?)`;
  }
    
  //{"id": 1, "name": "Bonne nuit", "user_id": 1, "start_date": "2023-09-18 19:00:00.000Z", "frequency": "day", "enabled": 0, "is_scheduled": 1}
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.user_id || !parsedData.start_date || !parsedData.frequency;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name|| !parsedData.user_id  || !parsedData.is_scheduled|| !parsedData.frequency || !parsedData.start_date || !parsedData.enabled;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.name, parsedData.user_id, parsedData.is_scheduled, parsedData.frequency, parsedData.start_date, parsedData.enabled, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.name, parsedData.user_id, parsedData.is_scheduled, parsedData.frequency, parsedData.start_date, parsedData.enabled];
  }
}