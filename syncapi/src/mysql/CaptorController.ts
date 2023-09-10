import { Controller } from "./Controller";


export class CaptorController extends Controller
{
  constructor(){
    super();
    this.tableName = "captors";
  }
    
  updateStatement: string = `INSERT INTO ${this.tableName} (id, name, room_id, value) VALUES (?, ?, ?, ?)`;
  insertStatement: string = `INSERT INTO ${this.tableName} (id, name, room_id, value) VALUES (?, ?, ?, ?)`;
    
  override checkUpdateData(parsedData: any) : boolean{
    return !parsedData.id || !parsedData.name || !parsedData.room_id || !parsedData.value;
  }
  override checkInsertData(parsedData: any) : boolean{
    return !parsedData.name || !parsedData.room_id;
  }
  override getUpdateData(parsedData: any) : any{
    return [parsedData.id, parsedData.name, parsedData.room_id, parsedData.value];
  }
  override getInsertData(parsedData: any) : any{
    return [parsedData.id, parsedData.name, parsedData.room_id, parsedData.value];
  }

}






