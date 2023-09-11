import mysql, { Pool } from "mysql2";
import { Controller } from "./Controller";

export class RoomController extends Controller
{
  constructor(){
    super();
    this.tableName = "rooms";
    this.updateStatement = `UPDATE ${this.tableName} SET name = ?, building_id = ? WHERE id = ?`;
    this.insertStatement = `INSERT INTO ${this.tableName} (id, name, building_id) VALUES (?, ?, ?)`;
  }
    
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.building_id;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.building_id;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.name, parsedData.building_id, parsedData.id];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.id, parsedData.name, parsedData.building_id];
  }
}