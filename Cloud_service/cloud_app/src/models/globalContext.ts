import { AutomationController } from "../mysql/AutomationController";
import { BuildingController } from "../mysql/BuildingController";
import { CaptorController } from "../mysql/CaptorController";
import { CaptorValueController } from "../mysql/CaptorValueController";
import { DeviceController } from "../mysql/DeviceController";
import { RoomController } from "../mysql/RoomController";
import { UserController } from "../mysql/UserController";
import { Box } from "./box";

export class GlobalContext{

    constructor(){
        this.boxes = [];
    }
    boxes: Box[];

    
    users = new UserController();
    devices = new DeviceController();
    buildings = new BuildingController();
    rooms = new RoomController();
    captors = new CaptorController();
    captorValues = new CaptorValueController();
    automations = new AutomationController();
}