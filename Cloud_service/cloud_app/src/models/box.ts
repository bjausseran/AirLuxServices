export class Box{
    constructor(ws: WebSocket, building_id: string){
        //this.id = id;
        this.building_id = building_id;
        this.ws = ws;
    }
    //id: string;
    building_id: string;
    ws: WebSocket;
}